import 'dart:convert';

import 'package:developer_wiki_source_capture/models/source_template.dart';
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
}
