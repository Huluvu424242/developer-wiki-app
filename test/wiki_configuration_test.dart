import 'package:developer_wiki_source_capture/models/wiki_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GitHubRepository.parse', () {
    test('accepts full GitHub repository URL', () {
      final repository = GitHubRepository.parse(
        'https://github.com/Huluvu424242/Developer-Wiki',
      );

      expect(repository.owner, 'Huluvu424242');
      expect(repository.name, 'Developer-Wiki');
      expect(
        repository.url,
        'https://github.com/Huluvu424242/Developer-Wiki',
      );
    });

    test('accepts owner/repo shorthand', () {
      final repository = GitHubRepository.parse('example/wiki');

      expect(repository.owner, 'example');
      expect(repository.name, 'wiki');
    });

    test('rejects non GitHub URLs', () {
      expect(
        () => GitHubRepository.parse('https://example.org/example/wiki'),
        throwsFormatException,
      );
    });
  });

  test('configuration is complete only with repository and token', () {
    expect(
      const WikiConfiguration(
        repositoryUrl: WikiConfiguration.defaultRepositoryUrl,
        token: 'token',
      ).isComplete,
      isTrue,
    );
    expect(
      const WikiConfiguration(
        repositoryUrl: WikiConfiguration.defaultRepositoryUrl,
        token: '',
      ).isComplete,
      isFalse,
    );
  });
}
