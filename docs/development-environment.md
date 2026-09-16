# Entwicklungsumgebung und Android-Toolchain

Diese Datei beschreibt den für die Developer-Wiki-App vorgesehenen Entwicklungsstand. Die im Repository versionierten Gradle-/AGP-Versionen sind die technische Referenz; lokale Werkzeuge sollen dazu kompatibel sein.

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
| Kotlin | AGP-9 Built-in Kotlin | kein separates `org.jetbrains.kotlin.android`-Plugin mehr |

AGP 9.0.1 benötigt mindestens Gradle 9.1.0 und JDK 17. Das Projekt verwendet JDK 21 für die Build-JVM; `sourceCompatibility`, `targetCompatibility` und Kotlin-`jvmTarget` bleiben auf 17.

## AGP 9 mit Built-in Kotlin und moderner DSL

Die App ist vollständig auf den von Flutter 3.47 unterstützten AGP-9-Pfad mit Built-in Kotlin migriert. Das frühere Plugin `org.jetbrains.kotlin.android` wird nicht mehr angewendet. Die Kotlin-Compilerkonfiguration liegt außerhalb des `android`-Blocks in der modernen `kotlin.compilerOptions`-DSL.

In `android/gradle.properties` sind die Zielmodi explizit aktiviert:

```properties
android.builtInKotlin=true
android.newDsl=true
```

Diese expliziten Werte verhindern, dass die Flutter-AGP-Migrationsguards das Projekt wieder auf den temporären Legacy-KGP-/Legacy-DSL-Modus zurückstellen. Sie können erst entfallen, wenn Flutter für AGP-9-Projekte keine entsprechenden Migrationsguards mehr benötigt.

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

Danach den Gradle Wrapper und den Android-Build prüfen:

```powershell
cd android
.\gradlew.bat --version
.\gradlew.bat assembleDebug
cd ..
```

`gradlew.bat --version` soll Gradle `9.1.0` melden. AGP wird nicht separat lokal installiert; seine Version kommt aus `android/settings.gradle.kts`. Ein separates Kotlin-Gradle-Plugin wird nicht mehr konfiguriert, da AGP 9 Built-in Kotlin verwendet.

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

### Flutter ergänzt Legacy-Flags für AGP 9

Flutter besitzt Migrationsguards für AGP-9-Projekte. Für dieses Repository sind `android.builtInKotlin=true` und `android.newDsl=true` bewusst versioniert. Werden sie unerwartet wieder auf `false` gesetzt, ist zunächst zu prüfen, ob der verwendete Flutter-Stand vom vorgesehenen Projektstand abweicht oder ein Plugin noch nicht Built-in-Kotlin-/New-DSL-kompatibel ist.

### Ein Plugin verwendet noch `org.jetbrains.kotlin.android`

Built-in Kotlin funktioniert nur, wenn die App und die beteiligten Flutter-Plugins mit dem AGP-9-Modell kompatibel sind. Meldet der Android-Build ein Plugin, das weiterhin das alte Kotlin-Gradle-Plugin anwendet, wird nicht global auf den Legacy-Modus zurückgeschaltet. Stattdessen wird geprüft, ob eine kompatible Plugin-Version verfügbar ist; andernfalls wird der konkrete Plugin-Konflikt separat behandelt.

### Lokale Gradle-Installation ist veraltet

Eine systemweit installierte Gradle-Version ist für dieses Projekt nicht maßgeblich. Builds immer über Flutter oder `android\gradlew.bat` ausführen, damit die im Repository festgelegte Gradle-Version verwendet wird.

## Quellen für die Versionsentscheidung

Die Migration orientiert sich an Flutter Stable 3.47.4, der Flutter-Anleitung zur AGP-9-/Built-in-Kotlin-Migration sowie der offiziellen AGP-9.0.1-Kompatibilitätsmatrix. Die konkreten Projektversionen bleiben im Repository versioniert, damit lokale Entwicklung und CI denselben Stand verwenden.
