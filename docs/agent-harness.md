# Agenten-Harness

Die Root-`AGENTS.md` ist der verbindliche Einstiegspunkt für KI-Arbeiten am Repository. Sie enthält Lesepflicht, Reihenfolge und Regelpriorität; die fachlichen Regeln liegen unter `agent-rules/`.

## Migrationsprinzip

Story #141 modularisiert den bisherigen monolithischen Harness, ohne seine fachlichen Anforderungen abzuschwächen. Regeln aus `taugts` und `Developer-Wiki` dienten als Strukturvorbild, wurden aber nicht mechanisch übernommen.

| Bisheriger Bereich in `AGENTS.md` | Normative Heimat nach #141 |
| --- | --- |
| Kommunikation, Story-/Bug-Workflow, PR-Verknüpfung, Rebase | `agent-rules/01-workflow-collaboration.md` |
| Grundgerüst-Grenzen | `agent-rules/02-project-bootstrap.md` |
| fachlich geschnittene Struktur | `agent-rules/03-structure.md` |
| Implementierungs- und Architekturleitplanken | `agent-rules/03-implementation.md` |
| UX und Barrierefreiheit | `agent-rules/04-ux-accessibility.md` |
| Repository-/Zweckbindung von Zugängen | `agent-rules/05-security-access.md` |
| sichere Datenbehandlung | `agent-rules/05-security-data.md` |
| Tests, CI und Sicherheitsvorfälle | `agent-rules/05-security-ci.md` |
| Codestyle, Tests, Abhängigkeiten und Lizenzen | `agent-rules/06-quality.md` |
| Changelog, README und `docs/` | `agent-rules/06-documentation.md` |
| Verantwortungsgrenze App ↔ Developer-Wiki | `agent-rules/08-wiki-integration.md` |

## Harmonisierung nach Story #142

Story #142 gleicht die bestehenden App-Regeln mit dem aktuellen Taugt’s-Harness ab. Bestehende strengere oder projektspezifische App-Regeln bleiben erhalten; übernommen werden nur Regeln, die dieselbe Problemklasse betreffen und zur Developer-Wiki-App passen.

| Bereich | App vor #142 | Präzisierung aus Taugt’s | Zielregel in der App |
| --- | --- | --- | --- |
| Architekturgrenzen | Trennung bereits vorhanden | kleine testbare Schnittstellen und zentrale Fachpfade | externe Abhängigkeiten und Plattformfunktionen klar kapseln; Android-Share und normale Erfassung verwenden denselben Fachpfad |
| Plattform | plattformneutral, Android isoliert | Android als primäre Referenzplattform | Android bleibt Referenz; allgemeine Fachlogik bleibt soweit sinnvoll in Dart |
| asynchrone UI-Zugriffe | Lebenszyklus allgemein erwähnt | Prüfung nach jeder asynchronen Lücke | nach jedem `await` Lebenszyklus erneut prüfen; gespeicherter `BuildContext` berücksichtigt `context.mounted` |
| Flutter-`const` | `const` sinnvoll verwenden | indirekte konstante Widgetbäume explizit prüfen | konstante Blätter bevorzugen; nicht konstante Konstruktoren dürfen keinen pauschal konstanten Vorfahren erzwingen |
| Barrierefreiheit | bereits appweit verbindlich | Bestandteil jeder GUI-Story | sofort umsetzbare Grundlagen und automatisierbare Tests gehören in jede GUI-Story; manuelle Gesamtprüfungen dürfen gebündelt werden |
| lazy Formulare | einzelne Erkenntnisse bereits im Changelog | vollständige Modell-/Controller-Validierung | fachliche Validierung darf nicht nur von aktuell gemounteten `FormField`s abhängen |
| Scroll-Widgettests | zustandsbasiertes Testen vorhanden | Existenz und Sichtbarkeit unterscheiden | `ensureVisible()` nur für gemountete Ziele; lazy Ziele zunächst gezielt in den Viewport bringen |
| Fehlersammler | Fokus und Scrollen bereits gefordert | Aufbau außerhalb des Viewports berücksichtigen | zuerst kontrolliert an den Anfang scrollen, nächsten Frame abwarten, dann Fokus/Semantik setzen |
| Support-Grundgerüst | About, Bugreport und Erklärung vorhanden | testbare Plattformabstraktionen und eindeutige Kontexte | Versionsermittlung und externes Öffnen testbar kapseln; Dialog und Eingaben bei Fehlern erhalten |
| Qualitätsstatus | Prüfungen vorhanden | einheitliche Abschlussstatus | `Implementiert, technische Prüfung ausstehend` und `Geprüft und mergebereit` verbindlich verwenden |
| Standardprüfungen | Format, Analyze und Tests bereits gefordert | einheitliche Befehlsfolge | `dart format --set-exit-if-changed lib test`, `flutter analyze`, `flutter test` als Standard für geänderten Dart-/Flutter-Code |

