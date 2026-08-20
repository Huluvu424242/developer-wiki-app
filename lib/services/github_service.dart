import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/created_issue.dart';
import '../models/source_issue_summary.dart';
import '../models/source_template.dart';
import '../models/workflow_run.dart';

class GitHubService {
  GitHubService(
    this.token, {
    this.owner = 'Huluvu424242',
    this.repo = 'Developer-Wiki',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String token;
  final String owner;
  final String repo;
  final http.Client _client;

  Map<String, String> get _headers => {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $token',
        'X-GitHub-Api-Version': '2022-11-28',
      };

  Future<CreatedIssue> createIssue({
    required String title,
    required String body,
  }) async {
    final response = await _client.post(
      Uri.parse('https://api.github.com/repos/$owner/$repo/issues'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'labels': ['quelle'],
      }),
    );
    if (response.statusCode != 201) {
      throw Exception(_message(response));
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return CreatedIssue(
      number: data['number'] as int,
      url: data['html_url'] as String,
    );
  }

  Future<List<SourceIssueSummary>> listRecentSourceIssues({
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      'https://api.github.com/repos/$owner/$repo/issues',
    ).replace(
      queryParameters: {
        'state': 'all',
        'labels': 'quelle',
        'per_page': limit.toString(),
        'sort': 'created',
        'direction': 'desc',
      },
    );
    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception(_message(response));
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .cast<Map<String, dynamic>>()
        .where((issue) => !issue.containsKey('pull_request'))
        .map(
          (issue) => SourceIssueSummary(
            number: issue['number'] as int,
            title: issue['title'] as String,
            isOpen: issue['state'] == 'open',
            url: issue['html_url'] as String,
          ),
        )
        .toList();
  }

  Future<void> dispatchWorkflow({
    required String workflow,
    String ref = 'master',
  }) async {
    final workflowId = _workflowId(workflow);
    final response = await _client.post(
      Uri.parse(
        'https://api.github.com/repos/$owner/$repo/actions/workflows/'
        '$workflowId/dispatches',
      ),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'ref': ref}),
    );
    if (response.statusCode != 204) {
      throw Exception(_message(response));
    }
  }

  Future<WorkflowRun?> latestWorkflowRun({
    required String workflow,
    DateTime? notBefore,
  }) async {
    final workflowId = _workflowId(workflow);
    final uri = Uri.parse(
      'https://api.github.com/repos/$owner/$repo/actions/workflows/'
      '$workflowId/runs',
    ).replace(
      queryParameters: const {
        'event': 'workflow_dispatch',
        'per_page': '10',
      },
    );
    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception(_message(response));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final runs = data['workflow_runs'] as List<dynamic>? ?? const [];
    for (final rawRun in runs) {
      final run = rawRun as Map<String, dynamic>;
      final createdAt = DateTime.parse(run['created_at'] as String).toUtc();
      if (notBefore != null && createdAt.isBefore(notBefore.toUtc())) {
        continue;
      }
      return WorkflowRun(
        id: run['id'] as int,
        url: run['html_url'] as String,
        state: _workflowRunState(
          run['status']?.toString(),
          run['conclusion']?.toString(),
        ),
        createdAt: createdAt,
      );
    }
    return null;
  }

  Future<String> login() async {
    final response = await _client.get(
      Uri.parse('https://api.github.com/user'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception(_message(response));
    }
    return (jsonDecode(response.body) as Map<String, dynamic>)['login']
        as String;
  }

  Future<String> verifyRepositoryAccess() async {
    final loginName = await login();
    final response = await _client.get(
      Uri.parse('https://api.github.com/repos/$owner/$repo'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception(_message(response));
    }
    return loginName;
  }

  static String issueBody(
    SourceTemplate template,
    Map<String, String> values,
  ) =>
      template.fields
          .where((field) => (values[field.id] ?? '').trim().isNotEmpty)
          .map(
            (field) =>
                '### ${field.label}\n\n${values[field.id]!.trim()}',
          )
          .join('\n\n');

  static String _workflowId(String workflow) {
    final trimmed = workflow.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Import-Workflow fehlt.');
    }
    return Uri.encodeComponent(trimmed);
  }

  static WorkflowRunState _workflowRunState(
    String? status,
    String? conclusion,
  ) {
    if (status == 'completed') {
      return conclusion == 'success'
          ? WorkflowRunState.successful
          : WorkflowRunState.failed;
    }
    if (status == 'in_progress') {
      return WorkflowRunState.running;
    }
    return WorkflowRunState.queued;
  }

  static String _message(http.Response response) {
    try {
      return (jsonDecode(response.body) as Map<String, dynamic>)['message']
              ?.toString() ??
          'HTTP ${response.statusCode}';
    } catch (_) {
      return 'HTTP ${response.statusCode}';
    }
  }
}
