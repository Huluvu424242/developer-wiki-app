import 'package:flutter/material.dart';

import '../models/app_info.dart';
import '../services/app_info_service.dart';
import '../services/external_url_service.dart';
import 'bounded_text_form_field.dart';
import 'error_summary.dart' as validation;

const _appRepository = 'Huluvu424242/developer-wiki-app';

class AppSupportMenu extends StatelessWidget {
  const AppSupportMenu({
    super.key,
    required this.contextName,
    this.appInfoGateway,
    this.externalUrlService,
  });

  final String contextName;
  final AppInfoGateway? appInfoGateway;
  final ExternalUrlService? externalUrlService;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SupportAction>(
      tooltip: 'App-Menü öffnen',
      onSelected: (action) {
        switch (action) {
          case _SupportAction.reportBug:
            showBugReport(
              context,
              contextName: contextName,
              appInfoGateway: appInfoGateway,
              externalUrlService: externalUrlService,
            );
          case _SupportAction.about:
            showAppAbout(
              context,
              contextName: contextName,
              appInfoGateway: appInfoGateway,
              externalUrlService: externalUrlService,
            );
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: _SupportAction.reportBug,
          child: Text('Bug melden'),
        ),
        PopupMenuItem(
          value: _SupportAction.about,
          child: Text('Über'),
        ),
      ],
    );
  }
}

enum _SupportAction { reportBug, about }

class BugReportButton extends StatelessWidget {
  const BugReportButton({
    super.key,
    required this.contextName,
    this.appInfoGateway,
    this.externalUrlService,
  });

  final String contextName;
  final AppInfoGateway? appInfoGateway;
  final ExternalUrlService? externalUrlService;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showBugReport(
        context,
        contextName: contextName,
        appInfoGateway: appInfoGateway,
        externalUrlService: externalUrlService,
      ),
      icon: const Icon(Icons.bug_report_outlined),
      label: const Text('Bug melden'),
    );
  }
}

Future<void> showAppAbout(
  BuildContext context, {
  required String contextName,
  AppInfoGateway? appInfoGateway,
  ExternalUrlService? externalUrlService,
}) async {
  final gateway = appInfoGateway ?? AppInfoService();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Über Developer Wiki'),
      content: FutureBuilder<AppInfo>(
        future: gateway.load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Semantics(
              liveRegion: true,
              child: Text(
                'Releaseversion konnte nicht geladen werden: ${snapshot.error}',
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Developer-Wiki-App'),
              const SizedBox(height: 8),
              Text('Releaseversion ${snapshot.data!.displayVersion}'),
            ],
          );
        },
      ),
      actions: [
        BugReportButton(
          contextName: 'Über-Dialog',
          appInfoGateway: gateway,
          externalUrlService: externalUrlService,
        ),
        TextButton(
          onPressed: () => showAccessibilityStatement(
            dialogContext,
            appInfoGateway: gateway,
            externalUrlService: externalUrlService,
          ),
          child: const Text('Barrierefreiheitserklärung'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Schließen'),
        ),
      ],
    ),
  );
}

Future<void> showAccessibilityStatement(
  BuildContext context, {
  AppInfoGateway? appInfoGateway,
  ExternalUrlService? externalUrlService,
}) =>
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Barrierefreiheitserklärung'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stand: 26. August 2026',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Die Developer-Wiki-App wird nach den im Projekt festgelegten '
                'UX- und Barrierefreiheitsregeln weiterentwickelt. Formulare '
                'bieten verständliche Beschriftungen, feldnahe Fehler, einen '
                'Fehlersammler und Unterstützung für vergrößerte Schrift.',
              ),
              SizedBox(height: 12),
              Text(
                'Bekannte Barrieren',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Die praktische Prüfung mit unterschiedlichen Android-'
                'Screenreadern und Schaltersteuerungen ist noch nicht für '
                'jede Gerätekombination abgeschlossen. Externe GitHub-Seiten '
                'liegen außerhalb des Einflussbereichs dieser App.',
              ),
              SizedBox(height: 12),
              Text(
                'Barrieren melden',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Über „Bug melden“ kann eine Barriere mit App-Version und '
                'aktuellem Nutzungskontext gemeldet werden.',
              ),
            ],
          ),
        ),
        actions: [
          BugReportButton(
            contextName: 'Barrierefreiheitserklärung',
            appInfoGateway: appInfoGateway,
            externalUrlService: externalUrlService,
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );

Future<void> showBugReport(
  BuildContext context, {
  required String contextName,
  AppInfoGateway? appInfoGateway,
  ExternalUrlService? externalUrlService,
}) async {
  final gateway = appInfoGateway ?? AppInfoService();
  AppInfo appInfo;
  try {
    appInfo = await gateway.load();
  } catch (error) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Releaseversion konnte nicht geladen werden: $error')),
    );
    return;
  }
  if (!context.mounted) {
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (_) => _BugReportDialog(
      contextName: contextName,
      appInfo: appInfo,
      externalUrlService: externalUrlService ?? ExternalUrlService(),
    ),
  );
}

