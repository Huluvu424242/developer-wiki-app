# Architektur: Implementierung

- UI, Fachlogik, Persistenz und externe Kommunikation werden klar getrennt.
- Screens und Widgets setzen keine GitHub-Transportdetails selbst zusammen.
- GitHub-Zugriffe, Plattformintegration und geschützte lokale Speicherung werden über klare Services beziehungsweise Schnittstellen gekapselt.
- Eine fachliche Funktion besitzt möglichst einen zentralen Implementierungsweg; normale Erfassung und Android-Share verwenden dieselbe Fachlogik.
- UI verwendet Fachlogik und Services; Fachlogik und Services hängen nicht von konkreten Screens ab.
- Datenmodelle bleiben soweit sinnvoll unabhängig von Widgets und externen API-Formaten.
- Externe Systeme werden an den Rändern der Anwendung angebunden.
- Abstraktionen erst bei konkretem Wiederverwendungs- oder Entkopplungsbedarf einführen.
- Mobile first entwickeln; Barrierefreiheit und Testbarkeit bereits beim Entwurf berücksichtigen.
- Clean Code, geringe Kopplung und wenige versteckte Seiteneffekte anstreben.
- Keine Architektur auf Vorrat und keine neuen Frameworks oder State-Management-Lösungen ohne konkreten Bedarf.
- Allgemeine Fachlogik soweit sinnvoll plattformneutral halten; Android-spezifische Funktionen klar isolieren.
- Nutzer- und repositoryspezifische Werte nicht unnötig hardcodieren; sinnvolle Defaults müssen überschreibbar bleiben.
- Lade-, Erfolgs-, Leer- und Fehlerzustände sichtbar behandeln, wenn sie relevant sind.
- Nutzereingaben bei Netzwerk- oder API-Fehlern nach Möglichkeit erhalten.
- Relevante Fehler nicht still ignorieren und keine leeren `catch`-Blöcke verwenden.
- Nach asynchronen Operationen bei UI-Zugriffen den Widget-Lebenszyklus beachten.
- Doppelte Seiteneffekte durch Mehrfachauslösung laufender Aktionen verhindern.

Ergänzende Erläuterungen stehen in `docs/agent-harness.md`.
