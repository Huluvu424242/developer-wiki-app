# Architektur: fachliche Struktur

- Die Anwendung wird grundsätzlich zuerst nach fachlichen Features und erst innerhalb dieser Einheiten nach technischen Rollen strukturiert.
- Globale technische Ordner sind nicht der primäre Schnitt für fachlich eigenständige Features.
- Kleine Features dürfen flach bleiben; technische Unterordner nur bei echtem Bedarf anlegen.
- Zu große Features zuerst fachlich weiter schneiden.
- Flutter-/Dart-Konventionen und technisch vorgegebene Bereiche wie `lib/`, `test/`, `android/`, `ios/` und `assets/` bleiben erhalten.
- Projektweit gemeinsame Infrastruktur darf zentral liegen; feature-lokale Fachlogik wird dadurch nicht wieder nach globalen technischen Schichten verteilt.
- Tests sollen die fachliche Struktur soweit sinnvoll spiegeln.
- Keine Big-Bang-Migration des Bestands; neue Features und gezielte Refactorings entwickeln die Struktur schrittweise weiter.
