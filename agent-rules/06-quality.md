# Qualität

## Codestyle und Abhängigkeiten

- Dart- und Flutter-Konventionen sowie bestehende Linter-Regeln befolgen.
- Klassen in `UpperCamelCase`, Variablen und Funktionen in `lowerCamelCase`, Dateien in `snake_case.dart` benennen.
- Sprechende Namen verwenden und unnötige Abkürzungen vermeiden.
- `const` verwenden, wo dies sinnvoll ist.
- Kontrollstrukturen mit geschweiften Klammern schreiben und unnötig lange oder komprimierte Codezeilen vermeiden.
- Kommentare erklären vor allem das Warum und wiederholen keinen offensichtlichen Code.
- Strukturierte Daten bevorzugt über klar benannte Modelle statt über lose Maps durch mehrere Schichten reichen.
- Neue Packages nur bei klarem Nutzen aufnehmen. Vorher Wartungszustand, Plattformunterstützung, Lizenz und tatsächlichen Bedarf prüfen.
- Keine Bibliothek für triviale Funktionalität einführen, die mit wenig verständlichem Code ohne neue Abhängigkeit lösbar ist.

## Prüfung

- Akzeptanzkriterien gegen die Umsetzung prüfen.
- `dart format` auf geänderten Dart-Dateien ausführen.
- `flutter analyze` ausführen und keine neuen Fehler oder Warnungen hinterlassen.
- Geeignete Unit-, Widget- oder Integrationstests ergänzen beziehungsweise ausführen.
- Fachliche Logik möglichst durch Unit-Tests, relevantes UI-Verhalten durch Widget-Tests und wichtige Integrationspfade durch geeignete Integrationstests absichern.
- Tests nicht über beliebige feste Wartezeiten synchronisieren. Wenn möglich auf das Erscheinen oder Verschwinden des erwarteten Zustands warten; feste Zeiten nur als begrenzendes Timeout oder kleine Polling-Schritte verwenden.
- Nicht ausführbare Prüfungen niemals als erfolgreich darstellen, sondern mit Begründung, Auswirkung und Restrisiko benennen.

## Lizenzen

- Neue oder geänderte fremde, mit dem Produkt verwendete und ausgelieferte Bestandteile auf Lizenzpflichten prüfen.
- Dazu zählen insbesondere Laufzeitabhängigkeiten, Bibliotheken, Frameworks, Logos, Bilder, Schriften, Audioinhalte und sonstige Assets.
- Relevante Bestandteile in `ATTRIBUTIONS.md` mit Herkunft, Rechteinhaber, Lizenz, betroffenen Dateien beziehungsweise Verwendungszweck und einzuhaltenden Bedingungen dokumentieren.
- Vor Aufnahme prüfen, ob die Lizenzbedingungen mit der MIT-Lizenz des Projekts vereinbar sind und der selbst entwickelte Projektcode weiter unter MIT veröffentlicht werden kann.
- Eine notwendige Änderung oder Aufgabe der MIT-Lizenz darf nicht stillschweigend erfolgen. Die Auswirkung wird im Pull Request dokumentiert und dem menschlichen Entwickler nach PR-Erstellung ausdrücklich mitgeteilt.
