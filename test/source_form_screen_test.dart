import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/models/created_issue.dart';
import 'package:developer_wiki_source_capture/models/pending_image_upload.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/screens/source_form_screen.dart';
import 'package:developer_wiki_source_capture/services/image_input_service.dart';
import 'package:developer_wiki_source_capture/services/image_upload_service.dart';
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

Future<void> pumpUntilNotFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 2),
  Duration step = const Duration(milliseconds: 20),
}) async {
  var elapsed = Duration.zero;

  while (finder.evaluate().isNotEmpty) {
    if (elapsed >= timeout) {
      throw TestFailure(
        'Widget ist innerhalb von $timeout nicht verschwunden.',
      );
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
    final gateway = _FakeImageInputGateway(
      ImageSourceFile(
        path: 'source.png',
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
          imagePreviewBuilder: (_) => const ColoredBox(
            color: Colors.transparent,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('image-source-pick-button')));
    final preview = find.byKey(const Key('image-source-preview'));
    await pumpUntilFound(tester, preview);

    expect(preview, findsOneWidget);
    expect(find.textContaining('source.png'), findsOneWidget);
    expect(find.text('Ersetzen'), findsOneWidget);

    await tester.tap(find.byKey(const Key('image-source-remove-button')));
    await pumpUntilNotFound(tester, preview);

    expect(preview, findsNothing);
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
      find.textContaining('Bild-Upload für Issue'),
      findsNothing,
    );
  });

  testWidgets('starts and finalizes the two-step GitHub image upload', (
    tester,
  ) async {
    final inputGateway = _FakeImageInputGateway(
      ImageSourceFile(
        path: 'source.png',
        name: 'source.png',
        mimeType: 'image/png',
        sizeBytes: 8,
      ),
    );
    final uploadGateway = _FakeImageUploadGateway();

    await tester.pumpWidget(
      MaterialApp(
        home: SourceFormScreen(
          initialTemplate: imageSourceTemplate,
          imageInputGateway: inputGateway,
          imageUploadGateway: uploadGateway,
          imagePreviewBuilder: (_) => const ColoredBox(
            color: Colors.transparent,
          ),
        ),
      ),
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Issue-Titel'),
      'Architekturdiagramm',
    );
    await tester.tap(find.byKey(const Key('image-source-pick-button')));
    await pumpUntilFound(
      tester,
      find.byKey(const Key('image-source-preview')),
    );
    final saveButton = find.byKey(const Key('source-form-save-button'));
    await tester.scrollUntilVisible(
      saveButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(saveButton);
    final pendingUpload = find.textContaining('Bild-Upload für Issue #123');
    await pumpUntilFound(tester, pendingUpload);

    expect(pendingUpload, findsOneWidget);
    expect(uploadGateway.started, isTrue);

    await tester.scrollUntilVisible(
      saveButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    final createdIssue = find.textContaining('Quelle erstellt – Issue #123');
    await pumpUntilFound(tester, createdIssue);

    expect(createdIssue, findsOneWidget);
    expect(uploadGateway.verified, isTrue);
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

class _FakeImageUploadGateway implements ImageUploadGateway {
  bool started = false;
  bool verified = false;

  @override
  Future<void> discard(PendingImageUpload upload) async {}

  @override
  Future<PendingImageUpload?> loadPending() async => null;

  @override
  Future<void> open(PendingImageUpload upload) async {}

  @override
  Future<PendingImageUpload> start({
    required String title,
    required Map<String, String> values,
    required ImageSourceFile image,
  }) async {
    started = true;
    return PendingImageUpload(
      issueNumber: 123,
      issueUrl: 'https://github.com/example/wiki/issues/123',
      createdAt: DateTime.utc(2026, 8, 25),
      title: title,
      values: values,
      image: image,
    );
  }

  @override
  Future<CreatedIssue> verify(PendingImageUpload upload) async {
    verified = true;
    return CreatedIssue(number: upload.issueNumber, url: upload.issueUrl);
  }
}
