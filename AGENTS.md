# Arbeitsregeln für KI-Assistenten

## Fehlerbehebung

Wenn der Benutzer einen Fehler meldet und um Behebung bittet, ist grundsätzlich folgender Ablauf einzuhalten:

1. Das Repository zunächst analysieren.
    - Für GitHub-Zugriffe ausschließlich den verbundenen GitHub-Connector verwenden.
    - Relevante Dateien, Konfigurationen, Abhängigkeiten und bestehende Issues/PRs prüfen.
    - Die wahrscheinlichste Ursache nachvollziehbar bestimmen.
    - Keine Codeänderungen vor Abschluss dieser Analyse vornehmen.

2. Nach der Analyse ein GitHub-Issue erstellen.
   Das Issue soll mindestens enthalten:
    - beobachtetes Fehlerbild,
    - bekannte Fehlermeldung,
    - Analyseergebnisse,
    - identifizierte oder vermutete Ursache,
    - betroffene Dateien bzw. Komponenten,
    - geplanten Lösungsansatz.

3. Erst danach die Fehlerbehebung umsetzen.
    - Einen eigenen Branch für die Änderung erstellen.
    - Nur Änderungen vornehmen, die zur Behebung des Fehlers erforderlich sind.
    - Bestehendes Verhalten soweit möglich unverändert lassen.
    - Geeignete Tests oder Prüfungen ergänzen bzw. ausführen.

4. Einen Pull Request erstellen.
   Der PR soll:
    - auf das zuvor erstellte Issue verweisen,
    - Ursache und Lösung kurz erklären,
    - die durchgeführten Prüfungen nennen,
    - verbleibende Unsicherheiten ausdrücklich erwähnen.

5. Dem Benutzer anschließend den Pull Request verlinken.
   Zusätzlich kurz mitteilen:
    - was die Ursache war,
    - was geändert wurde,
    - was der Benutzer nach dem Merge lokal prüfen sollte.

## Story-Erstellung und Planung

Wenn der Benutzer neue Funktionen, fachliche Anforderungen oder größere Erweiterungen planen und als Stories erfassen möchte, ist grundsätzlich folgender Ablauf einzuhalten:

1. Das Repository und den fachlichen Kontext zunächst analysieren.
    - Für GitHub-Zugriffe ausschließlich den verbundenen GitHub-Connector verwenden.
    - Bestehende Architektur, Dokumentation, Issues, Pull Requests, Labels und Milestones prüfen, soweit sie für die Planung relevant sind.
    - Bereits vorhandene Funktionen und Stories berücksichtigen, damit keine unnötigen Doppelungen entstehen.
    - Vor der Story-Erstellung noch keine Implementierung vornehmen.

2. Die Anforderungen in sinnvoll geschnittene Stories aufteilen.
    - Jede Story soll einen klar abgegrenzten, nachvollziehbaren Nutzer- oder Produktwert liefern.
    - Stories sollen weder unnötig groß noch künstlich kleinteilig sein.
    - Technische Vorarbeiten dürfen als eigene Story erfasst werden, wenn sie einen klaren Zweck für nachfolgende Funktionen haben.
    - Abhängigkeiten und eine sinnvolle Umsetzungsreihenfolge zwischen Stories ausdrücklich benennen.

3. Sinnvolle Milestones definieren und die Stories zuordnen.
    - Milestones sollen fachlich zusammengehörige Entwicklungsziele bündeln, zum Beispiel eine erste nutzbare Version oder einen klar abgegrenzten Ausbauzustand.
    - Bestehende passende Milestones sollen wiederverwendet werden; neue Milestones nur anlegen, wenn dies für die Planung erforderlich ist.
    - Jede Story soll genau dem Milestone zugeordnet werden, in dem ihr Ergebnis erstmals benötigt wird.

4. Für jede Story ein GitHub-Issue erstellen.
    - Jede Story erhält das Label `story`.
    - Die Story soll mindestens enthalten:
        - Ziel und Nutzen,
        - fachliche Beschreibung,
        - konkrete Akzeptanzkriterien,
        - relevante Abhängigkeiten oder Vorbedingungen,
        - betroffene Bereiche oder Komponenten, soweit bereits erkennbar.
    - Technische Lösungsdetails nur so weit festlegen, wie sie für das gewünschte Verhalten oder notwendige Randbedingungen relevant sind.

5. Bei Stories mit neuen oder geänderten GUI-Ansichten ein einfaches Wireframe oder Mockup in die Story aufnehmen.
    - Das Wireframe soll die wesentlichen Bereiche, Bedienelemente und Navigationswege der Zielansicht zeigen.
    - Ein einfaches textbasiertes ASCII-Wireframe oder vergleichbares Markdown-Mockup ist ausreichend.
    - Das Wireframe dient der Verständigung über das Zielbild und ist keine pixelgenaue Designvorgabe.
    - Relevante Zustände wie leer, erfolgreich, Fehler oder Laden sollen dargestellt werden, wenn sie für die Story wesentlich sind.

6. Dem Benutzer anschließend die erstellten Milestones und Stories verlinken.
   Zusätzlich kurz mitteilen:
    - wie die Anforderungen geschnitten wurden,
    - welche Abhängigkeiten zwischen den Stories bestehen,
    - welche Story bzw. welcher Milestone als nächster sinnvoll umgesetzt werden sollte.

## Grundsatz

Ein gemeldeter Defekt soll nicht direkt „still“ repariert werden.
Die Reihenfolge lautet grundsätzlich:

Analyse → Issue → Implementierung → Prüfung → Pull Request → Rückmeldung

Neue Funktionen und größere Erweiterungen sollen nicht direkt aus einer groben Idee implementiert werden.
Die Reihenfolge für die Planung lautet grundsätzlich:

Analyse → Story-Schnitt → Milestones → Stories mit Akzeptanzkriterien und ggf. Wireframes → Rückmeldung
