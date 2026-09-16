# Inhalte aus Android-Apps teilen

Android-Teilen behält den fachlichen Typ des Inhalts bei. Die App verwendet getrennte Share-Ziele und führt nach der Übergabe in denselben Formular-/Submit-Weg wie bei manueller Erfassung.

## Übersicht

```text
Browser ────────> Teilen > Developer Wiki – Link
                    ↓
                 🌐 Quellenmetadaten

Notiz-App ──────> Teilen > Developer Wiki – Text
                    ↓
                 📝 Allgemeine Information

Galerie ────────> Teilen > Developer Wiki – Bild
                    ↓
                 🖼️ Bild-Quelle

PDF-Viewer ─────> Teilen > Developer Wiki – Dokument
                    ↓
                 📄 Dokument-Quelle
```

## Link teilen

1. Im Browser `Teilen` wählen.
2. `Developer Wiki – Link` auswählen.
3. Die App öffnet `🌐 Quellenmetadaten`; die URL wird vorbelegt.
4. Metadaten ergänzen und Quelle speichern.

## Text teilen

1. In einer Notiz- oder Text-App `Teilen` wählen.
2. `Developer Wiki – Text` auswählen.
3. Die App öffnet `📝 Allgemeine Information`; der Text wird in ein passendes Beschreibungsfeld vorbelegt.
4. Kontext ergänzen und speichern.

## Bild teilen

1. In Galerie oder Bild-App `Teilen` wählen.
2. `Developer Wiki – Bild` auswählen.
3. Die Bild-Quelle öffnet mit Vorschau des geteilten Bilds.
4. Beschreibung ergänzen und den zweistufigen Attachment-Ablauf abschließen.

## PDF teilen

1. Im Dateimanager oder PDF-Viewer `Teilen` wählen.
2. `Developer Wiki – Dokument` auswählen.
3. Die App öffnet direkt `📄 Dokument-Quelle` mit dem geteilten Dokument.
4. Dateiname, MIME-Typ und Größe prüfen und Metadaten ergänzen.
5. Upload starten.
6. PDF im GitHub-Pending-Issue anhängen und Kommentar absenden.
7. Zur App zurückkehren und `Upload erneut prüfen` wählen.

```text
PDF-Viewer
   ↓ Teilen
Developer Wiki – Dokument
   ↓
┌─────────────────────────────┐
│ 📄 Dokument-Quelle          │
│ handbuch.pdf                │
│ application/pdf · 2,8 MiB   │
│ Beschreibung […]            │
│ [Upload auf GitHub starten] │
└─────────────────────────────┘
```

## Nicht unterstützte Datei

Ein unbekannter MIME-Typ wird nicht als Text, Bild oder PDF umgedeutet und erzeugt kein Quellen-Issue.

```text
Diese Datei kann mit der aktuellen Wiki-Konfiguration
nicht als Quelle erfasst werden.

Dateityp: application/zip
```

Fehlt die fachlich passende Quellenart im dynamischen Wiki-Vertrag, meldet die App ebenfalls die Inkompatibilität, anstatt einen unvollständigen Fallback zu erzeugen.

Weitere technische Details: [Android-Share-Ziele](../share-targets.md).
