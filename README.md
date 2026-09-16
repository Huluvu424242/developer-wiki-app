# developer-wiki-app

<img src="assets/branding/developer-wiki-app-logo.png" alt="Logo der Developer-Wiki-App" width="180">

(Die App funktioniert soweit wie gewünscht und damit pausiert die Entwicklung bis Feature Requests eintreffen)

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

Für den Zugriff auf GitHub wird ein **Fine-grained personal access token** verwendet. Für den aktuellen Funktionsumfang sollte das Token ausschließlich auf das persönliche Developer-Wiki beschränkt werden und nur folgende Repository-Berechtigungen besitzen:

- `Actions`: Read and write
- `Contents`: Read-only
- `Issues`: Read and write
- `Metadata`: Read-only

Zusätzliche Account Permissions sind für den aktuellen Funktionsumfang nicht erforderlich. Das Token ausschließlich in den App-Einstellungen eingeben und niemals in Quellcode, Screenshots, Issues oder Logs ablegen. Die App speichert es über den geschützten lokalen Plattform-Speicher. Direkt am PAT-Feld kann über das Hilfe-Symbol eine Schritt-für-Schritt-Anleitung zur Erstellung und Berechtigung des Tokens geöffnet werden.

Die Wiki-internen Secrets `SOURCE_IMAGE_TOKEN` und `SOURCE_ATTACHMENT_TOKEN` werden von der App nicht benötigt. Ebenso wird der Wiki-PAT nicht für Bugreports oder Zugriffe auf das App-Repository verwendet.

Release-Keystores und daraus erzeugte Base64-Dateien dürfen ebenfalls nicht ins Repository eingecheckt werden.

Der App-Bugreport öffnet ausschließlich eine vorbereitete GitHub-Seite im Browser. Zum endgültigen Absenden ist dort eine Anmeldung bei GitHub erforderlich; der vorbereitete Bericht kann vor dem Absenden geprüft oder verworfen werden. Das für das persönliche Wiki gespeicherte PAT wird dabei weder gelesen noch für Zugriffe auf das App-Repository verwendet.

## Hintergrund

Die App ist ein Client des persönlichen Developer-Wikis. Sie übernimmt die mobile Erfassung und GitHub-Interaktion; Importlogik, Archivierung und Wissensaufbereitung verbleiben im Wiki-Repository.

Der aktuelle Funktionsumfang umfasst unter anderem:

- dynamisch aus dem Wiki geladene Quellenarten mit Pflichtfeldern, Auswahlwerten, Titelpräfixen und Promptergänzungen,
- GitHub-kompatible Markdown-Issue-Beschreibungen,
- Erstellung von Issues mit dem Label `quelle`,
- Prüfung der Wiki-Verbindung und des PAT,
- Start und Statusabfrage des konfigurierten GitHub-Actions-Workflows,
- geschützte lokale Speicherung der Konfiguration,
- lokale Bild- und PDF-Quellen mit kontrolliertem GitHub-Attachment-Ablauf,
- Android-Share mit getrennten Zielen für Links, Text, Bilder und PDF-Dokumente als zusätzlicher Einstieg in dieselbe Quellenerfassung,
- appweites Menü mit About, installierter Releaseversion, offline verfügbarer Barrierefreiheitserklärung und kontextbezogenem Bugreport,
- feldnahe Validierungsfehler mit zusätzlichem Fehlersammler sowie barrierefreie Restzeichenzähler an allen Texteingaben.

Die App lädt den versionierten Quellen-Erfassungsvertrag aus dem konfigurierten Developer-Wiki und hält den letzten kompatiblen Stand repositorybezogen im geschützten Cache. Kann weder Remote-Vertrag noch Cache verwendet werden, steht ein klar gekennzeichneter gebündelter Rückfallstand zur Verfügung. Unbekannte Feldarten oder erforderliche Fähigkeiten werden nicht stillschweigend als Textfelder interpretiert.

