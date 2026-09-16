import 'package:developer_wiki_source_capture/models/source_capture_definition.dart';
import 'package:flutter_test/flutter_test.dart';

const _valid = '''
{
  "schemaVersion": 1,
  "issueLabel": "quelle",
  "templates": [
    {
      "id": "image-source",
      "name": "Bild-Quelle",
      "titlePrefix": "[Bild-Quelle]: ",
      "description": "Bild erfassen",
      "requiredCapabilities": ["guided-github-issue-image-attachment-v1"],
      "fields": [
        {
          "id": "content",
          "label": "Inhalt",
          "kind": "image",
          "required": true,
          "maxFiles": 1,
          "mimeTypes": ["image/png", "image/gif", "image/jpeg"],
          "maxBytes": 10485760,
          "bodyHeading": "Inhalt",
          "transport": "guided-github-issue-image-attachment-v1",
          "inputMethods": ["file-picker", "android-share"]
        }
      ]
    }
  ]
}
''';

void main() {
  test('parst unterstützte Version und Bildtransport', () {
    final definition = SourceCaptureDefinition.parse(_valid);
    expect(definition.schemaVersion, 1);
    expect(definition.issueLabel, 'quelle');
    final template = definition.templates.single;
    expect(template.id, 'image-source');
    expect(template.isImageSource, isTrue);
    expect(template.fields.single.maxBytes, 10 * 1024 * 1024);
  });

  test('lehnt unbekannte Schema-Version ab', () {
    final invalid =
        _valid.replaceFirst('"schemaVersion": 1', '"schemaVersion": 2');
    expect(() => SourceCaptureDefinition.parse(invalid), throwsFormatException);
  });

  test('lehnt unbekannte Feldart ab', () {
    final invalid =
        _valid.replaceFirst('"kind": "image"', '"kind": "document"');
    expect(() => SourceCaptureDefinition.parse(invalid), throwsFormatException);
  });

  test('lehnt unbekannte erforderliche Fähigkeit ab', () {
    final invalid = _valid.replaceFirst(
      'guided-github-issue-image-attachment-v1',
      'unknown-transport-v9',
    );
    expect(() => SourceCaptureDefinition.parse(invalid), throwsFormatException);
  });

  test('lehnt unvollständigen Bildtransport ab', () {
    final invalid = _valid.replaceFirst('"maxFiles": 1,', '"maxFiles": 2,');
    expect(() => SourceCaptureDefinition.parse(invalid), throwsFormatException);
  });
}
