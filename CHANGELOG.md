# Changelog

Alle relevanten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format orientiert sich an [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
und dieses Projekt verwendet [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Added

- Android-Teilen behält den fachlichen Quellentyp für Links, Text, Bilder und PDF-Dokumente bei; ein eigenes Dokument-Share-Ziel führt PDF-Dateien in die Dokument-Quelle, während unbekannte Dateitypen ohne stillen Fallback abgelehnt werden.
- Lokale PDF-Dateien können über die dynamische `Dokument-Quelle` ausgewählt, gegen MIME-Typ und Größenlimit des Wiki-Vertrags geprüft und in einem unterbrechbaren GitHub-Attachment-Flow erfasst werden; das Label `quelle` wird erst nach verifiziertem Attachment sowie rückgelesenem finalem Issue-Body gesetzt.
- Quellenarten und Formularfelder werden aus dem versionierten Quellen-Erfassungsvertrag des konfigurierten Developer-Wikis geladen; der letzte gültige Stand wird repositorybezogen gecacht und bei fehlendem beziehungsweise inkompatiblem Remote-Vertrag durch einen klar gekennzeichneten kompatiblen Bundle-Fallback ersetzt. Unbekannte Schema-Versionen, Feldarten und erforderliche Transportfähigkeiten werden nicht stillschweigend degradiert.
- Einen verbindlichen Lifecycle-Wartungsvertrag für Flutter, Dart, Android-Toolchain und native Plugins ergänzt: spätestens alle drei Monate einen neuen Lifecycle-Wartungszeitpunkt erfassen; existiert bereits eine offene Lifecycle-Story, wird sie auch über mehrjährige Ruhe-/Sarkophag-Betriebsphasen hinweg statt einer Dublette um einen datierten Quartalshinweis erweitert. Der konkrete Prüf- und Umsetzungsumfang wird stets aus dem jeweils aktuellen Harness abgeleitet; für nicht dringende Flutter-Stable-Releases gilt eine 2–4-wöchige Stabilisierungsphase sowie die definierte Upgrade-Governance.
- Eine quartalsweise `kiagent-quarterly-lifecycle-story`-GitHub-Action erfasst den Lifecycle-Wartungszeitpunkt automatisch: ohne offene Lifecycle-Story legt sie eine neue Story an, bei einer bereits offenen Story ergänzt sie genau einen datierten Hinweis je Quartal statt weitere offene Dubletten zu erzeugen.
- Eine schlanke `kiagent-flutter-validation`-GitHub-Action prüft bei jeder Pull-Request-Erstellung Formatierung, statische Analyse und Tests mit minimalen Leserechten und ohne Secrets oder Repository-Schreibwirkungen.
- Eine bei Push sowie manuell startbare `kiagent-format-and-commit`-GitHub-Action formatiert ausschließlich getrackte Python- und Dart-Dateien auf dem aktuellen Branch und committet notwendige reine Formatierungsänderungen auf denselben Branch.

### Changed

- Die Ersteinrichtung und PAT-Hilfe führen jetzt durch Repository, Wiki-PAT und Import-Workflow, erklären die erforderlichen Least-Privilege-Berechtigungen sowie ausdrücklich nicht benötigte Wiki-interne Secrets und prüfen Repository, Quellenmodell, Issues-Lesezugriff und Workflow-Sichtbarkeit vor dem Speichern.
- Die PAT-Hilfe nennt für das dynamische Laden des privaten Wiki-Vertrags zusätzlich `Contents: Read-only` und grenzt den App-PAT ausdrücklich von den internen Wiki-Secrets `SOURCE_IMAGE_TOKEN` und `SOURCE_ATTACHMENT_TOKEN` ab; ein Classic PAT für den Wiki-internen Dokumentdownload ist keine App-Anforderung.
- Die Android-Build-Toolchain auf den aktuellen Flutter-3.47.4-Template-Stand angehoben: Gradle 9.3.1, Android Gradle Plugin 9.1.0 und Kotlin Gradle Plugin 2.4.0; Android `minSdk` auf 24 und `targetSdk` auf 36 angehoben, die App verwendet `kotlin.compilerOptions`, während die von Flutter Stable weiterhin erzeugten AGP-9-Kompatibilitätsflags `android.newDsl=false` und `android.builtInKotlin=false` bewusst beibehalten werden. JDK 21 ist als lokaler und Release-Referenzstand dokumentiert.
- `flutter_secure_storage` von 9.x auf 10.3.4 aktualisiert, damit der Android-Pluginanteil Java 17 verwendet; die bisherige `encryptedSharedPreferences`-Konfiguration wird über den vorgesehenen 10.x-Migrationspfad mit aktivierter Algorithmusmigration und Backup-Schutz weitergeführt, bevor ein späteres Upgrade auf 11.x erfolgen darf.
- Den veralteten `android.enableJetifier=true`-Schalter entfernt; das Projekt verwendet ausschließlich AndroidX-Abhängigkeiten und soll keinen Legacy-Support-Library-Übersetzer mehr aktivieren.
- `kiagent-format-and-commit` und `kiagent-flutter-validation` verwenden für Dart einheitlich Flutter 3.47.4 sowie denselben Bereich `lib test`; die Formatierungsaction verifiziert nach `dart format lib test` zusätzlich mit exakt `dart format --set-exit-if-changed lib test` den späteren Validation-Check.
- Den Agenten-Harness von einer monolithischen `AGENTS.md` auf einen verbindlichen Einstiegspunkt mit thematischen Regelmodulen unter `agent-rules/` umgestellt; Regelpriorität, Wiki-/App-Verantwortungsgrenze und deterministische Harness-Strukturprüfung ergänzt.
- Flutter-, Architektur-, UX-, Barrierefreiheits- und Qualitätsregeln mit den passenden Erkenntnissen aus dem Taugt’s-Harness harmonisiert; insbesondere Lebenszyklusprüfungen nach `await`, sichere `const`-Widgetbäume, Lazy-Formularvalidierung, Scroll-Widgettests, robuste Fehlersammler-Navigation und einheitliche Abschlussstatus präzisiert.
- Einen verbindlichen Releasevorbereitungs-Vertrag ergänzt: `pubspec.yaml` ist technische Versionsquelle, `CHANGELOG.md` fachlicher Master; Versions-, Dokumentations-, Lizenz- und Konsistenzprüfungen sowie die Trennung zwischen Repository-Vorbereitung und produktiver Veröffentlichung sind festgelegt.

### Fixed

- „Verbindung testen“ prüft nun auch den tatsächlich benötigten Zugriff auf `src/config/source-capture.json`; bei fehlendem `Contents: Read-only` wird die Verbindung nicht als erfolgreich markiert und der 403-Hinweis nennt die benötigte Fine-grained-PAT-Berechtigung konkret.

### Security

- Eine verbindliche GitHub-Actions- und Werkzeugketten-Governance mit Default-Deny, Triggerprüfung vor schreibenden Repository-Operationen, separaten Werkzeugketten-PRs, menschlicher Review-Lücke, Freigabeverzeichnis und klarer Trennung von Merge und produktiver Ausführung eingeführt; der Android-Release-Workflow bleibt ohne ausdrückliche Owner-Freigabe von selbständiger Agentenausführung ausgeschlossen.
- Externe Actions des produktiven Android-Release-Workflows auf überprüfte unveränderliche Commit-SHAs gepinnt und Herkunft, Wartungszustand, Lizenz sowie bewusst verbleibende bewegliche Buildbestandteile dokumentiert.

## [0.1.0+4] - 2026-08-28

### Added

- Appweites Menü mit About-Dialog, installierter Release- und Buildnummer sowie offline verfügbarer Barrierefreiheitserklärung.
- Sicherer, kontextbezogener Bugreport für alle Screens und App-Dialoge, der ohne Wiki-PAT ein vorbereitetes Issue mit dem Label `bug` im Browser öffnet.
- Fehlersammler mit Feldnavigation und Fokussteuerung für Quellenformular, Einstellungen und Bugreport.
- Fachliche Maximallängen und barrierefreie Restzeichenzähler für alle Texteingaben mit kombinierter sichtbarer, semantischer und akustischer Grenzrückmeldung.

### Changed

- Die Architekturleitplanken strukturieren Anwendungscode künftig zuerst nach fachlichen Features und erst innerhalb dieser Features nach technischen Rollen; Bezeichner unterscheiden bewusst zwischen technischer englischer Terminologie und der Sprache der Fachdomäne.
- KI-Agenten kommunizieren mit menschlichen Entwicklern verbindlich auf Deutsch, formulieren insbesondere Stories, Bug-Issues und Pull Requests auf Deutsch und melden nach Arbeiten Ergebnis, Stand und relevante GitHub-Links zurück.
- Der Bugreport weist vor dem Wechsel zu GitHub darauf hin, dass zum endgültigen Absenden eine GitHub-Anmeldung erforderlich ist und der vorbereitete Bericht dort zunächst geprüft oder verworfen werden kann.
- Das importierbare Branch-Ruleset schützt neben `master` jetzt auch alle Branches unter `release/**`.
- Einstellungen verwenden jetzt feldnahe Validierung, temporäre Hinweise und reservierten Platz unter den Aktionsschaltflächen.

### Fixed

- Der GitHub-Anmeldehinweis im Bugreport verwendet kein unzulässiges `const` mehr am `Semantics`-Widget, sodass `flutter analyze` nicht mehr mit `const_with_non_const` abbricht.

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

[Unreleased]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0+4...HEAD
[0.1.0+4]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0+3...v0.1.0+4
[0.1.0+3]: https://github.com/Huluvu424242/developer-wiki-app/compare/v0.1.0+2...v0.1.0+3
