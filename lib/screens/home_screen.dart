import 'package:flutter/material.dart';

import '../models/shared_content.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/github_service.dart';
import 'settings_screen.dart';
import 'source_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onImportRequested,
    this.sharedContent,
  });

  final VoidCallback? onImportRequested;
  final SharedContent? sharedContent;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _configurationService = ConfigurationService();
  bool _importBusy = false;
  String? _importStatus;
  bool _importFailed = false;

  void _openSource(SourceTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SourceFormScreen(
          initialTemplate: template,
          sharedContent: widget.sharedContent,
        ),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  Future<void> _requestImport() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quellenimport starten?'),
        content: const Text(
          'Der Import-Workflow des verbundenen Wikis wird jetzt gestartet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Starten'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    if (widget.onImportRequested != null) {
      widget.onImportRequested!();
      return;
    }
    await _dispatchImport();
  }

  Future<void> _dispatchImport() async {
    setState(() {
      _importBusy = true;
      _importStatus = 'Import wird auf GitHub gestartet …';
      _importFailed = false;
    });
    try {
      final configuration = await _configurationService.load();
      final repository = _repositoryFrom(configuration);
      await GitHubService(
        configuration.token,
        owner: repository.owner,
        repo: repository.name,
      ).dispatchWorkflow(workflow: configuration.workflowFile);
      if (mounted) {
        setState(() {
          _importStatus = 'Import gestartet.';
          _importFailed = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _importStatus = 'Import konnte nicht gestartet werden: $error';
          _importFailed = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _importBusy = false);
      }
    }
  }

  GitHubRepository _repositoryFrom(WikiConfiguration configuration) {
    if (!configuration.isComplete) {
      throw const FormatException(
        'Wiki-Konfiguration ist unvollständig. Einstellungen prüfen.',
      );
    }
    if (configuration.workflowFile.trim().isEmpty) {
      throw const FormatException('Import-Workflow ist nicht konfiguriert.');
    }
    return GitHubRepository.parse(configuration.repositoryUrl);
  }

  @override
  Widget build(BuildContext context) {
    final isShared = widget.sharedContent != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Wiki'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen öffnen',
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            isShared ? 'Geteilten Inhalt erfassen' : 'Neue Quelle erfassen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            isShared
                ? 'Welche Quellenart ist das?'
                : 'Wähle die passende Quellenart aus.',
          ),
          const SizedBox(height: 16),
          ...sourceTemplates.map(
            (template) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  minVerticalPadding: 16,
                  title: Text(template.name),
                  subtitle: Text(template.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openSource(template),
                ),
              ),
            ),
          ),
          const Divider(height: 32),
          FilledButton.tonalIcon(
            onPressed: _importBusy ? null : _requestImport,
            icon: const Icon(Icons.sync),
            label: Text(
              _importBusy
                  ? 'Import wird gestartet …'
                  : 'Quellen ins Wiki importieren',
            ),
          ),
          if (_importStatus != null) ...[
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                _importStatus!,
                style: TextStyle(
                  color: _importFailed
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
