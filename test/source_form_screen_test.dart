import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/screens/source_form_screen.dart';
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
}
