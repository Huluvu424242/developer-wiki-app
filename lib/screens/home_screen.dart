import 'package:flutter/material.dart';

import '../models/pending_image_upload.dart';
import '../models/shared_content.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import '../models/workflow_run.dart';
import '../services/configuration_service.dart';
import '../services/external_url_service.dart';
import '../services/github_service.dart';
import '../services/image_upload_service.dart';
import '../services/share_source_router.dart';
import '../widgets/app_support.dart';
import 'document_source_screen.dart';
import 'recent_sources_screen.dart';
import 'settings_screen.dart';
import 'source_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onImportRequested,
    this.sharedContent,
    this.sourceFormBuilder,
    this.imageUploadGateway,
  });

  final VoidCallback? onImportRequested;
  final SharedContent? sharedContent;
  final Widget Function(SourceTemplate, SharedContent?)? sourceFormBuilder;
  final ImageUploadGateway? imageUploadGateway;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _configurationService = ConfigurationService();
  final _externalUrlService = ExternalUrlService();
  final _shareRouter = const ShareSourceRouter();
  bool _importBusy = false;
  bool _statusBusy = false;
  String? _importMessage;
  bool _importFailed = false;
  DateTime? _lastDispatchAt;
  WorkflowRun? _workflowRun;
  String? _openedSharedKey;
  late final ImageUploadGateway _imageUploadGateway;
  PendingImageUpload? _pendingImageUpload;

  @override
  void initState() {
    super.initState();
    _imageUploadGateway =
        widget.imageUploadGateway ?? GitHubImageUploadService();
    _loadPendingImageUpload();
    _scheduleSharedContent();
  }

  Future<void> _loadPendingImageUpload() async {
    try {
      final pending = await _imageUploadGateway.loadPending();
      if (mounted) {
        setState(() => _pendingImageUpload = pending);
      }
    } catch (_) {
      // Die normale Quellenerfassung bleibt bei defektem Altzustand nutzbar.
    }
  }

  Future<void> _openPendingImageUpload() async {
    final pending = _pendingImageUpload;
    if (pending == null) {
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SourceFormScreen(
          initialTemplate: imageSourceTemplate,
          pendingUpload: pending,
          imageUploadGateway: _imageUploadGateway,
        ),
      ),
    );
    await _loadPendingImageUpload();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sharedContent != widget.sharedContent) {
      _scheduleSharedContent();
    }
  }

  void _scheduleSharedContent() {
    final content = widget.sharedContent;
    if (content == null || content.isEmpty) {
      return;
    }
    final key =
        '${content.kind}:${content.image?.path ?? content.document?.path ?? content.text}';
    if (key == _openedSharedKey) {
      return;
    }
    final template = _shareRouter.templateFor(content, sourceTemplates);
    if (template == null) {
      return;
    }
    _openedSharedKey = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _openSource(template);
      }
    });
  }

  void _openSource(SourceTemplate template) {
    if (template.isFileSource) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentSourceScreen(
            template: template,
            initialDocument:
                widget.sharedContent?.kind == SharedContentKind.document
                    ? widget.sharedContent?.document
                    : null,
          ),
        ),
      );
      return;
    }
    final customBuilder = widget.sourceFormBuilder;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            customBuilder?.call(template, widget.sharedContent) ??
            SourceFormScreen(
              initialTemplate: template,
              sharedContent: widget.sharedContent,
            ),
      ),
    );
  }

  void _openRecentSources() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecentSourcesScreen()),
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
          const BugReportButton(contextName: 'Quellenimport-Dialog'),
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
          _lastDispatchAt =
              dispatchStartedAt.subtract(const Duration(seconds: 5));
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
        _importMessage =
            run == null ? 'Noch kein passender Workflow-Lauf gefunden.' : null;
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
          'Wiki-Konfiguration ist unvollständig. Einstellungen prüfen.');
    }
    if (configuration.workflowFile.trim().isEmpty) {
      throw const FormatException('Import-Workflow ist nicht konfiguriert.');
    }
    return GitHubRepository.parse(configuration.repositoryUrl);
  }

  String? _shareErrorText() {
    final content = widget.sharedContent;
    if (content == null) {
      return null;
    }
    return switch (content.kind) {
      SharedContentKind.imageError =>
        'Geteiltes Bild konnte nicht übernommen werden: ${content.text}',
      SharedContentKind.documentError =>
        'Geteiltes Dokument konnte nicht übernommen werden: ${content.text}',
      SharedContentKind.unsupportedFile =>
        'Diese Datei kann mit der aktuellen Wiki-Konfiguration nicht als Quelle erfasst werden. ${content.text}',
      SharedContentKind.link ||
      SharedContentKind.text ||
      SharedContentKind.image ||
      SharedContentKind.document =>
        _shareRouter.templateFor(content, sourceTemplates) == null
            ? 'Für den geteilten Inhalt bietet das verbundene Wiki keine kompatible Quellenart an.'
            : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isShared = widget.sharedContent != null;
    final shareError = _shareErrorText();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Wiki'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen öffnen',
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
          ),
          const AppSupportMenu(contextName: 'Startseite'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_pendingImageUpload != null) ...[
            Card(
              child: ListTile(
                key: const Key('pending-image-upload'),
                leading: const Icon(Icons.cloud_upload_outlined),
                title: Text(
                    'Bild-Upload #${_pendingImageUpload!.issueNumber} fortsetzen'),
                subtitle: Text(_pendingImageUpload!.image.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: _openPendingImageUpload,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (shareError != null) ...[
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Semantics(liveRegion: true, child: Text(shareError)),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            isShared ? 'Geteilten Inhalt erfassen' : 'Neue Quelle erfassen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            isShared
                ? 'Die passende Quellenart wird anhand des geteilten Inhalts vorausgewählt.'
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
          OutlinedButton.icon(
            onPressed: _openRecentSources,
            icon: const Icon(Icons.history),
            label: const Text('Letzte Quellen'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _importBusy ? null : _requestImport,
            icon: const Icon(Icons.sync),
            label: Text(_importBusy
                ? 'Import wird gestartet …'
                : 'Quellen ins Wiki importieren'),
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
            Text('Letzter gestarteter Import',
                style: Theme.of(context).textTheme.titleMedium),
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
                  label: Text(_statusBusy
                      ? 'Wird aktualisiert …'
                      : 'Status aktualisieren'),
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
