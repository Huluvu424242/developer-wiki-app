# Architektur: fachliche Struktur

Die Anwendung wird grundsätzlich zuerst nach fachlichen Features beziehungsweise Komponenten und erst innerhalb dieser Einheiten nach technischen Rollen strukturiert. Ziel ist hohe fachliche Kohäsion: Zusammengehörige Funktionalität soll gemeinsam auffindbar und möglichst als Einheit verschiebbar oder herauslösbar sein.

Beispiel:

```text
lib/
  bugreport/
    screens/
    services/
    models/
    widgets/
```

- Globale technische Ordner wie `screens/`, `services/` oder `models/` sind nicht der primäre Schnitt für fachlich eigenständige Features.
- Kleine Features dürfen flach bleiben; technische Unterordner nur bei echtem Bedarf anlegen.
- Zu große Features zuerst fachlich weiter schneiden: als fachlich benanntes Unterfeature oder eigenständiges Feature.
- Ein fachlicher Ordner darf sowohl technisch als auch fachlich benannte Unterordner enthalten.
- Flutter-/Dart-Konventionen und technisch vorgegebene Bereiche wie `lib/`, `test/`, `android/`, `ios/` und `assets/` bleiben erhalten.
- Projektweit gemeinsame Infrastruktur darf zentral liegen; feature-lokale Fachlogik wird dadurch nicht wieder nach globalen technischen Schichten verteilt.
- Tests sollen die fachliche Struktur soweit sinnvoll spiegeln.
- Keine Big-Bang-Migration des Bestands; neue Features und gezielte Refactorings entwickeln die Struktur schrittweise weiter, sofern der vereinbarte Story- oder Bugfix-Umfang dies trägt.
