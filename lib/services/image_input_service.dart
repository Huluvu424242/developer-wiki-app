import 'package:flutter/services.dart';

import '../models/image_source_file.dart';
import 'image_validation_service.dart';

abstract interface class ImageInputGateway {
  Future<ImageSourceFile?> pickImage();

  Future<void> discard(ImageSourceFile image);
}

class PlatformImageInputGateway implements ImageInputGateway {
  PlatformImageInputGateway({
    MethodChannel? channel,
    ImageValidationService? validationService,
  })  : _channel = channel ?? const MethodChannel('developer_wiki/image'),
        _validationService = validationService ?? ImageValidationService();

  final MethodChannel _channel;
  final ImageValidationService _validationService;

  @override
  Future<ImageSourceFile?> pickImage() async {
    final value = await _channel.invokeMapMethod<String, dynamic>('pickImage');
    if (value == null) {
      return null;
    }
    final image = _fromMap(value);
    return _validationService.validate(image);
  }

  @override
  Future<void> discard(ImageSourceFile image) {
    return _channel.invokeMethod<void>('discardImage', {'path': image.path});
  }

  ImageSourceFile _fromMap(Map<String, dynamic> value) {
    final path = value['path']?.toString() ?? '';
    final name = value['name']?.toString() ?? '';
    final mimeType = value['mimeType']?.toString() ?? '';
    final sizeValue = value['sizeBytes'];
    final sizeBytes = sizeValue is int
        ? sizeValue
        : int.tryParse(sizeValue?.toString() ?? '') ?? 0;
    if (path.isEmpty || name.isEmpty || mimeType.isEmpty) {
      throw const FormatException('Das ausgewählte Bild ist unvollständig.');
    }
    return ImageSourceFile(
      path: path,
      name: name,
      mimeType: mimeType,
      sizeBytes: sizeBytes,
    );
  }
}
