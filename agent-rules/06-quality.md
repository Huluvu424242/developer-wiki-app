# Qualität

## Codestyle und Abhängigkeiten

- Dart- und Flutter-Konventionen sowie bestehende Linter-Regeln befolgen.
- Klassen in `UpperCamelCase`, Variablen und Funktionen in `lowerCamelCase`, Dateien in `snake_case.dart` benennen.
- Sprechende Namen verwenden, unnötige Abkürzungen vermeiden und `const` sinnvoll einsetzen.
- Kommentare erklären vor allem das Warum; strukturierte Daten bevorzugt über klar benannte Modelle reichen.
- Neue Packages nur bei klarem Nutzen aufnehmen und zuvor Wartungszustand, Plattformunterstützung, Lizenz und tatsächlichen Bedarf prüfen.

## Prüfung

- Akzeptanzkriterien gegen die Umsetzung prüfen.
- `dart format` auf geänderten Dart-Dateien ausführen.
- `flutter analyze` ausführen und keine neuen Fehler oder Warnungen hinterlassen.
- Geeignete Unit-, Widget- oder Integrationstests ergänzen beziehungsweise ausführen.
- Tests nicht über beliebige feste Wartezeiten synchronisieren; wenn möglich auf den erwarteten Zustand warten.
- Nicht ausführbare Prüfungen niemals als erfolgreich darstellen, sondern mit Begründung und Restrisiko benennen.

## Lizenzen

- Mit dem Produkt verwendete und ausgelieferte fremde Bestandteile auf Lizenzpflichten prüfen.
- Relevante Laufzeitabhängigkeiten, Frameworks, Logos, Bilder, Schriften, Audioinhalte und sonstige Assets in `ATTRIBUTIONS.md` mit Herkunft, Rechteinhaber, Lizenz und Verwendungszweck dokumentieren.
- Eine notwendige Änderung der MIT-Lizenz darf nicht stillschweigend erfolgen und muss im Pull Request sowie gegenüber dem menschlichen Entwickler ausdrücklich benannt werden.
