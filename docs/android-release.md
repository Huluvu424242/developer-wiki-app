# Android-Release

Für reproduzierbare, installierbare APKs gibt es den manuell startbaren Workflow **Android Release APK** unter `.github/workflows/android-release.yml`.

Der Workflow:

- prüft, dass `release_version` exakt der Version in `pubspec.yaml` entspricht,
- führt `flutter analyze` und `flutter test` aus,
- lädt einen stabilen Android-Keystore ausschließlich aus GitHub Actions Secrets,
- baut eine signierte Release-APK,
- erzeugt eine SHA-256-Prüfsumme,
- veröffentlicht APK und Prüfsumme als GitHub Release `v<release_version>`.

## Supply-Chain-Härtung des Workflows

Externe GitHub Actions werden im produktiven Release-Workflow nicht über bewegliche Major-Tags, sondern über unveränderliche Commit-SHAs referenziert. Ein lesbarer Versionshinweis bleibt jeweils als Kommentar direkt neben dem SHA erhalten. Dadurch kann ein bereits geprüfter Workflow nicht allein durch das Verschieben eines fremden Tags anderen Action-Code ausführen.

Stand der Prüfung vom 15.09.2026:

| Action | Herkunft und Wartungszustand | Gepinnter Stand | Lizenz |
| --- | --- | --- | --- |
| `actions/checkout` | Offizielle GitHub-Action aus der Organisation `actions`; v6 wird weiterhin gepflegt. | `d23441a48e516b6c34aea4fa41551a30e30af803` (`v6.1.0`) | MIT |
| `actions/setup-java` | Offizielle GitHub-Action aus der Organisation `actions`; der v5-Zweig wurde 2026 weiterhin gepflegt. | `b6effb05e454b25005698d916606bdc6ffcbf961` (`v5`, Major-Tag-Stand am 15.09.2026) | MIT |
| `subosito/flutter-action` | Öffentliches Community-Projekt; laut Projektbeschreibung aktiv von Bartek Pacia gepflegt und mit aktuellen v2-Releases. | `1a449444c387b1966244ae4d4f8c696479add0b2` (`v2.23.0`) | MIT |

Die Commit-SHAs wurden gegen die jeweiligen GitHub-Tag-Referenzen geprüft. Bei einer späteren Aktualisierung wird nicht nur der Kommentar geändert: Der neue Commit-SHA wird erneut auf Herkunft, Wartungszustand, Lizenz und den erwarteten Versionsstand geprüft und über den vorgeschriebenen Werkzeugketten-PR eingebracht.

### Bewusst verbleibende bewegliche Bestandteile

Das SHA-Pinning der Actions macht den Release nicht vollständig bitgenau reproduzierbar. Folgende Bestandteile bleiben bewusst beweglich:

- `runs-on: ubuntu-latest` folgt dem von GitHub bereitgestellten aktuellen Ubuntu-Runner-Image. Eine Umstellung auf ein anderes Runner-Label würde die Buildumgebung ändern und ist für das reine Action-Pinning nicht erforderlich.
- `channel: stable` in `subosito/flutter-action` installiert den zum Ausführungszeitpunkt aktuellen stabilen Flutter-Stand. Eine exakte Flutter-Version ist derzeit keine zentrale Projektvorgabe; ein Pin würde daher eine zusätzliche Versionspolitik einführen.
- `java-version: "21"` mit Temurin kann innerhalb der Java-21-Linie neuere Patchstände auflösen. Der Major-Release bleibt fest, der konkrete JDK-Patchstand nicht.
- Vorinstallierte Runner-Werkzeuge wie Git und GitHub CLI können sich mit dem GitHub-Runner-Image ändern.

Diese Restbeweglichkeit wird für Story #147 akzeptiert, weil die Story die Supply-Chain-Grenze der **externen GitHub Actions** härtet, ohne Runner-, Flutter- oder JDK-Versionspolitik und damit das fachliche Releaseverhalten gleichzeitig umzubauen. Soll der Build später stärker reproduzierbar werden, ist dafür eine eigene Werkzeugketten-Story mit Kompatibilitätsprüfung sinnvoll.

### Unveränderte Sicherheitsgrenzen

Durch das SHA-Pinning ändern sich nicht:

- Trigger: ausschließlich `workflow_dispatch`;
- Berechtigung: weiterhin `contents: write`;
- Inputs: `release_version` und optional `release_notes`;
- Secret-Namen und deren Verwendung;
- Checkout mit `fetch-depth: 0`;
- Analyse-, Test-, Build- und Signierschritte;
- Release-Artefakte APK und SHA-256-Datei;
- schreibende Wirkung: Erzeugen von Tag und GitHub Release über `gh release create`.

Der Workflow bleibt **nicht** zur selbständigen Ausführung durch den KI-Agenten freigegeben. Ein Merge einer Workflowänderung ist keine produktive Ausführungsfreigabe. Vor der erstmaligen produktiven Nutzung eines geänderten Workflowstands ist gemäß `agent-rules/05-security-tooling.md` eine ausdrückliche Owner-Freigabe erforderlich; erst danach darf der freigegebene Stand mit seiner Commit-/Blob-Identität im Freigabeverzeichnis als produktiv freigegeben dokumentiert werden.

## Warum ein stabiler Keystore notwendig ist

Android-APKs müssen signiert sein. Für spätere Updates muss außerdem immer derselbe Signaturschlüssel verwendet werden. Der private Keystore darf deshalb nicht in das Repository eingecheckt werden, sondern wird GitHub Actions verschlüsselt als Secret bereitgestellt.

