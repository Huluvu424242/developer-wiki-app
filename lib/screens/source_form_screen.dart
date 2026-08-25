import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/created_issue.dart';
import '../models/image_source_file.dart';
import '../models/shared_content.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/external_url_service.dart';
import '../services/github_service.dart';
import '../services/image_input_service.dart';
import '../services/source_prefill_service.dart';
import 'settings_screen.dart';

class SourceFormScreen extends StatefulWidget {
  const SourceFormScreen({
    super.key,
    this.initialTemplate,
    this.sharedContent,
    this.imageInputGateway,
  });

  final SourceTemplate? initialTemplate;
  final SharedContent? sharedContent;
  final ImageInputGateway? imageInputGateway;

  @override
  State<SourceFormScreen> createState() => _SourceFormScreenState();
}

class _SourceFormScreenState extends State<SourceFormScreen> {
  static const _bottomClearance = 64.0;

  final key = GlobalKey<FormState>();
  final title = TextEditingController();
  final _configurationService = ConfigurationService();
  final _externalUrlService = ExternalUrlService();
  final _prefillService = SourcePrefillService();
  late final ImageInputGateway _imageInputGateway;
  late SourceTemplate template;
  final values = <String, TextEditingController>{};
  bool busy = false;
  bool _imageBusy = false;
  bool _useSharedContent = true;
  CreatedIssue? _createdIssue;
  ImageSourceFile? _image;
  bool _imagePrepared = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _imageInputGateway =
        widget.imageInputGateway ?? PlatformImageInputGateway();
    _select(widget.initialTemplate ?? sourceTemplates.first);
  }

  void _select(SourceTemplate next) {
    final previousImage = _image;
    if (previousImage != null) {
      unawaited(_imageInputGateway.discard(previousImage));
      _image = null;
    }
    template = next;
    for (final controller in values.values) {
      controller.dispose();
    }
    values.clear();
    for (final field in next.fields) {
      if (field.kind != FieldKind.image) {
        values[field.id] = TextEditingController(text: field.initialValue);
      }
    }
    final sharedContent = widget.sharedContent;
    if (_useSharedContent && sharedContent != null) {
      final prefilled = _prefillService.valuesFor(next, sharedContent);
      for (final entry in prefilled.entries) {
        values[entry.key]?.text = entry.value;
      }
    }
    _createdIssue = null;
    _imagePrepared = false;
    _errorMessage = null;
  }

  Future<void> submit() async {
    final formIsValid = key.currentState?.validate() ?? false;
    if (!formIsValid || _hasMissingRequiredValues()) {
      _showValidationHint();
      return;
    }

    setState(() {
      busy = true;
      _errorMessage = null;
    });
    if (template == imageSourceTemplate) {
      setState(() {
        busy = false;
        _imagePrepared = true;
      });
      return;
    }
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

  bool _hasMissingRequiredValues() {
    if (title.text.trim().isEmpty) {
      return true;
    }
    return template.fields.any(
      (field) =>
          field.required &&
          (field.kind == FieldKind.image
              ? _image == null
              : values[field.id]!.text.trim().isEmpty),
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _imageBusy = true;
      _errorMessage = null;
      _imagePrepared = false;
    });
    try {
      final selected = await _imageInputGateway.pickImage();
      if (selected == null || !mounted) {
        return;
      }
      final previous = _image;
      setState(() => _image = selected);
      if (previous != null) {
        await _imageInputGateway.discard(previous);
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage =
              'Bild konnte nicht übernommen werden: $error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _imageBusy = false);
      }
    }
  }

  Future<void> _removeImage() async {
    final image = _image;
    if (image == null) {
      return;
    }
    setState(() {
      _image = null;
      _imagePrepared = false;
    });
    try {
      await _imageInputGateway.discard(image);
    } catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage =
              'Temporäre Bilddatei konnte nicht entfernt werden: $error',
        );
      }
    }
  }

  void _showValidationHint() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Bitte markierte Pflichtfelder prüfen.'),
          duration: Duration(seconds: 2),
        ),
      );
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
        setState(
          () => _errorMessage = 'Issue konnte nicht geöffnet werden: $error',
        );
      }
    }
  }

  void _startNewSource() {
    _useSharedContent = false;
    title.clear();
    for (final field in template.fields) {
      if (field.kind != FieldKind.image) {
        values[field.id]!.text = field.initialValue;
      }
    }
    final image = _image;
    if (image != null) {
      unawaited(_imageInputGateway.discard(image));
      _image = null;
    }
    setState(() {
      _createdIssue = null;
      _imagePrepared = false;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    final image = _image;
    if (image != null) {
      unawaited(_imageInputGateway.discard(image));
    }
    title.dispose();
    for (final controller in values.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedContent = widget.sharedContent;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
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
            if (_imagePrepared) _preparedImageCard(),
            if (_errorMessage != null) _errorCard(_errorMessage!),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: title,
              builder: (context, value, _) => TextFormField(
                controller: title,
                enabled: !busy,
                decoration: InputDecoration(
                  labelText: 'Issue-Titel',
                  prefixText: template.titlePrefix,
                  suffixIcon: _clearButton(title, hasValue: value.text.isNotEmpty),
                ),
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Pflichtfeld' : null,
              ),
            ),
            const SizedBox(height: 12),
            ...template.fields.map(_field),
            const SizedBox(height: 20),
            FilledButton.icon(
              key: const Key('source-form-save-button'),
              onPressed: busy ? null : submit,
              icon: const Icon(Icons.cloud_upload),
              label: Text(
                busy
                    ? 'Wird erstellt …'
                    : template == imageSourceTemplate
                        ? 'Bildquelle vorbereiten'
                        : 'Quelle speichern',
              ),
            ),
            SizedBox(
              key: const Key('source-form-bottom-clearance'),
              height: _bottomClearance + bottomInset,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _clearButton(
    TextEditingController controller, {
    required bool hasValue,
  }) {
    if (!hasValue) {
      return null;
    }
    return IconButton(
      tooltip: 'Feld leeren',
      onPressed: busy ? null : controller.clear,
      icon: const Icon(Icons.clear),
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
    if (field.kind == FieldKind.image) {
      return _imageField(field);
    }
    final controller = values[field.id]!;
    if (field.kind == FieldKind.dropdown) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => DropdownButtonFormField<String>(
            key: ValueKey('${field.id}:${value.text}'),
            initialValue: value.text.isEmpty ? null : value.text,
            decoration: InputDecoration(
              labelText: field.label,
              helperText: field.description,
              suffixIcon: _clearButton(
                controller,
                hasValue: value.text.isNotEmpty,
              ),
            ),
            items: field.options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: busy ? null : (selected) => controller.text = selected ?? '',
            validator: (selected) =>
                field.required && selected == null ? 'Pflichtfeld' : null,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => TextFormField(
          controller: controller,
          enabled: !busy,
          minLines: field.kind == FieldKind.textarea ? 3 : 1,
          maxLines: field.kind == FieldKind.textarea ? 8 : 1,
          decoration: InputDecoration(
            labelText: field.label,
            helperText: field.description,
            hintText: field.placeholder,
            alignLabelWithHint: true,
            suffixIcon: _clearButton(
              controller,
              hasValue: value.text.isNotEmpty,
            ),
          ),
          validator: (value) => field.required && (value ?? '').trim().isEmpty
              ? 'Pflichtfeld'
              : null,
        ),
      ),
    );
  }

  Widget _imageField(SourceField field) {
    final image = _image;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FormField<ImageSourceFile>(
        key: const Key('image-source-field'),
        initialValue: image,
        validator: (_) =>
            field.required && _image == null ? 'Pflichtfeld' : null,
        builder: (formField) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(field.description),
            const SizedBox(height: 12),
            if (image == null)
              OutlinedButton.icon(
                key: const Key('image-source-pick-button'),
                onPressed: _imageBusy || busy ? null : _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: Text(
                  _imageBusy ? 'Bild wird übernommen …' : 'Bild auswählen',
                ),
              )
            else ...[
              Semantics(
                label: 'Vorschau des ausgewählten Bildes ${image.name}',
                image: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    key: const Key('image-source-preview'),
                    width: double.infinity,
                    height: 220,
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('Bildvorschau nicht verfügbar'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('${image.name} · ${image.formattedSize}'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _imageBusy || busy ? null : _pickImage,
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Ersetzen'),
                  ),
                  OutlinedButton.icon(
                    key: const Key('image-source-remove-button'),
                    onPressed: _imageBusy || busy ? null : _removeImage,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Entfernen'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Hinweis: Fotos können Aufnahmeort, Geräteinformationen '
                    'und weitere sensible Metadaten enthalten. Das Originalbild '
                    'wird unverändert übernommen.',
                  ),
                ),
              ),
            ],
            if (formField.hasError) ...[
              const SizedBox(height: 8),
              Text(
                formField.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _preparedImageCard() {
    return const Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Die Bild-Quelle ist lokal vorbereitet. Der GitHub-Attachment-Upload '
          'wird im abschließenden Teil des gestapelten Ablaufs ergänzt.',
        ),
      ),
    );
  }
}