## Installation

Vorausgesetzt werden Flutter mit passender Android-Toolchain sowie ein Android-Gerät oder Emulator. Der aktuell vorgesehene lokale Toolchain-Stand einschließlich Flutter-, JDK-, Android-Studio-, Gradle-, AGP- und Kotlin-Konfiguration ist in [Entwicklungsumgebung und Android-Toolchain](docs/development-environment.md) dokumentiert.

Repository klonen und Abhängigkeiten laden:

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

Beim ersten Start das Ziel-Wiki, das Fine-grained PAT und den per `workflow_dispatch` startbaren Import-Workflow konfigurieren. Die vollständige Schrittfolge steht im [Benutzerhandbuch](docs/benutzerhandbuch/index.md) und in der [PAT-Einrichtung](docs/pat-setup.md).

Danach können Links, Texte, Bilder und Dokumente manuell oder über Android-Teilen erfasst werden. Bild- und Dokumentquellen verwenden einen zweistufigen Pending-Attachment-Ablauf: Das Issue bleibt zunächst ohne `quelle`, bis das Attachment auf GitHub ergänzt, in der App geprüft und der finale Issue-Inhalt bestätigt wurde.

## Dokumentation

**Für die Bedienung der App:** [Benutzerhandbuch – typische End-to-End-Szenarien](docs/benutzerhandbuch/index.md)

Die weiterführende Projektdokumentation liegt unter [`docs/`](docs/README.md):

- [Ersteinrichtung und Fine-grained PAT](docs/pat-setup.md)
- [Dokument-Quellen und PDF-Attachments](docs/document-sources.md)
- [Android-Share-Ziele](docs/share-targets.md)
- [Bild-Quellen und GitHub-Attachments](docs/image-sources.md)
- [Architektur nach dem C4-Modell](docs/architecture.md)
- [Barrierefreiheit und UX](docs/accessibility.md)
- [App-Logo und Launcher-Icons](docs/app-icon.md)
- [Entwicklungsumgebung und Android-Toolchain](docs/development-environment.md)
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

Die verbindlichen Arbeits-, Architektur-, Test- und Dokumentationsregeln für Implementierungen stehen in [`AGENTS.md`](AGENTS.md). Den reproduzierbaren lokalen Toolchain-Stand und die Upgrade-Schritte beschreibt [`docs/development-environment.md`](docs/development-environment.md).

## Android-Release

Veröffentlichte APKs werden über den manuell startbaren GitHub-Actions-Workflow **Android Release APK** mit einem stabilen Keystore signiert. Der Workflow prüft Version, Analyse und Tests, erzeugt APK und SHA-256-Prüfsumme und veröffentlicht beides als GitHub Release.

Die vollständige Einrichtung des Keystores, die vier benötigten GitHub Actions Secrets und die Ausführung des Workflows sind in der [Android-Release-Dokumentation](docs/android-release.md) beschrieben.

## Mitwirken

Fragen und Fehler können über die [GitHub Issues](https://github.com/Huluvu424242/developer-wiki-app/issues) eingebracht werden. Pull Requests sind willkommen, sollen sich auf ein klar abgegrenztes Issue bzw. eine Story beziehen und die Regeln aus [`AGENTS.md`](AGENTS.md) einhalten.

Insbesondere müssen relevante Tests sowie `flutter analyze` erfolgreich sein. Bei Source-Änderungen ist außerdem zu prüfen, ob `CHANGELOG.md`, `README.md`, Dateien unter `docs/` oder Architekturdiagramme aktualisiert werden müssen.

## Lizenz

MIT © 2026 Thomas Schubert. Siehe [LICENSE](LICENSE). Herkunft und abweichende
Lizenzen des App-Logos sowie verwendeter Open-Source-Komponenten stehen in
[ATTRIBUTIONS.md](ATTRIBUTIONS.md).
