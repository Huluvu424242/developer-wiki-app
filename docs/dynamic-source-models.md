# Dynamische Quellenmodelle

## Zweck

Die Developer-Wiki-App lädt die angebotenen Quellenarten und Formularfelder nicht mehr ausschließlich aus fest verdrahtetem App-Code. Beim Start mit vollständiger Wiki-Konfiguration liest sie den versionierten Quellen-Erfassungsvertrag `src/config/source-capture.json` aus dem konfigurierten Developer-Wiki.

Der Vertrag wird vom Wiki gepflegt und enthält Schema-Version, Quellenarten, Felddefinitionen, Pflichtstatus, Auswahlwerte, Defaultwerte und erforderliche Client-Fähigkeiten. Dadurch können sich Wiki und App kontrolliert gemeinsam weiterentwickeln.

## Kompatibilität und Fallback

Die App unterstützt derzeit `schemaVersion: 1` und die Client-Fähigkeit `guided-github-issue-image-attachment-v1`.

Beim Laden gilt folgende Reihenfolge:

1. aktuellen Vertrag über die GitHub Contents API aus `master` lesen und strikt validieren;
2. bei Erfolg den Rohvertrag als letzten gültigen Stand lokal speichern;
3. bei Netzwerkfehler oder inkompatiblem aktuellen Vertrag den letzten gültigen Cache verwenden;
4. wenn auch kein gültiger Cache vorhanden ist, die mit der App ausgelieferte kompatible Rückfall-Definition verwenden.

Ein unbekannter Schema-Stand, eine unbekannte Feldart oder eine unbekannte erforderliche Transportfähigkeit wird **nicht** stillschweigend auf ein Textfeld oder einen anderen Ablauf reduziert. Der Nutzer erhält bei Cache- oder Bundle-Fallback einen sichtbaren Hinweis.

Der Cache ist repositorybezogen und wird über denselben geschützten Android-Speichermechanismus wie die App-Konfiguration gehalten. Ein inkompatibler Remote-Vertrag überschreibt keinen zuvor gültigen Cache.

## Bildquellen

Der dynamische Vertrag beschreibt den bereits vorhandenen geführten Bildquellen-Ablauf mit der Fähigkeit `guided-github-issue-image-attachment-v1`. Die App verwendet auch für dynamisch geladene Bildfelder denselben zentralen Uploadpfad:

- genau ein PNG, GIF oder JPEG bis 10 MiB;
- lokaler Datei-/Share-Einstieg und Vorschau;
- vorläufiges Issue noch ohne `quelle`;
- Upload über die normale GitHub-Weboberfläche;
- Rücklesen der stabilen GitHub-Attachment-Referenz;
- Aktualisieren des Issue-Bodys;
- erst danach Label `quelle` setzen.

Kurzlebige signierte Download-URLs sind weder Bestandteil des Client-Vertrags noch persistenter App-Zustand.

Der aktuelle Wiki-Import erkennt Anhänge formatbasiert. Das Präfix `[Bild-Quelle]` bleibt eine komfortable App-Erfassungsart, ist aber keine technische Voraussetzung des Wiki-Imports.

## GitHub-Zugang und Token-Grenze

Für ein privates Wiki benötigt der in der App konfigurierte Fine-grained PAT nun zusätzlich **Contents: Read-only**, damit `src/config/source-capture.json` gelesen werden kann. Die bisher benötigten Rechte für Issues und Actions bleiben davon unberührt.

Der Button **„Verbindung testen“** prüft deshalb nicht nur Anmeldung und Repository-Zugriff, sondern liest und validiert auch genau diesen Quellen-Erfassungsvertrag. Erst wenn dieser Zugriff funktioniert, gilt die Verbindung als erfolgreich geprüft. Liefert GitHub dabei HTTP 403, weist die App konkret auf das benötigte Recht `Contents: Read-only` hin.

Die Wiki-internen Secrets `SOURCE_IMAGE_TOKEN` und `SOURCE_ATTACHMENT_TOKEN` gehören ausschließlich zu den GitHub-Actions des Developer-Wikis. Sie werden von der App weder benötigt noch gelesen. Insbesondere macht die Classic-PAT-Anforderung des Wiki-internen privaten Dokumentdownloads keinen Classic PAT für die App erforderlich.

## Verantwortungsgrenze

Die App lädt und rendert die Erfassungsdefinition und erzeugt die dazugehörigen GitHub-Issues. Import, Attachment-Download, Quellarchivierung und Wissenseinarbeitung bleiben vollständig Aufgaben des Developer-Wikis.
