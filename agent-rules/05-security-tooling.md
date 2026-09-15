# Sicherheit und Werkzeugketten

Dieses Modul regelt GitHub Actions, CI/CD-Pipelines, Bots, externe Runner und vergleichbare ausführbare Werkzeugketten. Es ergänzt die allgemeinen Sicherheitsregeln und schwächt sie nicht ab.

## Default-Deny und Erlaubnisvorbehalt

- Es gilt Default-Deny: Eine Werkzeugkette darf nicht eigenmächtig erstellt, verändert, aktiviert, deaktiviert, manuell gestartet, erneut ausgeführt, abgebrochen, geplant oder als Ersatz für fehlende lokale Werkzeuge verwendet werden.
- Eine Nutzung oder Änderung ist nur zulässig, wenn der konkrete Vorgang bereits durch dieses Freigabeverzeichnis oder einen spezielleren ausdrücklich genehmigten Vertrag gedeckt ist oder der Repository-Owner vorher eine konkrete ausdrückliche Erlaubnis erteilt hat.
- Ein vorhandener Workflow, ein sichtbarer `Run workflow`-Button, vorhandene Secrets, technische Connector-Berechtigungen, eine allgemeine Umsetzungsbeauftragung, eine frühere Freigabe für einen anderen Lauf oder Schweigen sind keine Erlaubnis.
- Reines Lesen von Workflow-Dateien, Statusinformationen und vorhandenen Logs ist zulässig, sofern dadurch kein Lauf ausgelöst, kein Zustand verändert und kein Secret offengelegt wird.
- Fehlt ein erlaubtes Werkzeug, bleibt die technische Prüfung offen. Es wird keine Ersatz-Action oder externe Pipeline eigenmächtig aufgebaut; der Status lautet entsprechend den Workflow-Regeln `Implementiert, technische Prüfung ausstehend`.

## Triggerprüfung vor schreibenden GitHub-Operationen

- Vor jeder schreibenden Repository-Operation wird geprüft, welche vorhandenen Workflows, Bots oder Folgeaktionen dadurch automatisch ausgelöst werden können.
- Insbesondere sind Pushes, Pull Requests, Reopen/Close, Labels, Kommentare, Tags, Releases, Issue-/PR-Ereignisse und sonstige konfigurierte Trigger zu berücksichtigen.
- Würde eine Schreiboperation einen nicht freigegebenen Workflow auslösen, wird die betroffene Operation vor Ausführung angehalten und eine ausdrückliche Erlaubnis eingeholt.
- Automatische Trigger, die im Freigabeverzeichnis für den dokumentierten Workflowstand ausdrücklich freigegeben sind, dürfen bestimmungsgemäß ausgelöst werden.
- Erwartete Folgeaktionen werden im Arbeits- oder PR-Bericht benannt, wenn sie für Berechtigungen, Kosten, externe Datenflüsse oder Schreibwirkungen relevant sind.

## Neue oder geänderte Werkzeugketten

Jede neue oder geänderte ausführbare Werkzeugkette benötigt vor der Implementierung grundsätzlich eine eigene Story und einen separaten Pull Request. Eine Werkzeugkettenänderung wird nicht in einem fachlich unabhängigen Feature- oder Bug-PR versteckt und im selben PR nicht bereits als dauerhaft freigegeben vorausgesetzt.

Die Story dokumentiert mindestens:

- Zweck und fachlichen Nutzen;
- Trigger und erlaubte Akteure beziehungsweise Nutzungsarten;
- minimale GitHub-`permissions`;
- Secrets und Variablen ausschließlich mit Namen, niemals mit Werten;
- Datenzugriffe, Datenflüsse und externe Dienste;
- externe Actions, Tools und Runner;
- Inputs und Outputs;
- Artefakte und Aufbewahrung;
- mögliche schreibende Wirkungen;
- Supply-Chain- und Lizenzaspekte;
- Kosten- und Laufzeitrisiken;
- Auditierbarkeit;
- Deaktivierung und Rollback.

Externe Actions werden vor Aufnahme auf Herkunft, Wartungszustand, Berechtigungen und Lizenz geprüft und soweit praktikabel auf unveränderliche Commit-SHAs gepinnt. Wird stattdessen ein beweglicher Versions-Tag verwendet, muss dies bewusst bewertet und dokumentiert werden.

## Merge ist keine Ausführungsfreigabe

Die verbindliche Reihenfolge lautet:

**Story → separater Werkzeugketten-PR → Review/Merge → ausdrückliche Erst- oder Dauerfreigabe → produktive Verwendung**

- Der Merge einer neuen oder geänderten Werkzeugkette erteilt nicht automatisch die Erlaubnis zu ihrer erstmaligen produktiven Ausführung.
- Eine dauerhafte Freigabe gilt nur für den dokumentierten Stand, Zweck, Triggerumfang, Berechtigungen, Secrets/Variablen, Datenzugriffe, externen Actions/Tools, Runner, Inputs, Outputs, Artefakte und schreibenden Wirkungen.
- Ändert sich eines dieser Gültigkeitsmerkmale, wird vor der nächsten entsprechenden produktiven Verwendung geprüft, ob eine neue ausdrückliche Freigabe erforderlich ist.
- Das Freigabeverzeichnis beschreibt erteilte Freigaben; seine bloße Änderung erteilt selbst keine Freigabe.

