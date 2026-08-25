import 'image_source_file.dart';

enum SharedContentKind { link, text, image, imageError }

class SharedContent {
  const SharedContent({
    required this.kind,
    this.text = '',
    this.image,
  });

  final SharedContentKind kind;
  final String text;
  final ImageSourceFile? image;

  bool get isEmpty => switch (kind) {
        SharedContentKind.image => image == null,
        SharedContentKind.imageError => text.trim().isEmpty,
        SharedContentKind.link || SharedContentKind.text => text.trim().isEmpty,
      };
}
