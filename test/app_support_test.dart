import 'package:developer_wiki_source_capture/models/app_info.dart';
import 'package:developer_wiki_source_capture/services/app_info_service.dart';
import 'package:developer_wiki_source_capture/services/external_url_service.dart';
import 'package:developer_wiki_source_capture/widgets/app_support.dart';
import 'package:developer_wiki_source_capture/widgets/bounded_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('About shows installed release and accessibility statement', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              AppSupportMenu(
                contextName: 'Testseite',
                appInfoGateway: const _FakeAppInfoGateway(),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('App-Menü öffnen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Über'));
    await tester.pumpAndSettle();

    expect(find.text('Releaseversion 1.2.3+45'), findsOneWidget);
    expect(find.text('Barrierefreiheitserklärung'), findsOneWidget);

    await tester.tap(find.text('Barrierefreiheitserklärung'));
    await tester.pumpAndSettle();
    expect(find.text('Bekannte Barrieren'), findsOneWidget);
    expect(find.text('Bug melden'), findsWidgets);
  });

  testWidgets('bug report requires type and opens prefilled app issue', (
    tester,
  ) async {
    final urlService = _FakeExternalUrlService();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              AppSupportMenu(
                contextName: 'Quellenformular',
                appInfoGateway: const _FakeAppInfoGateway(),
                externalUrlService: urlService,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('App-Menü öffnen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bug melden'));
    await tester.pumpAndSettle();

    expect(find.text('Kontext: Quellenformular'), findsOneWidget);
    expect(find.text('Releaseversion: 1.2.3+45'), findsOneWidget);

    await tester.tap(find.text('Auf GitHub prüfen'));
    await tester.pump();
    expect(find.byKey(const Key('validation-error-summary')), findsOneWidget);

    await tester.tap(find.text('Bitte auswählen').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barrierefreiheitsfehler').last);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Beschreibung'),
      'Der Fokus ist nicht sichtbar.',
    );
    await tester.tap(find.text('Auf GitHub prüfen'));
    await tester.pumpAndSettle();

    final uri = Uri.parse(urlService.openedUrl!);
    expect(uri.host, 'github.com');
    expect(uri.path, '/Huluvu424242/developer-wiki-app/issues/new');
    expect(uri.queryParameters['labels'], 'bug');
    expect(uri.queryParameters['body'], contains('Quellenformular'));
    expect(uri.queryParameters['body'], contains('1.2.3+45'));
    expect(uri.queryParameters['body'], isNot(contains('token')));
  });

  testWidgets('remaining-character counter starts at ten characters', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BoundedTextFormField(
            controller: controller,
            maxLength: 20,
            decoration: const InputDecoration(labelText: 'Text'),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '1234567890');
    await tester.pump();
    expect(find.text('noch 10 Zeichen'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '12345678901234567890');
    await tester.pump();
    expect(find.text('Kein Zeichen mehr möglich'), findsOneWidget);
  });
}

class _FakeAppInfoGateway implements AppInfoGateway {
  const _FakeAppInfoGateway();

  @override
  Future<AppInfo> load() async =>
      const AppInfo(version: '1.2.3', buildNumber: '45');
}

class _FakeExternalUrlService extends ExternalUrlService {
  String? openedUrl;

  @override
  Future<void> open(String url) async {
    openedUrl = url;
  }
}
