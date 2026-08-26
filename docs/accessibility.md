# Barrierefreiheit und UX

Die Developer-Wiki-App setzt die verbindlichen UX- und
Barrierefreiheitsregeln aus der [AGENTS.md](../AGENTS.md) über gemeinsame,
wiederverwendbare Komponenten um.

## In der App verfügbare Hilfen

- Ein gemeinsames App-Menü bietet auf allen Screens **Bug melden** und **Über**.
- Der About-Dialog zeigt Releaseversion und Buildnummer der installierten App.
- Die Barrierefreiheitserklärung ist offline in der App verfügbar.
- Validierte Formulare zeigen Fehler direkt am Feld und zusätzlich in einem
  Fehlersammler am Anfang des Formulars.
- Ein Eintrag im Fehlersammler scrollt zum betroffenen Feld und setzt den Fokus.
- Nach fehlgeschlagener Validierung werden Snackbar, Fehlersammler und
  Fokuswechsel gemeinsam ausgelöst.
- Textfelder besitzen fachliche Maximallängen. Ab zehn verbleibenden Zeichen
  erscheint ein sichtbarer und semantischer Restzeichenzähler.
- Beim Erreichen einer Zeichengrenze werden eine sichtbare Meldung, eine
  Screenreader-Ansage und ein akustisches Signal kombiniert.
- Unter primären Aktionsbereichen bleibt Platz für Safe Area, Snackbars und
  andere temporäre Meldungen.

## Bugreports

Der Bugreport erfasst Fehlerart, optionalen Freitext, aktuellen Screen oder
Dialog sowie Releaseversion. Danach öffnet die App einen vorbereiteten
GitHub-Bugreport im Browser:

`https://github.com/Huluvu424242/developer-wiki-app/issues/new`

Der Nutzer kann die Meldung auf GitHub prüfen und endgültig absenden. Das in
der App gespeicherte PAT des persönlichen Developer-Wikis wird dafür weder
gelesen noch übertragen. Der Browserablauf setzt das Label `bug` über die
vorbereitete GitHub-URL.

Keine Logs, Tokens oder anderen Diagnosedaten werden automatisch beigefügt.

## Laufzeitermittlung der Version

Flutter liest Releaseversion und Buildnummer über den Android-MethodChannel
`developer_wiki/app_info`. Android liefert dafür die tatsächlich
installierten Paketinformationen. Der Zugriff ist hinter `AppInfoGateway`
gekapselt und kann in Widget-Tests durch einen Fake ersetzt werden.

## Pflege der Barrierefreiheitserklärung

Der in der App enthaltene Text muss bei jeder relevanten UX-/A11y-Änderung
geprüft werden. Insbesondere sind zu aktualisieren:

- Datum beziehungsweise Versionsstand der Prüfung,
- aktueller Umsetzungsstand,
- bekannte Barrieren,
- Meldeweg.

Neben automatisierten Widget-Tests bleibt eine manuelle Prüfung auf einem
Android-Gerät mit TalkBack, großer Schrift, Bildschirmtastatur und
Gestennavigation erforderlich.
