# Lifecycle-Wartung

Dieses Modul regelt die planmäßige technische Wartung der Flutter-/Android-Entwicklungs- und Build-Toolchain. Ziel ist, kleine, kontrollierte Upgrades regelmäßig durchzuführen und große, gekoppelte Sprünge nach langen Wartungspausen zu vermeiden.

## Wartungsrhythmus

- Eine bewusste Lifecycle-Prüfung erfolgt grundsätzlich **quartalsweise**, bevorzugt im zeitlichen Umfeld eines neuen Flutter-Stable-Releases.
- Zwischen zwei bewussten Lifecycle-Prüfungen beziehungsweise dokumentierten Upgrade-Entscheidungen sollen im Normalfall **nicht mehr als sechs Monate** liegen.
- Zwölfmonatige oder noch längere Sammel-Upgrades mehrerer Flutter-/Android-Toolchain-Generationen werden vermieden, sofern nicht ein ausdrücklich dokumentierter Ausnahmegrund entgegensteht.
- Pub-/Flutter-Abhängigkeiten werden häufiger, typischerweise **monatlich bis zweimonatlich**, auf relevante Updates, Deprecations, Supportgrenzen und Sicherheitsbedarf geprüft. Besonderes Augenmerk gilt Plugins mit nativen Android-Anteilen.
- Sicherheitsupdates, angekündigte Support-Enden, konkrete Lifecycle-Warnungen und Deprecations mit absehbarer Build-Auswirkung werden **außerplanmäßig** bewertet und bei Bedarf zeitnah bearbeitet; sie warten nicht zwingend bis zum nächsten Quartalstermin.

## Flutter als Taktgeber

- Für die gekoppelte mobile Toolchain ist **Flutter Stable** der primäre Taktgeber.
- Dart wird grundsätzlich zusammen mit der von der gewählten Flutter-Version ausgelieferten Dart-Version betrachtet und nicht unabhängig davon auf eine andere Version gezogen.
- Gradle, Android Gradle Plugin (AGP), Kotlin Gradle Plugin (KGP), JDK und Android SDK werden nicht mechanisch jeweils auf die neueste Einzelversion aktualisiert.
- Maßgeblich ist eine **zusammenpassende und von der vorgesehenen Flutter-Stable-Version tatsächlich unterstützte Kombination**. Bevorzugte Referenzen sind die aktuellen Flutter-Projektvorlagen, die offiziellen Flutter-Kompatibilitätsvorgaben und ergänzend die jeweiligen Herstelleranforderungen von Android/Gradle/Kotlin.
- Android Studio darf unabhängig auf einem kompatiblen Stable-Stand aktuell gehalten werden. Die installierte IDE-Version allein ist kein Grund, die im Repository versionierte Gradle-/AGP-/Kotlin-Toolchain auf andere Werte zu ziehen.

## Zeitpunkt eines Flutter-Upgrades

- Ein neues nicht sicherheitskritisches Flutter-Stable-Release wird nicht allein aufgrund seiner Veröffentlichung sofort übernommen.
- Sofern kein Supportende, Security-Fix, notwendiger Plattformwechsel oder anderer dringender Grund besteht, wird normalerweise eine kurze **Stabilisierungsphase von etwa zwei bis vier Wochen** abgewartet. Dadurch können erste Patch-Releases und erkennbare Plugin-Inkompatibilitäten berücksichtigt werden.
- Vor der Entscheidung wird geprüft, ob der aktuelle Projektstand noch unterstützt ist und ob relevante Deprecation-/Lifecycle-Warnungen ein früheres Upgrade verlangen.

## Mindestumfang einer Lifecycle-Prüfung

Eine quartalsweise Lifecycle-Prüfung umfasst mindestens:

1. aktuelle Flutter-Stable-Version und die im Projekt festgelegte Flutter-Version;
2. die mit Flutter ausgelieferte Dart-Version;
3. die von der Ziel-Flutter-Version verwendeten beziehungsweise unterstützten Template-/Kompatibilitätsstände für Gradle, AGP und KGP;
4. JDK-Anforderungen und tatsächlich verwendete Build-JVM;
5. Android `compileSdk`, `targetSdk` und `minSdk` einschließlich angekündigter Supportgrenzen;
6. Kompatibilität des eingesetzten Android-Studio-Stable-Stands;
7. `flutter pub outdated` beziehungsweise eine gleichwertige Prüfung der direkten und relevanten transitiven Abhängigkeiten;
8. Deprecation-, Lifecycle- und Support-Warnungen aus `flutter analyze`, Gradle-/Android-Builds und verwendeten Plugins;
9. Security- und Wartungszustand relevanter nativer Plugins und Build-Abhängigkeiten;
10. erkennbare Migrationsanforderungen für persistierte Daten, Buildskripte, Signing oder Releaseabläufe.

