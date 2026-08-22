import 'package:developer_wiki_source_capture/widgets/pat_help_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens PAT help and shows required permissions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: PatHelpButton()),
        ),
      ),
    );

    expect(find.byTooltip(PatHelpButton.tooltip), findsOneWidget);

    await tester.tap(find.byTooltip(PatHelpButton.tooltip));
    await tester.pumpAndSettle();

    expect(find.text('GitHub PAT einrichten'), findsOneWidget);
    expect(find.text('• Actions: Read and write'), findsOneWidget);
    expect(find.text('• Issues: Read and write'), findsOneWidget);
    expect(find.text('• Metadata: Read-only'), findsOneWidget);
    expect(find.textContaining('Only select repositories'), findsOneWidget);
    expect(find.textContaining('Generate new token'), findsOneWidget);
    expect(find.text('Schließen'), findsOneWidget);
  });
}
