import 'package:flutter/services.dart';

import '../models/shared_content.dart';

class ShareIntentService {
  static const _channel = MethodChannel('developer_wiki/share');

  Future<SharedContent?> initialize(
    void Function(SharedContent content) onShared,
  ) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'shared') {
        return;
      }
      final content = _fromMap(call.arguments);
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

  SharedContent? _fromMap(Object? value) {
    if (value is! Map) {
      return null;
    }
    final kindValue = value['kind']?.toString();
    final text = value['text']?.toString() ?? '';
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
}
