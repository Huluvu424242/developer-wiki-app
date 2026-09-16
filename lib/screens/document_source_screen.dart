import 'dart:async';

import 'package:flutter/material.dart';

import '../models/created_issue.dart';
import '../models/document_source_file.dart';
import '../models/pending_document_upload.dart';
import '../models/source_template.dart';
import '../services/document_input_service.dart';
import '../services/document_upload_service.dart';
import '../services/external_url_service.dart';
import '../widgets/app_support.dart';
import '../widgets/bounded_text_form_field.dart';
import '../widgets/error_summary.dart' as validation;

class DocumentSourceScreen extends StatefulWidget {
  const DocumentSourceScreen({
    super.key,
    required this.template,
    this.initialDocument,
    this.inputGateway,
    this.uploadGateway,
  });

  final SourceTemplate template;
  final DocumentSourceFile? initialDocument;
  final DocumentInputGateway? inputGateway;
  final DocumentUploadGateway? uploadGateway;

  @override
  State<DocumentSourceScreen> createState() => _DocumentSourceScreenState();
}

class _DocumentSourceScreenState extends State<DocumentSourceScreen> {
  static const _bottomClearance = 64.0;

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _summaryFocus = FocusNode(debugLabel: 'Dokumentquelle-Fehlersammler');
  final _titleFocus = FocusNode(debugLabel: 'Issue-Titel');
  final _fieldFocus = <String, FocusNode>{};
  final _title = TextEditingController();
  final _values = <String, TextEditingController>{};
  final _externalUrlService = ExternalUrlService();
  late final DocumentInputGateway _inputGateway;
  late final DocumentUploadGateway _uploadGateway;
  late final SourceField _documentField;

  DocumentSourceFile? _document;
  PendingDocumentUpload? _pending;
  CreatedIssue? _createdIssue;
  bool _busy = false;
  bool _fileBusy = false;
  String? _errorMessage;
  List<String> _validationErrors = const [];

  @override
  void initState() {
    super.initState();
    if (!widget.template.isFileSource) {
      throw ArgumentError('DocumentSourceScreen benötigt eine Datei-Quellenart.');
    }
    _documentField = widget.template.fields.firstWhere(
      (field) => field.kind == FieldKind.file,
    );
    _inputGateway = widget.inputGateway ?? PlatformDocumentInputGateway();
    _uploadGateway = widget.uploadGateway ?? GitHubDocumentUploadService();
    _document = widget.initialDocument;
    for (final field in widget.template.fields) {
      _fieldFocus[field.id] = FocusNode(debugLabel: field.label);
      if (field.kind != FieldKind.file) {
        _values[field.id] = TextEditingController(text: field.initialValue);
      }
    }
    unawaited(_loadPending());
  }

  Future<void> _loadPending() async {
    try {
      final pending = await _uploadGateway.loadPending();
      if (!mounted || pending == null || pending.templateId != widget.template.id) {
        return;
      }
      setState(() {
        _pending = pending;
        _document = pending.document;
        _title.text = pending.title;
        for (final entry in pending.values.entries) {
          _values[entry.key]?.text = entry.value;
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ausstehender Dokument-Upload konnte nicht geladen '
              'werden: $error';
        });
      }
    }
  }

