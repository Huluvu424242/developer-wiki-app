# Changelog

Alle relevanten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format orientiert sich an [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
und dieses Projekt verwendet [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Added

- Appweites Menü mit About-Dialog, installierter Release- und Buildnummer sowie offline verfügbarer Barrierefreiheitserklärung.
- Sicherer, kontextbezogener Bugreport für alle Screens und App-Dialoge, der ohne Wiki-PAT ein vorbereitetes Issue mit dem Label `bug` im Browser öffnet.
- Fehlersammler mit Feldnavigation und Fokussteuerung für Quellenformular, Einstellungen und Bugreport.
- Fachliche Maximallängen und barrierefreie Restzeichenzähler für alle Texteingaben mit kombinierter sichtbarer, semantischer und akustischer Grenzrückmeldung.

### Changed

- KI-Agenten kommunizieren mit menschlichen Entwicklern verbindlich auf Deutsch, formulieren insbesondere Stories, Bug-Issues und Pull Requests auf Deutsch und melden nach Arbeiten Ergebnis, Stand und relevante GitHub-Links zurück.
- Der Bugreport weist vor dem Wechsel zu GitHub darauf hin, dass zum endgültigen Absenden eine GitHub-Anmeldung erforderlich ist und der vorbereitete Bericht dort zunächst geprüft werden kann.
- Das importierbare Branch-Ruleset schützt neben `master` jetzt auch alle Branches unter `release/**`.
- Einstellungen verwenden jetzt feldnahe Validierung, temporäre Hinweise und reservierten Platz unter den Aktionsschaltflächen.

## [0.1.0+3] - 2026-08-25

### Added

- Grundlage für Bild-Quellen mit eigenem Quellentyp, validierter Bildauswahl,
  Vorschau sowie Entfernen und Ersetzen des unveränderten Originalbilds.
- Drittes Android-Share-Ziel für PNG-, GIF- und JPEG-Bilder, das geteilte
  `content://`-Inhalte in denselben privaten Bildquellen-Entwurf übernimmt.
- Unterbrechbarer GitHub-Attachment-Ablauf für Bild-Quellen: unlabeled
  Pending-Issue, Upload im GitHub-Markdown-Editor, Prüfung einer stabilen
  `user-attachments`-URL und erst danach Veröffentlichung mit `quelle`.
- Verbindliche Projektdokumentation unter `docs/` mit C4-orientierter Architekturübersicht.
- Dokumentationsregeln für Changelog, README und technische Dokumentation im Implementierungsworkflow.

### Changed

- Android-Share-Ziele verwenden eigenständige Launcher-Icons mit unterscheidbaren Overlays für Link, Text und Bild.

### Fixed

- Dialoge zur Fehlererfassung übermitteln jetzt eindeutig unterscheidbare Kontexte für Link-, Text-, Bild- und Personenquellen sowie für Über-Dialog und Barrierefreiheitserklärung.

## [0.1.0+2] - 2026-08-24

### Added

- Bild-Quelle als eigener Quellentyp mit Bildauswahl und GitHub-Attachment-Ablauf.
- App-Logo und Share-Ziel-Varianten für Link-, Text- und Bildquellen.
- `ATTRIBUTIONS.md` für lizenzrechtlich relevante ausgelieferte Bestandteile.

## [0.1.0+1] - 2026-08-22

### Added

- Erste veröffentlichte Android-Version der Developer-Wiki-App.
