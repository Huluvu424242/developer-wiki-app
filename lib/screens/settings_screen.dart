import 'package:flutter/material.dart';

import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/github_service.dart';

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
  final _repositoryController = TextEditingController();
  final _tokenController = TextEditingController();
  final _configurationService = ConfigurationService();

  bool _busy = false;
  bool _obscure = true;
  bool _connectionVerified = false;
  String? _status;
  bool _statusIsError = false;

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

  Future<void> _testConnection() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      _setStatus('Bitte zuerst ein Fine-grained PAT eingeben.', isError: true);
      return;
    }

    GitHubRepository repository;
    try {
      repository = GitHubRepository.parse(_repositoryController.text);
    } on FormatException catch (error) {
      _setStatus(error.message.toString(), isError: true);
      return;
    }

    setState(() {
      _busy = true;
      _status = 'Verbindung wird geprüft …';
      _statusIsError = false;
      _connectionVerified = false;
    });

    try {
      final login = await GitHubService(
        token,
        owner: repository.owner,
        repo: repository.name,
      ).verifyRepositoryAccess();
      if (!mounted) {
        return;
      }
      setState(() {
        _connectionVerified = true;
        _status = 'Verbindung erfolgreich – angemeldet als $login.';
        _statusIsError = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      _setStatus(
        'Zugriff fehlgeschlagen. Token, Repository und Berechtigungen prüfen: '
        '$error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_connectionVerified) {
      _setStatus('Bitte die Verbindung vor dem Speichern erfolgreich testen.',
          isError: true);
      return;
    }

    final repository = GitHubRepository.parse(_repositoryController.text);
    setState(() => _busy = true);
    try {
      await _configurationService.save(
        WikiConfiguration(
          repositoryUrl: repository.url,
          token: _tokenController.text.trim(),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isSetup,
        title: Text(widget.isSetup ? 'Developer Wiki – Einrichtung' : 'Einstellungen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _repositoryController,
            enabled: !_busy,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'GitHub Wiki',
              helperText: 'Repository-URL oder owner/repo',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tokenController,
            enabled: !_busy,
            obscureText: _obscure,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Fine-grained PAT',
              helperText: 'Das Token wird nur im geschützten lokalen Speicher abgelegt.',
              suffixIcon: IconButton(
                tooltip: _obscure ? 'Token anzeigen' : 'Token ausblenden',
                onPressed: _busy ? null : () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
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
            onPressed: _busy || !_connectionVerified ? null : _save,
            icon: const Icon(Icons.save),
            label: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