Die Lifecycle-Prüfung ist eine Bewertung und verpflichtet nicht dazu, jede verfügbare neue Version sofort zu übernehmen. Das Ergebnis wird als nachvollziehbare Upgrade-Entscheidung dokumentiert: **jetzt aktualisieren**, **gezielt aufschieben** oder **kein Handlungsbedarf**.

## Story- und Änderungsumfang

- Eine tatsächliche Toolchain-Migration erhält vor der Umsetzung eine eigene Lifecycle-Story mit prüfbaren Akzeptanzkriterien.
- Major-Migrationen von Flutter, AGP, Gradle, Kotlin/KGP, JDK oder Android SDK sowie Änderungen an Build- oder Release-Infrastruktur werden nicht beiläufig in fachfremde Bugfixes oder Feature-Stories aufgenommen.
- Zusammengehörige Versionen dürfen in einer Lifecycle-Story bewusst als koordinierter Satz aktualisiert werden, wenn ihre Kompatibilität voneinander abhängt.
- Ein Versionssprung wird nicht mit einem Skip-/Disable-Flag „grün gemacht“, wenn dadurch eine echte Kompatibilitätsprüfung umgangen wird. Notwendige Übergangsflags sind nur zulässig, wenn sie von der verwendeten Flutter-/Android-Toolchain ausdrücklich vorgesehen und dokumentiert sind.
- Ändert eine Lifecycle-Migration GitHub Actions oder andere ausführbare Werkzeugketten, gelten zusätzlich vollständig die Regeln aus [Sicherheit und Werkzeugketten](05-security-tooling.md), insbesondere separate Werkzeugketten-Story/PR und menschliche Reviewpflicht, soweit dort verlangt.

## Umgang mit Abhängigkeiten und Warnungen

- Warnungen und Deprecations aus eigenen Projektdateien werden innerhalb einer Lifecycle-Migration nach Möglichkeit direkt behoben, sofern die Änderung fachlich klar und im Scope liegt.
- Warnungen aus Drittanbieter-Packages oder Plugins werden nicht durch Änderungen im lokalen Package-Cache oder durch Unterdrückung „behoben“.
- Für Drittanbieterwarnungen wird geprüft, ob ein gepflegtes kompatibles Update verfügbar ist. Ist kein sinnvoller Fix verfügbar, wird die Restwarnung mit Ursache, Auswirkung und geplantem Folgeschritt dokumentiert.
- Bei Major-Upgrades von Abhängigkeiten mit persistierter oder sicherheitsrelevanter Datenhaltung wird der dokumentierte Migrationspfad des Herstellers eingehalten. Ein direkter Versionssprung darf keine notwendige Zwischenmigration überspringen.
- Neue oder wesentlich geänderte Abhängigkeiten unterliegen zusätzlich den Lizenz-, Wartungs- und Sicherheitsprüfungen aus [Qualität](06-quality.md) und [Sicherheit – Tests, CI und Vorfälle](05-security-ci.md).

## Technische Prüfungen nach einer Migration

Soweit die jeweilige Änderung die Bereiche betrifft und die Werkzeuge verfügbar sind, werden vor Abschluss mindestens ausgeführt beziehungsweise nachvollziehbar geprüft:

```text
flutter pub get
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
cd android && ./gradlew --version
cd android && ./gradlew assembleDebug
```

Unter Windows ist entsprechend `gradlew.bat` zu verwenden.

Zusätzlich gelten:

- Android Gradle Sync in einer kompatiblen Android-Studio-Version;
- `flutter run` auf Android beziehungsweise eine gleichwertige reale Laufprüfung;
- Prüfung der tatsächlich verwendeten Gradle- und JVM-Version;
- bei Änderungen an `minSdk`, `targetSdk`, Manifest, Berechtigungen oder nativen Plugins eine passende Android-Laufprüfung;
- bei Datenmigrationen ein Upgrade-Test mit bestehenden App-Daten ohne vorheriges Löschen der Daten;
- bei Release-relevanten Änderungen die erforderlichen Releaseprüfungen gemäß [Releasevorbereitung](07-release.md), ohne dadurch automatisch eine produktive Veröffentlichung auszulösen.

Nicht ausführbare Prüfungen werden nach den allgemeinen Qualitätsregeln ausdrücklich als offen gemeldet und nicht als erfolgreich angenommen.

## Trennung von Wartung und Veröffentlichung

- Eine erfolgreich geprüfte Lifecycle-Migration ist noch keine Releasefreigabe.
- Releasevorbereitung, produktive Veröffentlichung, Signing und Release-Workflows bleiben eigenständige Vorgänge und richten sich nach [Releasevorbereitung](07-release.md) sowie [Sicherheit und Werkzeugketten](05-security-tooling.md).
- Die Lifecycle-Wartung darf einen notwendigen Folgerelease empfehlen oder vorbereiten, aber keine bestehende Ausführungs- oder Review-Governance umgehen.
