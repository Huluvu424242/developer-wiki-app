import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wiki_configuration.dart';

class GitHubAccessDiagnosticService {
  GitHubAccessDiagnosticService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<void> verifyOperationalReadAccess(
    WikiConfiguration configuration,
  ) async {
    final repository = GitHubRepository.parse(configuration.repositoryUrl);
    final headers = {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ${configuration.token}',
      'X-GitHub-Api-Version': '2022-11-28',
    };

    final issues = await _client.get(
      Uri.parse(
        'https://api.github.com/repos/${repository.owner}/${repository.name}/issues',
      ).replace(queryParameters: const {'state': 'all', 'per_page': '1'}),
      headers: headers,
    );
    if (issues.statusCode != 200) {
      throw FormatException(
        _permissionMessage(
          issues,
          'Issues: Read and write',
          'Quellen-Issues können nicht gelesen werden.',
        ),
      );
    }

    final workflow = configuration.workflowFile.trim();
    if (workflow.isEmpty) {
      throw const FormatException('Import-Workflow fehlt.');
    }
    final actions = await _client.get(
      Uri.parse(
        'https://api.github.com/repos/${repository.owner}/${repository.name}/actions/workflows/${Uri.encodeComponent(workflow)}',
      ),
      headers: headers,
    );
    if (actions.statusCode != 200) {
      throw FormatException(
        _permissionMessage(
          actions,
          'Actions: Read and write',
          'Der konfigurierte Import-Workflow ist nicht lesbar.',
        ),
      );
    }
  }

  String _permissionMessage(
    http.Response response,
    String permission,
    String context,
  ) {
    var detail = 'HTTP ${response.statusCode}';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        detail = decoded['message'] as String;
      }
    } catch (_) {
      // Keine Antwortdaten oder bewusst keine Weitergabe unbekannter Inhalte.
    }
    return '$context Benötigt wird mindestens $permission für das ausgewählte '
        'Developer-Wiki. GitHub meldet: $detail';
  }
}
