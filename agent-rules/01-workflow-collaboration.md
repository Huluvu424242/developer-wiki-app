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
- Umfasst ein menschlicher Auftrag ausdrücklich mehrere Stories oder Bugs, werden alle beauftragten Einheiten vollständig bis zu ihren jeweils vorgesehenen Pull Requests bearbeitet, bevor die abschließende menschliche Review-Lücke beginnt.
- Die Erstellung eines ersten oder weiteren PRs innerhalb eines solchen Mehrfachauftrags beendet den Gesamtauftrag nicht. Der Agent fährt mit den übrigen ausdrücklich beauftragten Stories oder Bugs fort, sofern keine fachliche Blockade oder widersprüchliche Regel dies verhindert.

## Pull Requests

- Jeder PR referenziert die zugehörigen Stories und Bugs.
- Vollständig erledigte Issues werden mit `Closes`, `Fixes` oder `Resolves` verknüpft; teilweise erledigte Issues nur mit einer nicht schließenden Referenz.
- Der PR nennt Umsetzung, Prüfungen, Dokumentationsstatus und verbleibende Unsicherheiten.

## Menschliche Review-Lücke und delegierter Merge

- Bei einem Einzelauftrag beginnt die menschliche Review-Lücke nach Bereitstellung des zugehörigen Pull Requests beziehungsweise nach dessen letzter wesentlicher Aktualisierung.
- Bei einem ausdrücklich mehrere Stories, Bugs oder PRs umfassenden Implementierungsauftrag beginnt die menschliche Review-Lücke erst, nachdem **alle im Auftrag vorgesehenen Implementierungen bis zu ihren jeweiligen Pull Requests bereitgestellt** wurden. Bereits erstellte PRs innerhalb dieses Batches sind kein Grund, die Bearbeitung der übrigen beauftragten Einheiten vorzeitig zu beenden.
- Die Review-Lücke trennt den gesamten abgeschlossenen Implementierungsauftrag von einer späteren Merge-Aufgabe. Der KI-Agent führt im ursprünglichen Implementierungsauftrag keinen Merge der dabei erzeugten PRs aus.
- Der Mensch erhält nach Bereitstellung des vollständigen PR-Satzes Gelegenheit, Diffs, Prüfungen, Risiken, Abhängigkeiten und gegebenenfalls die geplante Merge-Reihenfolge zu prüfen.
- Ein späterer Merge durch den KI-Agenten ist zulässig, wenn der Mensch ihn nach dieser Review-Lücke in einer **neuen, ausdrücklichen Aufgabe** beauftragt.
- Diese neue Aufgabe darf auch mehrere bereits geprüfte PRs umfassen, insbesondere für gestapelte Merges, notwendige Rebases und konfliktfreie Reihenfolgen.
- Eine frühere Implementierungsbeauftragung, die bloße PR-Erstellung, ein erfolgreicher CI-Lauf, Schweigen oder eine allgemeine Aussage wie `wenn alles grün ist, merge` im ursprünglichen Implementierungsauftrag ersetzen die spätere neue Merge-Beauftragung nicht.
- Vor einem delegierten Merge prüft der KI-Agent den aktuellen PR-Stand erneut, einschließlich Reviews, CI/Checks, Mergekonflikten, Branch-Abhängigkeiten und seit der menschlichen Prüfung hinzugekommenen Änderungen.
- Sind seit der erkennbaren menschlichen Prüfung inhaltlich relevante Änderungen hinzugekommen, wird nicht eigenmächtig gemergt; der Mensch wird auf die Änderung hingewiesen und eine erneute Review-Möglichkeit eingeräumt.
- Rebase und Konfliktauflösung dürfen Bestandteil der delegierten Merge-Aufgabe sein. Konflikte werden fachlich gelöst; bei unklarer Bedeutung wird nicht geraten.
- Der Agent darf mehrere freigegebene PRs in einer vom Menschen delegierten Merge-Aufgabe nacheinander rebasen, prüfen und mergen, wenn Abhängigkeiten und Reihenfolge dies erfordern.

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
