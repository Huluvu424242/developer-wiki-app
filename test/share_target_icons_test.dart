import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('share targets reference their distinct overlay icons', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(
      manifest,
      contains('android:name=".ShareLinkActivity"'),
    );
    expect(manifest, contains('android:icon="@drawable/ic_share_link"'));
    expect(manifest, contains('android:icon="@drawable/ic_share_text"'));
    expect(manifest, contains('android:icon="@drawable/ic_share_image"'));

    for (final icon in ['link', 'text', 'image']) {
      final drawable = File(
        'android/app/src/main/res/drawable/ic_share_$icon.xml',
      );
      expect(drawable.existsSync(), isTrue);
      expect(drawable.readAsStringSync(), contains('<vector'));
    }
  });
}
