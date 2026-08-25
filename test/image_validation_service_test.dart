import 'dart:io';

import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/services/image_validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory directory;
  final service = ImageValidationService();

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('image-validation-');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('accepts matching PNG metadata and signature', () async {
    final file = File('${directory.path}/source.png');
    await file.writeAsBytes(
      const [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
    );

    final validated = await service.validate(
      ImageSourceFile(
        path: file.path,
        name: 'source.png',
        mimeType: 'image/png',
        sizeBytes: 1,
      ),
    );

    expect(validated.sizeBytes, 8);
    expect(validated.mimeType, 'image/png');
  });

  test('rejects unsupported MIME type', () async {
    final file = File('${directory.path}/source.webp');
    await file.writeAsBytes(const [0x52, 0x49, 0x46, 0x46]);

    await expectLater(
      service.validate(
        ImageSourceFile(
          path: file.path,
          name: 'source.webp',
          mimeType: 'image/webp',
          sizeBytes: 4,
        ),
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a signature that does not match the MIME type', () async {
    final file = File('${directory.path}/source.png');
    await file.writeAsBytes('GIF89a'.codeUnits);

    await expectLater(
      service.validate(
        ImageSourceFile(
          path: file.path,
          name: 'source.png',
          mimeType: 'image/png',
          sizeBytes: 6,
        ),
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects images larger than ten MiB', () async {
    final file = File('${directory.path}/large.jpg');
    final randomAccess = await file.open(mode: FileMode.write);
    await randomAccess.truncate(ImageValidationService.maxBytes + 1);
    await randomAccess.close();

    await expectLater(
      service.validate(
        ImageSourceFile(
          path: file.path,
          name: 'large.jpg',
          mimeType: 'image/jpeg',
          sizeBytes: ImageValidationService.maxBytes + 1,
        ),
      ),
      throwsA(isA<FormatException>()),
    );
  });
}
