import 'document_source_file.dart';
import 'image_source_file.dart';

enum SharedContentKind {
  link,
  text,
  image,
  document,
  imageError,
  documentError,
  unsupportedFile,
}

class SharedContent {
  const SharedContent({
    required this.kind,
    this.text = '',
    this.image,
    this.document,
  });

  final SharedContentKind kind;
  final String text;
  final ImageSourceFile? image;
  final DocumentSourceFile? document;

  bool get isEmpty => switch (kind) {
        SharedContentKind.image => image == null,
        SharedContentKind.document => document == null,
        SharedContentKind.imageError ||
        SharedContentKind.documentError ||
        SharedContentKind.unsupportedFile =>
          text.trim().isEmpty,
        SharedContentKind.link || SharedContentKind.text => text.trim().isEmpty,
      };
}
