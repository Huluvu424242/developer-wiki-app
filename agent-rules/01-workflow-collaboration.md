# Workflow und Zusammenarbeit

## Kommunikation mit menschlichen Entwicklern

- Jegliche Kommunikation zwischen KI-Agenten und menschlichen Entwicklern erfolgt grundsätzlich in deutscher Sprache.
- Dies gilt insbesondere für direkte Rückmeldungen, Analysen, Planungen, Review-Rückmeldungen, Abschlussmeldungen, GitHub-Stories, Bug-Issues, Pull-Request-Titel und Pull-Request-Beschreibungen.
- Technische Bezeichner, API-Namen, Dateinamen, Kommandos, Code, Log-Ausgaben und unveränderte externe Zitate dürfen in ihrer technisch notwendigen Originalsprache verbleiben.
- Nach Fertigstellung oder bei einem klaren Zwischenstand wird der menschliche Entwickler aktiv über Ergebnis, Prüfungen, offene Punkte, Risiken und den nächsten sinnvollen Schritt informiert.
- Relevante GitHub-Artefakte wie Stories, Bugs und Pull Requests werden direkt verlinkt.

## Sprache von Bezeichnern

- Fachliche Präzision hat Vorrang vor sprachlicher Vereinheitlichung.
- Etablierte technische Begriffe dürfen und sollen in englischer Fachsprache verwendet werden.
- Fachliche Begriffe werden bevorzugt in der Sprache der jeweiligen Domäne benannt, wenn dies die Bedeutung präziser ausdrückt.
- Begriffe dürfen nicht mechanisch übersetzt werden. Eine technische `Editor`-Komponente bleibt `Editor`, solange tatsächlich ein Editor gemeint ist.
- Framework-, Sprach- und API-Konventionen wie `get...`, `set...`, `is...`, `UpperCamelCase`, `lowerCamelCase` und `snake_case.dart` bleiben erhalten.

## Fehlerbehebung

Ein gemeldeter Defekt wird nicht still repariert. Die Reihenfolge lautet:

**Analyse → Bug-Issue → eigener Branch → Implementierung → Prüfung → Pull Request → Rückmeldung**

1. Repository, relevante Dateien, Konfigurationen, Abhängigkeiten und bestehende Issues/PRs analysieren. Für GitHub-Zugriffe den verbundenen GitHub-Connector verwenden.
2. Sofern noch kein passendes Bug-Issue existiert, ein Issue mit Fehlerbild, Fehlermeldung, Analyse, Ursache beziehungsweise begründeter Vermutung, betroffenen Komponenten und Lösungsansatz anlegen.
3. Erst danach auf einem eigenen Branch die ursachenbezogene Änderung umsetzen. Fachfremde Aufräumarbeiten bleiben draußen.
4. Geeignete Tests und Prüfungen ausführen und die Dokumentationspflichten aus [Qualität und Dokumentation](06-quality-documentation.md) einhalten.
5. Einen Pull Request mit Closing-Keyword erstellen, Ursache, Lösung, Prüfungen, Dokumentationsstatus und verbleibende Unsicherheiten nennen.
6. Dem menschlichen Entwickler Pull Request, Ursache, Änderung, Prüfstatus und notwendige lokale Prüfungen mitteilen.

## Story-Erstellung und Planung

Neue Funktionen, fachliche Anforderungen und größere Erweiterungen werden vor der Umsetzung als Story mit dem Label `story` und prüfbaren Akzeptanzkriterien erfasst.

Auch Aufgaben „auf Zuruf“ werden grundsätzlich zuerst als Story erfasst. Von dieser Story-Pflicht darf ausschließlich nach folgendem Entscheidungsdialog abgewichen werden:

- Vor Beginn der Umsetzung muss der KI-Assistent wörtlich fragen: `Soll ich zunächst eine Story erstellen?`
- Bei `Ja` wird zuerst die Story erstellt.
- Bei `Nein` darf nur der konkret angefragte Auftrag ohne vorherige Story auf einem eigenen Branch umgesetzt werden.
- Eine unklare Antwort hebt die Story-Pflicht nicht auf.
- Die Ausnahme gilt ausschließlich für den konkreten Auftrag.

Für die Planung gilt:

