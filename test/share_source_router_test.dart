import 'package:developer_wiki_source_capture/models/document_source_file.dart';
import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/models/shared_content.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/services/share_source_router.dart';
import 'package:flutter_test/flutter_test.dart';

const _templates = [
  SourceTemplate(
    id: 'source-metadata',
    name: 'Link',
    titlePrefix: '',
    description: 'Link',
    fields: [SourceField(id: 'urls', label: 'URL', kind: FieldKind.textarea)],
  ),
  SourceTemplate(
    id: 'wiki-information',
    name: 'Text',
    titlePrefix: '',
    description: 'Text',
    fields: [
      SourceField(id: 'description', label: 'Text', kind: FieldKind.textarea)
    ],
  ),
  SourceTemplate(
    id: 'image-source',
    name: 'Bild',
    titlePrefix: '',
    description: 'Bild',
    fields: [SourceField(id: 'content', label: 'Bild', kind: FieldKind.image)],
  ),
  SourceTemplate(
    id: 'document-source',
    name: 'Dokument',
    titlePrefix: '',
    description: 'Dokument',
    fields: [SourceField(id: 'content', label: 'Datei', kind: FieldKind.file)],
  ),
];

void main() {
  const router = ShareSourceRouter();

  test('routet Link auf Quellenmetadaten', () {
    const content = SharedContent(
      kind: SharedContentKind.link,
      text: 'https://example.invalid',
    );
    expect(router.templateFor(content, _templates)?.id, 'source-metadata');
  });

  test('routet Text auf allgemeine Information', () {
    const content = SharedContent(kind: SharedContentKind.text, text: 'Notiz');
    expect(router.templateFor(content, _templates)?.id, 'wiki-information');
  });

  test('routet Bild auf Bild-Quelle', () {
    const content = SharedContent(
      kind: SharedContentKind.image,
      image: ImageSourceFile(
        path: '/tmp/a.png',
        name: 'a.png',
        mimeType: 'image/png',
        sizeBytes: 10,
      ),
    );
    expect(router.templateFor(content, _templates)?.id, 'image-source');
  });

  test('routet PDF auf Dokument-Quelle', () {
    const content = SharedContent(
      kind: SharedContentKind.document,
      document: DocumentSourceFile(
        path: '/tmp/a.pdf',
        name: 'a.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 10,
      ),
    );
    expect(router.templateFor(content, _templates)?.id, 'document-source');
  });

  test('routet unbekannte Datei nicht auf generische Quelle', () {
    const content = SharedContent(
      kind: SharedContentKind.unsupportedFile,
      text: 'application/zip',
    );
    expect(router.templateFor(content, _templates), isNull);
  });
}
