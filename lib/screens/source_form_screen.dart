import 'package:flutter/material.dart';

import '../models/source_template.dart';
import '../services/github_service.dart';
import '../services/settings_service.dart';
import '../share/shared_content.dart';
import 'settings_screen.dart';

class SourceFormScreen extends StatefulWidget {
  const SourceFormScreen({
    super.key,
    required this.githubService,
    required this.settingsService,
    this.sharedContent,
  });

  final GitHubService githubService;
  final SettingsService settingsService;
  final SharedContent? sharedContent;

  @override
  State<SourceFormScreen> createState() => _SourceFormScreenState();
}

class _SourceFormScreenState extends State<SourceFormScreen> {
  final key = GlobalKey<FormState>();
  final title = TextEditingController();
  final values = <String, TextEditingController>{};
  late SourceTemplate template;
  bool busy = false;
  CreatedIssue? _createdIssue;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    template = sourceTemplates.first;
    _select(template);
    _applySharedContent(widget.sharedContent);
  }

  @override
  void dispose() {
    title.dispose();
    for (final controller in values.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _select(SourceTemplate selected) {
    template = selected;
    for (final controller in values.values) {
      controller.dispose();
    }
    values
      ..clear()
      ..addEntries(
        selected.fields.map(
          (field) => MapEntry(field.id, TextEditingController()),
        ),
      );
    _applySharedContent(widget.sharedContent);
  }

  void _applySharedContent(SharedContent? sharedContent) {
    if (sharedContent == null) {
      return;
    }

    final url = sharedContent.url?.trim();
    final text = sharedContent.text.trim();
    if (url != null && url.isNotEmpty) {
      for (final field in template.fields) {
        if (field.id.toLowerCase().contains('url')) {
          values[field.id]?.text = url;
          break;
        }
      }
    }

    if (text.isNotEmpty) {
      for (final field in template.fields) {
        if (field.kind == FieldKind.textarea) {
          values[field.id]?.text = text;
          break;
        }
      }
    }
  }

  Future<void> submit() async {
    if (!(key.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      busy = true;
      _createdIssue = null;
      _errorMessage = null;
    });
    try {
      final issue = await widget.githubService.createSourceIssue(
        template: template,
        title: title.text,
        values: {
          for (final entry in values.entries) entry.key: entry.value.text,
        },
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _createdIssue = issue;
        busy = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        busy = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _openCreatedIssue() async {
    final issue = _createdIssue;
    if (issue == null) {
      return;
    }
    await widget.githubService.openIssue(issue.url);
  }

  void _startNewSource() {
    setState(() {
      _createdIssue = null;
      _errorMessage = null;
      title.clear();
      _select(template);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sharedContent = widget.sharedContent;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sharedContent == null
              ? 'Wiki-Quelle erfassen'
              : 'Geteilten Inhalt erfassen',
        ),
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
            if (sharedContent != null) ...[
              const Text(
                'Geteilter Inhalt wurde vorausgefüllt und kann bearbeitet werden.',
              ),
              const SizedBox(height: 12),
            ],
            DropdownButtonFormField<SourceTemplate>(
              initialValue: template,
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
          initialValue: controller.text.isEmpty ? null : controller.text,
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
        ),
        validator: (value) => field.required && (value ?? '').trim().isEmpty
            ? 'Pflichtfeld'
            : null,
      ),
    );
  }
}
