import 'package:flutter/material.dart';

import '../models/source_issue_summary.dart';
import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/external_url_service.dart';
import '../services/github_service.dart';
import '../widgets/app_support.dart';
import 'source_form_screen.dart';

class RecentSourcesScreen extends StatefulWidget {
  const RecentSourcesScreen({super.key});

  @override
  State<RecentSourcesScreen> createState() => _RecentSourcesScreenState();
}

class _RecentSourcesScreenState extends State<RecentSourcesScreen> {
  final _configurationService = ConfigurationService();
  final _externalUrlService = ExternalUrlService();

  bool _busy = false;
  String? _errorMessage;
  List<SourceIssueSummary> _issues = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    try {
      final configuration = await _configurationService.load();
      final repository = _repositoryFrom(configuration);
      final issues = await GitHubService(
        configuration.token,
        owner: repository.owner,
        repo: repository.name,
      ).listRecentSourceIssues();
      if (mounted) {
        setState(() => _issues = issues);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Quellen konnten nicht geladen werden: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  GitHubRepository _repositoryFrom(WikiConfiguration configuration) {
    if (!configuration.isComplete) {
      throw const FormatException(
        'Wiki-Konfiguration ist unvollständig. Einstellungen prüfen.',
      );
    }
    return GitHubRepository.parse(configuration.repositoryUrl);
  }

  Future<void> _openIssue(SourceIssueSummary issue) async {
    try {
      await _externalUrlService.open(issue.url);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Issue konnte nicht geöffnet werden: $error');
      }
    }
  }

  void _captureSource() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SourceFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letzte Quellen'),
        actions: [
          IconButton(
            tooltip: 'Quellen aktualisieren',
            onPressed: _busy ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
          const AppSupportMenu(contextName: 'Letzte Quellen'),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_busy && _issues.isEmpty && _errorMessage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _issues.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      );
    }

    if (_issues.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Noch keine Quellen gefunden.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _captureSource,
                icon: const Icon(Icons.add),
                label: const Text('Quelle erfassen'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _issues.length + (_errorMessage == null ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == 0 && _errorMessage != null) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            );
          }
          final issueIndex = index - (_errorMessage == null ? 0 : 1);
          final issue = _issues[issueIndex];
          return Card(
            child: ListTile(
              minVerticalPadding: 14,
              title: Text('#${issue.number} ${issue.title}'),
              subtitle: Text(issue.isOpen ? 'offen' : 'geschlossen'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openIssue(issue),
            ),
          );
        },
      ),
    );
  }
}
