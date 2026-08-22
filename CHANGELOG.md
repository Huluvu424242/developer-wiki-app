# Changelog

Alle relevanten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format orientiert sich an [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
und dieses Projekt verwendet [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Added

- Verbindliche Projektdokumentation unter `docs/` mit C4-orientierter Architekturübersicht.
- Dokumentationsregeln für Changelog, README und technische Dokumentation im Implementierungsworkflow.
- Direkt in den Einstellungen aufrufbare Hilfe zum Erstellen eines Fine-grained GitHub PAT mit den benötigten Least-Privilege-Berechtigungen.
- Dokumentierter Prozess für die menschliche PR-Abnahme und das schrittweise Prüfen und Rebasen gestapelter Branches.
- Verbindliche PR-Regel zur Verknüpfung vollständig erledigter Stories und Bugs mit GitHub-Closing-Keywords.

### Changed

- README nach der Struktur von Standard Readme neu gegliedert und mit der weiterführenden Dokumentation verknüpft.
- Quellenformular ergonomischer gestaltet: zusätzlicher Abstand unter dem Speichern-Button, temporärer Validierungshinweis und Löschaktionen für befüllte Eingabefelder.
- Android-Release-Prozess um produktive `release/<tagname>`-Wartungsbranches für Bugfixes, Security Updates und Lifecycle-Maßnahmen ergänzt.

### Fixed

- Widget-Test für den Validierungshinweis wartet zustandsbasiert auf die Snackbar statt auf eine feste Verzögerung.
- Widget-Test adressiert den Speichern-Button über einen stabilen Key statt über die konkrete Button-Implementierung.

[Unreleased]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0...HEAD
