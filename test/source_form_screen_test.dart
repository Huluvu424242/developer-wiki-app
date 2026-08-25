import 'dart:io';

import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/screens/source_form_screen.dart';
import 'package:developer_wiki_source_capture/services/image_input_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 2),
  Duration step = const Duration(milliseconds: 20),
}) async {
  var elapsed = Duration.zero;

  while (finder.evaluate().isEmpty) {
    if (elapsed >= timeout) {
      throw TestFailure('Widget wurde innerhalb von $timeout nicht gefunden.');
    }
    await tester.pump(step);
    elapsed += step;
  }
}

void main() {
  testWidgets('shows a temporary hint when validation fails', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SourceFormScreen(initialTemplate: sourceTemplates[1]),
      ),
    );

    final saveButton = find.byKey(const Key('source-form-save-button'));
    await tester.scrollUntilVisible(
      saveButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(saveButton);
    await tester.pump();
    await tester.tap(saveButton);

    final validationHint = find.text('Bitte markierte Pflichtfelder prüfen.');
    await pumpUntilFound(tester, validationHint);

    expect(validationHint, findsOneWidget);
  });

  testWidgets('clears a default value with one tap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SourceFormScreen(initialTemplate: sourceTemplates[1]),
      ),
    );

    await tester.scrollUntilVisible(
      find.byTooltip('Feld leeren'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byTooltip('Feld leeren'), findsOneWidget);
    await tester.tap(find.byTooltip('Feld leeren'));
    await tester.pump();

    expect(find.byTooltip('Feld leeren'), findsNothing);
  });

  testWidgets('keeps bottom clearance in addition to the safe-area inset', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            viewPadding: EdgeInsets.only(bottom: 24),
          ),
          child: SourceFormScreen(initialTemplate: sourceTemplates[1]),
        ),
      ),
    );

    final clearance = find.byKey(const Key('source-form-bottom-clearance'));
    await tester.scrollUntilVisible(
      clearance,
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(tester.widget<SizedBox>(clearance).height, 88);
  });

  testWidgets('shows, replaces and removes an image source preview', (
    tester,
  ) async {
    final directory = await Directory.systemTemp.createTemp('image-form-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/source.png');
    await file.writeAsBytes(
      const [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a],
    );
    final gateway = _FakeImageInputGateway(
      ImageSourceFile(
        path: file.path,
        name: 'source.png',
        mimeType: 'image/png',
        sizeBytes: 8,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SourceFormScreen(
          initialTemplate: imageSourceTemplate,
          imageInputGateway: gateway,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('image-source-pick-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('image-source-preview')), findsOneWidget);
    expect(find.textContaining('source.png'), findsOneWidget);
    expect(find.text('Ersetzen'), findsOneWidget);

    await tester.tap(find.byKey(const Key('image-source-remove-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('image-source-preview')), findsNothing);
    expect(gateway.discarded, hasLength(1));
  });

  testWidgets('does not prepare an image source without an image', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SourceFormScreen(
          initialTemplate: imageSourceTemplate,
          imageInputGateway: _FakeImageInputGateway(null),
        ),
      ),
    );

    final saveButton = find.byKey(const Key('source-form-save-button'));
    await tester.scrollUntilVisible(
      saveButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Bitte markierte Pflichtfelder prüfen.'), findsOneWidget);
    expect(
      find.textContaining('Die Bild-Quelle ist lokal vorbereitet'),
      findsNothing,
    );
  });
}

class _FakeImageInputGateway implements ImageInputGateway {
  _FakeImageInputGateway(this.image);

  final ImageSourceFile? image;
  final discarded = <ImageSourceFile>[];

  @override
  Future<void> discard(ImageSourceFile image) async {
    discarded.add(image);
  }

  @override
  Future<ImageSourceFile?> pickImage() async => image;
}
