import 'dart:convert';

import 'package:developer_wiki_source_capture/models/source_capture_definition.dart';
import 'package:developer_wiki_source_capture/models/wiki_configuration.dart';
import 'package:developer_wiki_source_capture/services/source_template_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _contract = '''
{
  "schemaVersion": 1,
  "issueLabel": "quelle",
  "templates": [
    {
      "id": "wiki-information",
      "name": "Information",
      "titlePrefix": "[Information]: ",
      "description": "Information erfassen",
      "requiredCapabilities": [],
      "fields": [
        {"id": "description", "label": "Beschreibung", "kind": "textarea", "required": true}
      ]
    }
  ]
}
''';

const _configuration = WikiConfiguration(
  repositoryUrl: 'https://github.com/example/private-wiki',
  token: 'test-token',
);

class _MemoryCache implements SourceTemplateCache {
  String? value;

  @override
  Future<String?> read(GitHubRepository repository) async => value;

  @override
  Future<void> write(GitHubRepository repository, String rawJson) async {
    value = rawJson;
  }
}

void main() {
  test('lädt Vertrag aus konfiguriertem Repository und cached ihn', () async {
    final cache = _MemoryCache();
    final client = MockClient((request) async {
      expect(
        request.url.path,
        '/repos/example/private-wiki/contents/src/config/source-capture.json',
      );
      expect(request.url.queryParameters['ref'], 'master');
      expect(request.headers['Authorization'], 'Bearer test-token');
      return http.Response(
        jsonEncode({
          'encoding': 'base64',
          'content': base64Encode(utf8.encode(_contract)),
        }),
        200,
      );
    });
    final loaded = await SourceTemplateService(client: client, cache: cache)
        .load(_configuration);

    expect(loaded.origin, SourceTemplateOrigin.remote);
    expect(loaded.templates.single.id, 'wiki-information');
    expect(cache.value, _contract);
  });

  test('prüft beim Verbindungstest den echten Remote-Vertrag', () async {
    late http.Request capturedRequest;
    final service = SourceTemplateService(
      cache: _MemoryCache(),
      client: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'encoding': 'base64',
            'content': base64Encode(utf8.encode(_contract)),
          }),
          200,
        );
      }),
    );

    await service.verifyRemoteAccess(_configuration);

    expect(
      capturedRequest.url.path,
      '/repos/example/private-wiki/contents/src/config/source-capture.json',
    );
    expect(capturedRequest.url.queryParameters['ref'], 'master');
    expect(capturedRequest.headers['Authorization'], 'Bearer test-token');
  });

  test('meldet bei HTTP 403 das benötigte Contents-Leserecht', () async {
    final service = SourceTemplateService(
      cache: _MemoryCache(),
      client: MockClient((_) async => http.Response('forbidden', 403)),
    );

    await expectLater(
      service.verifyRemoteAccess(_configuration),
      throwsA(
        predicate(
          (error) =>
              error.toString().contains('HTTP 403') &&
              error.toString().contains('Contents: Read-only') &&
              !error.toString().contains('test-token'),
        ),
      ),
    );
  });

  test('Fallback-Warnung erklärt fehlendes Contents-Leserecht', () async {
    final service = SourceTemplateService(
      cache: _MemoryCache(),
      client: MockClient((_) async => http.Response('forbidden', 403)),
    );

    final loaded = await service.load(_configuration);

    expect(loaded.origin, SourceTemplateOrigin.bundledFallback);
    expect(loaded.warning, contains('Contents: Read-only'));
    expect(loaded.warning, isNot(contains('test-token')));
  });

  test('verwendet letzten gültigen Cache bei Netzwerkfehler', () async {
    final cache = _MemoryCache()..value = _contract;
    final service = SourceTemplateService(
      cache: cache,
      client: MockClient((_) async => http.Response('offline', 503)),
    );

    final loaded = await service.load(_configuration);

    expect(loaded.origin, SourceTemplateOrigin.cache);
    expect(loaded.warning, isNotNull);
    expect(loaded.templates.single.id, 'wiki-information');
  });

  test('verwendet gebündelten Fallback ohne gültigen Cache', () async {
    final service = SourceTemplateService(
      cache: _MemoryCache(),
      client: MockClient((_) async => http.Response('offline', 503)),
    );

    final loaded = await service.load(_configuration);

    expect(loaded.origin, SourceTemplateOrigin.bundledFallback);
    expect(loaded.templates, isNotEmpty);
    expect(loaded.warning, isNotNull);
  });

  test('überschreibt gültigen Cache nicht mit inkompatibler Version', () async {
    final cache = _MemoryCache()..value = _contract;
    final incompatible = _contract.replaceFirst(
      '"schemaVersion": 1',
      '"schemaVersion": 2',
    );
    final service = SourceTemplateService(
      cache: cache,
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'encoding': 'base64',
            'content': base64Encode(utf8.encode(incompatible)),
          }),
          200,
        ),
      ),
    );

    final loaded = await service.load(_configuration);

    expect(loaded.origin, SourceTemplateOrigin.cache);
    expect(cache.value, _contract);
  });
}
