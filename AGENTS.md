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

## Grundsatz

Ein gemeldeter Defekt soll nicht direkt „still“ repariert werden.
Die Reihenfolge lautet grundsätzlich:

Analyse → Issue → Implementierung → Prüfung → Pull Request → Rückmeldung