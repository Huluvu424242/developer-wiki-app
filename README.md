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

Vor einer Veröffentlichung muss eine eigene Android-Signatur konfiguriert werden.

## Architekturentscheidung

Die Formulare sind derzeit versioniert in `lib/models/source_template.dart` enthalten. Das macht die App offline startbar und verhindert, dass ein kompromittiertes Template ungeprüft UI und Request-Inhalt verändert. Bei Änderungen an den GitHub-Templates müssen die Definitionen bewusst synchronisiert und getestet werden. Eine spätere Version kann Templates lesend von GitHub laden und eine geprüfte lokale Fallback-Version behalten.
