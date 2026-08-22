# developer-wiki-app

App zum Erfassen von Quellen für das Developer Wiki

Die Flutter-App erfasst strukturierte Quellen mobil und legt sie als GitHub-Issues im konfigurierten persönlichen Developer-Wiki an. Zusätzlich kann sie den zugehörigen Import-Workflow starten und dessen Status anzeigen. Sie besitzt keinen eigenen Server und sendet keine Telemetrie.

Der Flutter-Paketname lautet aus historischen Gründen `developer_wiki_source_capture`; das Repository und die Anwendung werden als `developer-wiki-app` geführt.

## Inhaltsverzeichnis

- [Sicherheit](#sicherheit)
- [Hintergrund](#hintergrund)
- [Installation](#installation)
- [Nutzung](#nutzung)
- [Dokumentation](#dokumentation)
- [Entwicklung](#entwicklung)
- [Android-Release](#android-release)
- [Mitwirken](#mitwirken)
- [Lizenz](#lizenz)

## Sicherheit

Für den Zugriff auf GitHub wird ein **Fine-grained personal access token** verwendet. Für den aktuellen Funktionsumfang sollte das Token auf das Ziel-Wiki beschränkt werden und nur folgende Repository-Berechtigungen besitzen:

- `Actions`: Read and write
- `Issues`: Read and write
- `Metadata`: Read-only

Zusätzliche Account Permissions sind für den aktuellen Funktionsumfang nicht erforderlich. Das Token ausschließlich in den App-Einstellungen eingeben und niemals in Quellcode, Screenshots, Issues oder Logs ablegen. Die App speichert es über den geschützten lokalen Plattform-Speicher.

Release-Keystores und daraus erzeugte Base64-Dateien dürfen ebenfalls nicht ins Repository eingecheckt werden.

## Hintergrund

Die App ist ein Client des persönlichen Developer-Wikis. Sie übernimmt die mobile Erfassung und GitHub-Interaktion; Importlogik, Archivierung und Wissensaufbereitung verbleiben im Wiki-Repository.

Der aktuelle Funktionsumfang umfasst unter anderem:

- Quellenarten mit Pflichtfeldern, Auswahlwerten, Titelpräfixen und Promptergänzungen,
- GitHub-kompatible Markdown-Issue-Beschreibungen,
- Erstellung von Issues mit dem Label `quelle`,
- Prüfung der Wiki-Verbindung und des PAT,
- Start und Statusabfrage des konfigurierten GitHub-Actions-Workflows,
- geschützte lokale Speicherung der Konfiguration,
- Android-Share als zusätzlicher Einstieg in die Quellenerfassung.

Die Quellenformulare sind derzeit versioniert in `lib/models/source_template.dart` enthalten. Dadurch bleibt die App offline startbar und externe Template-Änderungen beeinflussen UI und Requests nicht ungeprüft. Eine spätere Version kann Templates lesend aus dem Wiki laden und eine geprüfte lokale Fallback-Version behalten.

## Installation

Vorausgesetzt werden Flutter mit passender Android-Toolchain sowie ein Android-Gerät oder Emulator. Repository klonen und Abhängigkeiten laden:

```bash
git clone https://github.com/Huluvu424242/developer-wiki-app.git
cd developer-wiki-app
flutter pub get
```

Falls generierte Flutter-Plattformdateien bewusst neu aufgebaut werden müssen, kann Flutter sie ergänzen:

```bash
flutter create . --platforms android --org de.huluvu
```

Danach den Diff prüfen, damit Paket-ID und bewusst gepflegte Android-Konfiguration erhalten bleiben.

## Nutzung

Ein verbundenes Android-Gerät oder einen Emulator auswählen und die App starten:

```bash
flutter run
```

Beim ersten Start das Ziel-Wiki, das Fine-grained PAT und den per `workflow_dispatch` startbaren Import-Workflow konfigurieren. Anschließend können Quellen erfasst und als Issues im Wiki gespeichert werden.

## Dokumentation

Die weiterführende Projektdokumentation liegt unter [`docs/`](docs/README.md):

- [Architektur nach dem C4-Modell](docs/architecture.md)
- [Signierter Android-Release über GitHub Actions](docs/android-release.md)

Änderungen an Features, Bugfixes oder technischer Infrastruktur aktualisieren die betroffenen Dokumentationsartefakte im selben Pull Request. Das [CHANGELOG](CHANGELOG.md) wird nach Keep a Changelog gepflegt.

## Entwicklung

Vor einem Pull Request mindestens die statische Analyse und Tests ausführen:

```bash
flutter analyze
flutter test
```

Für einen lokalen Release-Build:

```bash
flutter build apk --release
```

Die verbindlichen Arbeits-, Architektur-, Test- und Dokumentationsregeln für Implementierungen stehen in [`AGENTS.md`](AGENTS.md).

## Android-Release

Veröffentlichte APKs werden über den manuell startbaren GitHub-Actions-Workflow **Android Release APK** mit einem stabilen Keystore signiert. Der Workflow prüft Version, Analyse und Tests, erzeugt APK und SHA-256-Prüfsumme und veröffentlicht beides als GitHub Release.

Die vollständige Einrichtung des Keystores, die vier benötigten GitHub Actions Secrets und die Ausführung des Workflows sind in der [Android-Release-Dokumentation](docs/android-release.md) beschrieben.

## Mitwirken

Fragen und Fehler können über die [GitHub Issues](https://github.com/Huluvu424242/developer-wiki-app/issues) eingebracht werden. Pull Requests sind willkommen, sollen sich auf ein klar abgegrenztes Issue bzw. eine Story beziehen und die Regeln aus [`AGENTS.md`](AGENTS.md) einhalten.

Insbesondere müssen relevante Tests sowie `flutter analyze` erfolgreich sein. Bei Source-Änderungen ist außerdem zu prüfen, ob `CHANGELOG.md`, `README.md`, Dateien unter `docs/` oder Architekturdiagramme aktualisiert werden müssen.

## Lizenz

MIT © 2026 Thomas Schubert. Siehe [LICENSE](LICENSE).
