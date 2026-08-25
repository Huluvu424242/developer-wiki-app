import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('image source template matches the wiki contract', () {
    expect(imageSourceTemplate.name, '🖼️ Bild-Quelle');
    expect(imageSourceTemplate.titlePrefix, '[Bild-Quelle]: ');
    expect(
      imageSourceTemplate.fields.map((field) => field.id),
      ['content', 'description', 'agent_notes', 'prompt_additions'],
    );
    expect(imageSourceTemplate.fields.first.kind, FieldKind.image);
    expect(imageSourceTemplate.fields.first.required, isTrue);
    expect(
      imageSourceTemplate.fields.last.initialValue,
      agentInstruction,
    );
  });
}
