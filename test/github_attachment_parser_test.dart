import 'package:developer_wiki_source_capture/services/github_attachment_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = GitHubAttachmentParser();

  test('extracts and deduplicates stable GitHub attachment URLs', () {
    const url = 'https://github.com/user-attachments/assets/'
        '123e4567-e89b-12d3-a456-426614174000';

    expect(
      parser.stableUrls(['![image]($url)', '<img src="$url">']),
      [url],
    );
  });

  test('ignores temporary and unrelated URLs', () {
    expect(
      parser.stableUrls([
        'https://objects.githubusercontent.com/private/signed?token=short',
        'https://example.org/image.png',
      ]),
      isEmpty,
    );
  });
}