class _BugReportDialog extends StatefulWidget {
  const _BugReportDialog({
    required this.contextName,
    required this.appInfo,
    required this.externalUrlService,
  });

  final String contextName;
  final AppInfo appInfo;
  final ExternalUrlService externalUrlService;

  @override
  State<_BugReportDialog> createState() => _BugReportDialogState();
}

class _BugReportDialogState extends State<_BugReportDialog> {
  static const _descriptionMaxLength = 2000;

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _summaryFocus = FocusNode(debugLabel: 'Bugreport-Fehlersammler');
  final _typeFocus = FocusNode(debugLabel: 'Fehlerart');
  final _descriptionFocus = FocusNode(debugLabel: 'Fehlerbeschreibung');
  final _description = TextEditingController();
  String? _type;
  bool _showErrors = false;
  bool _busy = false;
  String? _errorMessage;

  List<validation.ValidationErrorItem> get _errors {
    if (!_showErrors || _type != null) {
      return const [];
    }
    return [
      validation.ValidationErrorItem(
        label: 'Fehlerart: Bitte auswählen',
        onActivate: () => _focus(_typeFocus),
      ),
    ];
  }

  void _focus(FocusNode node) {
    node.requestFocus();
    final focusContext = node.context;
    if (focusContext != null) {
      Scrollable.ensureVisible(focusContext);
    }
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      setState(() => _showErrors = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte markierte Pflichtfelder prüfen.')),
      );
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      _summaryFocus.requestFocus();
      return;
    }

    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    final title = '[${_type!}] App-Fehler in ${widget.contextName}';
    final body = [
      '## Fehlerart',
      _type!,
      '',
      '## Kontext',
      widget.contextName,
      '',
      '## Releaseversion',
      widget.appInfo.displayVersion,
      '',
      '## Beschreibung',
      _description.text.trim().isEmpty
          ? 'Keine zusätzliche Beschreibung angegeben.'
          : _description.text.trim(),
    ].join('\n');
    final uri = Uri.https(
      'github.com',
      '/$_appRepository/issues/new',
      {
        'template': 'app_bug_report.md',
        'labels': 'bug',
        'title': title,
        'body': body,
      },
    );
    try {
      await widget.externalUrlService.open(uri.toString());
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _errorMessage = 'Bugreport konnte nicht auf GitHub geöffnet werden: $error';
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _summaryFocus.dispose();
    _typeFocus.dispose();
    _descriptionFocus.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bug melden'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                validation.ErrorSummary(errors: _errors, focusNode: _summaryFocus),
                Text('Kontext: ${widget.contextName}'),
                Text('Releaseversion: ${widget.appInfo.displayVersion}'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  focusNode: _typeFocus,
                  initialValue: _type,
                  hint: const Text('Bitte auswählen'),
                  decoration: const InputDecoration(
                    labelText: 'Fehlerart *',
                    helperText: 'Bitte eine Fehlerart auswählen.',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Barrierefreiheitsfehler',
                      child: Text('Barrierefreiheitsfehler'),
                    ),
                    DropdownMenuItem(
                      value: 'Darstellungsfehler',
                      child: Text('Darstellungsfehler'),
                    ),
                    DropdownMenuItem(
                      value: 'Funktionsfehler',
                      child: Text('Funktionsfehler'),
                    ),
                    DropdownMenuItem(
                      value: 'Sonstiges',
                      child: Text('Sonstiges'),
                    ),
                  ],
                  onChanged: _busy
                      ? null
                      : (value) => setState(() => _type = value),
                  validator: (value) =>
                      value == null ? 'Bitte eine Fehlerart auswählen.' : null,
                ),
                const SizedBox(height: 16),
                BoundedTextFormField(
                  controller: _description,
                  focusNode: _descriptionFocus,
                  maxLength: _descriptionMaxLength,
                  minLines: 4,
                  maxLines: 8,
                  enabled: !_busy,
                  decoration: const InputDecoration(
                    labelText: 'Beschreibung',
                    helperText:
                        'Keine Zugangsdaten oder persönlichen Daten eintragen.',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  container: true,
                  child: const Text(
                    'Zum Absenden ist eine Anmeldung bei GitHub erforderlich. '
                    'Der vorbereitete Bericht kann auf GitHub geprüft und erst '
                    'dort endgültig abgesendet werden.',
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton.icon(
          onPressed: _busy ? null : _submit,
          icon: const Icon(Icons.open_in_new),
          label: Text(_busy ? 'Wird geöffnet …' : 'Auf GitHub prüfen'),
        ),
      ],
    );
  }
}
