# Changelog

Alle relevanten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format orientiert sich an [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
und dieses Projekt verwendet [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Added

- Einen verbindlichen Lifecycle-Wartungsvertrag für Flutter, Dart, Android-Toolchain und native Plugins ergänzt: spätestens alle drei Monate einen neuen Lifecycle-Wartungszeitpunkt erfassen; existiert bereits eine offene Lifecycle-Story, wird sie statt einer Dublette um einen datierten Quartalshinweis erweitert. Der konkrete Prüf- und Umsetzungsumfang wird stets aus dem jeweils aktuellen Harness abgeleitet; für nicht dringende Flutter-Stable-Releases gilt eine 2–4-wöchige Stabilisierungsphase sowie die definierte Upgrade-Governance.
- Eine quartalsweise `kiagent-quarterly-lifecycle-story`-GitHub-Action erfasst den Lifecycle-Wartungszeitpunkt automatisch: ohne offene Lifecycle-Story legt sie eine neue Story an, bei einer bereits offenen Story ergänzt sie genau einen datierten Hinweis je Quartal statt weitere offene Dubletten zu erzeugen.
- Eine schlanke `kiagent-flutter-validation`-GitHub-Action prüft bei jeder Pull-Request-Erstellung Formatierung, statische Analyse und Tests mit minimalen Leserechten und ohne Secrets oder Repository-Schreibwirkungen.
- Eine bei Push sowie manuell startbare `kiagent-format-and-commit`-GitHub-Action formatiert ausschließlich getrackte Python- und Dart-Dateien auf dem aktuellen Branch und committet notwendige reine Formatierungsänderungen auf denselben Branch.

### Changed

- Die Android-Build-Toolchain auf den aktuellen Flutter-3.47.4-Template-Stand angehoben: Gradle 9.3.1, Android Gradle Plugin 9.1.0 und Kotlin Gradle Plugin 2.4.0; Android `minSdk` auf 24 und `targetSdk` auf 36 angehoben, die App verwendet `kotlin.compilerOptions`, während die von Flutter Stable weiterhin erzeugten AGP-9-Kompatibilitätsflags `android.newDsl=false` und `android.builtInKotlin=false` bewusst beibehalten werden. JDK 21 ist als lokaler und Release-Referenzstand dokumentiert.
- `flutter_secure_storage` von 9.x auf 10.3.4 aktualisiert, damit der Android-Pluginanteil Java 17 verwendet; die bisherige `encryptedSharedPreferences`-Konfiguration wird über den vorgesehenen 10.x-Migrationspfad mit aktivierter Algorithmusmigration und Backup-Schutz weitergeführt, bevor ein späteres Upgrade auf 11.x erfolgen darf.
- Den veralteten `android.enableJetifier=true`-Schalter entfernt; das Projekt verwendet ausschließlich AndroidX-Abhängigkeiten und soll keinen Legacy-Support-Library-Übersetzer mehr aktivieren.
- `kiagent-format-and-commit` und `kiagent-flutter-validation` verwenden für Dart einheitlich Flutter 3.47.4 sowie denselben Bereich `lib test`; die Formatierungsaction verifiziert nach `dart format lib test` zusätzlich mit exakt `dart format --set-exit-if-changed lib test` den späteren Validation-Check.
- Den Agenten-Harness von einer monolithischen `AGENTS.md` auf einen verbindlichen Einstiegspunkt mit thematischen Regelmodulen unter `agent-rules/` umgestellt; Regelpriorität, Wiki-/App-Verantwortungsgrenze und deterministische Harness-Strukturprüfung ergänzt.
- Flutter-, Architektur-, UX-, Barrierefreiheits- und Qualitätsregeln mit den passenden Erkenntnissen aus dem Taugt’s-Harness harmonisiert; insbesondere Lebenszyklusprüfungen nach `await`, sichere `const`-Widgetbäume, Lazy-Formularvalidierung, Scroll-Widgettests, robuste Fehlersammler-Navigation und einheitliche Abschlussstatus präzisiert.
- Einen verbindlichen Releasevorbereitungs-Vertrag ergänzt: `pubspec.yaml` ist technische Versionsquelle, `CHANGELOG.md` fachlicher Master; Versions-, Dokumentations-, Lizenz- und Konsistenzprüfungen sowie die Trennung zwischen Repository-Vorbereitung und produktiver Veröffentlichung sind festgelegt.

### Security

- Eine verbindliche GitHub-Actions- und Werkzeugketten-Governance mit Default-Deny, Triggerprüfung vor schreibenden Repository-Operationen, separaten Werkzeugketten-PRs, menschlicher Review-Lücke, Freigabeverzeichnis und klarer Trennung von Merge und produktiver Ausführung eingeführt; der Android-Release-Workflow bleibt ohne ausdrückliche Owner-Freigabe von selbständiger Agentenausführung ausgeschlossen.
- Externe Actions des produktiven Android-Release-Workflows auf überprüfte unveränderliche Commit-SHAs gepinnt und Herkunft, Wartungszustand, Lizenz sowie bewusst verbleibende bewegliche Buildbestandteile dokumentiert.
