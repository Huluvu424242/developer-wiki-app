import 'package:flutter/services.dart';

import '../models/document_source_file.dart';
import '../models/source_template.dart';

abstract interface class DocumentInputGateway {
  Future<DocumentSourceFile?> pick(SourceField field);

  Future<void> discard(DocumentSourceFile document);
}

class PlatformDocumentInputGateway implements DocumentInputGateway {
  PlatformDocumentInputGateway({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('developer_wiki/document');

  final MethodChannel _channel;

  @override
  Future<DocumentSourceFile?> pick(SourceField field) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'pickDocument',
      {
        'mimeTypes': field.mimeTypes,
        'maxBytes': field.maxBytes,
      },
    );
    if (result == null) {
      return null;
    }
    return validate(
      DocumentSourceFile(
        path: result['path']?.toString() ?? '',
        name: result['name']?.toString() ?? '',
        mimeType: result['mimeType']?.toString() ?? '',
        sizeBytes: _asInt(result['sizeBytes']),
      ),
      field,
    );
  }

  @override
  Future<void> discard(DocumentSourceFile document) {
    return _channel.invokeMethod<void>('discardDocument', {
      'path': document.path,
    });
  }

  static DocumentSourceFile validate(
    DocumentSourceFile document,
    SourceField field,
  ) {
    if (document.path.isEmpty ||
        document.name.isEmpty ||
        document.mimeType.isEmpty ||
        document.sizeBytes <= 0) {
      throw const FormatException(
          'Das ausgewählte Dokument ist unvollständig.');
    }
    if (!field.mimeTypes.contains(document.mimeType)) {
      throw FormatException(
        'Dateityp ${document.mimeType} wird für diese Quellenart nicht '
        'unterstützt.',
      );
    }
    final maxBytes = field.maxBytes;
    if (maxBytes != null && document.sizeBytes > maxBytes) {
      throw FormatException(
        'Die Datei ist zu groß. Erlaubt sind höchstens '
        '${_displayBytes(maxBytes)}.',
      );
    }
    return document;
  }

  static int _asInt(Object? value) {
    return value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _displayBytes(int value) {
    if (value >= 1024 * 1024) {
      return '${(value / (1024 * 1024)).toStringAsFixed(0)} MiB';
    }
    return '${(value / 1024).toStringAsFixed(0)} KiB';
  }
}
