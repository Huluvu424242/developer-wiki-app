import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/pending_image_upload.dart';

class PendingImageUploadStore {
  PendingImageUploadStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  static const _key = 'pending_image_upload';
  final FlutterSecureStorage _storage;

  Future<PendingImageUpload?> load() async {
    final value = await _storage.read(key: _key);
    if (value == null || value.isEmpty) {
      return null;
    }
    return PendingImageUpload.fromJson(
      jsonDecode(value) as Map<String, dynamic>,
    );
  }

  Future<void> save(PendingImageUpload upload) {
    return _storage.write(key: _key, value: jsonEncode(upload.toJson()));
  }

  Future<void> clear() => _storage.delete(key: _key);
}
