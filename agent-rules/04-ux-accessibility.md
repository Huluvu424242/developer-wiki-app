# UX und Barrierefreiheit

Für alle Screens, Seiten, Formulare und Dialoge gelten diese Regeln.

## Validierung

- Fehler werden am Feld und zusätzlich in einem Fehlersammler am Anfang des Inhalts angezeigt.
- Jeder Eintrag benennt Feld und Fehler verständlich, ist fokussierbar und führt sichtbar zum betroffenen Feld.
- Der Fehlersammler ersetzt nie die feldnahe Fehleranzeige.
- Nach einer fehlgeschlagenen Aktion werden zugleich ein kurzer Hinweis angezeigt und Fokus beziehungsweise Scrollposition barrierefrei zum Fehlersammler geführt.

## Aktionsbereich

- Primäre Aktionen stehen am unteren Ende, aber nicht unmittelbar am Bildschirmrand.
- Unterhalb bleibt Platz für Meldungen, Safe Area, Bedienhilfen und Tastatur; Aktionen dürfen dadurch nicht verdeckt werden.

## Über und Barrierefreiheit

- Die App besitzt eine dauerhaft erreichbare Barrierefreiheitserklärung mit aktuellem Stand, bekannten Barrieren und Meldeweg.
- Der Menüpunkt `Über` zeigt die installierte Releaseversion und verlinkt die Barrierefreiheitserklärung.

## Bugreport

- Auf jeder Seite und in jedem anwendungseigenen Dialog ist `Bug melden` barrierefrei erreichbar.
- Der Bericht zielt auf das App-Repository und verwendet das Label `bug`.
- Screen beziehungsweise Dialog und installierte Releaseversion werden als Kontext vorbelegt.
- `Fehlerart` ist eine zunächst unvorbelegte Pflichtauswahl mit mindestens `Barrierefreiheitsfehler` und `Sonstiges`.
- Der Freitext ist auf 2000 Zeichen begrenzt.
- Beschriftungen, Hilfetexte, Pflichtstatus, Fehler und Bedienelemente sind semantisch eindeutig.
- Vertrauliche Zugangsdaten dürfen nicht in den Bericht übernommen werden.

## Eingabefelder

- Jedes Eingabefeld besitzt eine fachlich festgelegte maximale Zeichenlänge.
- Bei zehn oder weniger verbleibenden Zeichen wird ein sichtbarer Restzähler eingeblendet; Screenreader geben `noch x Zeichen` aus.
- Am letzten zulässigen Zeichen erfolgen ein akustisches Signal und die semantische Meldung `Kein Zeichen mehr möglich`.
- Das Signal ist nie die einzige Rückmeldung; weitere Zeichen werden ohne Textverlust verhindert.
- Die Grenzrückmeldung wird pro Grenzerreichung nicht bei jedem weiteren Eingabeversuch wiederholt.

## Allgemein

- Mobile Bedienbarkeit, verständliche Beschriftungen, ausreichende Touch-Ziele, sinnvolle Semantik und große Systemschrift werden bei jeder GUI-Änderung berücksichtigt.
- Zustände dürfen nicht ausschließlich über Farbe vermittelt werden.
