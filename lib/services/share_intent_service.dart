import 'package:flutter/services.dart';

import '../models/image_source_file.dart';
import '../models/shared_content.dart';
import 'image_validation_service.dart';

class ShareIntentService {
  ShareIntentService({
    MethodChannel? channel,
    ImageValidationService? validationService,
  })  : _channel = channel ?? const MethodChannel('developer_wiki/share'),
        _validationService = validationService ?? ImageValidationService();

  final MethodChannel _channel;
  final ImageValidationService _validationService;

  Future<SharedContent?> initialize(
    void Function(SharedContent content) onShared,
  ) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'shared') {
        return;
      }
      final content = await _fromMap(call.arguments);
      if (content != null && !content.isEmpty) {
        onShared(content);
      }
    });

    try {
      final initial = await _channel.invokeMapMethod<String, dynamic>(
        'getInitialShare',
      );
      return _fromMap(initial);
    } on MissingPluginException {
      return null;
    }
  }

  Future<SharedContent?> _fromMap(Object? value) async {
    if (value is! Map) {
      return null;
    }
    final kindValue = value['kind']?.toString();
    final text = value['text']?.toString() ?? '';
    if (kindValue == 'image_error') {
      return SharedContent(kind: SharedContentKind.imageError, text: text);
    }
    if (kindValue == 'image') {
      final image = ImageSourceFile(
        path: value['path']?.toString() ?? '',
        name: value['name']?.toString() ?? '',
        mimeType: value['mimeType']?.toString() ?? '',
        sizeBytes: _asInt(value['sizeBytes']),
      );
      if (image.path.isEmpty || image.name.isEmpty || image.mimeType.isEmpty) {
        return const SharedContent(
          kind: SharedContentKind.imageError,
          text: 'Das geteilte Bild ist unvollständig.',
        );
      }
      try {
        return SharedContent(
          kind: SharedContentKind.image,
          image: await _validationService.validate(image),
        );
      } on FormatException catch (error) {
        return SharedContent(
          kind: SharedContentKind.imageError,
          text: error.message.toString(),
        );
      }
    }
    final kind = switch (kindValue) {
      'link' => SharedContentKind.link,
      'text' => SharedContentKind.text,
      _ => null,
    };
    if (kind == null || text.trim().isEmpty) {
      return null;
    }
    return SharedContent(kind: kind, text: text);
  }

  int _asInt(Object? value) {
    return value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
