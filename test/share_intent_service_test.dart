import 'dart:io';

import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/models/shared_content.dart';
import 'package:developer_wiki_source_capture/services/image_validation_service.dart';
import 'package:developer_wiki_source_capture/services/share_intent_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('developer_wiki/share-test');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('validates an initially shared image through the common path', () async {
    final directory = await Directory.systemTemp.createTemp('shared-image-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/shared.png');
    await file.writeAsBytes(
      const [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'getInitialShare');
      return {
        'kind': 'image',
        'path': file.path,
        'name': 'shared.png',
        'mimeType': 'image/png',
        'sizeBytes': 8,
      };
    });

    final content = await ShareIntentService(
      channel: channel,
    ).initialize((_) {});

    expect(content?.kind, SharedContentKind.image);
    expect(content?.image?.name, 'shared.png');
  });

  test('turns native image errors into user-visible shared content', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => {
              'kind': 'image_error',
              'text': 'Datei zu groß',
            });

    final content = await ShareIntentService(
      channel: channel,
    ).initialize((_) {});

    expect(content?.kind, SharedContentKind.imageError);
    expect(content?.text, 'Datei zu groß');
  });

  test('handles an asynchronous missing plugin error while mapping', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => {
              'kind': 'image',
              'path': '/private/shared.png',
              'name': 'shared.png',
              'mimeType': 'image/png',
              'sizeBytes': 8,
            });

    final content = await ShareIntentService(
      channel: channel,
      validationService: _MissingPluginImageValidationService(),
    ).initialize((_) {});

    expect(content, isNull);
  });
}

class _MissingPluginImageValidationService extends ImageValidationService {
  @override
  Future<ImageSourceFile> validate(ImageSourceFile image) async {
    throw MissingPluginException();
  }
}
