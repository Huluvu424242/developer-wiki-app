import 'dart:io';

import '../models/image_source_file.dart';

class ImageValidationService {
  static const maxBytes = 10 * 1024 * 1024;
  static const supportedMimeTypes = <String>{
    'image/gif',
    'image/jpeg',
    'image/png',
  };

  Future<ImageSourceFile> validate(ImageSourceFile image) async {
    final file = File(image.path);
    if (!await file.exists()) {
      throw const FormatException('Die ausgewählte Bilddatei ist nicht mehr verfügbar.');
    }

    final size = await file.length();
    if (size <= 0) {
      throw const FormatException('Die ausgewählte Bilddatei ist leer.');
    }
    if (size > maxBytes) {
      throw const FormatException('Das Bild darf höchstens 10 MiB groß sein.');
    }

    final mimeType = image.mimeType.toLowerCase();
    if (!supportedMimeTypes.contains(mimeType)) {
      throw const FormatException(
        'Unterstützt werden PNG-, GIF- und JPEG-Bilder.',
      );
    }

    final header = await file.openRead(0, 16).fold<List<int>>(
      <int>[],
      (bytes, chunk) => bytes..addAll(chunk),
    );
    if (!_matchesSignature(mimeType, header)) {
      throw const FormatException(
        'Dateityp und tatsächlicher Bildinhalt stimmen nicht überein.',
      );
    }

    return ImageSourceFile(
      path: image.path,
      name: image.name,
      mimeType: mimeType,
      sizeBytes: size,
    );
  }

  bool _matchesSignature(String mimeType, List<int> bytes) {
    return switch (mimeType) {
      'image/png' => _startsWith(
          bytes,
          const [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
        ),
      'image/jpeg' => _startsWith(bytes, const [0xff, 0xd8, 0xff]),
      'image/gif' =>
        _startsWith(bytes, 'GIF87a'.codeUnits) ||
            _startsWith(bytes, 'GIF89a'.codeUnits),
      _ => false,
    };
  }

  bool _startsWith(List<int> bytes, List<int> signature) {
    if (bytes.length < signature.length) {
      return false;
    }
    for (var index = 0; index < signature.length; index++) {
      if (bytes[index] != signature[index]) {
        return false;
      }
    }
    return true;
  }
}
