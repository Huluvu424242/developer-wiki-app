# Bild-Quellen und GitHub-Attachments

## Unterstützte Eingänge

Die App verarbeitet PNG-, GIF- und JPEG-Bilder bis 10 MiB. Ein Bild kann im
Bildquellenformular ausgewählt oder über das Android-Share-Ziel
**Developer Wiki – Bild** übergeben werden. Android liefert dabei regelmäßig
nur einen `content://`-URI. Die App liest dessen Stream einmalig, kopiert die
Bytes unverändert in ihren privaten Cache und prüft MIME-Typ, Größe und
Dateisignatur. Beide Eingänge laufen danach durch dasselbe Formular.

## Warum der Upload zweistufig ist

GitHub stellt für allgemeine Issue-Attachments keine dokumentierte REST- oder
GraphQL-Upload-API bereit. Deshalb lädt die App die Datei nicht über einen
nachgebauten internen Endpunkt hoch. Stattdessen wird der von GitHub
unterstützte Markdown-Editor im Browser verwendet:

1. Die App erstellt ein Pending-Issue ohne Label `quelle`. Sein Inhalt weist
   ausdrücklich darauf hin, dass es noch nicht importiert werden darf.
2. Die App öffnet den Kommentarbereich dieses Issues auf GitHub.
3. Der Mensch wählt dort das Bild aus und sendet den Kommentar ab. Das Bild
   muss im Browser erneut gewählt werden, weil eine andere App oder ein
   Browser nicht automatisch auf den privaten Cache der App zugreifen darf.
4. Nach **Upload prüfen und Quelle veröffentlichen** liest die App die
   Issue-Kommentare über die GitHub Issues API. Berücksichtigt werden nur
   Kommentare des aktuell authentifizierten GitHub-Kontos.
5. Genau eine stabile URL der Form
   `https://github.com/user-attachments/assets/<uuid>` muss vorhanden sein.
   Temporäre signierte Download-URLs und fremde Links werden nicht übernommen.
6. Die App ersetzt den Pending-Inhalt durch das finale Bild-Markdown und setzt
   erst als letzten Schritt das Label `quelle`. Erst jetzt kann der Wiki-Import
   das Issue verarbeiten.

Bei der Verarbeitung löst das Developer-Wiki die stabile Attachment-Referenz
über die GitHub-Markdown-Verarbeitung in eine kurzlebige signierte Download-URL
auf. Ein direkter Download der stabilen Referenz ist nicht Teil des App-Ablaufs.

## Unterbrechung und Aufräumen

Der Pending-Zustand einschließlich Issue-Nummer, Formulardaten und privatem
Cache-Pfad wird im geschützten lokalen Speicher abgelegt. Nach einem App-Neustart
erscheint er auf der Startseite und kann fortgesetzt werden. Beim erfolgreichen
Abschluss wird die temporäre Datei entfernt. **Upload verwerfen** schließt das
Pending-Issue als nicht geplant, löscht den lokalen Zustand und entfernt die
temporäre Datei.

Der private Android-Cache kann vom Betriebssystem bereinigt werden. Wurde der
Kommentar bereits hochgeladen, bleibt die Abschlussprüfung trotzdem möglich,
weil sie ausschließlich die stabile GitHub-Referenz benötigt.

## Datenschutz

Die App verändert oder bereinigt das Originalbild nicht. Insbesondere können
Fotos EXIF-Daten wie Aufnahmeort, Zeitpunkt oder Geräteinformationen enthalten.
Vor dem Upload muss deshalb geprüft werden, ob das unveränderte Bild geteilt
werden darf.
