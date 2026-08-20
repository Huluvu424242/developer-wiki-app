import 'package:flutter/material.dart';

import '../models/created_issue.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/external_url_service.dart';
import '../services/github_service.dart';
import 'settings_screen.dart';

class SourceFormScreen extends StatefulWidget {
  const SourceFormScreen({
    super.key,
    this.initialTemplate,
  });

  final SourceTemplate? initialTemplate;

  @override
  State<SourceFormScreen> createState() => _SourceFormScreenState();
}

class _SourceFormScreenState extends State<SourceFormScreen> {
  final key = GlobalKey<FormState>();
  final title = TextEditingController();
  final _configurationService = ConfigurationService();
  final _externalUrlService = ExternalUrlService();
  late SourceTemplate template;
  final values = <String, TextEditingController>{};
  bool busy = false;
  CreatedIssue? _createdIssue;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _select(widget.initialTemplate ?? sourceTemplates.first);
  }

  void _select(SourceTemplate next) {
    template = next;
    for (final controller in values.values) {
      controller.dispose();
    }
    values.clear();
    for (final field in next.fields) {
      values[field.id] = TextEditingController(text: field.initialValue);
    }
    _createdIssue = null;
    _errorMessage = null;
  }

  Future<void> submit() async {
    if (!key.currentState!.validate()) {
      return;
    }

    setState(() {
      busy = true;
      _errorMessage = null;
    });
    try {
      final configuration = await _configurationService.load();
      final repository = _repositoryFrom(configuration);
      final map = values.map((key, value) => MapEntry(key, value.text));
      final issue = await GitHubService(
        configuration.token,
        owner: repository.owner,
        repo: repository.name,
      ).createIssue(
        title: '${template.titlePrefix}${title.text.trim()}',
        body: GitHubService.issueBody(template, map),
      );
      if (mounted) {
        setState(() => _createdIssue = issue);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Quelle konnte nicht erstellt werden: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() => busy = false);
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

  Future<void> _openCreatedIssue() async {
    final issue = _createdIssue;
    if (issue == null) {
      return;
    }
    try {
      await _externalUrlService.open(issue.url);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Issue konnte nicht geöffnet werden: $error');
      }
    }
  }

  void _startNewSource() {
    title.clear();
    for (final field in template.fields) {
      values[field.id]!.text = field.initialValue;
    }
    setState(() {
      _createdIssue = null;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    title.dispose();
    for (final controller in values.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wiki-Quelle erfassen'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen öffnen',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<SourceTemplate>(
              value: template,
              decoration: const InputDecoration(labelText: 'Quellentyp'),
              items: sourceTemplates
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: busy
                  ? null
                  : (selected) {
                      if (selected != null) {
                        setState(() => _select(selected));
                      }
                    },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(template.description),
            ),
            if (_createdIssue != null) _successCard(_createdIssue!),
            if (_errorMessage != null) _errorCard(_errorMessage!),
            TextFormField(
              controller: title,
              enabled: !busy,
              decoration: InputDecoration(
                labelText: 'Issue-Titel',
                prefixText: template.titlePrefix,
              ),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Pflichtfeld' : null,
            ),
            const SizedBox(height: 12),
            ...template.fields.map(_field),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: busy ? null : submit,
              icon: const Icon(Icons.cloud_upload),
              label: Text(busy ? 'Wird erstellt …' : 'Quelle speichern'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _successCard(CreatedIssue issue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quelle erstellt – Issue #${issue.number}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _openCreatedIssue,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Issue öffnen'),
                ),
                FilledButton.tonalIcon(
                  onPressed: _startNewSource,
                  icon: const Icon(Icons.add),
                  label: const Text('Neue Quelle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorCard(String message) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Semantics(
          liveRegion: true,
          child: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }

  Widget _field(SourceField field) {
    final controller = values[field.id]!;
    if (field.kind == FieldKind.dropdown) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          value: controller.text.isEmpty ? null : controller.text,
          decoration: InputDecoration(
            labelText: field.label,
            helperText: field.description,
          ),
          items: field.options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: busy ? null : (value) => controller.text = value ?? '',
          validator: (value) =>
              field.required && value == null ? 'Pflichtfeld' : null,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: !busy,
        minLines: field.kind == FieldKind.textarea ? 3 : 1,
        maxLines: field.kind == FieldKind.textarea ? 8 : 1,
        decoration: InputDecoration(
          labelText: field.label,
          helperText: field.description,
          hintText: field.placeholder,
          alignLabelWithHint: true,
        ),
        validator: (value) => field.required && (value ?? '').trim().isEmpty
            ? 'Pflichtfeld'
            : null,
      ),
    );
  }
}
