import 'package:developer_wiki_source_capture/models/document_source_file.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/services/document_input_service.dart';
import 'package:flutter_test/flutter_test.dart';

const _field = SourceField(
  id: 'content',
  label: 'Dokument',
  kind: FieldKind.file,
  required: true,
  mimeTypes: ['application/pdf'],
  maxBytes: 10 * 1024 * 1024,
  maxFiles: 1,
  bodyHeading: 'Inhalt',
  transport: 'guided-github-issue-file-attachment-v1',
);

void main() {
  test('akzeptiert PDF innerhalb des Vertrags', () {
    const document = DocumentSourceFile(
      path: '/tmp/example.pdf',
      name: 'example.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 1024,
    );
    expect(PlatformDocumentInputGateway.validate(document, _field), document);
  });

  test('lehnt unbekannten MIME-Typ ab', () {
    const document = DocumentSourceFile(
      path: '/tmp/example.zip',
      name: 'example.zip',
      mimeType: 'application/zip',
      sizeBytes: 1024,
    );
    expect(
      () => PlatformDocumentInputGateway.validate(document, _field),
      throwsFormatException,
    );
  });

  test('lehnt zu große Datei ab', () {
    const document = DocumentSourceFile(
      path: '/tmp/example.pdf',
      name: 'example.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 11 * 1024 * 1024,
    );
    expect(
      () => PlatformDocumentInputGateway.validate(document, _field),
      throwsFormatException,
    );
  });
}
