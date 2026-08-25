# Attributionen und Lizenzen

Diese Datei dokumentiert die Herkunft und Lizenzierung von Bildmaterial,
Frameworks und wesentlichen Laufzeitabhängigkeiten der Developer-Wiki-App.
Der selbst entwickelte Programmcode des Projekts bleibt davon unberührt und
steht unter der in der Root-Datei [`LICENSE`](LICENSE) genannten MIT-Lizenz.

## App-Logo

**Betroffene Dateien:**

- `assets/branding/developer-wiki-app-logo.png`
- die daraus erzeugten Android-Launcher-Icons unter
  `android/app/src/main/res/mipmap-*`
- das daraus abgeleitete monochrome Android-Icon
  `android/app/src/main/res/drawable/ic_launcher_monochrome.xml`
- die daraus abgeleiteten Android-Icons der Teilen-Ziele
  `android/app/src/main/res/drawable/ic_share_*.xml`

**Entstehung:** Gestaltung, Auswahl und Veröffentlichung durch
[Huluvu424242](https://github.com/Huluvu424242) unter Verwendung der
ChatGPT-Bildgenerierung von OpenAI.

**Lizenz:** [CC0 1.0 Universal – Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/)

Soweit Huluvu424242 beziehungsweise der Projektinhaber Urheberrechte oder
verwandte Schutzrechte an diesen Logo-Dateien hält, werden diese Rechte im
größtmöglichen gesetzlich zulässigen Umfang gemäß CC0 1.0 aufgegeben. Das Logo
darf ohne Erlaubnis kopiert, verändert, verbreitet und auch kommerziell genutzt
werden. Eine Namensnennung ist nicht erforderlich.

Die oben genannte Entstehungsangabe dient ausschließlich der freiwilligen
Dokumentation der Herkunft und begründet keine Pflicht zur Namensnennung. CC0
betrifft Urheber- und verwandte Schutzrechte; andere Rechte sowie die
Haftungs- und Gewährleistungsausschlüsse der CC0-Erklärung bleiben unberührt.

## Open-Source-Komponenten

| Komponente | Verwendung | Lizenz und Rechteinhaber |
| --- | --- | --- |
| [Flutter Framework und Engine](https://github.com/flutter/flutter) | UI-Framework und Laufzeit | [BSD-3-Clause](https://github.com/flutter/flutter/blob/master/LICENSE), © 2014 The Flutter Authors |
| [Dart SDK](https://github.com/dart-lang/sdk) | Sprache und Laufzeit | [BSD-3-Clause](https://github.com/dart-lang/sdk/blob/main/LICENSE), © 2012 The Dart project authors |
| [`http` 1.6.0](https://pub.dev/packages/http/versions/1.6.0) | HTTP-Kommunikation mit GitHub | [BSD-3-Clause](https://github.com/dart-lang/http/blob/master/LICENSE), © 2014 The Dart project authors |
| [`flutter_secure_storage` 9.2.4](https://pub.dev/packages/flutter_secure_storage/versions/9.2.4) | Geschützte lokale Speicherung | [BSD-3-Clause](https://pub.dev/packages/flutter_secure_storage/versions/9.2.4/license), © 2017 German Saprykin |
| [Material Icons](https://github.com/google/material-design-icons) | Über Flutter eingebundene App-Symbole | [Apache-2.0](https://github.com/google/material-design-icons/blob/master/LICENSE), Google LLC und Mitwirkende |
| [Gradle Wrapper 8.14](https://docs.gradle.org/8.14/userguide/gradle_wrapper.html) | Im Repository enthaltene Android-Buildskripte und Wrapper-JAR | [Apache-2.0](https://github.com/gradle/gradle/blob/master/LICENSE), Gradle, Inc. und Mitwirkende |

Die jeweils vollständigen Lizenztexte der verwendeten Flutter-, Dart- und
Pub-Pakete werden vom Flutter-Build in die Asset-Datei `NOTICES` aufgenommen.
Flutter stellt diese Einträge zur Laufzeit über `LicenseRegistry` bereit. Die
konkret aufgelösten Paketversionen sind in [`pubspec.lock`](pubspec.lock)
festgehalten; dadurch werden auch transitive Laufzeitabhängigkeiten erfasst.

Reine Entwicklungs- und Erzeugungswerkzeuge wie `flutter_test`,
`flutter_lints` und ImageMagick sind nicht Bestandteil der ausgelieferten App
und werden deshalb nicht als Laufzeitkomponenten aufgeführt. Der Gradle Wrapper
ist eine Ausnahme, weil seine Skripte und sein Wrapper-JAR direkt im
Repository weitergegeben werden.

## Pflegehinweis

Neue Logos, Bilder, Schriften, Audioinhalte oder sonstige fremde Assets müssen
vor ihrer Aufnahme in die App mit Herkunft, Rechteinhaber und Lizenz in dieser
Datei ergänzt werden. Bei neuen Laufzeitabhängigkeiten ist zu prüfen, ob ihre
Lizenz zusätzliche Hinweise oder Bedingungen für Binärdistributionen verlangt.
