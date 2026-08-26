import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/created_issue.dart';
import '../models/image_source_file.dart';
import '../models/pending_image_upload.dart';
import '../models/shared_content.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import '../services/configuration_service.dart';
import '../services/external_url_service.dart';
import '../services/github_service.dart';
import '../services/image_input_service.dart';
import '../services/image_upload_service.dart';
import '../services/source_prefill_service.dart';
import '../widgets/app_support.dart';
import '../widgets/bounded_text_form_field.dart';
import 'settings_screen.dart';

class SourceFormScreen extends StatefulWidget {
  const SourceFormScreen({
    super.key,
    this.initialTemplate,
    this.sharedContent,
    this.imageInputGateway,
    this.imageUploadGateway,
    this.imagePreviewBuilder,
    this.pendingUpload,
  });

  final SourceTemplate? initialTemplate;
  final SharedContent? sharedContent;
  final ImageInputGateway? imageInputGateway;
  final ImageUploadGateway? imageUploadGateway;
  final Widget Function(ImageSourceFile image)? imagePreviewBuilder;
  final PendingImageUpload? pendingUpload;

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
  late final ImageUploadGateway _imageUploadGateway;
  late SourceTemplate template;
  final values = <String, TextEditingController>{};
  bool busy = false;
  bool _imageBusy = false;
  bool _useSharedContent = true;
  CreatedIssue? _createdIssue;
  ImageSourceFile? _image;
  PendingImageUpload? _pendingUpload;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _imageInputGateway =
        widget.imageInputGateway ?? PlatformImageInputGateway();
    _imageUploadGateway =
        widget.imageUploadGateway ?? GitHubImageUploadService();
    _select(widget.initialTemplate ?? sourceTemplates.first);
    final pendingUpload = widget.pendingUpload;
    final sharedImage = widget.sharedContent?.image;
    if (pendingUpload != null) {
      _pendingUpload = pendingUpload;
      _image = pendingUpload.image;
      title.text = pendingUpload.title;
      for (final entry in pendingUpload.values.entries) {
        values[entry.key]?.text = entry.value;
      }
    } else if (widget.sharedContent?.kind == SharedContentKind.image &&
        sharedImage != null) {
      _image = sharedImage;
    }
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
    try {
      if (template == imageSourceTemplate) {
        await _submitImageSource();
      } else {
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

  Future<void> _submitImageSource() async {
    final pending = _pendingUpload;
    if (pending == null) {
      final image = _image!;
      final map = values.map((key, value) => MapEntry(key, value.text));
      final started = await _imageUploadGateway.start(
        title: title.text,
        values: map,
        image: image,
      );
      if (mounted) {
        setState(() => _pendingUpload = started);
      }
      return;
    }

    final issue = await _imageUploadGateway.verify(pending);
    final image = _image;
    if (image != null) {
      unawaited(_imageInputGateway.discard(image));
    }
    if (mounted) {
      setState(() {
        _pendingUpload = null;
        _image = null;
        _createdIssue = issue;
      });
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

  Future<void> _openPendingUpload() async {
    final pending = _pendingUpload;
    if (pending == null) {
      return;
    }
    try {
      await _imageUploadGateway.open(pending);
    } catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage =
              'Pending-Issue konnte nicht geöffnet werden: $error',
        );
      }
    }
  }

  Future<void> _discardPendingUpload() async {
    final pending = _pendingUpload;
    if (pending == null) {
      return;
    }
    setState(() {
      busy = true;
      _errorMessage = null;
    });
    try {
      await _imageUploadGateway.discard(pending);
      await _imageInputGateway.discard(pending.image);
      if (mounted) {
        setState(() {
          _pendingUpload = null;
          _image = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _errorMessage =
              'Upload konnte nicht verworfen werden: $error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => busy = false);
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
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    final image = _image;
    if (image != null && _pendingUpload == null) {
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
          AppSupportMenu(
            contextName: sharedContent == null
                ? 'Quellenformular'
                : 'Geteilten Inhalt erfassen',
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
              onChanged: busy || _pendingUpload != null
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
            if (_pendingUpload != null) _pendingImageCard(_pendingUpload!),
            if (_errorMessage != null) _errorCard(_errorMessage!),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: title,
              builder: (context, value, _) => TextFormField(
                controller: title,
                enabled: !busy && _pendingUpload == null,
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
                        ? _pendingUpload == null
                            ? 'Upload auf GitHub starten'
                            : 'Upload prüfen und Quelle veröffentlichen'
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
      onPressed: busy || _pendingUpload != null ? null : controller.clear,
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
            onChanged: busy || _pendingUpload != null
                ? null
                : (selected) => controller.text = selected ?? '',
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
          enabled: !busy && _pendingUpload == null,
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
                onPressed: _imageBusy || busy || _pendingUpload != null
                    ? null
                    : _pickImage,
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
                    child: widget.imagePreviewBuilder?.call(image) ??
                        Image.file(
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
                    onPressed: _imageBusy || busy || _pendingUpload != null
                        ? null
                        : _pickImage,
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Ersetzen'),
                  ),
                  OutlinedButton.icon(
                    key: const Key('image-source-remove-button'),
                    onPressed: _imageBusy || busy || _pendingUpload != null
                        ? null
                        : _removeImage,
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

  Widget _pendingImageCard(PendingImageUpload upload) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bild-Upload für Issue #${upload.issueNumber} ausstehend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Das Bild im geöffneten GitHub-Issue als Kommentar anhängen und '
              'den Kommentar absenden. Danach hier den Upload prüfen. Erst bei '
              'Erfolg wird das Label „quelle“ gesetzt.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: busy ? null : _openPendingUpload,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('GitHub öffnen'),
                ),
                TextButton.icon(
                  onPressed: busy ? null : _discardPendingUpload,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Upload verwerfen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
