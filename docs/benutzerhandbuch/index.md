# Benutzerhandbuch

Dieses Handbuch beschreibt die typischen Abläufe der Developer-Wiki-App vom ersten Start bis zur erfolgreichen Übergabe einer Quelle an das persönliche Developer-Wiki.

## Schnellstart

1. [Ersteinrichtung und GitHub-Zugang](ersteinrichtung.md)
2. [Quellen manuell erfassen](quellen-erfassen.md)
3. [Inhalte aus Android-Apps teilen](teilen.md)
4. [Fehler erkennen und sicher beheben](fehlerbehebung.md)

Vertiefende technische Nutzerhinweise:

- [Fine-grained PAT Schritt für Schritt](../pat-setup.md)
- [Dokument-Quellen und Pending-Attachment](../document-sources.md)
- [Android-Share-Ziele](../share-targets.md)
- [Bild-Quellen](../image-sources.md)

## Gesamtfluss

```text
┌──────────────┐
│ Ersteinrichtung
│ Wiki + PAT + Workflow
└──────┬───────┘
       ↓
┌──────────────┐
│ Quelle erfassen
│ manuell oder Teilen
└──────┬───────┘
       ↓
┌──────────────┐
│ Datei?       │── nein ──> Quellen-Issue mit `quelle`
└──────┬───────┘
       │ ja
       ↓
┌──────────────┐
│ Pending-Issue
│ Attachment auf GitHub ergänzen
└──────┬───────┘
       ↓
┌──────────────┐
│ Upload prüfen
│ finalen Body bestätigen
└──────┬───────┘
       ↓
┌──────────────┐
│ `quelle` gesetzt
│ Quelle importierbar
└──────┬───────┘
       ↓
┌──────────────┐
│ Quellen ins Wiki importieren
└──────────────┘
```

Das Mockup zeigt die Reihenfolge, ersetzt aber keine Information: Die einzelnen Schritte sind in den verlinkten Kapiteln vollständig beschrieben.

## Sicherheit in einem Satz

Der Nutzer hinterlegt ausschließlich den auf sein Developer-Wiki begrenzten Fine-grained PAT in der App. `SOURCE_IMAGE_TOKEN`, `SOURCE_ATTACHMENT_TOKEN`, GitHub-Actions-Secrets und ein PAT für das App-Repository gehören **nicht** in die App.