Wenn bereits eine APK mit einem anderen Schlüssel installiert wurde, kann Android das Update verweigern. In diesem Fall muss die alte Installation einmalig deinstalliert werden. Danach funktionieren Updates, solange derselbe Release-Keystore weiterverwendet wird.

## Keystore unter Windows/PowerShell erzeugen

```powershell
keytool -genkeypair `
  -v `
  -keystore developer-wiki-app-release.jks `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias developer-wiki-app
```

Den Keystore danach als Base64-String für GitHub Actions kodieren:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("developer-wiki-app-release.jks")) | Set-Clipboard
```

Optional zusätzlich in eine Datei schreiben:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("developer-wiki-app-release.jks")) | Set-Content -NoNewline "developer-wiki-app-release.jks.base64.txt"
```

Die `.jks`-Datei und eine daraus erzeugte Base64-Datei dürfen nicht ins Repository eingecheckt werden. Der Keystore muss dauerhaft und sicher gesichert werden, weil spätere APK-Updates denselben Schlüssel benötigen.

## Benötigte GitHub Actions Secrets

Unter **Settings → Secrets and variables → Actions → New repository secret** werden folgende Repository-Secrets angelegt:

- `ANDROID_KEYSTORE_BASE64`: Base64-Inhalt der `.jks`-Datei
- `ANDROID_KEYSTORE_PASSWORD`: Passwort des Keystores
- `ANDROID_KEY_ALIAS`: Alias, z. B. `developer-wiki-app`
- `ANDROID_KEY_PASSWORD`: Passwort des Schlüssels

## Release ausführen

1. `pubspec.yaml` auf eine neue Version im Format `MAJOR.MINOR.PATCH+BUILD` setzen, z. B. `0.1.1+2`.
2. Änderung mergen.
3. In GitHub **Actions → Android Release APK → Run workflow** öffnen.
4. `release_version` exakt wie in `pubspec.yaml` eintragen.
5. Optional Release Notes in Markdown erfassen.
6. Workflow starten.
7. Nach erfolgreichem Lauf das erzeugte GitHub Release öffnen und die APK herunterladen.
8. Anschließend vom erzeugten Release-Tag den produktiven Release-Branch gemäß dem folgenden Abschnitt anlegen.

## Produktiver Release-Branch nach erfolgreichem Release

Nach einem erfolgreich gebauten und veröffentlichten Release wird vom zugehörigen Release-Tag ein eigener produktiver Wartungsbranch erstellt. Der Branchname folgt verbindlich dem Schema:

```text
release/<tagname>
```

Erzeugt der Workflow beispielsweise den Tag `v0.1.1+2`, wird daraus der Branch:

```text
release/v0.1.1+2
```

Der Branch muss **vom Release-Tag** und damit exakt von dem Commit ausgehen, aus dem die veröffentlichte APK gebaut wurde. Er darf nicht nachträglich vom aktuellen `master` erzeugt werden, wenn dieser bereits weitere Änderungen enthält.

Beispiel mit Git:

```powershell
git fetch origin --tags
git branch release/v0.1.1+2 v0.1.1+2
git push origin release/v0.1.1+2
```

Der Release-Branch repräsentiert ab diesem Zeitpunkt die produktiv eingesetzte Release-Linie. Für ihn gelten andere Änderungsregeln als für `master`:

- **Keine neuen Features:** Neue Funktionen und fachliche Erweiterungen werden ausschließlich auf Basis von `master` entwickelt und nicht auf einen bestehenden Release-Branch aufgenommen.
- **Bugfixes:** Fehler, die den produktiven Release betreffen, dürfen auf dem zugehörigen Release-Branch behoben werden.
- **Security Updates:** Sicherheitsrelevante Korrekturen und notwendige Dependency-Updates dürfen auf dem Release-Branch durchgeführt werden.
- **Lifecycle- und Wartungsmaßnahmen:** Technisch notwendige Anpassungen zur weiteren Betriebsfähigkeit, Kompatibilität oder Wartbarkeit des produktiven Releases sind zulässig, sofern sie keine neuen Features einführen.
- **Rückübernahme nach `master`:** Bugfixes, Security Updates und Lifecycle-Maßnahmen sollen, soweit sie für die aktuelle Weiterentwicklung noch relevant sind, auch auf `master` übernommen werden. Dadurch wird verhindert, dass ein bereits behobener Fehler in einer späteren Version erneut auftritt.

Änderungen an einem Release-Branch werden wie andere produktive Änderungen über einen Pull Request geprüft. Der Branch ist kein alternativer Entwicklungszweig, sondern ausschließlich eine stabilisierte Wartungslinie für den bereits veröffentlichten Stand.

Wenn für einen bestehenden Release-Branch ein korrigierter Build veröffentlicht werden muss, wird dessen Versionsnummer entsprechend erhöht und erneut über den vorgesehenen Release-Prozess gebaut. Für jeden neu veröffentlichten Release-Tag wird wiederum ein eigener `release/<tagname>`-Branch angelegt.

Die Gradle-Konfiguration liest die Signing-Daten nur aus Umgebungsvariablen bzw. Gradle-Properties. Lokale Release-Builds ohne diese Werte behalten die Debug-Signatur als Fallback; veröffentlichte Builds über GitHub Actions verwenden dagegen zwingend den stabilen Release-Keystore.