1. Repository und fachlichen Kontext analysieren; vor der Story-Erstellung keine Implementierung vornehmen.
2. Anforderungen in sinnvoll geschnittene Stories mit eigenständigem Nutzen aufteilen und Abhängigkeiten benennen.
3. Bestehende passende Milestones wiederverwenden; neue nur bei erkennbarem Bedarf anlegen.
4. Jede Story beschreibt Ziel und Nutzen, fachliche Beschreibung, konkrete Akzeptanzkriterien, Abhängigkeiten und erkennbare betroffene Bereiche.
5. Bei neuen oder geänderten GUI-Ansichten ein einfaches Wireframe oder Markdown-Mockup mit relevanten Leer-, Lade-, Erfolgs- und Fehlerzuständen aufnehmen.
6. Erstellte Stories, Milestones und empfohlene Reihenfolge verlinken.

Gemeldete Defekte folgen dem gesonderten Bug-Workflow und werden nicht als Story umetikettiert.

## Implementierung von Stories

1. Story und aktuellen Repository-Stand vollständig analysieren; Akzeptanzkriterien sind verbindlicher Umfang.
2. Relevante Abhängigkeiten, bestehende Architektur und offene Pull Requests prüfen.
3. Größere Vorarbeiten oder Refactorings nicht still in den Umfang aufnehmen, sondern separat planen.
4. Einen eigenen Branch verwenden, der ausschließlich die zur Story gehörenden Änderungen enthält.
5. Entlang der Architekturregeln aus [Architektur und Implementierung](03-architecture.md) umsetzen.
6. Sicherheits-, UX-, Qualitäts-, Dokumentations- und Wiki-Integrationsregeln der übrigen Module einhalten.
7. Akzeptanzkriterien und erforderliche Prüfungen gegen die Umsetzung kontrollieren.
8. Pull Request mit Issue-Verknüpfung erstellen und anschließend Ergebnis und Prüfstatus melden.

## Verknüpfung von Pull Requests mit Stories und Bugs

- Jeder Pull Request referenziert alle Stories und Bugs, die durch seine Änderungen betroffen sind.
- Vollständig erledigte Issues werden mit einem GitHub-Closing-Keyword wie `Closes #123`, `Fixes #123` oder `Resolves #123` verknüpft.
- Bei mehreren vollständig erledigten Issues wird jedes einzeln mit Closing-Keyword genannt.
- Für nur teilweise erledigte Issues darf kein Closing-Keyword verwendet werden; sie werden beispielsweise mit `Related to #123` oder `Part of #123` referenziert.
- Vor Bereitmeldung eines Pull Requests ist die Issue-Verknüpfung zu prüfen.
- Bei gestapelten Pull Requests wird ein Issue nur in dem PR geschlossen, der es fachlich vollständig erledigt.

## Rebase und Aktualisierung von Arbeitsbranches

- `master` selbst wird niemals rebased oder durch History-Rewriting verändert.
- Rebase findet ausschließlich auf Arbeitsbranches statt; bereits gemergte Branches werden nicht nachträglich rebased.
- Vor einem Rebase aktuellen Zielstand, richtigen Branch und mögliche Mitbenutzer des Branches prüfen.
- Geteilte Branches nicht ohne ausdrückliche Zustimmung rebasen.
- Rebase bevorzugen, wenn ein Arbeitsbranch sinnvoll auf den aktuellen `master` gebracht werden muss; nicht als Selbstzweck verwenden.
- Konflikte fachlich und nachvollziehbar auflösen. Wenn die richtige Lösung unklar ist, Rebase abbrechen statt zu raten.
- Nach einem Rebase relevante Tests und statische Prüfungen erneut ausführen.
- Bereits veröffentlichte Arbeitsbranches nach Rebase ausschließlich mit einer sicheren Aktualisierung entsprechend `git push --force-with-lease` veröffentlichen. `git push --force` ist unzulässig.
- Scheitert `--force-with-lease` wegen fremder Änderungen, diese zuerst prüfen und nicht überschreiben.
- Der geschützte `master` wird ausschließlich über Pull Requests verändert; Force Pushes auf `master` bleiben verboten.

## Grundsätzliche Arbeitsreihenfolgen

Defekt:

**Analyse → Issue → Implementierung → Prüfung → Pull Request → Rückmeldung**

Neue Funktion oder größere Erweiterung:

**Analyse → Story-Schnitt → Milestones → Stories mit Akzeptanzkriterien und ggf. Wireframes → Rückmeldung**

Story-Umsetzung:

**Story prüfen → Branch → Implementierung → Tests, Analyse und Dokumentationspflege → Pull Request → Rückmeldung**
