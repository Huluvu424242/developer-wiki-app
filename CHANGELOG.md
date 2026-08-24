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
- Provisorisches Android-Launcher-Icon durch das offizielle Developer-Wiki-App-Logo mit Adaptive, Round und Themed Icon ersetzt.
- Herkunft und Lizenzen des App-Logos sowie wesentlicher Open-Source-Komponenten in `ATTRIBUTIONS.md` dokumentiert.

### Fixed

- Widget-Test für den Validierungshinweis wartet zustandsbasiert auf die Snackbar statt auf eine feste Verzögerung.
- Widget-Test adressiert den Speichern-Button über einen stabilen Key statt über die konkrete Button-Implementierung.
- Widget-Test scrollt bis zum lazily aufgebauten Speichern-Button, bevor er ihn antippt.
- Widget-Test stabilisiert nach dem Scrollen die Sichtbarkeit und das Layout des Speichern-Buttons vor dem Tap.
- Pflichtfelder werden beim Speichern unabhängig von ihrer aktuellen Sichtbarkeit im scrollbaren Quellenformular geprüft.
- Snackbar-Widget-Test prüft nur den globalen Validierungshinweis und setzt keine gleichzeitig sichtbaren Inline-Feldfehler voraus.

[Unreleased]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0...HEAD