  Future<void> _pickDocument() async {
    setState(() {
      _fileBusy = true;
      _errorMessage = null;
    });
    try {
      final selected = await _inputGateway.pick(_documentField);
      if (selected == null || !mounted) {
        return;
      }
      final previous = _document;
      setState(() => _document = selected);
      if (previous != null && previous.path != selected.path) {
        await _inputGateway.discard(previous);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Dokument konnte nicht übernommen werden: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _fileBusy = false);
      }
    }
  }

  Future<void> _removeDocument() async {
    final document = _document;
    if (document == null) {
      return;
    }
    setState(() => _document = null);
    try {
      await _inputGateway.discard(document);
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Temporäre Dokumentdatei konnte nicht entfernt '
              'werden: $error';
        });
      }
    }
  }

  Future<void> _submit() async {
    final errors = _collectErrors();
    _formKey.currentState?.validate();
    if (errors.isNotEmpty) {
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
      if (!mounted) {
        return;
      }
      _summaryFocus.requestFocus();
      return;
    }

    setState(() {
      _busy = true;
      _errorMessage = null;
      _validationErrors = const [];
    });
    try {
      final pending = _pending;
      if (pending == null) {
        final document = _document!;
        final values = _values.map(
          (key, controller) => MapEntry(key, controller.text),
        );
        final started = await _uploadGateway.start(
          template: widget.template,
          title: _title.text,
          values: values,
          document: document,
        );
        if (mounted) {
          setState(() => _pending = started);
        }
      } else {
        final issue = await _uploadGateway.verify(pending, widget.template);
        final document = _document;
        if (document != null) {
          unawaited(_inputGateway.discard(document));
        }
        if (mounted) {
          setState(() {
            _pending = null;
            _document = null;
            _createdIssue = issue;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Quelle konnte nicht erstellt werden: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  List<String> _collectErrors() {
    final errors = <String>[];
    if (_title.text.trim().isEmpty) {
      errors.add('Issue-Titel: Pflichtfeld');
    }
    for (final field in widget.template.fields) {
      if (!field.required) {
        continue;
      }
      final missing = field.kind == FieldKind.file
          ? _document == null
          : (_values[field.id]?.text.trim().isEmpty ?? true);
      if (missing) {
        errors.add('${field.label}: Pflichtfeld');
      }
    }
    return errors;
  }

  void _focusError(String error) {
    final label = error.split(':').first;
    final node = label == 'Issue-Titel'
        ? _titleFocus
        : widget.template.fields
            .where((field) => field.label == label)
            .map((field) => _fieldFocus[field.id])
            .firstOrNull;
    if (node == null) {
      return;
    }
    node.requestFocus();
    final focusContext = node.context;
    if (focusContext != null) {
      Scrollable.ensureVisible(focusContext);
    }
  }

  Future<void> _openPending() async {
    final pending = _pending;
    if (pending == null) {
      return;
    }
    try {
      await _uploadGateway.open(pending);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Pending-Issue konnte nicht geöffnet werden: $error');
      }
    }
  }

  Future<void> _discardPending() async {
    final pending = _pending;
    if (pending == null) {
      return;
    }
    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    try {
      await _uploadGateway.discard(pending);
      await _inputGateway.discard(pending.document);
      if (mounted) {
        setState(() {
          _pending = null;
          _document = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Upload konnte nicht verworfen werden: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
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

  @override
  void dispose() {
    final document = _document;
    if (document != null && _pending == null) {
      unawaited(_inputGateway.discard(document));
    }
    _scrollController.dispose();
    _summaryFocus.dispose();
    _titleFocus.dispose();
    for (final node in _fieldFocus.values) {
      node.dispose();
    }
    _title.dispose();
    for (final controller in _values.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokument-Quelle erfassen'),
        actions: [
          AppSupportMenu(contextName: 'Quellendialog – ${widget.template.name}'),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            validation.ErrorSummary(
              focusNode: _summaryFocus,
              errors: _validationErrors
                  .map(
                    (error) => validation.ValidationErrorItem(
                      label: error,
                      onActivate: () => _focusError(error),
                    ),
                  )
                  .toList(growable: false),
            ),
            Text(widget.template.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(widget.template.description),
            const SizedBox(height: 16),
            if (_pending != null) _pendingCard(),
            if (_createdIssue != null) _successCard(_createdIssue!),
            if (_errorMessage != null) _errorCard(_errorMessage!),
            BoundedTextFormField(
              controller: _title,
              focusNode: _titleFocus,
              maxLength: 256,
              enabled: !_busy && _pending == null,
              decoration: InputDecoration(
                labelText: 'Issue-Titel',
                prefixText: widget.template.titlePrefix,
              ),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Pflichtfeld' : null,
            ),
            const SizedBox(height: 12),
            ...widget.template.fields.map(_fieldWidget),
            const SizedBox(height: 20),
            FilledButton.icon(
              key: const Key('document-source-save-button'),
              onPressed: _busy ? null : _submit,
              icon: const Icon(Icons.cloud_upload),
              label: Text(
                _busy
                    ? 'Wird verarbeitet …'
                    : _pending == null
                        ? 'Upload auf GitHub starten'
                        : 'Upload erneut prüfen',
              ),
            ),
            SizedBox(height: _bottomClearance + bottomInset),
          ],
        ),
      ),
    );
  }

  Widget _fieldWidget(SourceField field) {
    if (field.kind == FieldKind.file) {
      return _documentWidget(field);
    }
    final controller = _values[field.id]!;
    if (field.kind == FieldKind.dropdown) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          focusNode: _fieldFocus[field.id],
          initialValue: controller.text.isEmpty ? null : controller.text,
          decoration: InputDecoration(
            labelText: field.label,
            helperText: field.description,
          ),
          items: field.options
              .map((option) => DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: _busy || _pending != null
              ? null
              : (value) => controller.text = value ?? '',
          validator: (value) => field.required && value == null ? 'Pflichtfeld' : null,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BoundedTextFormField(
        controller: controller,
        focusNode: _fieldFocus[field.id],
        maxLength: field.effectiveMaxLength,
        enabled: !_busy && _pending == null,
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

  Widget _documentWidget(SourceField field) {
    final document = _document;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Focus(
        focusNode: _fieldFocus[field.id],
        child: FormField<DocumentSourceFile>(
          key: const Key('document-source-field'),
          initialValue: document,
          validator: (_) => field.required && _document == null ? 'Pflichtfeld' : null,
          builder: (formField) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.label, style: Theme.of(context).textTheme.titleMedium),
              if (field.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(field.description),
              ],
              const SizedBox(height: 12),
              if (document == null)
                OutlinedButton.icon(
                  key: const Key('document-source-pick-button'),
                  onPressed: _fileBusy || _busy || _pending != null
                      ? null
                      : _pickDocument,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: Text(_fileBusy ? 'Wird ausgewählt …' : 'PDF auswählen'),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          label: 'Ausgewähltes Dokument ${document.name}, '
                              '${document.mimeType}, ${document.displaySize}',
                          child: Text(
                            '${document.name}\n${document.mimeType} · ${document.displaySize}',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: _fileBusy || _busy || _pending != null
                                  ? null
                                  : _pickDocument,
                              child: const Text('Ersetzen'),
                            ),
                            TextButton(
                              onPressed: _fileBusy || _busy || _pending != null
                                  ? null
                                  : _removeDocument,
                              child: const Text('Entfernen'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (formField.hasError) ...[
                const SizedBox(height: 8),
                Text(
                  formField.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _pendingCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PDF noch nicht vollständig hochgeladen.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Die PDF auf GitHub als Attachment zu einem Kommentar hinzufügen, '
              'den Kommentar absenden und anschließend hier erneut prüfen.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _busy ? null : _openPending,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('GitHub öffnen'),
                ),
                TextButton.icon(
                  onPressed: _busy ? null : _discardPending,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Quelle verwerfen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _successCard(CreatedIssue issue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.check_circle_outline),
        title: Text('Quelle erstellt – Issue #${issue.number}'),
        trailing: const Icon(Icons.open_in_new),
        onTap: _openCreatedIssue,
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
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
