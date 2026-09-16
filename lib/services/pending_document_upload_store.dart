import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/pending_document_upload.dart';

class PendingDocumentUploadStore {
  PendingDocumentUploadStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                migrateOnAlgorithmChange: true,
                migrateWithBackup: true,
              ),
            );

  static const _key = 'pending_document_upload';
  final FlutterSecureStorage _storage;

  Future<PendingDocumentUpload?> load() async {
    final value = await _storage.read(key: _key);
    if (value == null || value.isEmpty) {
      return null;
    }
    return PendingDocumentUpload.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
  }

  Future<void> save(PendingDocumentUpload upload) {
    return _storage.write(key: _key, value: jsonEncode(upload.toJson()));
  }

  Future<void> clear() => _storage.delete(key: _key);
}
