# Qualität

## Codestyle und Abhängigkeiten

- Dart- und Flutter-Konventionen sowie bestehende Linter-Regeln befolgen.
- Klassen in `UpperCamelCase`, Variablen und Funktionen in `lowerCamelCase`, Dateien in `snake_case.dart` benennen.
- Sprechende Namen verwenden und unnötige Abkürzungen vermeiden.
- `const` verwenden, wo dies sinnvoll ist. Für zusammengesetzte Widgetbäume gelten zusätzlich die Flutter-Regeln aus [Architektur – Implementierung](03-implementation.md).
- Kontrollstrukturen mit geschweiften Klammern schreiben und unnötig lange oder komprimierte Codezeilen vermeiden.
- Kommentare erklären vor allem das Warum und wiederholen keinen offensichtlichen Code.
- Strukturierte Daten bevorzugt über klar benannte Modelle statt über lose Maps durch mehrere Schichten reichen.
- Neue Packages nur bei klarem Nutzen aufnehmen. Vorher Wartungszustand, Plattformunterstützung, Lizenz und tatsächlichen Bedarf prüfen.
- Keine Bibliothek für triviale Funktionalität einführen, die mit wenig verständlichem Code ohne neue Abhängigkeit lösbar ist.

## Prüfung

- Akzeptanzkriterien gegen die Umsetzung prüfen.
- Für geänderten Dart-/Flutter-Code sind vor Abschluss `dart format --set-exit-if-changed lib test`, `flutter analyze` und `flutter test` die Standardprüfungen, soweit das Flutter-SDK verfügbar ist.
- Ein Pull Request mit geändertem Dart- oder Flutter-Code wird nur dann als `Geprüft und mergebereit` gemeldet, wenn die erforderlichen und verfügbaren automatisierten Prüfungen erfolgreich waren.
- Kann mindestens eine erforderliche automatisierte Prüfung nicht erfolgreich ausgeführt werden, lautet der Status `Implementiert, technische Prüfung ausstehend`.
- Nicht ausgeführte oder fehlgeschlagene Prüfungen werden mit Grund, Auswirkung und Restrisiko benannt und niemals als Erfolg dargestellt.
- Geeignete Unit-, Widget- oder Integrationstests ergänzen beziehungsweise ausführen.
- Fachliche Logik möglichst durch Unit-Tests, relevantes UI-Verhalten durch Widget- und Semantiktests und wichtige Integrationspfade durch geeignete Integrationstests absichern.
- Für lazy Scrollbereiche gelten die Testregeln aus [UX und Barrierefreiheit](04-ux-accessibility.md), insbesondere die Unterscheidung zwischen Widget-Existenz und Viewport-Sichtbarkeit.
- Tests nicht über beliebige feste Wartezeiten synchronisieren. Wenn möglich auf das Erscheinen oder Verschwinden des erwarteten Zustands warten; feste Zeiten nur als begrenzendes Timeout oder kleine Polling-Schritte verwenden.

## Lizenzen

- Neue oder geänderte fremde, mit dem Produkt verwendete und ausgelieferte Bestandteile auf Lizenzpflichten prüfen.
- Dazu zählen insbesondere Laufzeitabhängigkeiten, Bibliotheken, Frameworks, Logos, Bilder, Schriften, Audioinhalte und sonstige Assets.
- Relevante Bestandteile in `ATTRIBUTIONS.md` mit Herkunft, Rechteinhaber, Lizenz, betroffenen Dateien beziehungsweise Verwendungszweck und einzuhaltenden Bedingungen dokumentieren.
- Vor Aufnahme prüfen, ob die Lizenzbedingungen mit der MIT-Lizenz des Projekts vereinbar sind und der selbst entwickelte Projektcode weiter unter MIT veröffentlicht werden kann.
- Eine notwendige Änderung oder Aufgabe der MIT-Lizenz darf nicht stillschweigend erfolgen. Die Auswirkung wird im Pull Request dokumentiert und dem menschlichen Entwickler nach PR-Erstellung ausdrücklich mitgeteilt.
