# Workflow und Zusammenarbeit

## Kommunikation

- Kommunikation mit menschlichen Entwicklern, Stories, Bugs sowie PR-Titel und -Beschreibungen erfolgt auf Deutsch; technische Bezeichner und unveränderte Fehlermeldungen dürfen englisch bleiben.
- Abschlussmeldungen nennen Ergebnis, Prüfungen, offene Risiken, nächste Schritte und relevante GitHub-Links.
- Bezeichner folgen Dart-/Flutter-Konventionen und werden fachlich präzise statt mechanisch übersetzt.

## Fehlerbehebung

Ein Defekt folgt: **Analyse → Bug-Issue → eigener Branch → Implementierung → Prüfung → Pull Request → Rückmeldung**.

Das Bug-Issue enthält Fehlerbild, Fehlermeldung, Analyse, Ursache beziehungsweise begründete Vermutung, betroffene Komponenten und Lösungsansatz. Ein vorhandenes passendes Bug-Issue wird wiederverwendet. Fachfremde Änderungen bleiben draußen.

## Story-Planung

Neue Funktionen und funktionale Änderungen werden grundsätzlich zuerst als Story mit Label `story` und prüfbaren Akzeptanzkriterien erfasst. Soll ausnahmsweise ohne Story gearbeitet werden, muss vorher wörtlich gefragt werden: `Soll ich zunächst eine Story erstellen?` Nur ein eindeutiges `Nein` hebt die Story-Pflicht für genau diesen Auftrag auf.

Stories beschreiben Ziel, Nutzen, fachliche Anforderungen, Akzeptanzkriterien, Abhängigkeiten und betroffene Bereiche. GUI-Stories enthalten ein einfaches Wireframe oder Mockup mit relevanten Zuständen. Bestehende passende Milestones werden wiederverwendet.

## Story-Umsetzung

- Story und aktuellen Repository-Stand vor Änderungen vollständig prüfen.
- Einen eigenen, thematisch geschlossenen Arbeitsbranch verwenden.
- Architekturregeln aus [Struktur](03-structure.md) und [Implementierung](03-implementation.md) einhalten.
- Sicherheits-, UX-, Qualitäts-, Dokumentations- und Wiki-Integrationsregeln der übrigen Module anwenden.
- Akzeptanzkriterien und erforderliche Prüfungen vor Abschluss kontrollieren.

## Pull Requests

- Jeder PR referenziert die zugehörigen Stories und Bugs.
- Vollständig erledigte Issues werden mit `Closes`, `Fixes` oder `Resolves` verknüpft; teilweise erledigte Issues nur mit einer nicht schließenden Referenz.
- Der PR nennt Umsetzung, Prüfungen, Dokumentationsstatus und verbleibende Unsicherheiten.

## Rebase

- `master` wird niemals rebased oder per Force Push verändert.
- Rebase findet nur auf Arbeitsbranches statt; geteilte Branches nur nach Zustimmung.
- Konflikte fachlich auflösen und bei Unklarheit abbrechen statt raten.
- Nach Rebase relevante Prüfungen wiederholen.
- Veröffentlichte Arbeitsbranches nur entsprechend `git push --force-with-lease` aktualisieren; ungesichertes `--force` ist verboten.
- Der geschützte `master` wird ausschließlich über Pull Requests verändert.

## Abschlussstatus

- `Implementiert, technische Prüfung ausstehend`: Mindestens eine erforderliche automatisierte Prüfung konnte nicht erfolgreich ausgeführt werden. Grund, Auswirkung und Restrisiko werden genannt.
- `Geprüft und mergebereit`: Alle erforderlichen und verfügbaren automatisierten Prüfungen waren erfolgreich, die Dokumentation ist aktuell und es ist kein bekannter technischer Blocker offen. Noch offene manuelle Prüfungen werden transparent benannt.
- Nicht ausführbare Prüfungen werden niemals als erfolgreich dargestellt.
