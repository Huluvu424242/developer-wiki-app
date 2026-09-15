# UX und Barrierefreiheit

Barrierefreiheit ist Bestandteil jeder einzelnen GUI-Story und keine ausschließlich nachgelagerte Querschnittsaufgabe. Spätere Gesamtprüfungen dürfen die sofort umsetzbaren Grundlagen nicht ersetzen.

## In jeder GUI-Story

- Interaktive Elemente erhalten verständliche sichtbare Bezeichnungen oder eindeutige semantische Beschriftungen; Icon-Schaltflächen insbesondere Tooltip beziehungsweise Semantics-Label.
- Touch-Ziele werden ausreichend groß ausgelegt; primäre Aktionen bleiben mit Abstand zu Bildschirmrand, Systemgesten, Bildschirmtastatur und temporären Meldungen erreichbar.
- Layouts sind scroll- und umbruchfähig. Große Systemschrift und kleine Android-Bildschirme dürfen Kerninhalte oder Aktionen nicht abschneiden oder überlagern.
- Information wird nicht ausschließlich über Farbe, Position, Form oder unbeschriftete Symbole vermittelt.
- Lade-, Leer-, Erfolgs- und Fehlerzustände sind verständlich und semantisch wahrnehmbar; behebbare Fehler bieten eine sinnvolle nächste Aktion.
- Nutzereingaben und Entwürfe bleiben bei Validierungs-, Netzwerk- und Navigationsfehlern nach Möglichkeit erhalten.
- Fokusreihenfolge und Tastaturaktivierung werden sinnvoll angelegt. Offensichtliche Fokusfallen und ausschließlich gestenbasierte Bedienwege ohne zugängliche Alternative sind unzulässig.
- Passende Widget- und Semantiktests werden ergänzt, soweit Flutter die Anforderung automatisiert prüfen kann.

Manuelle Prüfungen mit TalkBack, extremer Systemschrift, realem Gerät und gegebenenfalls Tastatur- oder Schalterbedienung dürfen gebündelt werden. Sie ersetzen die sofort umsetzbaren Grundlagen nicht.

## Validierung und Fehlersammler

- Validierungsfehler werden am betroffenen Feld und zusätzlich in einem fokussierbaren Fehlersammler am Anfang des Inhalts angezeigt.
- Jeder Eintrag benennt den Fehler verständlich und ist als Link beziehungsweise fokussierbare Aktion zum zugehörigen invaliden Feld ausgeführt.
- Beim Aktivieren wird das Feld sichtbar gemacht und der Eingabefokus dorthin gesetzt.
- Der Fehlersammler ersetzt nie die feldnahe Fehleranzeige.
- Werden durch eine Aktion Validierungsfehler sichtbar, erscheinen immer zugleich eine kurze wahrnehmbare Hinweismeldung und ein barrierefreier Fokus-/Scrollwechsel zum Fehlersammler beziehungsweise ersten Fehler.
- In lazy aufgebauten Formularen darf die Navigation nicht allein davon abhängen, dass der Fehlersammler bereits einen `BuildContext` oder `GlobalKey.currentContext` besitzt. Wird er erst nach der Validierung am Inhaltsanfang eingefügt, wird der Scrollbereich zunächst kontrolliert an den Anfang bewegt, der folgende Frame abgewartet und erst danach Fokus beziehungsweise Semantik auf den Fehlersammler gesetzt.

## Vollständige Validierung lazy aufgebauter Formulare

- Die vollständige fachliche Validierung eines scrollbaren oder lazy aufgebauten Formulars hängt nicht ausschließlich von `FormState.validate()` oder aktuell gemounteten `FormField`-Widgets ab.
- Außerhalb des Viewports liegende Felder können aus dem Widgetbaum entfernt sein. Die Speicherlogik prüft deshalb alle fachlich relevanten Controller- beziehungsweise Modellwerte unabhängig von ihrer aktuellen Sichtbarkeit.
- Feldvalidatoren bleiben zusätzlich für die lokale Fehleranzeige zuständig.
- Widgettests lösen die Speicheraktion auch aus einer Position am Formularende aus und weisen nach, dass Fehler in nicht sichtbaren Feldern erkannt werden.

## Scrollbereiche in Widgettests