## GitHub-Settings und Secrets

- Repository-Settings, Secrets, Variablen, Branchregeln, Rulesets und Berechtigungen werden nicht eigenmächtig geändert.
- Eine Codeänderung an einer Workflow-Datei bedeutet nicht, dass zugehörige Settings oder Secrets bereits eingerichtet oder geändert wurden.
- Workflows erhalten explizite minimale `permissions`.
- Secrets werden nur den Schritten bereitgestellt, die sie tatsächlich benötigen, niemals protokolliert oder in Artefakte geschrieben und nicht unnötig an Fork- oder andere nicht vertrauenswürdige Kontexte weitergegeben.
- Signierschlüssel und Keystore-Inhalte verbleiben ausschließlich in dafür vorgesehenen sicheren Secret Stores.

## Freigabeverzeichnis

### Vorhanden, aber nicht zur selbständigen Agentenausführung freigegeben: Android Release APK

- **Repository:** `Huluvu424242/developer-wiki-app`
- **Workflow-Datei:** `.github/workflows/android-release.yml`
- **Anzeigename:** `Android Release APK`
- **Dokumentierter Stand:** Git-Blob-SHA `7fbc905b85ebd17aad70e6ac7e850b357d7ca91c`, inventarisiert auf `master`-Commit `a11f8630e27e9a222e80757b8684675ba8319e76`
- **Freigabestatus:** vorhanden, aber nicht zur selbständigen Agentenausführung freigegeben; weder manuelle Ausführung noch Wiederholung fehlgeschlagener Läufe ist durch dieses Verzeichnis erlaubt
- **Trigger:** ausschließlich `workflow_dispatch`; keine automatische Ausführung durch Push, Pull Request, Label, Issue, Tag oder Release
- **Inputs:** Pflichtfeld `release_version`; optionales Markdown-Feld `release_notes`
- **Berechtigungen:** `contents: write`
- **Runner:** `ubuntu-latest`
- **Concurrency:** Gruppe `android-release-${{ inputs.release_version }}`; `cancel-in-progress: false`
- **Repository-/Datenzugriffe:** vollständiger Checkout mit `fetch-depth: 0`; Projektabhängigkeiten über `flutter pub get`; Zugriff auf Buildausgaben sowie GitHub-Tag-/Releasebereich
- **Secret-Namen:** `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`; zusätzlich wird für die Release-Veröffentlichung das eingebaute `github.token` als `GH_TOKEN` verwendet
- **Externe Actions:** `actions/checkout@v6`, `actions/setup-java@v5`, `subosito/flutter-action@v2`
- **Build-/Prüfschritte:** Version aus `pubspec.yaml` gegen `release_version` prüfen, vorhandenen Tag ausschließen, Java 21/Temurin und Flutter stable einrichten, `flutter pub get`, `flutter analyze`, `flutter test`, Keystore decodieren, signierte APK bauen, Release-Dateien vorbereiten und SHA-256-Prüfsumme erzeugen
- **Outputs:** `developer-wiki-app-<release_version>.apk`, zugehörige `.sha256`-Datei und Release Notes; diese werden als Bestandteile des GitHub Release veröffentlicht, nicht als GitHub-Actions-Artefakt mit eigener Retention
- **Schreibwirkungen:** `gh release create` erstellt den Tag `v<release_version>`, veröffentlicht das GitHub Release mit APK und Prüfsumme und markiert es mit `--latest`
- **Gültigkeitsgrenze:** Inventar und Sicherheitsbewertung des aktuellen Workflows; keine Agentenfreigabe, keine Settings-/Secret-Änderung und keine Freigabe für geänderte Workflowstände
- **Supply-Chain-Hinweis:** Die externen Actions werden aktuell über bewegliche Major-Tags referenziert. Eine Härtung auf unveränderliche Commit-SHAs ist sinnvoll, aber nicht Bestandteil dieser Story und benötigt eine eigene Werkzeugketten-Story und einen separaten PR.

## Änderungen am Freigabeverzeichnis

- Eine dokumentierte Freigabe gilt nur innerhalb ihrer ausdrücklich beschriebenen Gültigkeitsgrenzen.
- Änderungen an Workflow-Datei, externer Action oder deren Commit-SHA, Triggern, Berechtigungen, Secrets/Variablen, Datenzugriffen, externen Diensten, Runnern, Inputs, Outputs, Artefakten, schreibenden Wirkungen oder Zweck werden vor weiterer produktiver Verwendung neu bewertet.
- Nicht nachweisbar erteilte Freigaben dürfen nicht durch Dokumentation erfunden oder rückwirkend angenommen werden.
