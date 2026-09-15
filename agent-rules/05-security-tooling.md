# Sicherheit und Werkzeugketten

Dieses Modul regelt GitHub Actions, CI/CD-Pipelines, Bots, externe Runner und vergleichbare ausführbare Werkzeugketten. Es ergänzt die allgemeinen Sicherheitsregeln und schwächt sie nicht ab.

## Default-Deny und Erlaubnisvorbehalt

- Es gilt Default-Deny: Eine Werkzeugkette darf nicht eigenmächtig erstellt, verändert, aktiviert, deaktiviert, manuell gestartet, erneut ausgeführt, abgebrochen, geplant oder als Ersatz für fehlende lokale Werkzeuge verwendet werden.
- Eine Nutzung oder Änderung ist nur zulässig, wenn der konkrete Vorgang bereits durch dieses Freigabeverzeichnis oder einen spezielleren ausdrücklich genehmigten Vertrag gedeckt ist oder der Repository-Owner vorher eine konkrete ausdrückliche Erlaubnis erteilt hat.
- Ausnahme für ausdrücklich als KI-Agenten-Werkzeugketten gekennzeichnete GitHub Actions: Workflows unter `.github/workflows/`, deren Dateiname mit `kiagent-` beginnt und deren YAML-`name` ebenfalls mit `kiagent-` beginnt, sind für den KI-Agenten zur bestimmungsgemäßen Ausführung freigegeben.
- Diese `kiagent-*`-Freigabe umfasst automatische Ausführungen über die im Workflow definierten Trigger sowie, falls im Workflow vorgesehen, manuelle Starts und Wiederholungen durch den KI-Agenten. Sie gilt auch für die technische Validierung eines neuen oder geänderten `kiagent-*`-Workflows auf seinem Werkzeugketten-PR-Branch; dies ersetzt niemals die verpflichtende menschliche PR-Prüfung vor dem Merge.
- Die Freigabe erteilt keine darüber hinausgehenden Rechte zum Ändern von Repository-Settings, Secrets, Variablen, Rulesets oder Berechtigungen.
- Die Freigabe eines `kiagent-*`-Workflows gilt nur für den jeweils im Repository beziehungsweise auf dem zugehörigen Werkzeugketten-PR-Branch vorhandenen Workflowstand und dessen dokumentierten Zweck, Trigger, Berechtigungen, Inputs, Secrets/Variablen, Datenzugriffe, externen Actions/Tools, Runner, Outputs und schreibende Wirkungen.
- Workflows ohne `kiagent-`-Präfix bleiben vollständig dem Default-Deny unterworfen, sofern sie nicht an anderer Stelle ausdrücklich freigegeben sind.
- Ein vorhandener Workflow, ein sichtbarer `Run workflow`-Button, vorhandene Secrets, technische Connector-Berechtigungen, eine allgemeine Umsetzungsbeauftragung, eine frühere Freigabe für einen anderen Lauf oder Schweigen sind außerhalb der ausdrücklich dokumentierten Freigaben keine Erlaubnis.
- Reines Lesen von Workflow-Dateien, Statusinformationen und vorhandenen Logs ist zulässig, sofern dadurch kein Lauf ausgelöst, kein Zustand verändert und kein Secret offengelegt wird.
- Fehlt ein erlaubtes Werkzeug, bleibt die technische Prüfung offen. Es wird keine Ersatz-Action oder externe Pipeline eigenmächtig aufgebaut; der Status lautet entsprechend den Workflow-Regeln `Implementiert, technische Prüfung ausstehend`.

## Triggerprüfung vor schreibenden GitHub-Operationen

- Vor jeder schreibenden Repository-Operation wird geprüft, welche vorhandenen Workflows, Bots oder Folgeaktionen dadurch automatisch ausgelöst werden können.
- Insbesondere sind Pushes, Pull Requests, Reopen/Close, Labels, Kommentare, Tags, Releases, Issue-/PR-Ereignisse und sonstige konfigurierte Trigger zu berücksichtigen.
- Würde eine Schreiboperation einen nicht freigegebenen Workflow auslösen, wird die betroffene Operation vor Ausführung angehalten und eine ausdrückliche Erlaubnis eingeholt.
- Automatische Trigger von `kiagent-*`-Workflows gelten innerhalb ihrer dokumentierten Konfiguration als freigegeben und dürfen bestimmungsgemäß ausgelöst werden.
- Automatische Trigger, die im Freigabeverzeichnis für andere dokumentierte Workflowstände ausdrücklich freigegeben sind, dürfen ebenfalls bestimmungsgemäß ausgelöst werden.
- Erwartete Folgeaktionen werden im Arbeits- oder PR-Bericht benannt, wenn sie für Berechtigungen, Kosten, externe Datenflüsse oder Schreibwirkungen relevant sind.

## Neue oder geänderte Werkzeugketten

Jede neue oder geänderte ausführbare Werkzeugkette benötigt vor der Implementierung grundsätzlich eine eigene Story und einen separaten Pull Request. Eine Werkzeugkettenänderung wird nicht in einem fachlich unabhängigen Feature- oder Bug-PR versteckt.

Für GitHub-Actions-Workflows gilt zusätzlich zwingend:

- Neue Workflow-Dateien dürfen ausschließlich auf einem Arbeitsbranch erstellt und über einen Pull Request gegen den geschützten Zielbranch eingebracht werden.
- Bestehende Workflow-Dateien dürfen ebenfalls nur über einen eigenen Werkzeugketten-PR geändert werden.
- Jeder PR, der eine GitHub Action neu erstellt oder verändert, muss vor dem Merge von einem Menschen geprüft werden. Diese Prüfung muss als ausdrückliche menschliche Review-/Freigabeentscheidung erkennbar sein; ein bloß fehlender Widerspruch genügt nicht.
- Der KI-Agent darf einen solchen PR weder selbst freigeben noch selbst mergen noch per Auto-Merge zum selbständigen Merge vormerken.
- Eine KI-Agenten-Bewertung, ein erfolgreicher CI-Lauf oder das Fehlen von Review-Kommentaren ersetzt die menschliche Prüfung nicht.
- Das Präfix `kiagent-` hebt diese Reviewpflicht nicht auf. Es kennzeichnet ausschließlich Workflows, deren bestimmungsgemäße Ausführung durch den KI-Agenten erlaubt ist.
- Neue oder geänderte `kiagent-*`-Workflows dürfen auf ihrem PR-Branch für technische Prüfungen bestimmungsgemäß laufen beziehungsweise vom KI-Agenten gestartet oder wiederholt werden, sofern der Workflow dies vorsieht. Ein erfolgreicher Lauf gibt dem KI-Agenten weiterhin keinerlei Merge-Recht.
- Nach menschlicher Prüfung und Merge bleibt die `kiagent-*`-Ausführungsfreigabe für den gemergten Workflowstand bestehen. Änderungen an diesem Workflow erfordern erneut den vollständigen Story-/PR-/Human-Review-Prozess.

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

## Merge und Ausführungsfreigabe

Für nicht als `kiagent-*` gekennzeichnete Werkzeugketten gilt weiterhin:

**Story → separater Werkzeugketten-PR → menschliche Prüfung/Merge → ausdrückliche Erst- oder Dauerfreigabe → produktive Verwendung**

Für `kiagent-*`-Workflows gilt:

**Story → separater Werkzeugketten-PR → technische Ausführung im PR erlaubt → verpflichtende menschliche Prüfung → Merge durch einen Menschen → weitere Ausführung gemäß gemergter Workflow-Konfiguration**

- Der Merge einer neuen oder geänderten Werkzeugkette ohne `kiagent-`-Freigabe erteilt nicht automatisch die Erlaubnis zu ihrer erstmaligen produktiven Ausführung.
- Bei `kiagent-*`-Workflows ergibt sich die Ausführungsfreigabe aus der reservierten Kennzeichnung; die menschliche Prüfung ist unabhängig davon zwingendes Merge-Gate.
- Eine dauerhafte Freigabe gilt nur für den dokumentierten Stand, Zweck, Triggerumfang, Berechtigungen, Secrets/Variablen, Datenzugriffe, externen Actions/Tools, Runner, Inputs, Outputs, Artefakte und schreibenden Wirkungen.
- Ändert sich eines dieser Gültigkeitsmerkmale, muss die Änderung erneut über Story, separaten PR und menschliche Prüfung laufen.
- Das Freigabeverzeichnis beschreibt erteilte Freigaben; seine bloße Änderung darf außerhalb der ausdrücklich definierten `kiagent-*`-Regel nicht als implizite Freigabe interpretiert werden.

## GitHub-Settings und Secrets

- Repository-Settings, Secrets, Variablen, Branchregeln, Rulesets und Berechtigungen werden nicht eigenmächtig geändert.
- Eine Codeänderung an einer Workflow-Datei bedeutet nicht, dass zugehörige Settings oder Secrets bereits eingerichtet oder geändert wurden.
- Workflows erhalten explizite minimale `permissions`.
- Secrets werden nur den Schritten bereitgestellt, die sie tatsächlich benötigen, niemals protokolliert oder in Artefakte geschrieben und nicht unnötig an Fork- oder andere nicht vertrauenswürdige Kontexte weitergegeben.
- Signierschlüssel und Keystore-Inhalte verbleiben ausschließlich in dafür vorgesehenen sicheren Secret Stores.

## Freigabeverzeichnis

### Pauschalfreigabe für KI-Agenten-Workflows: `kiagent-*`

- **Namenskonvention:** Workflow-Datei unter `.github/workflows/` beginnt mit `kiagent-`; der YAML-Anzeigename `name:` beginnt ebenfalls exakt mit `kiagent-`.
- **Freigabestatus:** bestimmungsgemäße Ausführung durch den KI-Agenten erlaubt.
- **Umfang:** automatische Trigger sowie vorhandene manuelle Start-/Wiederholungsmöglichkeiten innerhalb der jeweiligen Workflow-Konfiguration; dies umfasst auch technische Validierungsläufe auf dem zugehörigen Werkzeugketten-PR-Branch.
- **Voraussetzung für neue oder geänderte Workflows:** eigene Story, separater Werkzeugketten-PR und zwingende menschliche Prüfung vor Merge.
- **Merge:** Der KI-Agent darf Workflow-PRs nicht selbst freigeben, mergen oder Auto-Merge aktivieren.
- **Änderungsgrenze:** Jede Änderung an Workflow-Datei, Triggern, Berechtigungen, Inputs, Secrets/Variablen, Datenzugriffen, externen Diensten, Actions/Tools, Runnern, Outputs, Artefakten oder schreibenden Wirkungen erfordert erneut einen menschlich geprüften Werkzeugketten-PR.
- **Keine impliziten Zusatzrechte:** Die `kiagent-*`-Freigabe ändert keine Repository-Settings, Secrets, Rulesets oder Branch-Protection und erlaubt deren Änderung nicht.

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
- Für `kiagent-*`-Workflows erfolgt diese Neubewertung zwingend über eine Story, einen separaten PR und menschliche Prüfung vor dem Merge.
- Nicht nachweisbar erteilte Freigaben dürfen nicht durch Dokumentation erfunden oder rückwirkend angenommen werden.