## Bewusste Abweichungen von der vorgeschlagenen Zielstruktur

- Die umfangreichen Sicherheitsregeln sind in die drei Module Zugriff, Datenbehandlung sowie Tests/CI/Vorfälle geteilt. Dadurch bleibt jede Regel fachlich eindeutig zugeordnet und besser reviewbar.
- Architektur ist in fachliche Struktur und Implementierung aufgeteilt, weil diese beiden Regelgruppen unabhängig voneinander umfangreich sind.
- Qualität und Dokumentation besitzen getrennte normative Module, damit Prüf-/Lizenzregeln nicht mit Dokumentationsregeln vermischt werden.
- Ein eigenes Release-Regelmodul ist bewusst noch nicht Bestandteil von #141 oder #142. Story #144 führt diesen fachlich separat ein. Bis dahin gelten die allgemeinen Workflow-, Sicherheits-, Qualitäts- und Dokumentationsregeln auch für Releasearbeiten.

## Bewusste Abgrenzungen

Nicht übernommen wurden insbesondere:

- Offline-first beziehungsweise ausschließlich lokale Datenhaltung aus `taugts`, weil die App bewusst GitHub und das Developer-Wiki anspricht;
- Taugt’s-spezifische Persistenz-, Import-/Export- und Datenmigrationsregeln;
- Taugt’s-spezifische Plattformvorgaben für Windows/Linux sowie dessen Ausschlüsse für Web/iOS;
- Taugt’s-spezifische MkDocs-, GitHub-Pages- und Workflowvorgaben;
- die Bootstrap-Pflicht „Name und Logo vor Implementierungsbeginn“, weil die bestehende Developer-Wiki-App diese Identität bereits besitzt;
- Wiki-interne OKF-, Quellenarchiv-, Wissenssynthese-, Retrieval- und `wiki-data`-Regeln aus `Developer-Wiki`;
- konkrete Freigaben, Workflow-Dateien, Repositorypfade oder Datenmodelle anderer Projekte.

## Normative Quelle

Die Projektdokumentation erläutert den Harness nur. Normative Regeln stehen ausschließlich in der Root-`AGENTS.md`, den dort gelisteten Modulen oder künftig ausdrücklich referenzierten Spezialverträgen.

## Deterministische Strukturprüfung

`test/agent_harness_test.dart` verwendet die bestehende Flutter-Testtoolchain und prüft:

- die vollständige, eindeutige und geordnete Modulliste in `AGENTS.md`;
- die Existenz jedes verbindlichen Moduls;
- die Auflösung lokaler Markdown-Links innerhalb des verbindlichen Harness;
- dass Regelmodule nicht rekursiv die Root-`AGENTS.md` wieder als Pflicht-Einstieg referenzieren.

Dadurch ist keine neue GitHub Action und keine zusätzliche Werkzeugkette erforderlich. Der Test läuft mit dem regulären `flutter test` beziehungsweise gezielt mit:

```text
flutter test test/agent_harness_test.dart
```
