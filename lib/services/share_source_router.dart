import '../models/shared_content.dart';
import '../models/source_template.dart';

class ShareSourceRouter {
  const ShareSourceRouter();

  SourceTemplate? templateFor(
    SharedContent content,
    Iterable<SourceTemplate> templates,
  ) {
    final targetId = switch (content.kind) {
      SharedContentKind.link => 'source-metadata',
      SharedContentKind.text => 'wiki-information',
      SharedContentKind.image => 'image-source',
      SharedContentKind.document => 'document-source',
      SharedContentKind.imageError ||
      SharedContentKind.documentError ||
      SharedContentKind.unsupportedFile =>
        null,
    };
    if (targetId == null) {
      return null;
    }
    for (final template in templates) {
      if (template.id == targetId) {
        return template;
      }
    }
    return null;
  }
}
