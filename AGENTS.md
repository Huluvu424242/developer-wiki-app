# Arbeitsregeln für KI-Assistenten

Diese Datei ist der verbindliche Einstiegspunkt für alle Arbeiten am Repository **Developer-Wiki-App**. Die eigentlichen Arbeitsregeln sind modular unter `agent-rules/` organisiert.

## Lesepflicht

Vor jeder Repository-Arbeit müssen der **aktuelle Repository-Stand** dieser `AGENTS.md` und alle nachfolgend gelisteten Regelmodule vollständig gelesen werden. Regeln aus einem früheren Lauf dürfen nicht als ausreichend aktuell vorausgesetzt werden.

Für GitHub-Zugriffe und -Änderungen ist ausschließlich der verbundene GitHub-Connector zu verwenden. Fremde oder nicht zum Auftrag gehörende Änderungen bleiben erhalten.

## Verbindlicher Regelkatalog

Die Module sind in dieser Reihenfolge zu lesen:

1. [Workflow und Zusammenarbeit](agent-rules/01-workflow-collaboration.md)
2. [Projektaufsetzung und Grundgerüst](agent-rules/02-project-bootstrap.md)
3. [Architektur – fachliche Struktur](agent-rules/03-structure.md)
4. [Architektur – Implementierung](agent-rules/03-implementation.md)
5. [UX und Barrierefreiheit](agent-rules/04-ux-accessibility.md)
6. [Sicherheit – Zugriffsgrenzen](agent-rules/05-security-access.md)
7. [Sicherheit – Datenbehandlung](agent-rules/05-security-data.md)
8. [Sicherheit – Tests, CI und Vorfälle](agent-rules/05-security-ci.md)
9. [Qualität](agent-rules/06-quality.md)
10. [Dokumentationspflege](agent-rules/06-documentation.md)
11. [Wiki-Integration](agent-rules/08-wiki-integration.md)

Alle gelisteten Dateien sind verbindlicher Bestandteil des Harness. Nicht gelistete Dateien unter `agent-rules/` sind nicht automatisch normativ.

Ein eigenes Release-Regelmodul wird mit Story #144 eingeführt. Bis dahin gelten für Releasearbeiten die allgemeinen Workflow-, Sicherheits-, Qualitäts- und Dokumentationsregeln dieses Katalogs; Story #141 nimmt den späteren Releasevertrag nicht vorweg.

## Regelpriorität

Bei Konflikten gilt folgende Reihenfolge:

1. Plattform-, Sicherheits- und Berechtigungsvorgaben der Ausführungsumgebung;
2. spezifische Repository-Sicherheitsregeln und ausdrücklich speziellere Verträge für den konkreten Ablauf;
3. die thematisch speziellere Regel vor einer allgemeineren Regel;
4. konkrete Story beziehungsweise konkreter Auftrag innerhalb der durch die höheren Regeln gesetzten Grenzen;
5. allgemeine Repository-Regeln.

Widersprechen sich zwei gleichrangige Regeln oder bleibt ein Konflikt fachlich unauflösbar, darf der Agent nicht raten. Die betroffene irreversible oder widersprüchliche Änderung wird angehalten und der menschliche Entwickler über den konkreten Konflikt informiert. Unabhängige, eindeutig ausführbare Teilaufgaben dürfen fortgeführt werden, sofern sie den Konflikt nicht verschärfen.

## Normative Quelle

Eine Regel soll möglichst genau eine normative Heimat besitzen. Projektdokumentation darf Regeln begründen, erklären und auf sie verweisen, soll aber keine unabhängige Vollkopie derselben Regel pflegen.

Spezifischere Verträge dürfen den Umfang eines Ablaufs enger begrenzen, aber keine übergeordneten Sicherheitsregeln abschwächen.
