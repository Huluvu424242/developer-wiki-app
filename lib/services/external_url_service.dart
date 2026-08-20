import 'package:flutter/services.dart';

class ExternalUrlService {
  static const _channel = MethodChannel('developer_wiki/external_url');

  Future<void> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      throw const FormatException('Ungültiger Link.');
    }
    await _channel.invokeMethod<void>('open', {'url': url});
  }
}
