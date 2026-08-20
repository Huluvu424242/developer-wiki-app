import 'dart:convert';

import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/models/workflow_run.dart';
import 'package:developer_wiki_source_capture/services/github_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('Issue-Body entspricht GitHub-Issue-Form-Struktur', () {
    final body = GitHubService.issueBody(
      sourceTemplates.first,
      {'source_title': 'Test', 'urls': 'https://example.org'},
    );
    expect(
      body,
      '### Titel der Quelle\n\nTest\n\n### Link oder zusammengehörige Links\n\nhttps://example.org',
    );
  });

  test('createIssue uses configured repository and source label', () async {
    late http.Request capturedRequest;
    final client = MockClient((request) async {
      capturedRequest = request;
      return http.Response(
        jsonEncode({
          'number': 123,
          'html_url': 'https://github.com/example/wiki/issues/123',
        }),
        201,
      );
    });
    final service = GitHubService(
      'secret',
      owner: 'example',
      repo: 'wiki',
      client: client,
    );

    final issue = await service.createIssue(title: 'Title', body: 'Body');

    expect(
      capturedRequest.url.toString(),
      'https://api.github.com/repos/example/wiki/issues',
    );
    final payload = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
    expect(payload['title'], 'Title');
    expect(payload['body'], 'Body');
    expect(payload['labels'], ['quelle']);
    expect(issue.number, 123);
    expect(issue.url, 'https://github.com/example/wiki/issues/123');
  });

  test('listRecentSourceIssues loads source issues and excludes pull requests',
      () async {
    late http.Request capturedRequest;
    final client = MockClient((request) async {
      capturedRequest = request;
      return http.Response(
        jsonEncode([
          {
            'number': 42,
            'title': 'Neue Quelle',
            'state': 'open',
            'html_url': 'https://github.com/example/wiki/issues/42',
          },
          {
            'number': 41,
            'title': 'Verarbeitete Quelle',
            'state': 'closed',
            'html_url': 'https://github.com/example/wiki/issues/41',
          },
          {
            'number': 40,
            'title': 'Pull Request',
            'state': 'open',
            'html_url': 'https://github.com/example/wiki/pull/40',
            'pull_request': {'url': 'https://api.github.com/example'},
          },
        ]),
        200,
      );
    });
    final service = GitHubService(
      'secret',
      owner: 'example',
      repo: 'wiki',
      client: client,
    );

    final issues = await service.listRecentSourceIssues();

    expect(capturedRequest.url.queryParameters['labels'], 'quelle');
    expect(capturedRequest.url.queryParameters['state'], 'all');
    expect(capturedRequest.url.queryParameters['direction'], 'desc');
    expect(issues, hasLength(2));
    expect(issues.first.number, 42);
    expect(issues.first.title, 'Neue Quelle');
    expect(issues.first.isOpen, isTrue);
    expect(issues[1].isOpen, isFalse);
  });

  test('dispatchWorkflow uses configured workflow and master ref', () async {
    late http.Request capturedRequest;
    final client = MockClient((request) async {
      capturedRequest = request;
      return http.Response('', 204);
    });
    final service = GitHubService(
      'secret',
      owner: 'example',
      repo: 'wiki',
      client: client,
    );

    await service.dispatchWorkflow(workflow: 'import-source-issues.yml');

    expect(
      capturedRequest.url.toString(),
      'https://api.github.com/repos/example/wiki/actions/workflows/'
      'import-source-issues.yml/dispatches',
    );
    expect(
      jsonDecode(capturedRequest.body),
      {'ref': 'master'},
    );
  });

  test('latestWorkflowRun maps matching successful dispatch', () async {
    late http.Request capturedRequest;
    final client = MockClient((request) async {
      capturedRequest = request;
      return http.Response(
        jsonEncode({
          'workflow_runs': [
            {
              'id': 77,
              'html_url': 'https://github.com/example/wiki/actions/runs/77',
              'status': 'completed',
              'conclusion': 'success',
              'created_at': '2026-08-20T20:00:00Z',
            },
          ],
        }),
        200,
      );
    });
    final service = GitHubService(
      'secret',
      owner: 'example',
      repo: 'wiki',
      client: client,
    );

    final run = await service.latestWorkflowRun(
      workflow: 'import-source-issues.yml',
      notBefore: DateTime.parse('2026-08-20T19:59:00Z'),
    );

    expect(run, isNotNull);
    expect(run!.id, 77);
    expect(run.state, WorkflowRunState.successful);
    expect(
      capturedRequest.url.queryParameters['event'],
      'workflow_dispatch',
    );
    expect(capturedRequest.url.queryParameters['per_page'], '10');
  });

  test('latestWorkflowRun ignores runs older than dispatch', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'workflow_runs': [
            {
              'id': 76,
              'html_url': 'https://github.com/example/wiki/actions/runs/76',
              'status': 'in_progress',
              'conclusion': null,
              'created_at': '2026-08-20T19:58:00Z',
            },
          ],
        }),
        200,
      );
    });
    final service = GitHubService(
      'secret',
      owner: 'example',
      repo: 'wiki',
      client: client,
    );

    final run = await service.latestWorkflowRun(
      workflow: 'import-source-issues.yml',
      notBefore: DateTime.parse('2026-08-20T19:59:00Z'),
    );

    expect(run, isNull);
  });
}
