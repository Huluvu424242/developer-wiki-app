# Lifecycle-Wartung

Dieses Modul regelt die planmäßige technische Wartung der Flutter-/Android-Entwicklungs- und Build-Toolchain. Ziel ist, kleine, kontrollierte Upgrades regelmäßig durchzuführen und große, gekoppelte Sprünge nach langen Wartungspausen zu vermeiden.

## Wartungsrhythmus

- Eine bewusste Lifecycle-Prüfung erfolgt grundsätzlich **quartalsweise**, bevorzugt im zeitlichen Umfeld eines neuen Flutter-Stable-Releases.
- **Spätestens alle drei Monate muss ein neuer Lifecycle-Wartungszeitpunkt im Repository erfasst werden.** Existiert zu diesem Zeitpunkt keine offene Lifecycle-Story, wird eine neue Lifecycle-Story angelegt. Existiert bereits eine offene Lifecycle-Story, wird **keine zweite parallele Story** erzeugt; stattdessen wird die bestehende Story um einen datierten Quartalshinweis ergänzt, dass ein weiterer Lifecycle-Wartungszeitpunkt fällig geworden ist.
- Damit existiert im Normalfall höchstens **eine offene quartalsweise Lifecycle-Story**. Eine über längere Zeit offene Story bleibt der zentrale Wartungsauftrag und sammelt die inzwischen zusätzlich fällig gewordenen Quartale nachvollziehbar als Kommentare, statt für jedes Quartal weitere offene Dubletten zu erzeugen.
- Wird die offene Lifecycle-Story geschlossen, erzeugt der nächste fällige Quartalstermin wieder eine neue Lifecycle-Story.
- Der Standardrhythmus sind die vier Kalenderquartale Januar–März, April–Juni, Juli–September und Oktober–Dezember.
- Die quartalsweise Story ist nicht nur ein Prüfticket. Sie beauftragt die Ermittlung des zum Bearbeitungszeitpunkt aktuellen Lifecycle-Handlungsbedarfs und – soweit die übrigen Repository-Regeln dies innerhalb derselben Story zulassen – die anschließende Umsetzung dieses Handlungsbedarfs.
- Zwischen zwei bewussten Lifecycle-Prüfungen beziehungsweise dokumentierten Upgrade-Entscheidungen sollen im Normalfall **nicht mehr als drei Monate** liegen. Sechs Monate sind nur bei einem ausdrücklich dokumentierten Ausnahmegrund vertretbar; zwölfmonatige oder noch längere Sammel-Upgrades mehrerer Flutter-/Android-Toolchain-Generationen werden vermieden.
- Pub-/Flutter-Abhängigkeiten werden häufiger, typischerweise **monatlich bis zweimonatlich**, auf relevante Updates, Deprecations, Supportgrenzen und Sicherheitsbedarf geprüft. Besonderes Augenmerk gilt Plugins mit nativen Android-Anteilen.
- Sicherheitsupdates, angekündigte Support-Enden, konkrete Lifecycle-Warnungen und Deprecations mit absehbarer Build-Auswirkung werden **außerplanmäßig** bewertet und bei Bedarf zeitnah bearbeitet; sie warten nicht zwingend bis zum nächsten Quartalstermin.

## Verbindlicher Vertrag für die quartalsweise Lifecycle-Story

Die quartalsweise Story besitzt bewusst **keine kopierte statische Toolchain-Checkliste und keine feste Versionsmatrix**. Die einzige normative Quelle für Inhalt und Prüfpflichten ist die zum Bearbeitungszeitpunkt auf dem Zielbranch gültige Fassung dieses Moduls `agent-rules/09-lifecycle-maintenance.md` zusammen mit den übrigen über `AGENTS.md` eingebundenen Regeln.

Jede manuell oder automatisiert erzeugte quartalsweise Lifecycle-Story enthält daher nur einen stabilen Meta-Auftrag mit folgenden Pflichten:

1. `AGENTS.md` und alle dort aktuell gelisteten Regelmodule vollständig lesen.
2. Die aktuelle Fassung dieses Lifecycle-Moduls als verbindlichen Prüf- und Umsetzungsvertrag anwenden.
3. Den aktuellen Projekt-, Flutter-, Android-, JDK-, Build-Toolchain- und Dependency-Stand ermitteln und gegen die aktuell unterstützten beziehungsweise vorgesehenen Zielstände bewerten.
4. Aus dem **aktuellen** Lifecycle-Vertrag die für diesen Lauf tatsächlich erforderlichen Prüfschritte und Änderungen ableiten, statt eine im Issue gespeicherte ältere Checkliste abzuarbeiten.
5. Das Ergebnis als nachvollziehbare Entscheidung dokumentieren: `jetzt aktualisieren`, `gezielt aufschieben` oder `kein Handlungsbedarf`.
6. Bei `jetzt aktualisieren` die ermittelten und nach der übrigen Governance zulässigen Änderungen im Rahmen des Lifecycle-Auftrags tatsächlich umsetzen und die vom aktuellen Harness geforderten Prüfungen durchführen.
7. Verlangt eine erkannte Änderung nach den Werkzeugketten-, Release- oder sonstigen Regeln eine eigene Story oder einen separaten Pull Request, wird diese Trennung eingehalten und im Lifecycle-Batch verlinkt; die quartalsweise Story darf die speziellere Governance nicht umgehen.
8. Noch offene, nicht ausführbare oder bewusst aufgeschobene Punkte mit Begründung, Auswirkung und geplantem Folgeschritt dokumentieren.

