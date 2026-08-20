import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/source_template.dart';
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
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  late SourceTemplate template;
  final values = <String, TextEditingController>{};
  bool busy = false;

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
  }

  Future<void> submit() async {
    if (!key.currentState!.validate()) {
      return;
    }
    final token = await storage.read(key: 'github_pat');
    if (token == null || token.isEmpty) {
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
      }
      return;
    }
    setState(() => busy = true);
    try {
      final map = values.map((key, value) => MapEntry(key, value.text));
      final url = await GitHubService(token).createIssue(
        title: '${template.titlePrefix}${title.text.trim()}',
        body: GitHubService.issueBody(template, map),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Issue erstellt: $url')),
        );
        title.clear();
        for (final field in template.fields) {
          values[field.id]!.text = field.initialValue;
        }
        setState(() {});
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => busy = false);
      }
    }
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
              onChanged: (selected) {
                if (selected != null) {
                  setState(() => _select(selected));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(template.description),
            ),
            TextFormField(
              controller: title,
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
              label: Text(
                busy
                    ? 'Wird erstellt …'
                    : 'Issue mit Label „quelle“ erstellen',
              ),
            ),
          ],
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
          onChanged: (value) => controller.text = value ?? '',
          validator: (value) =>
              field.required && value == null ? 'Pflichtfeld' : null,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
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
