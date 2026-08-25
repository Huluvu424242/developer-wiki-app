class ImageSourceFile {
  const ImageSourceFile({
    required this.path,
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
  });

  final String path;
  final String name;
  final String mimeType;
  final int sizeBytes;

  String get formattedSize {
    if (sizeBytes >= 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MiB';
    }
    return '${(sizeBytes / 1024).toStringAsFixed(1)} KiB';
  }
}
