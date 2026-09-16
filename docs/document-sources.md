# Dokument-Quellen

Die Developer-Wiki-App kann Dokument-Quellen aus dem dynamischen Quellen-Erfassungsvertrag des verbundenen Developer-Wikis anbieten. Der Mindestumfang ist eine lokal auf Android gespeicherte PDF-Datei.

## Lokale PDF erfassen

```text
┌──────────────────────────────────┐
│ 📄 Dokument-Quelle               │
├──────────────────────────────────┤
│ Issue-Titel                      │
│ [ Architekturhandbuch          ] │
│                                  │
│ Dokument                         │
│ handbuch.pdf                     │
│ application/pdf · 2,8 MiB        │
│ [Ersetzen] [Entfernen]           │
│                                  │
│ Beschreibung                     │
│ [..............................] │
│                                  │
│ [Upload auf GitHub starten]      │
└──────────────────────────────────┘
```

1. Auf der Startseite `📄 Dokument-Quelle` wählen.
2. `PDF auswählen` öffnen. Androids Dokumentauswahl wird verwendet; die App benötigt keinen allgemeinen Zugriff auf den Gerätespeicher.
3. Dateiname, MIME-Typ und Größe prüfen. Die zulässigen MIME-Typen und das Größenlimit stammen aus dem dynamischen Wiki-Vertrag.
4. Titel und weitere Metadaten ergänzen.
5. `Upload auf GitHub starten` wählen.

## Pending-Attachment vervollständigen

GitHub stellt für Issue-Attachments keinen direkten Upload-Endpunkt bereit, den die App mit dem Wiki-PAT verwendet. Deshalb führt die App einen kontrollierten zweistufigen Ablauf aus:

```text
PDF gewählt
   ↓
Pending-Issue ohne Label `quelle`
   ↓
GitHub-Kommentar öffnen
   ↓
PDF dort anhängen und Kommentar absenden
   ↓
zur App zurückkehren
   ↓
Upload erneut prüfen
   ↓
finalen Issue-Body schreiben und rücklesen
   ↓
erst jetzt Label `quelle`
```

Solange das Attachment fehlt, mehrere Attachments gefunden werden oder der finale Issue-Body nicht bestätigt werden kann, bleibt das Issue ohne `quelle` und wird nicht als fertige Wiki-Quelle freigegeben. Der Pending-Zustand wird lokal im geschützten App-Speicher gehalten und kann später fortgesetzt oder verworfen werden.

## Sicherheitsgrenze

Die App speichert keine PDF als Base64 im Issue und persistiert keine kurzlebige signierte Download-URL. Im finalen Issue steht ausschließlich die stabile GitHub-Attachment-Referenz.

Der in der App hinterlegte Fine-grained PAT bleibt der Wiki-Zugang der App. Die Wiki-internen Secrets `SOURCE_IMAGE_TOKEN` und `SOURCE_ATTACHMENT_TOKEN` werden von der App weder gelesen noch benötigt.

## Abhängigkeit zum Wiki-Vertrag

Die Dokument-Quelle wird nur angeboten, wenn das verbundene Wiki einen kompatiblen `file`-Feldtyp mit der Fähigkeit `guided-github-issue-file-attachment-v1` bereitstellt. Ein unbekannter oder unvollständiger Vertrag wird nicht stillschweigend auf ein Textfeld reduziert.
