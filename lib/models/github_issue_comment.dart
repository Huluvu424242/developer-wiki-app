class GitHubIssueComment {
  const GitHubIssueComment({
    required this.body,
    required this.createdAt,
    required this.authorLogin,
  });

  final String body;
  final DateTime createdAt;
  final String authorLogin;
}
