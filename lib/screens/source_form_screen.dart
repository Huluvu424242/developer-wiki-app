import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/source_template.dart';
import '../services/github_service.dart';
import 'settings_screen.dart';

class SourceFormScreen extends StatefulWidget {
  const SourceFormScreen({super.key});
  @override
  State<SourceFormScreen> createState() => _SourceFormScreenState();
}

class _SourceFormScreenState extends State<SourceFormScreen> {
  final key = GlobalKey<FormState>();
  final title = TextEditingController();
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  late SourceTemplate template;
  final values = <String, TextEditingController>{};
  bool busy = false;
  @override
  void initState() {
    super.initState();
    _select(sourceTemplates.first);
  }

  void _select(SourceTemplate next) {
    template = next;
    for (final c in values.values) c.dispose();
    values.clear();
    for (final f in next.fields)
      values[f.id] = TextEditingController(text: f.initialValue);
  }

  Future<void> submit() async {
    if (!key.currentState!.validate()) return;
    final token = await storage.read(key: 'github_pat');
    if (token == null || token.isEmpty) {
      if (mounted)
        await Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
      return;
    }
    setState(() => busy = true);
    try {
      final map = values.map((k, v) => MapEntry(k, v.text));
      final url = await GitHubService(token).createIssue(
          title: '${template.titlePrefix}${title.text.trim()}',
          body: GitHubService.issueBody(template, map));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Issue erstellt: $url')));
        title.clear();
        for (final f in template.fields) values[f.id]!.text = f.initialValue;
        setState(() {});
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Wiki-Quelle erfassen'), actions: [
        IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
            icon: const Icon(Icons.settings))
      ]),
      body: Form(
          key: key,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            DropdownButtonFormField<SourceTemplate>(
                value: template,
                decoration: const InputDecoration(labelText: 'Quellentyp'),
                items: sourceTemplates
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (t) => setState(() => _select(t!))),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(template.description)),
            TextFormField(
                controller: title,
                decoration: InputDecoration(
                    labelText: 'Issue-Titel', prefixText: template.titlePrefix),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Pflichtfeld' : null),
            const SizedBox(height: 12),
            ...template.fields.map(_field),
            const SizedBox(height: 20),
            FilledButton.icon(
                onPressed: busy ? null : submit,
                icon: const Icon(Icons.cloud_upload),
                label: Text(busy
                    ? 'Wird erstellt …'
                    : 'Issue mit Label „quelle“ erstellen')),
          ])));
  Widget _field(SourceField f) {
    final c = values[f.id]!;
    if (f.kind == FieldKind.dropdown)
      return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
              value: c.text.isEmpty ? null : c.text,
              decoration: InputDecoration(
                  labelText: f.label, helperText: f.description),
              items: f.options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: (v) => c.text = v ?? '',
              validator: (v) =>
                  f.required && v == null ? 'Pflichtfeld' : null));
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
            controller: c,
            minLines: f.kind == FieldKind.textarea ? 3 : 1,
            maxLines: f.kind == FieldKind.textarea ? 8 : 1,
            decoration: InputDecoration(
                labelText: f.label,
                helperText: f.description,
                hintText: f.placeholder,
                alignLabelWithHint: true),
            validator: (v) =>
                f.required && (v ?? '').trim().isEmpty ? 'Pflichtfeld' : null));
  }
}
