class SourceIssueSummary {
  const SourceIssueSummary({
    required this.number,
    required this.title,
    required this.isOpen,
    required this.url,
  });

  final int number;
  final String title;
  final bool isOpen;
  final String url;
}
