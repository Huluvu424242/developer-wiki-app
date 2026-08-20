import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/wiki_configuration.dart';

class ConfigurationService {
  ConfigurationService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  static const _tokenKey = 'github_pat';
  static const _repositoryKey = 'wiki_repository_url';
  static const _workflowKey = 'wiki_import_workflow';

  final FlutterSecureStorage _storage;

  Future<WikiConfiguration> load() async {
    final token = await _storage.read(key: _tokenKey) ?? '';
    final repositoryUrl = await _storage.read(key: _repositoryKey) ??
        WikiConfiguration.defaultRepositoryUrl;
    final workflowFile = await _storage.read(key: _workflowKey) ??
        WikiConfiguration.defaultWorkflowFile;
    return WikiConfiguration(
      repositoryUrl: repositoryUrl,
      token: token,
      workflowFile: workflowFile,
    );
  }

  Future<void> save(WikiConfiguration configuration) async {
    await _storage.write(
      key: _repositoryKey,
      value: configuration.repositoryUrl.trim(),
    );
    await _storage.write(
      key: _tokenKey,
      value: configuration.token.trim(),
    );
    await _storage.write(
      key: _workflowKey,
      value: configuration.workflowFile.trim(),
    );
  }
}
