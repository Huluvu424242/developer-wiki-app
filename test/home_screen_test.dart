import 'package:developer_wiki_source_capture/models/created_issue.dart';
import 'package:developer_wiki_source_capture/models/shared_content.dart';
import 'package:developer_wiki_source_capture/models/image_source_file.dart';
import 'package:developer_wiki_source_capture/models/pending_image_upload.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/screens/home_screen.dart';
import 'package:developer_wiki_source_capture/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home screen offers sources, import and settings', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.text('Neue Quelle erfassen'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    final scrollable = find.byType(Scrollable);

    for (final template in sourceTemplates) {
      await tester.scrollUntilVisible(
        find.text(template.name),
        200,
        scrollable: scrollable,
      );

      expect(find.text(template.name), findsOneWidget);
    }

    await tester.scrollUntilVisible(
      find.text('Quellen ins Wiki importieren'),
      200,
      scrollable: scrollable,
    );

    expect(find.text('Quellen ins Wiki importieren'), findsOneWidget);
  });

  testWidgets('selected source opens matching form', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    final template = sourceTemplates.first;
    await tester.tap(find.text(template.name));
    await tester.pumpAndSettle();

    expect(find.text('Wiki-Quelle erfassen'), findsOneWidget);
    expect(find.text(template.description), findsOneWidget);
  });

  testWidgets('shared content is forwarded to the selected source form',
      (tester) async {
    const sharedContent = SharedContent(
      kind: SharedContentKind.link,
      text: 'https://example.org/source',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(sharedContent: sharedContent),
      ),
    );

    expect(find.text('Geteilten Inhalt erfassen'), findsOneWidget);
    expect(find.text('Welche Quellenart ist das?'), findsOneWidget);

    final template = sourceTemplates.first;
    await tester.tap(find.text(template.name));
    await tester.pumpAndSettle();

    expect(find.text('Geteilten Inhalt erfassen'), findsOneWidget);
    expect(
      find.text('Geteilter Inhalt wurde vorausgefüllt und kann bearbeitet werden.'),
      findsOneWidget,
    );
  });

  testWidgets('shared image opens the image source form directly', (
    tester,
  ) async {
    const sharedContent = SharedContent(
      kind: SharedContentKind.image,
      image: ImageSourceFile(
        path: '/private/image.png',
        name: 'image.png',
        mimeType: 'image/png',
        sizeBytes: 8,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          sharedContent: sharedContent,
          sourceFormBuilder: (template, content) => Text(
            '${template.name}:${content?.image?.name}',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('🖼️ Bild-Quelle:image.png'), findsOneWidget);
  });

  testWidgets('pending image upload remains visible after restart', (
    tester,
  ) async {
    final gateway = _FakeImageUploadGateway(
      PendingImageUpload(
        issueNumber: 42,
        issueUrl: 'https://github.com/example/wiki/issues/42',
        createdAt: DateTime.utc(2026, 8, 25),
        title: 'Diagramm',
        values: const {},
        image: const ImageSourceFile(
          path: '/private/image.png',
          name: 'image.png',
          mimeType: 'image/png',
          sizeBytes: 8,
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(imageUploadGateway: gateway)),
    );
    await tester.pump();

    expect(find.byKey(const Key('pending-image-upload')), findsOneWidget);
    expect(find.text('Bild-Upload #42 fortsetzen'), findsOneWidget);
  });
}

class _FakeImageUploadGateway implements ImageUploadGateway {
  _FakeImageUploadGateway(this.pending);

  final PendingImageUpload? pending;

  @override
  Future<void> discard(PendingImageUpload upload) async {}

  @override
  Future<PendingImageUpload?> loadPending() async => pending;

  @override
  Future<void> open(PendingImageUpload upload) async {}

  @override
  Future<PendingImageUpload> start({
    required String title,
    required Map<String, String> values,
    required ImageSourceFile image,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CreatedIssue> verify(PendingImageUpload upload) {
    throw UnimplementedError();
  }
}
