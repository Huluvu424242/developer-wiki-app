import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/screens/home_screen.dart';
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
}
