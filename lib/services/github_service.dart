import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/created_issue.dart';
import '../models/source_template.dart';

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
