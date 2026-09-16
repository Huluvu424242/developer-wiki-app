class DocumentSourceFile {
  const DocumentSourceFile({
    required this.path,
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
  });

  final String path;
  final String name;
  final String mimeType;
  final int sizeBytes;

  String get displaySize {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    }
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KiB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MiB';
  }
}
