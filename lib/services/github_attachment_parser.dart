class GitHubAttachmentParser {
  static final _stableAttachment = RegExp(
    r'https://github\.com/user-attachments/assets/'
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

  List<String> stableUrls(Iterable<String> markdownBodies) {
    final urls = <String>{};
    for (final body in markdownBodies) {
      urls.addAll(
        _stableAttachment.allMatches(body).map((match) => match.group(0)!),
      );
    }
    return urls.toList(growable: false);
  }
}
