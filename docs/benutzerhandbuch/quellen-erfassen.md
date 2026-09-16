# Quellen manuell erfassen

Die Startseite zeigt die Quellenarten, die das verbundene Developer-Wiki über seinen versionierten Erfassungsvertrag anbietet. Felder, Pflichtangaben und Datei-Limits stammen deshalb aus dem Wiki und nicht aus einer unabhängig gepflegten App-Kopie.

## Web-Link als Quelle

1. `🌐 Quellenmetadaten erfassen` wählen.
2. Titel, URL, Kurzbeschreibung, Art und Sprache ergänzen.
3. Optional Herausgeber, Autor, Datum, Relevanz und Hinweise ergänzen.
4. `Quelle speichern` wählen.

```text
🌐 Quellenmetadaten
Titel: [Flutter Dokumentation]
URL:   [https://…]
Art:   [Dokumentation]
Sprache: [Deutsch]
[Quelle speichern]
```

## Text oder eigene Information

1. `📝 Allgemeine Information fürs Wiki` wählen.
2. Beschreibung beziehungsweise Notiz eingeben.
3. Optional Thema, Relevanz, Quellen, Zielbezug und Sicherheitseinschätzung ergänzen.
4. `Quelle speichern` wählen.

## Bild lokal auswählen

1. `🖼️ Bild-Quelle` wählen.
2. Bild auswählen und Vorschau prüfen.
3. Beschreibung und Agentenhinweise ergänzen.
4. Upload starten.
5. Bild im geöffneten GitHub-Pending-Issue als Attachment zu einem Kommentar hinzufügen und Kommentar absenden.
6. Zur App zurückkehren und Upload prüfen.
7. Erst nach erfolgreicher Prüfung wird die Quelle mit `quelle` freigegeben.

## PDF lokal auswählen

```text
┌──────────────────────────────────┐
│ 📄 Dokument-Quelle               │
├──────────────────────────────────┤
│ Issue-Titel [Handbuch          ] │
│                                  │
│ Dokument                         │
│ [ PDF auswählen ]                │
│                                  │
│ nach Auswahl:                    │
│ handbuch.pdf                     │
│ application/pdf · 2,8 MiB        │
│ [Ersetzen] [Entfernen]           │
│                                  │
│ Beschreibung [................]   │
│ [Upload auf GitHub starten]      │
└──────────────────────────────────┘
```

1. `📄 Dokument-Quelle` wählen.
2. `PDF auswählen` wählen und die lokale Datei im Android-Dateidialog auswählen.
3. Dateiname, MIME-Typ und Größe prüfen. Das zulässige Größenlimit kommt aus dem Wiki-Vertrag.
4. Titel und weitere Metadaten ergänzen.
5. `Upload auf GitHub starten` wählen.
6. GitHub öffnet das Pending-Issue. PDF dort als Attachment zu einem Kommentar hinzufügen und den Kommentar absenden.
7. Zur App zurückkehren.
8. `Upload erneut prüfen` wählen.
9. Die App akzeptiert genau ein passendes Attachment, schreibt den finalen Issue-Body, liest ihn zur Bestätigung zurück und setzt erst danach `quelle`.

### Pending-Zustand

```text
┌──────────────────────────────────┐
│ PDF noch nicht vollständig       │
│ hochgeladen.                     │
│                                  │
│ PDF auf GitHub anhängen und      │
│ Kommentar absenden.              │
│                                  │
│ [GitHub öffnen]                  │
│ [Upload erneut prüfen]           │
│ [Quelle verwerfen]               │
└──────────────────────────────────┘
```

Der Pending-Zustand darf unterbrochen werden. Beim späteren Öffnen der Dokument-Quelle kann der gespeicherte Vorgang fortgesetzt werden. `Quelle verwerfen` schließt das Pending-Issue und bereinigt die temporäre lokale Datei.

Weitere Details stehen unter [Dokument-Quellen](../document-sources.md).

## Erfolg kontrollieren und importieren

Nach erfolgreicher Quellenerfassung ist das Issue mit `quelle` markiert. Über `Letzte Quellen` lässt sich der zuletzt erfasste Stand nachvollziehen. Mit `Quellen ins Wiki importieren` wird nach Bestätigung der konfigurierte Import-Workflow gestartet; dessen Status kann anschließend aktualisiert und auf GitHub geöffnet werden.
