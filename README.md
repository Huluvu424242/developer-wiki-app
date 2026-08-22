# Developer Wiki Source Capture

Flutter-App für Android, mit der die vier Quellen-Issue-Formulare des privaten Repositories `Huluvu424242/Developer-Wiki` mobil erfasst werden können.

## Funktionsumfang

- vier Quelltypen entsprechend dem Stand der GitHub-Issue-Templates vom 16.08.2026
- gleiche Pflichtfelder, Auswahlwerte, Titelpräfixe und Promptergänzungen
- Erzeugung einer GitHub-kompatiblen Markdown-Issue-Beschreibung
- Erstellung des Issues über die GitHub REST API mit Label `quelle`
- Prüfung des PAT gegen `/user`
- verschlüsselte Speicherung über Android EncryptedSharedPreferences/Keystore
- keine Telemetrie und kein eigener Server

## PAT einrichten

Auf GitHub ein **Fine-grained personal access token** erstellen, nur für das Repository `Developer-Wiki`. Als Repository-Berechtigung genügt **Issues: Read and write**. Das Token ausschließlich in den App-Einstellungen eingeben; niemals in Quellcode, Screenshots oder Issues ablegen.

## Starten

Flutter installieren, einmal die versionspassenden Android-Wrapperdateien ergänzen,
ein Android-Gerät oder einen Emulator verbinden und ausführen:

```bash
flutter create . --platforms android --org de.huluvu
flutter pub get
flutter run
```

`flutter create` ergänzt nur generierte Plattformdateien. Vor dem Commit sollte
der Diff geprüft werden, damit die bewusst gesetzte Paket-ID erhalten bleibt.

Tests:

```bash
flutter test
```

Release-APK:

```bash
flutter build apk --release
```

Für veröffentlichte APKs sollte die unten beschriebene stabile Android-Signatur verwendet werden.

## Android-Release per GitHub Actions

Für reproduzierbare, installierbare APKs gibt es den manuell startbaren Workflow **Android Release APK** unter `.github/workflows/android-release.yml`.

Der Workflow:

- prüft, dass `release_version` exakt der Version in `pubspec.yaml` entspricht,
- führt `flutter analyze` und `flutter test` aus,
- lädt einen stabilen Android-Keystore ausschließlich aus GitHub Actions Secrets,
- baut eine signierte Release-APK,
- erzeugt eine SHA-256-Prüfsumme,
- veröffentlicht APK und Prüfsumme als GitHub Release `v<release_version>`.

### Warum ein stabiler Keystore notwendig ist

Android-APKs müssen signiert sein. Für spätere Updates muss außerdem immer derselbe Signaturschlüssel verwendet werden. Der private Keystore darf deshalb nicht in das Repository eingecheckt werden, sondern wird GitHub Actions verschlüsselt als Secret bereitgestellt.

Wenn bereits eine APK mit einem anderen Schlüssel installiert wurde, kann Android das Update verweigern. In diesem Fall muss die alte Installation einmalig deinstalliert werden. Danach funktionieren Updates, solange derselbe Release-Keystore weiterverwendet wird.

### Keystore unter Windows/PowerShell erzeugen

Beispiel:

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

### Benötigte GitHub Actions Secrets

Unter **Settings → Secrets and variables → Actions → New repository secret** folgende Secrets anlegen:

- `ANDROID_KEYSTORE_BASE64`: Base64-Inhalt der `.jks`-Datei
- `ANDROID_KEYSTORE_PASSWORD`: Passwort des Keystores
- `ANDROID_KEY_ALIAS`: Alias, z. B. `developer-wiki-app`
- `ANDROID_KEY_PASSWORD`: Passwort des Schlüssels

### Release ausführen

1. `pubspec.yaml` auf eine neue Version im Format `MAJOR.MINOR.PATCH+BUILD` setzen, z. B. `0.1.1+2`.
2. Änderung mergen.
3. In GitHub **Actions → Android Release APK → Run workflow** öffnen.
4. `release_version` exakt wie in `pubspec.yaml` eintragen.
5. Optional Release Notes in Markdown erfassen.
6. Workflow starten.
7. Nach erfolgreichem Lauf das erzeugte GitHub Release öffnen und die APK herunterladen.

Die Gradle-Konfiguration liest die Signing-Daten nur aus Umgebungsvariablen bzw. Gradle-Properties. Lokale Release-Builds ohne diese Werte behalten die Debug-Signatur als Fallback; veröffentlichte Builds über GitHub Actions verwenden dagegen zwingend den stabilen Release-Keystore.

## Architekturentscheidung

Die Formulare sind derzeit versioniert in `lib/models/source_template.dart` enthalten. Das macht die App offline startbar und verhindert, dass ein kompromittiertes Template ungeprüft UI und Request-Inhalt verändert. Bei Änderungen an den GitHub-Templates müssen die Definitionen bewusst synchronisiert und getestet werden. Eine spätere Version kann Templates lesend von GitHub laden und eine geprüfte lokale Fallback-Version behalten.
