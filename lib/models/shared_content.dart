enum SharedContentKind { link, text }

class SharedContent {
  const SharedContent({
    required this.kind,
    required this.text,
  });

  final SharedContentKind kind;
  final String text;

  bool get isEmpty => text.trim().isEmpty;
}
