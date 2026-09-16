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
| Android SDK Build Tools | `36.0.0` oder kompatibler neuerer Stand | AGP 9.0.1 verwendet 36.0.0 als Standard |
| Android Gradle Plugin | `9.0.1` | in `android/settings.gradle.kts` versioniert |
| Gradle | `9.1.0` | über den Gradle Wrapper versioniert |
| Kotlin Gradle Plugin | `2.3.20` | in `android/settings.gradle.kts` versioniert |

AGP 9.0.1 benötigt mindestens Gradle 9.1.0 und JDK 17. Das Projekt verwendet JDK 21 für die Build-JVM; `sourceCompatibility`, `targetCompatibility` und Kotlin-`jvmTarget` bleiben auf 17.

## AGP-9-Übergangsmodus

Die App verwendet weiterhin das Kotlin Gradle Plugin. Flutter 3.47 unterstützt dafür bei AGP 9 ausdrücklich einen Übergangsmodus. Deshalb stehen in `android/gradle.properties` bewusst:

```properties
android.builtInKotlin=false
android.newDsl=false
```

Diese Flags sind kein dauerhaftes Architekturziel. Eine spätere Umstellung auf AGP built-in Kotlin und die neue AGP DSL erfolgt als eigene Migration, nachdem App und verwendete Flutter-Plugins dafür geprüft wurden. Die Flags nicht nebenbei entfernen.

## Windows: lokale Umgebung aktualisieren

### 1. Android Studio aktualisieren

Android Studio auf den aktuellen Stable-Stand aktualisieren. Referenz bei Einführung dieser Toolchain ist Quail 4 (`2026.1.4`). Danach im SDK Manager mindestens sicherstellen:

- Android SDK Platform 36,
- Android SDK Build-Tools 36.0.0,
- aktuelle Android SDK Platform-Tools,
- aktuelle Android SDK Command-line Tools,
- bei Emulatorn ein zur Testhardware passendes System Image.

### 2. Flutter auf Stable 3.47.4 bringen

Bei einem normal auf dem Stable-Channel installierten Flutter-SDK:

```powershell
flutter channel stable
flutter upgrade
flutter --version
```

Für diesen Projektstand soll `flutter --version` Flutter `3.47.4` melden. Falls der Stable-Channel inzwischen weitergezogen ist, für reproduzierbare Arbeiten stattdessen explizit Flutter 3.47.4 aus dem offiziellen Flutter-SDK-Archiv verwenden.

### 3. JDK 21 verwenden

Prüfen, welches Java Flutter tatsächlich nutzt:

```powershell
flutter doctor -v
java -version
```

Für dieses Projekt soll die Build-JVM JDK 21 sein. Falls Flutter eine andere JDK-Installation verwendet, kann der gewünschte JDK-Pfad gesetzt werden:

```powershell
flutter config --jdk-dir="C:\Pfad\zu\jdk-21"
```

In Android Studio unter `Settings > Build, Execution, Deployment > Build Tools > Gradle` denselben JDK-21-Stand als Gradle JDK auswählen, damit IDE-Sync und Flutter-CLI nicht mit unterschiedlichen Java-Versionen arbeiten.

### 4. Projekt nach dem Toolchain-Update neu einlesen

Nach Aktualisierung des lokalen SDKs im Projektroot:

```powershell
flutter clean
flutter pub get
flutter doctor -v
flutter analyze --suggestions
flutter analyze
flutter test
```

Danach den Gradle Wrapper prüfen:

```powershell
cd android
.\gradlew.bat --version
.\gradlew.bat assembleDebug
cd ..
```

`gradlew.bat --version` soll Gradle `9.1.0` melden. AGP und KGP werden nicht separat lokal installiert; ihre Versionen kommen aus `android/settings.gradle.kts`.

### 5. Android-Lauf prüfen

Mit verbundenem Gerät oder laufendem Emulator:

```powershell
flutter devices
flutter run
```

Ein erfolgreicher Gradle-Sync in Android Studio und ein erfolgreicher `flutter run` schließen die lokale Migrationsprüfung ab.

## Typische Fehler nach dem Upgrade

### Android Studio und Flutter verwenden unterschiedliche JDKs

Symptome sind unterschiedliche Ergebnisse zwischen IDE-Sync und `flutter build` beziehungsweise Meldungen zu nicht unterstützten Java-/Gradle-Versionen. `flutter doctor -v`, `java -version` und die Android-Studio-Einstellung `Gradle JDK` auf denselben JDK-21-Stand bringen.

### Flutter überschreibt oder ergänzt AGP-9-Flags

Flutter kann bei AGP 9 Kompatibilitätsflags migrieren. Für dieses Repository sind `android.builtInKotlin=false` und `android.newDsl=false` bewusst versioniert. Unerwartete Änderungen daran nicht ungeprüft übernehmen.

### Lokale Gradle-Installation ist veraltet

Eine systemweit installierte Gradle-Version ist für dieses Projekt nicht maßgeblich. Builds immer über Flutter oder `android\gradlew.bat` ausführen, damit die im Repository festgelegte Gradle-Version verwendet wird.

## Quellen für die Versionsentscheidung

Die Migration orientiert sich an Flutter Stable 3.47.4, der Flutter-Anleitung für AGP 9 mit legacy KGP sowie der offiziellen AGP-9.0.1-Kompatibilitätsmatrix. Die konkreten Projektversionen bleiben im Repository versioniert, damit lokale Entwicklung und CI denselben Stand verwenden.
