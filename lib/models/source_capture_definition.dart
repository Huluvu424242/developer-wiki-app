import 'dart:convert';

import 'source_template.dart';

class SourceCaptureDefinition {
  const SourceCaptureDefinition({
    required this.schemaVersion,
    required this.issueLabel,
    required this.templates,
  });

  static const supportedSchemaVersion = 1;
  static const supportedCapabilities = {
    'guided-github-issue-image-attachment-v1',
  };

  final int schemaVersion;
  final String issueLabel;
  final List<SourceTemplate> templates;

  factory SourceCaptureDefinition.parse(String rawJson) {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Quellenmodell muss ein JSON-Objekt sein.');
    }
    final version = decoded['schemaVersion'];
    if (version != supportedSchemaVersion) {
      throw FormatException(
        'Nicht unterstützte Quellenmodell-Version: $version. '
        'Unterstützt wird Version $supportedSchemaVersion.',
      );
    }
    final issueLabel = decoded['issueLabel'];
    final rawTemplates = decoded['templates'];
    if (issueLabel is! String || issueLabel.trim().isEmpty) {
      throw const FormatException('issueLabel fehlt im Quellenmodell.');
    }
    if (rawTemplates is! List || rawTemplates.isEmpty) {
      throw const FormatException('Keine Quellenarten im Quellenmodell.');
    }
    final templates = rawTemplates
        .map((item) => _parseTemplate(item))
        .toList(growable: false);
    return SourceCaptureDefinition(
      schemaVersion: version as int,
      issueLabel: issueLabel,
      templates: templates,
    );
  }

  static SourceTemplate _parseTemplate(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Quellenart muss ein Objekt sein.');
    }
    final id = _requiredString(raw, 'id');
    final capabilities = _stringList(raw['requiredCapabilities']);
    final unknown = capabilities
        .where((capability) => !supportedCapabilities.contains(capability))
        .toList();
    if (unknown.isNotEmpty) {
      throw FormatException(
        'Quellenart $id benötigt unbekannte Client-Fähigkeit: '
        '${unknown.join(', ')}.',
      );
    }
    final rawFields = raw['fields'];
    if (rawFields is! List || rawFields.isEmpty) {
      throw FormatException('Quellenart $id enthält keine Felder.');
    }
    return SourceTemplate(
      id: id,
      name: _requiredString(raw, 'name'),
      titlePrefix: _requiredString(raw, 'titlePrefix', allowEmpty: true),
      description: _requiredString(raw, 'description'),
      requiredCapabilities: capabilities,
      fields: rawFields.map(_parseField).toList(growable: false),
    );
  }

  static SourceField _parseField(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Quellenfeld muss ein Objekt sein.');
    }
    final kindName = _requiredString(raw, 'kind');
    final kind = switch (kindName) {
      'input' => FieldKind.input,
      'textarea' => FieldKind.textarea,
      'dropdown' => FieldKind.dropdown,
      'image' => FieldKind.image,
      _ => throw FormatException('Unbekannte Feldart: $kindName.'),
    };
    final transport = raw['transport']?.toString();
    if (transport != null &&
        transport.isNotEmpty &&
        !supportedCapabilities.contains(transport)) {
      throw FormatException('Unbekannter Feldtransport: $transport.');
    }
    final options = _stringList(raw['options']);
    if (kind == FieldKind.dropdown && options.isEmpty) {
      throw FormatException(
        'Dropdown ${raw['id']} enthält keine Auswahlwerte.',
      );
    }
    if (kind == FieldKind.image) {
      if (raw['maxFiles'] != 1 ||
          raw['maxBytes'] is! int ||
          _stringList(raw['mimeTypes']).isEmpty ||
          transport == null) {
        throw FormatException(
          'Bildfeld ${raw['id']} besitzt keinen vollständigen Transportvertrag.',
        );
      }
    }
    return SourceField(
      id: _requiredString(raw, 'id'),
      label: _requiredString(raw, 'label'),
      kind: kind,
      description: raw['description']?.toString() ?? '',
      placeholder: raw['placeholder']?.toString() ?? '',
      required: raw['required'] == true,
      options: options,
      initialValue: raw['initialValue']?.toString() ?? '',
      maxLength: raw['maxLength'] as int?,
      maxFiles: raw['maxFiles'] as int?,
      mimeTypes: _stringList(raw['mimeTypes']),
      maxBytes: raw['maxBytes'] as int?,
      bodyHeading: raw['bodyHeading']?.toString(),
      transport: transport,
      inputMethods: _stringList(raw['inputMethods']),
    );
  }

  static String _requiredString(
    Map<String, dynamic> map,
    String key, {
    bool allowEmpty = false,
  }) {
    final value = map[key];
    if (value is! String || (!allowEmpty && value.trim().isEmpty)) {
      throw FormatException('$key fehlt im Quellenmodell.');
    }
    return value;
  }

  static List<String> _stringList(Object? value) {
    if (value == null) {
      return const [];
    }
    if (value is! List || value.any((item) => item is! String)) {
      throw const FormatException('Erwartete eine Liste von Textwerten.');
    }
    return value.cast<String>().toList(growable: false);
  }
}

class LoadedSourceTemplates {
  const LoadedSourceTemplates({
    required this.templates,
    required this.issueLabel,
    required this.origin,
    this.warning,
  });

  final List<SourceTemplate> templates;
  final String issueLabel;
  final SourceTemplateOrigin origin;
  final String? warning;
}

enum SourceTemplateOrigin { remote, cache, bundledFallback }
