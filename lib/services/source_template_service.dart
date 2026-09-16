import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/source_capture_definition.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';

abstract class SourceTemplateLoader {
  Future<LoadedSourceTemplates> load(WikiConfiguration configuration);
}

class SourceTemplateService implements SourceTemplateLoader {
  SourceTemplateService({
    http.Client? client,
    SourceTemplateCache? cache,
  })  : _client = client ?? http.Client(),
        _cache = cache ?? SecureSourceTemplateCache();

  static const contractPath = 'src/config/source-capture.json';
  static const _fallbackIssueLabel = 'quelle';

  final http.Client _client;
  final SourceTemplateCache _cache;

  Future<void> verifyRemoteAccess(WikiConfiguration configuration) async {
    final repository = GitHubRepository.parse(configuration.repositoryUrl);
    final raw = await _fetchContract(repository, configuration.token);
    SourceCaptureDefinition.parse(raw);
  }

  @override
  Future<LoadedSourceTemplates> load(WikiConfiguration configuration) async {
    final repository = GitHubRepository.parse(configuration.repositoryUrl);
    Object? remoteError;
    try {
      final raw = await _fetchContract(repository, configuration.token);
      final definition = SourceCaptureDefinition.parse(raw);
      await _cache.write(repository, raw);
      return LoadedSourceTemplates(
        templates: definition.templates,
        issueLabel: definition.issueLabel,
        origin: SourceTemplateOrigin.remote,
      );
    } catch (error) {
      remoteError = error;
    }

    try {
      final cached = await _cache.read(repository);
      if (cached != null) {
        final definition = SourceCaptureDefinition.parse(cached);
        return LoadedSourceTemplates(
          templates: definition.templates,
          issueLabel: definition.issueLabel,
          origin: SourceTemplateOrigin.cache,
          warning: 'Aktuelles Quellenmodell konnte nicht geladen werden. '
              'Die letzte kompatible lokale Version wird verwendet: $remoteError',
        );
      }
    } catch (_) {
      // Ein defekter Cache blockiert die gebündelte Rückfall-Definition nicht.
    }

    return LoadedSourceTemplates(
      templates: sourceTemplates,
      issueLabel: _fallbackIssueLabel,
      origin: SourceTemplateOrigin.bundledFallback,
      warning:
          'Quellenmodell konnte weder aus dem Wiki noch aus dem lokalen Cache '
          'geladen werden. Die gebündelte kompatible Rückfall-Definition wird '
          'verwendet: $remoteError',
    );
  }

  Future<String> _fetchContract(
    GitHubRepository repository,
    String token,
  ) async {
    final uri = Uri.parse(
      'https://api.github.com/repos/${repository.owner}/${repository.name}/'
      'contents/$contractPath',
    ).replace(queryParameters: const {'ref': 'master'});
    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $token',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );
    if (response.statusCode == 403) {
      throw Exception(
        'Quellenmodell: HTTP 403 – der Fine-grained PAT benötigt für dieses '
        'Wiki Contents: Read-only.',
      );
    }
    if (response.statusCode != 200) {
      throw Exception('Quellenmodell: HTTP ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic> || data['content'] is! String) {
      throw const FormatException(
        'GitHub lieferte kein lesbares Quellenmodell.',
      );
    }
    final encoding = data['encoding']?.toString();
    if (encoding != 'base64') {
      throw FormatException('Unbekannte GitHub-Inhaltskodierung: $encoding.');
    }
    final normalized = (data['content'] as String).replaceAll('\n', '');
    return utf8.decode(base64Decode(normalized));
  }
}

abstract class SourceTemplateCache {
  Future<String?> read(GitHubRepository repository);
  Future<void> write(GitHubRepository repository, String rawJson);
}

class SecureSourceTemplateCache implements SourceTemplateCache {
  SecureSourceTemplateCache({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                migrateOnAlgorithmChange: true,
                migrateWithBackup: true,
              ),
            );

  final FlutterSecureStorage _storage;

  String _key(GitHubRepository repository) =>
      'source_capture_${repository.owner}_${repository.name}'.toLowerCase();

  @override
  Future<String?> read(GitHubRepository repository) =>
      _storage.read(key: _key(repository));

  @override
  Future<void> write(GitHubRepository repository, String rawJson) =>
      _storage.write(key: _key(repository), value: rawJson);
}