Wird eine bereits offene Lifecycle-Story bei einem späteren Quartalstermin weiterverwendet, gilt zusätzlich:

- der neue Quartalstermin wird als **Kommentar mit Datum und Quartalskennung** dokumentiert;
- der Kommentar enthält keine kopierte technische Checkliste und keine festen Toolchain-Versionen, sondern weist darauf hin, dass der Wartungsumfang bei Bearbeitung erneut aus dem dann aktuellen Harness abzuleiten ist;
- pro Kalenderquartal wird derselbe Fälligkeitshinweis höchstens einmal ergänzt;
- ältere Quartalshinweise bleiben als Audit-Trail erhalten und werden nicht gelöscht oder überschrieben;
- die fachliche Tragweite der offenen Story wächst damit auf alle seit ihrer Erstellung zusätzlich fällig gewordenen Lifecycle-Zeitpunkte, ohne dass daraus parallele Lifecycle-Stories entstehen.

Damit gilt ausdrücklich: **Bei einem Widerspruch zwischen dem Text einer älteren Lifecycle-Story oder eines älteren Quartalshinweises und dem aktuellen Harness hat der aktuelle Harness Vorrang.** Ein automatischer Story-Erzeuger darf feste Versionsnummern, eine vollständige technische Prüfliste oder andere normative Lifecycle-Regeln nicht duplizieren. Ändert sich der Lifecycle-Vertrag, wirkt die Änderung dadurch automatisch auf künftig bearbeitete quartalsweise Stories.

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

- Die quartalsweise Lifecycle-Story erfüllt bereits die Pflicht, vor einer tatsächlich erforderlichen Lifecycle-Migration einen fachlichen Wartungsauftrag anzulegen. Für die aus dieser Prüfung unmittelbar hervorgehende normale Toolchain-Migration muss daher nicht künstlich eine zweite gleichartige Lifecycle-Story erzeugt werden.
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

## Automatisierte Story-Anlage

- Eine GitHub Action darf den quartalsweisen Lifecycle-Wartungszeitpunkt automatisch erfassen, sofern sie als eigene Werkzeugkettenänderung gemäß [Sicherheit und Werkzeugketten](05-security-tooling.md) eingeführt und menschlich geprüft wurde.
- Der automatische Lauf soll quartalsweise in einem deterministischen Kalenderrhythmus erfolgen und zusätzlich idempotent sein.
- Existiert keine offene Lifecycle-Story, legt die Action eine neue Story mit dem oben definierten Meta-Auftrag an.
- Existiert bereits eine offene Lifecycle-Story, legt die Action **keine weitere Lifecycle-Story** an. Stattdessen ergänzt sie genau einen datierten Kommentar für das neu fällig gewordene Kalenderquartal.
- Ein wiederholter oder verspäteter Lauf darf weder eine zweite offene Lifecycle-Story noch einen doppelten Quartalskommentar für denselben Zeitraum erzeugen.
- Die Action darf ausschließlich Story-Anlage beziehungsweise Quartalshinweis automatisieren. Sie führt keine Toolchain-Upgrades, Merges, Releases oder sonstigen Repository-Codeänderungen selbst aus.
- Storytext und Quartalskommentar verweisen auf dieses Modul als aktuelle normative Quelle und enthalten nur den oben definierten Meta-Auftrag beziehungsweise Fälligkeitshinweis. Sie duplizieren keine feste technische Checkliste oder Versionsmatrix.
- Ein manueller Ausfall oder eine Deaktivierung der Action hebt die Harness-Pflicht zur dreimonatlichen Erfassung des Lifecycle-Wartungszeitpunkts nicht auf. Die Harness-Regel bleibt die fachliche Pflicht; die Action ist nur deren technische Erinnerung und Umsetzungshilfe.

## Trennung von Wartung und Veröffentlichung

- Eine erfolgreich geprüfte Lifecycle-Migration ist noch keine Releasefreigabe.
- Releasevorbereitung, produktive Veröffentlichung, Signing und Release-Workflows bleiben eigenständige Vorgänge und richten sich nach [Releasevorbereitung](07-release.md) sowie [Sicherheit und Werkzeugketten](05-security-tooling.md).
- Die Lifecycle-Wartung darf einen notwendigen Folgerelease empfehlen oder vorbereiten, aber keine bestehende Ausführungs- oder Review-Governance umgehen.
