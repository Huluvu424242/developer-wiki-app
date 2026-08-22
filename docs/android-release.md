# Android-Release

Für reproduzierbare, installierbare APKs gibt es den manuell startbaren Workflow **Android Release APK** unter `.github/workflows/android-release.yml`.

Der Workflow:

- prüft, dass `release_version` exakt der Version in `pubspec.yaml` entspricht,
- führt `flutter analyze` und `flutter test` aus,
- lädt einen stabilen Android-Keystore ausschließlich aus GitHub Actions Secrets,
- baut eine signierte Release-APK,
- erzeugt eine SHA-256-Prüfsumme,
- veröffentlicht APK und Prüfsumme als GitHub Release `v<release_version>`.

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

Die Gradle-Konfiguration liest die Signing-Daten nur aus Umgebungsvariablen bzw. Gradle-Properties. Lokale Release-Builds ohne diese Werte behalten die Debug-Signatur als Fallback; veröffentlichte Builds über GitHub Actions verwenden dagegen zwingend den stabilen Release-Keystore.
