class WikiConfiguration {
  const WikiConfiguration({
    required this.repositoryUrl,
    required this.token,
  });

  static const defaultRepositoryUrl =
      'https://github.com/Huluvu424242/Developer-Wiki';

  final String repositoryUrl;
  final String token;

  bool get isComplete =>
      repositoryUrl.trim().isNotEmpty && token.trim().isNotEmpty;
}

class GitHubRepository {
  const GitHubRepository({required this.owner, required this.name});

  final String owner;
  final String name;

  static GitHubRepository parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Repository-Angabe fehlt.');
    }

    final normalized = trimmed.startsWith('http://') ||
            trimmed.startsWith('https://')
        ? trimmed
        : 'https://github.com/$trimmed';
    final uri = Uri.tryParse(normalized);
    if (uri == null || uri.host.toLowerCase() != 'github.com') {
      throw const FormatException('Bitte ein GitHub-Repository angeben.');
    }

    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
    if (segments.length != 2) {
      throw const FormatException(
          'Repository als https://github.com/owner/repo oder owner/repo angeben.');
    }

    return GitHubRepository(owner: segments[0], name: segments[1]);
  }

  String get url => 'https://github.com/$owner/$name';
}
