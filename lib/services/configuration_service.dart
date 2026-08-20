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

  final FlutterSecureStorage _storage;

  Future<WikiConfiguration> load() async {
    final token = await _storage.read(key: _tokenKey) ?? '';
    final repositoryUrl = await _storage.read(key: _repositoryKey) ??
        WikiConfiguration.defaultRepositoryUrl;
    return WikiConfiguration(repositoryUrl: repositoryUrl, token: token);
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
  }
}
