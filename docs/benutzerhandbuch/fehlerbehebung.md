# Fehlerbehebung

Die App versucht, Eingaben und Pending-Uploads bei behebbaren Fehlern zu erhalten. Die folgenden Fälle beschreiben sichere nächste Schritte.

## Token fehlt, ist abgelaufen oder ungültig

**Fehlerbild:** Der Verbindungstest oder ein GitHub-Zugriff schlägt fehl.

**Nächster Schritt:** In den Einstellungen den Wiki-PAT prüfen. Falls er abgelaufen oder widerrufen wurde, einen neuen Fine-grained PAT nach [PAT-Einrichtung](../pat-setup.md) erstellen und anschließend `Verbindung und Rechte testen` erneut ausführen.

## Falsches Wiki-Repository

**Fehlerbild:** Repository oder Quellenmodell kann nicht gelesen werden.

**Nächster Schritt:** `GitHub Wiki` auf das persönliche Developer-Wiki korrigieren. Der PAT muss genau für dieses Repository freigegeben sein.

## Quellenmodell kann nicht geladen werden

**Fehlerbild:** Die App meldet, dass der aktuelle Quellenvertrag nicht erreichbar oder inkompatibel ist.

**Nächster Schritt:** Netzwerkzugang, `Contents: Read-only` und den aktuellen Wiki-Vertrag prüfen. Existiert ein kompatibler Cache, kann die App diesen gekennzeichnet weiterverwenden; unbekannte Feldarten oder Fähigkeiten werden nicht still degradiert.

## PDF zu groß oder nicht unterstützt

**Fehlerbild:** Die Dateiauswahl beziehungsweise Validierung lehnt das Dokument ab.

**Nächster Schritt:** MIME-Typ und Größenlimit des angezeigten Dokumentvertrags beachten. Der aktuelle Mindestvertrag unterstützt PDF. Bereits ausgefüllte Metadaten bleiben erhalten, sodass nur die Datei ersetzt werden muss.

## Attachment wurde noch nicht hinzugefügt

**Fehlerbild:** `Upload erneut prüfen` meldet, dass noch kein GitHub-Attachment gefunden wurde.

**Nächster Schritt:** `GitHub öffnen`, die vorgesehene Bild- oder PDF-Datei als Attachment zu einem Kommentar hinzufügen, den Kommentar **absenden**, zur App zurückkehren und erneut prüfen.

## Mehrere unerwartete Attachments

**Fehlerbild:** Die Prüfung findet mehr als ein Attachment.

**Nächster Schritt:** Im Pending-Issue nur das für diese Quelle vorgesehene Attachment belassen beziehungsweise einen eindeutigen Kommentar verwenden und erneut prüfen. Die App setzt solange kein `quelle`-Label.

## Pending-Upload erst später fortsetzen

Der Pending-Zustand wird lokal geschützt gespeichert. Ein Dokument-Upload kann später über die Dokument-Quelle wieder geöffnet werden. Die Eingaben und die temporäre Datei bleiben bis Abschluss oder bewusstem Verwerfen erhalten.

## Nicht unterstützter Share-Dateityp

**Fehlerbild:** Die App nennt beispielsweise `application/zip` als nicht unterstützten Dateityp.

**Nächster Schritt:** Keine Quelle wurde erzeugt. Verwende eine vom aktuellen Wiki-Vertrag unterstützte Quellenart oder erfasse die relevanten Informationen als Text/Link, sofern dies fachlich wirklich der Quelle entspricht.

## Import-Workflow nicht erreichbar

**Fehlerbild:** Der Verbindungstest oder `Quellen ins Wiki importieren` kann den Workflow nicht lesen beziehungsweise starten.

**Nächster Schritt:** `Import-Workflow` auf den korrekten Dateinamen prüfen und sicherstellen, dass der Wiki-PAT `Actions: Read and write` besitzt.

## Sicherheitsregel bei allen Fehlern

Fehlermeldungen niemals durch Einfügen eines echten Tokens in Issue, Screenshot oder Chat „debuggen“. Ein möglicherweise offengelegter PAT wird auf GitHub widerrufen und ersetzt.
