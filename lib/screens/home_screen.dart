import 'package:flutter/material.dart';

import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import '../models/workflow_run.dart';
import '../services/configuration_service.dart';
import '../services/external_url_service.dart';
import '../services/github_service.dart';
import 'settings_screen.dart';
import 'source_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onImportRequested});

  final VoidCallback? onImportRequested;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _configurationService = ConfigurationService();
  final _externalUrlService = ExternalUrlService();
  bool _importBusy = false;
  bool _statusBusy = false;
  String? _importMessage;
  bool _importFailed = false;
  DateTime? _lastDispatchAt;
  WorkflowRun? _workflowRun;

  void _openSource(SourceTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SourceFormScreen(initialTemplate: template),
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
    final dispatchStartedAt = DateTime.now().toUtc();
    setState(() {
      _importBusy = true;
      _importMessage = 'Import wird auf GitHub gestartet …';
      _importFailed = false;
      _workflowRun = null;
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
          _lastDispatchAt = dispatchStartedAt.subtract(const Duration(seconds: 5));
          _importMessage = 'Import gestartet. Status kann aktualisiert werden.';
          _importFailed = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _importMessage = 'Import konnte nicht gestartet werden: $error';
          _importFailed = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _importBusy = false);
      }
    }
  }

  Future<void> _refreshImportStatus() async {
    final notBefore = _lastDispatchAt;
    if (notBefore == null) {
      return;
    }
    setState(() {
      _statusBusy = true;
      _importMessage = null;
      _importFailed = false;
    });
    try {
      final configuration = await _configurationService.load();
      final repository = _repositoryFrom(configuration);
      final run = await GitHubService(
        configuration.token,
        owner: repository.owner,
        repo: repository.name,
      ).latestWorkflowRun(
        workflow: configuration.workflowFile,
        notBefore: notBefore,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _workflowRun = run;
        _importMessage = run == null
            ? 'Noch kein passender Workflow-Lauf gefunden.'
            : null;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _importMessage = 'Importstatus konnte nicht geladen werden: $error';
          _importFailed = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _statusBusy = false);
      }
    }
  }

  Future<void> _openWorkflowRun() async {
    final run = _workflowRun;
    if (run == null) {
      return;
    }
    try {
      await _externalUrlService.open(run.url);
    } catch (error) {
      if (mounted) {
        setState(() {
          _importMessage = 'Workflow-Lauf konnte nicht geöffnet werden: $error';
          _importFailed = true;
        });
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
            'Neue Quelle erfassen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Wähle die passende Quellenart aus.'),
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
          if (_lastDispatchAt != null) ...[
            const SizedBox(height: 16),
            _importStatusCard(),
          ],
          if (_importMessage != null) ...[
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                _importMessage!,
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

  Widget _importStatusCard() {
    final run = _workflowRun;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Letzter gestarteter Import',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(run?.label ?? 'gestartet / wartet'),
            if (run != null) Text('GitHub Actions #${run.id}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _statusBusy ? null : _refreshImportStatus,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    _statusBusy ? 'Wird aktualisiert …' : 'Status aktualisieren',
                  ),
                ),
                if (run != null)
                  OutlinedButton.icon(
                    onPressed: _openWorkflowRun,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Auf GitHub öffnen'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
