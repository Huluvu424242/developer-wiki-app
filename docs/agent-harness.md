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

## Bewusste Abweichungen von der vorgeschlagenen Zielstruktur

- Die umfangreichen Sicherheitsregeln sind in die drei Module Zugriff, Datenbehandlung sowie Tests/CI/Vorfälle geteilt. Dadurch bleibt jede Regel fachlich eindeutig zugeordnet und besser reviewbar.
- Architektur ist in fachliche Struktur und Implementierung aufgeteilt, weil diese beiden Regelgruppen unabhängig voneinander umfangreich sind.
- Qualität und Dokumentation besitzen getrennte normative Module, damit Prüf-/Lizenzregeln nicht mit Dokumentationsregeln vermischt werden.
- Ein eigenes Release-Regelmodul ist bewusst noch nicht Bestandteil von #141. Der bisherige App-Harness enthielt keinen eigenständigen Releasevertrag; Story #144 führt diesen fachlich separat ein. Bis dahin gelten die allgemeinen Workflow-, Sicherheits-, Qualitäts- und Dokumentationsregeln auch für Releasearbeiten.

## Bewusste Abgrenzungen

Nicht übernommen wurden insbesondere:

- Offline-first beziehungsweise ausschließlich lokale Datenhaltung aus `taugts`, weil die App bewusst GitHub und das Developer-Wiki anspricht;
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
