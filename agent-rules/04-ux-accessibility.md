# UX und Barrierefreiheit

Für alle Screens, Seiten, Formulare und Dialoge gelten diese Regeln verbindlich.

## Validierung

- Validierungsfehler werden am betroffenen Feld und zusätzlich in einem Fehlersammler am Anfang des Inhalts angezeigt.
- Jeder Eintrag benennt den Fehler verständlich und ist als Link beziehungsweise fokussierbare Aktion zum zugehörigen invaliden Feld ausgeführt.
- Beim Aktivieren wird das Feld sichtbar gemacht und der Eingabefokus dorthin gesetzt.
- Der Fehlersammler ersetzt nie die feldnahe Fehleranzeige.
- Werden durch eine Aktion Validierungsfehler sichtbar, erscheinen immer zugleich eine kurze temporäre Hinweismeldung und ein barrierefreier Fokus-/Scrollwechsel zum Fehlersammler.
- Hinweismeldung und Fokuswechsel müssen für assistive Technologien wahrnehmbar sein.

## Aktionsbereich

- Primäre Aktionen stehen am unteren Ende der Seite oder des Dialogs, aber nicht unmittelbar am Bildschirmrand.
- Unterhalb bleibt ausreichend Platz für temporäre Meldungen, Systemeinblendungen und Bedienhilfen.
- Aktionen dürfen nicht durch Snackbars, Toasts, Tooltips, Bildschirmränder, Gestennavigation oder Bildschirmtastatur verdeckt werden.

## Über und Barrierefreiheit

- Die App besitzt eine dauerhaft erreichbare Barrierefreiheitserklärung mit aktuellem Stand, bekannten Barrieren und einem barrierefrei nutzbaren Kontakt- oder Meldeweg.
- Die App besitzt einen Menüpunkt `Über`.
- Der About-Dialog zeigt die installierte Releaseversion und enthält eine eindeutig beschriftete Schaltfläche zur Barrierefreiheitserklärung.

## Bugreport

- Auf jeder Seite und in jedem anwendungseigenen Dialog ist `Bug melden` barrierefrei erreichbar.
- Der Meldeweg zielt auf das App-Repository und verwendet das Label `bug`.
- Aktueller Screen beziehungsweise Dialog und installierte Releaseversion werden als Kontext vorbelegt.
- `Fehlerart` ist eine zunächst nicht vorbelegte Pflichtauswahl; ein Platzhalter gilt nicht als gültige Auswahl.
- Mindestens `Barrierefreiheitsfehler` und `Sonstiges` sind auswählbar.
- Der Freitext ist auf 2000 Zeichen begrenzt.
- Beschriftungen, Hilfetexte, Pflichtstatus, Validierungsfehler und Bedienelemente sind für Screenreader semantisch eindeutig.
- Zugangsdaten, Tokens oder sonstige Secrets dürfen vor Öffnen oder Übermitteln nicht in den Bugreport übernommen werden.

## Eingabefelder

- Jedes Eingabefeld besitzt eine fachlich festgelegte maximale Zeichenlänge und einen Zeichenzähler.
- Sobald nur noch zehn Zeichen bis zur Grenze verbleiben, wird der Zähler sichtbar und bleibt bis zur Grenze eingeblendet; Screenreader geben `noch x Zeichen` aus.
- Nach Eingabe des letzten zulässigen Zeichens ertönt ein akustisches Signal und assistive Technologien geben `Kein Zeichen mehr möglich` aus.
- Das akustische Signal ist nie die einzige Rückmeldung; sichtbarer Zähler und semantische Textausgabe bleiben erforderlich.
- Weitere Zeichen werden verhindert, ohne bereits eingegebenen Text zu verlieren.
- Die Grenzrückmeldung wird pro Grenzerreichung nicht bei jedem weiteren Eingabeversuch ununterbrochen wiederholt.

## Allgemein

- Mobile Bedienbarkeit, verständliche Beschriftungen, ausreichende Touch-Ziele, sinnvolle Semantik und gute Bedienbarkeit mit vergrößerter Schrift werden bei jeder GUI-Änderung berücksichtigt.
- Zustände dürfen nicht ausschließlich über Farbe vermittelt werden.
