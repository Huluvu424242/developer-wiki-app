import 'package:flutter/material.dart';

import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/github_service.dart';
import '../widgets/app_support.dart';
import '../widgets/bounded_text_form_field.dart';
import '../widgets/error_summary.dart';
import '../widgets/pat_help_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.isSetup = false,
    this.onConfigured,
  });

  final bool isSetup;
  final VoidCallback? onConfigured;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _bottomClearance = 64.0;

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _summaryFocus = FocusNode(debugLabel: 'Einstellungen-Fehlersammler');
  final _repositoryFocus = FocusNode(debugLabel: 'GitHub Wiki');
  final _tokenFocus = FocusNode(debugLabel: 'Fine-grained PAT');
  final _workflowFocus = FocusNode(debugLabel: 'Import-Workflow');
  final _repositoryController = TextEditingController();
  final _tokenController = TextEditingController();
  final _workflowController = TextEditingController();
  final _configurationService = ConfigurationService();

  bool _busy = false;
  bool _obscure = true;
  bool _connectionVerified = false;
  String? _status;
  bool _statusIsError = false;
  List<String> _validationErrors = const [];

  @override
  void initState() {
    super.initState();
    _repositoryController.addListener(_invalidateVerification);
    _tokenController.addListener(_invalidateVerification);
    _load();
  }

  Future<void> _load() async {
    final configuration = await _configurationService.load();
    if (!mounted) {
      return;
    }
    _repositoryController.text = configuration.repositoryUrl;
    _tokenController.text = configuration.token;
    _workflowController.text = configuration.workflowFile;
  }

  void _invalidateVerification() {
    if (!_connectionVerified && _status == null) {
      return;
    }
    setState(() {
      _connectionVerified = false;
      _status = null;
      _statusIsError = false;
    });
  }

  List<String> _collectErrors({required bool includeWorkflow}) {
    final errors = <String>[];
    if (_repositoryController.text.trim().isEmpty) {
      errors.add('GitHub Wiki: Pflichtfeld');
    } else {
      try {
        GitHubRepository.parse(_repositoryController.text);
      } on FormatException catch (error) {
        errors.add('GitHub Wiki: ${error.message}');
      }
    }
    if (_tokenController.text.trim().isEmpty) {
      errors.add('Fine-grained PAT: Pflichtfeld');
    }
    if (includeWorkflow && _workflowController.text.trim().isEmpty) {
      errors.add('Import-Workflow: Pflichtfeld');
    }
    return errors;
  }

  Future<bool> _showValidationErrors(List<String> errors) async {
    if (errors.isEmpty) {
      setState(() => _validationErrors = const []);
      return false;
    }
    setState(() => _validationErrors = errors);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Bitte markierte Pflichtfelder prüfen.')),
      );
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    _summaryFocus.requestFocus();
    return true;
  }

  void _focusError(String error) {
    final label = error.split(':').first;
    final node = switch (label) {
      'GitHub Wiki' => _repositoryFocus,
      'Fine-grained PAT' => _tokenFocus,
      _ => _workflowFocus,
    };
    node.requestFocus();
    final focusContext = node.context;
    if (focusContext != null) {
      Scrollable.ensureVisible(focusContext);
    }
  }

  String? _required(String? value) =>
      (value ?? '').trim().isEmpty ? 'Pflichtfeld' : null;

  String? _repositoryValidator(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) {
      return requiredError;
    }
    try {
      GitHubRepository.parse(value!);
      return null;
    } on FormatException catch (error) {
      return error.message.toString();
    }
  }

  Future<void> _testConnection() async {
    if (await _showValidationErrors(_collectErrors(includeWorkflow: false))) {
      return;
    }
    final repository = GitHubRepository.parse(_repositoryController.text);
    setState(() {
      _busy = true;
      _status = 'Verbindung wird geprüft …';
      _statusIsError = false;
      _connectionVerified = false;
    });
    try {
      final login = await GitHubService(
        _tokenController.text.trim(),
        owner: repository.owner,
        repo: repository.name,
      ).verifyRepositoryAccess();
      if (mounted) {
        setState(() {
          _connectionVerified = true;
          _status = 'Verbindung erfolgreich – angemeldet als $login.';
          _statusIsError = false;
        });
      }
    } catch (error) {
      if (mounted) {
        _setStatus(
          'Zugriff fehlgeschlagen. Token, Repository und Berechtigungen prüfen: '
          '$error',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _save() async {
    if (await _showValidationErrors(_collectErrors(includeWorkflow: true))) {
      return;
    }
    if (!_connectionVerified) {
      _setStatus(
        'Bitte die Verbindung vor dem Speichern erfolgreich testen.',
        isError: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speichern ist noch nicht möglich.')),
      );
      return;
    }
    final repository = GitHubRepository.parse(_repositoryController.text);
    setState(() => _busy = true);
    try {
      await _configurationService.save(
        WikiConfiguration(
          repositoryUrl: repository.url,
          token: _tokenController.text.trim(),
          workflowFile: _workflowController.text.trim(),
        ),
      );
      if (!mounted) {
        return;
      }
      widget.onConfigured?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wiki-Verbindung gespeichert.')),
      );
      if (!widget.isSetup && Navigator.canPop(context)) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _setStatus(String message, {required bool isError}) {
    if (!mounted) {
      return;
    }
    setState(() {
      _status = message;
      _statusIsError = isError;
      if (isError) {
        _connectionVerified = false;
      }
    });
  }

  @override
  void dispose() {
    _repositoryController
      ..removeListener(_invalidateVerification)
      ..dispose();
    _tokenController
      ..removeListener(_invalidateVerification)
      ..dispose();
    _workflowController.dispose();
    _scrollController.dispose();
    _summaryFocus.dispose();
    _repositoryFocus.dispose();
    _tokenFocus.dispose();
    _workflowFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isSetup,
        title: Text(
          widget.isSetup ? 'Developer Wiki – Einrichtung' : 'Einstellungen',
        ),
        actions: [
          AppSupportMenu(
            contextName: widget.isSetup ? 'Ersteinrichtung' : 'Einstellungen',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            ErrorSummary(
              focusNode: _summaryFocus,
              errors: _validationErrors
                  .map(
                    (error) => ValidationErrorItem(
                      label: error,
                      onActivate: () => _focusError(error),
                    ),
                  )
                  .toList(growable: false),
            ),
            BoundedTextFormField(
              controller: _repositoryController,
              focusNode: _repositoryFocus,
              maxLength: 300,
              enabled: !_busy,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              validator: _repositoryValidator,
              decoration: const InputDecoration(
                labelText: 'GitHub Wiki',
                helperText: 'Repository-URL oder owner/repo',
              ),
            ),
            const SizedBox(height: 16),
            BoundedTextFormField(
              controller: _tokenController,
              focusNode: _tokenFocus,
              maxLength: 500,
              enabled: !_busy,
              obscureText: _obscure,
              enableSuggestions: false,
              autocorrect: false,
              validator: _required,
              decoration: InputDecoration(
                labelText: 'Fine-grained PAT',
                helperText:
                    'Das Token wird nur im geschützten lokalen Speicher abgelegt.',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PatHelpButton(),
                    IconButton(
                      tooltip: _obscure ? 'Token anzeigen' : 'Token ausblenden',
                      onPressed: _busy
                          ? null
                          : () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BoundedTextFormField(
              controller: _workflowController,
              focusNode: _workflowFocus,
              maxLength: 255,
              enabled: !_busy,
              validator: _required,
              decoration: const InputDecoration(
                labelText: 'Import-Workflow',
                helperText:
                    'Dateiname des per workflow_dispatch startbaren Workflows',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _testConnection,
              icon: const Icon(Icons.link),
              label: const Text('Verbindung testen'),
            ),
            if (_status != null) ...[
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Text(
                  _status!,
                  style: TextStyle(
                    color: _statusIsError
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.save),
              label: const Text('Speichern'),
            ),
            SizedBox(height: _bottomClearance + bottomInset),
          ],
        ),
      ),
    );
  }
}
