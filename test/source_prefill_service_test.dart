import 'package:developer_wiki_source_capture/models/shared_content.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/services/source_prefill_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = SourcePrefillService();

  test('link share fills URL and keeps accompanying text', () {
    final values = service.valuesFor(
      sourceTemplates.first,
      const SharedContent(
        kind: SharedContentKind.link,
        text: 'Interessanter Artikel https://example.org/article',
      ),
    );

    expect(values['urls'], 'https://example.org/article');
    expect(values['summary'], 'Interessanter Artikel');
  });

  test('text share fills suitable content field', () {
    final values = service.valuesFor(
      sourceTemplates[1],
      const SharedContent(
        kind: SharedContentKind.text,
        text: 'Eine wichtige Notiz',
      ),
    );

    expect(values['description'], 'Eine wichtige Notiz');
  });

  test('unexpected link content is preserved in a fallback field', () {
    final values = service.valuesFor(
      sourceTemplates[2],
      const SharedContent(
        kind: SharedContentKind.link,
        text: 'Kein gültiger Link, aber wichtiger Inhalt',
      ),
    );

    expect(values['person_notes'], 'Kein gültiger Link, aber wichtiger Inhalt');
  });
}
