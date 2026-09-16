# Entwicklungsumgebung und Android-Toolchain

Diese Datei beschreibt den für die Developer-Wiki-App vorgesehenen Entwicklungsstand. Die im Repository versionierten Gradle-/AGP-/Kotlin-Versionen sind die technische Referenz; lokale Werkzeuge sollen dazu kompatibel sein.

## Referenzstand

Stand: 2026-09-16

| Komponente | Projektstand | Hinweis |
| --- | --- | --- |
| Flutter | `3.47.4` stable | entspricht der `kiagent-flutter-validation` |
| Dart | mit Flutter 3.47.4 ausgeliefert | nicht separat installieren |
| Android Studio | Quail 4 / `2026.1.4` stable oder kompatibler neuerer Stable-Stand | IDE ist nicht Teil des Buildscripts |
| JDK | `21` für Entwicklung und Release | Android-Quell-/Bytecode-Ziel der App bleibt Java 17 |
| Android SDK | Platform 36 | `compileSdk = 36`, `targetSdk = 36`, `minSdk = 24` |
| Android Gradle Plugin | `9.1.0` | aktueller Flutter-3.47.4-Templatewert |
| Gradle | `9.3.1` | aktueller Flutter-3.47.4-Templatewert |
| Kotlin Gradle Plugin | `2.4.0` | aktueller Flutter-3.47.4-Templatewert |
| flutter_secure_storage | `10.3.1` | Android-Teil auf Java 17; bewusster Migrationsschritt von 9.x vor einem späteren 11.x-Upgrade |

Flutter 3.47.4 erzeugt für AGP 9 derzeit weiterhin die Kompatibilitätsflags `android.newDsl=false` und `android.builtInKotlin=false`. Das ist bewusst: Die Stable-Templates deklarieren KGP 2.4.0 und verwenden vorerst noch die Legacy-Kompatibilitätsbrücken.

## Android-Konfiguration

In `android/settings.gradle.kts` werden AGP und KGP entsprechend dem Flutter-3.47.4-Template versioniert:

```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
}
```

In `android/gradle.properties` bleiben die von Flutter 3.47.4 vorgesehenen Übergangsflags aktiv:

```properties
android.newDsl=false
android.builtInKotlin=false
```

Die App selbst verwendet die moderne Kotlin-Compilerkonfiguration und Android API 24 bis 36 als unterstützten Bereich:

```kotlin
android {
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        minSdk = 24
        targetSdk = 36
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
```

`minSdk = 24` folgt dem Flutter-3.47.4-Referenzstand und beseitigt die Lifecycle-Warnung für API 23. `targetSdk = 36` gleicht das Laufzeit-Ziel an die verwendete Android-36-Toolchain an.

## Secure-Storage-Migration von 9.x auf 10.x

`flutter_secure_storage` wird bewusst zunächst auf `10.3.1` und nicht direkt auf 11.x aktualisiert. Version 10 migriert Android von der veralteten Jetpack-Security-Implementierung auf die aktuelle Cipher-Implementierung und verwendet seit 10.1.0 Java 17. Der Hersteller verlangt für Daten aus Versionen vor v10 ausdrücklich diesen Zwischenschritt, bevor auf 11.x gewechselt wird.

Die App hatte unter 9.x `encryptedSharedPreferences: true` verwendet. Für 10.x wird die veraltete Option entfernt und die vorgesehene Migration explizit aktiviert:

```dart
const FlutterSecureStorage(
  aOptions: AndroidOptions(
    migrateOnAlgorithmChange: true,
    migrateWithBackup: true,
  ),
)
```

Damit sollen insbesondere der lokal gespeicherte GitHub-PAT und die Wiki-Konfiguration beim Upgrade erhalten bleiben. Ein späteres Upgrade auf 11.x ist eine eigene Lifecycle-Änderung und darf erst erfolgen, nachdem eine ausgelieferte 10.x-Version die Bestandsdaten migrieren konnte.

## Windows: lokale Umgebung aktualisieren

### 1. Android Studio und SDK

Android Studio auf einen aktuellen Stable-Stand bringen. Im SDK Manager mindestens Android SDK Platform 36, aktuelle Platform Tools, aktuelle Command-line Tools und bei Bedarf ein Emulator-System-Image installieren.

### 2. Flutter auf Stable 3.47.4 bringen

```powershell
flutter channel stable
flutter upgrade
flutter --version
```

Für diesen Projektstand soll `flutter --version` Flutter `3.47.4` melden.

### 3. JDK 21 verwenden

```powershell
flutter doctor -v
java -version
```

Für dieses Projekt soll die Build-JVM JDK 21 sein. Falls Flutter eine andere JDK-Installation verwendet:

```powershell
flutter config --jdk-dir="C:\Pfad\zu\jdk-21"
```

In Android Studio unter `Settings > Build, Execution, Deployment > Build Tools > Gradle` ebenfalls JDK 21 auswählen.

### 4. Projekt neu einlesen und prüfen

Nach jeder Änderung an `pubspec.yaml` zuerst die Abhängigkeiten samt Lockfile aktualisieren:

```powershell
flutter clean
flutter pub get
flutter doctor -v
flutter analyze --suggestions
flutter analyze
flutter test
```

Danach:

```powershell
cd android
.\gradlew.bat --version
.\gradlew.bat assembleDebug
cd ..
```

`gradlew.bat --version` soll Gradle `9.3.1` und JDK 21 melden. AGP und KGP werden nicht separat lokal installiert; ihre Versionen kommen aus `android/settings.gradle.kts`.

### 5. Android-Lauf und Secure-Storage-Migration prüfen

```powershell
flutter devices
flutter run
```

Für eine bestehende Installation mit gespeicherter Konfiguration muss nach dem Upgrade zusätzlich geprüft werden, dass Repository-URL, Workflow-Datei und insbesondere der gespeicherte PAT weiterhin lesbar sind. Die App soll dafür nicht vor dem Test deinstalliert oder ihre Daten gelöscht werden, weil sonst gerade der Migrationspfad nicht geprüft würde.

Ein erfolgreicher Gradle-Sync, `assembleDebug`, `flutter run` und der erfolgreiche Zugriff auf die vor dem Upgrade gespeicherte Konfiguration schließen die lokale Migrationsprüfung ab.

## Warum Built-in Kotlin noch nicht erzwungen wird

Flutter 3.47 unterstützt Built-in Kotlin grundsätzlich. In der aktuellen Stable-Version 3.47.4 existiert jedoch weiterhin ein Problem in der Flutter-Abhängigkeitsprüfung: Bei `android.builtInKotlin=true` wird die von AGP eingebettete Kotlin-Version ausgewertet und eine extern angehobene KGP-Version nicht zuverlässig berücksichtigt. Der Projektstand folgt daher bewusst dem offiziellen Flutter-3.47.4-Template statt diesen Checker mit `--android-skip-build-dependency-validation` zu umgehen.

Sobald Flutter Stable die vollständige Built-in-Kotlin-/New-DSL-Migration ohne diese Übergangsflags ausliefert, sollte diese Konfiguration in einer eigenen Lifecycle-Story erneut geprüft werden.

## Quellen für die Versionsentscheidung

Maßgeblich sind die mit Flutter `3.47.4` ausgelieferten Projektvorlagen und Versionskonstanten in `flutter_tools`. Für diesen Stand sind dort Gradle `9.3.1`, AGP `9.1.0`, KGP `2.4.0`, Android `minSdk 24` und `targetSdk 36` definiert. Die Secure-Storage-Migration folgt zusätzlich den Migrationshinweisen des Pakets `flutter_secure_storage` 10.x.
