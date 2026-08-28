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

- Die Architekturleitplanken strukturieren Anwendungscode künftig zuerst nach fachlichen Features und erst innerhalb dieser Features nach technischen Rollen; Bezeichner unterscheiden bewusst zwischen technischer englischer Terminologie und der Sprache der Fachdomäne.
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
- Direkt in den Einstellungen aufrufbare Hilfe zum Erstellen eines Fine-grained GitHub PAT mit den benötigten Least-Privilege-Berechtigungen.
- Dokumentierter Prozess für die menschliche PR-Abnahme und das schrittweise Prüfen und Rebasen gestapelter Branches.
- Verbindliche PR-Regel zur Verknüpfung vollständig erledigter Stories und Bugs mit GitHub-Closing-Keywords.

### Changed

- Android-Teilen-Ziele verwenden unterscheidbare App-Logo-Varianten mit
  Weltkugel-, Text- beziehungsweise Bild-Overlay.
- README nach der Struktur von Standard Readme neu gegliedert und mit der weiterführenden Dokumentation verknüpft.
- Quellenformular ergonomischer gestaltet: zusätzlicher Abstand unter dem Speichern-Button, temporärer Validierungshinweis und Löschaktionen für befüllte Eingabefelder.
- Android-Release-Prozess um produktive `release/<tagname>`-Wartungsbranches für Bugfixes, Security Updates und Lifecycle-Maßnahmen ergänzt.
- Provisorisches Android-Launcher-Icon durch das offizielle Developer-Wiki-App-Logo mit Adaptive, Round und Themed Icon ersetzt.
- Herkunft und Lizenzen des App-Logos sowie wesentlicher Open-Source-Komponenten in `ATTRIBUTIONS.md` dokumentiert.

### Fixed

- Bugreports unterscheiden den aktuell gewählten Quellendialog sowie Über-Dialog und Barrierefreiheitserklärung eindeutig im vorbelegten Kontext.
- Der zweistufige Upload-Widget-Test scrollt zu lazy aufgebauten Pending- und
  Erfolgskarten, bevor er deren Darstellung prüft.
- Bildquellen-Widget-Tests machen gescrollte Aktionsbuttons vor dem Tap
  vollständig sichtbar und pumpen anschließend das aktualisierte Layout.
- Bildquellen-Widget-Tests verwenden eine injizierte synchrone Vorschau und
  hängen damit weder vom nativen Bild-Codec noch vom Windows-Dateisystem ab.
- Bildquellen-Widget-Tests verwenden vollständig decodierbare PNG-Testdaten,
  damit der Bild-Codec unter Windows nicht an einer abgeschnittenen Datei hängt.
- Bildquellen-Widget-Tests warten zustandsbasiert auf Vorschau-, Pending- und
  Erfolgszustände, statt bei einem animierten Textcursor mit `pumpAndSettle`
  bis zum Timeout zu laufen.
- Widget-Test für den Validierungshinweis wartet zustandsbasiert auf die Snackbar statt auf eine feste Verzögerung.
- Initiale Share-Intent-Inhalte werden innerhalb der vorgesehenen asynchronen
  Fehlerbehandlung vollständig abgewartet.
- Widget-Test adressiert den Speichern-Button über einen stabilen Key statt über die konkrete Button-Implementierung.
- Widget-Test scrollt bis zum lazily aufgebauten Speichern-Button, bevor er ihn antippt.
- Widget-Test stabilisiert nach dem Scrollen die Sichtbarkeit und das Layout des Speichern-Buttons vor dem Tap.
- Pflichtfelder werden beim Speichern unabhängig von ihrer aktuellen Sichtbarkeit im scrollbaren Quellenformular geprüft.
- Snackbar-Widget-Test prüft nur den globalen Validierungshinweis und setzt keine gleichzeitig sichtbaren Inline-Feldfehler voraus.

[Unreleased]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0+3...HEAD
[0.1.0+3]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0+2...v0.1.0+3
