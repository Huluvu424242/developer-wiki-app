import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/models/pending_image_upload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pending image upload survives JSON persistence', () {
    final upload = PendingImageUpload(
      issueNumber: 42,
      issueUrl: 'https://github.com/example/wiki/issues/42',
      createdAt: DateTime.utc(2026, 8, 25, 18),
      title: 'Diagramm',
      values: const {'description': 'Systemkontext'},
      image: const ImageSourceFile(
        path: '/private/image.png',
        name: 'image.png',
        mimeType: 'image/png',
        sizeBytes: 8,
      ),
    );

    final restored = PendingImageUpload.fromJson(upload.toJson());

    expect(restored.issueNumber, 42);
    expect(restored.values['description'], 'Systemkontext');
    expect(restored.image.path, '/private/image.png');
    expect(restored.createdAt, DateTime.utc(2026, 8, 25, 18));
  });
}