- Widgettests unterscheiden zwischen Existenz im Widgetbaum und Sichtbarkeit im Viewport.
- `ensureVisible()` wird nur für bereits gemountete Widgets verwendet.
- Kann ein lazy erzeugtes Ziel außerhalb des Viewports noch nicht aufgebaut sein, wird zunächst mit `scrollUntilVisible()`, kontrollierten Drag-Schritten oder einem gleichwertigen Verfahren gescrollt, bis das Ziel erzeugt und sichtbar ist.
- Erst danach wird der Finder dereferenziert oder das Widget aktiviert.
- Tests warten bevorzugt zustandsbasiert auf erwartete Änderungen; feste Wartezeiten sind nur als begrenzendes Timeout oder kleine Polling-Schritte zulässig.

## Aktionsbereich

- Primäre Aktionen stehen am unteren Ende der Seite oder des Dialogs, aber nicht unmittelbar am Bildschirmrand.
- Unterhalb bleibt ausreichend Platz für temporäre Meldungen, Systemeinblendungen und Bedienhilfen.
- Aktionen dürfen nicht durch Snackbars, Toasts, Tooltips, Bildschirmränder, Gestennavigation oder Bildschirmtastatur verdeckt werden.

## Über und Barrierefreiheit

- Die App besitzt eine dauerhaft und offline erreichbare Barrierefreiheitserklärung mit aktuellem Stand, bekannten Barrieren und einem barrierefrei nutzbaren Kontakt- oder Meldeweg.
- Die App besitzt einen Menüpunkt `Über`.
- Der About-Dialog zeigt App-Name sowie installierte Releaseversion einschließlich Buildnummer und enthält eindeutig beschriftete Zugänge zur Barrierefreiheitserklärung sowie zu vorhandenen Supportzielen.
- Paketinformationen und das Öffnen externer Ziele liegen hinter kleinen testbaren Plattformabstraktionen, damit Widgettests Fakes verwenden können.
- Fehler bei Versionsermittlung oder externem Öffnen werden verständlich behandelt; Dialog und bereits eingegebene Daten bleiben erhalten.

## Bugreport

- Auf jeder Seite und in jedem anwendungseigenen Dialog ist `Bug melden` barrierefrei erreichbar.
- Der Meldeweg zielt auf das App-Repository und verwendet das Label `bug`.
- Aktueller Screen beziehungsweise Dialog und installierte Releaseversion einschließlich Buildnummer werden als eindeutiger fachlicher Kontext vorbelegt.
- Generische Kontexte wie nur `Dialog` oder derselbe Wert für fachlich verschiedene Abläufe sind unzulässig.
- `Fehlerart` ist eine zunächst nicht vorbelegte Pflichtauswahl; ein Platzhalter gilt nicht als gültige Auswahl.
- Mindestens `Barrierefreiheitsfehler` und `Sonstiges` sind auswählbar.
- Der Freitext ist auf 2000 Zeichen begrenzt.
- Beschriftungen, Hilfetexte, Pflichtstatus, Validierungsfehler und Bedienelemente sind für Screenreader semantisch eindeutig.
- Logs, Zugangsdaten, Nutzerdaten, Gerätekennungen oder sonstige Diagnosedaten werden nicht automatisch an den Bugreport angehängt oder übertragen.
- Vor dem externen Öffnen wird lokal validiert; Fehler beim Öffnen des Zielsystems werden verständlich behandelt, ohne Eingaben zu verlieren oder Erfolg vorzutäuschen.

## Eingabefelder

- Jedes Eingabefeld besitzt eine fachlich festgelegte maximale Zeichenlänge und einen Zeichenzähler.
- Sobald nur noch zehn Zeichen bis zur Grenze verbleiben, wird der Zähler sichtbar und bleibt bis zur Grenze eingeblendet; Screenreader geben `noch x Zeichen` aus.
- Nach Eingabe des letzten zulässigen Zeichens ertönt ein akustisches Signal und assistive Technologien geben `Kein Zeichen mehr möglich` aus.
- Das akustische Signal ist nie die einzige Rückmeldung; sichtbarer Zähler und semantische Textausgabe bleiben erforderlich.
- Weitere Zeichen werden verhindert, ohne bereits eingegebenen Text zu verlieren.
- Die Grenzrückmeldung wird pro Grenzerreichung nicht bei jedem weiteren Eingabeversuch ununterbrochen wiederholt.
