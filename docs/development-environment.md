# Entwicklungsumgebung und Android-Toolchain

Diese Datei beschreibt den für die Developer-Wiki-App vorgesehenen Entwicklungsstand. Die im Repository versionierten Gradle-/AGP-/Kotlin-Versionen sind die technische Referenz; lokale Werkzeuge sollen dazu kompatibel sein.

## Referenzstand

Stand: 2026-09-16

| Komponente | Projektstand | Hinweis |
| --- | --- | --- |
| Flutter | `3.47.4` stable | entspricht der `kiagent-flutter-validation` |
| Dart | mit Flutter 3.47.4 ausgeliefert | nicht separat installieren |
| Android Studio | Quail 4 / `2026.1.4` stable oder kompatibler neuerer Stable-Stand | IDE ist nicht Teil des Buildscripts |
| JDK | `21` für Entwicklung und Release | Android-Quell-/Bytecode-Ziel bleibt Java 17 |
| Android SDK | Platform 36 | `compileSdk = 36` |
| Android Gradle Plugin | `9.1.0` | aktueller Flutter-3.47.4-Templatewert |
| Gradle | `9.3.1` | aktueller Flutter-3.47.4-Templatewert |
| Kotlin Gradle Plugin | `2.4.0` | aktueller Flutter-3.47.4-Templatewert |

Flutter 3.47.4 erzeugt für AGP 9 derzeit weiterhin die Kompatibilitätsflags `android.newDsl=false` und `android.builtInKotlin=false`. Das ist bewusst: Die Stable-Templates deklarieren KGP 2.4.0 und verwenden vorerst noch die Legacy-Kompatibilitätsbrücken, obwohl Flutter parallel bereits an der vollständigen Built-in-Kotlin-/New-DSL-Migration arbeitet.

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

Die App selbst verwendet bereits die moderne Kotlin-Compilerkonfiguration:

```kotlin
kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
```

Damit vermeiden wir die veraltete `kotlinOptions`-DSL, ohne die von Flutter Stable noch nicht vollständig freigegebene Built-in-Kotlin-Migration zu erzwingen.

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

`gradlew.bat --version` soll Gradle `9.3.1` melden. AGP und KGP werden nicht separat lokal installiert; ihre Versionen kommen aus `android/settings.gradle.kts`.

### 5. Android-Lauf prüfen

```powershell
flutter devices
flutter run
```

Ein erfolgreicher Gradle-Sync in Android Studio und ein erfolgreicher `flutter run` schließen die lokale Migrationsprüfung ab.

## Warum Built-in Kotlin noch nicht erzwungen wird

Flutter 3.47 unterstützt Built-in Kotlin grundsätzlich. In der aktuellen Stable-Version 3.47.4 existiert jedoch weiterhin ein Problem in der Flutter-Abhängigkeitsprüfung: Bei `android.builtInKotlin=true` wird die von AGP eingebettete Kotlin-Version ausgewertet und eine extern angehobene KGP-Version nicht zuverlässig berücksichtigt. Der Projektstand folgt daher bewusst dem offiziellen Flutter-3.47.4-Template statt diesen Checker mit `--android-skip-build-dependency-validation` zu umgehen.

Sobald Flutter Stable die vollständige Built-in-Kotlin-/New-DSL-Migration ohne diese Übergangsflags ausliefert, sollte diese Konfiguration in einer eigenen Lifecycle-Story erneut geprüft werden.

## Quellen für die Versionsentscheidung

Maßgeblich sind die mit Flutter `3.47.4` ausgelieferten Projektvorlagen und Versionskonstanten in `flutter_tools`. Für diesen Stand sind dort Gradle `9.3.1`, AGP `9.1.0` und KGP `2.4.0` definiert.
