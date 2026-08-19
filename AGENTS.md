# Arbeitsregeln für KI-Assistenten

## Fehlerbehebung

Wenn der Benutzer einen Fehler meldet und um Behebung bittet, ist grundsätzlich folgender Ablauf einzuhalten:

1. Das Repository zunächst analysieren.
    - Für GitHub-Zugriffe ausschließlich den verbundenen GitHub-Connector verwenden.
    - Relevante Dateien, Konfigurationen, Abhängigkeiten und bestehende Issues/PRs prüfen.
    - Die wahrscheinlichste Ursache nachvollziehbar bestimmen.
    - Keine Codeänderungen vor Abschluss dieser Analyse vornehmen.

2. Nach der Analyse ein GitHub-Issue erstellen.
   Das Issue soll mindestens enthalten:
    - beobachtetes Fehlerbild,
    - bekannte Fehlermeldung,
    - Analyseergebnisse,
    - identifizierte oder vermutete Ursache,
    - betroffene Dateien bzw. Komponenten,
    - geplanten Lösungsansatz.

3. Erst danach die Fehlerbehebung umsetzen.
    - Einen eigenen Branch für die Änderung erstellen.
    - Nur Änderungen vornehmen, die zur Behebung des Fehlers erforderlich sind.
    - Bestehendes Verhalten soweit möglich unverändert lassen.
    - Geeignete Tests oder Prüfungen ergänzen bzw. ausführen.

4. Einen Pull Request erstellen.
   Der PR soll:
    - auf das zuvor erstellte Issue verweisen,
    - Ursache und Lösung kurz erklären,
    - die durchgeführten Prüfungen nennen,
    - verbleibende Unsicherheiten ausdrücklich erwähnen.

5. Dem Benutzer anschließend den Pull Request verlinken.
   Zusätzlich kurz mitteilen:
    - was die Ursache war,
    - was geändert wurde,
    - was der Benutzer nach dem Merge lokal prüfen sollte.

## Story-Erstellung und Planung

Wenn der Benutzer neue Funktionen, fachliche Anforderungen oder größere Erweiterungen planen und als Stories erfassen möchte, ist grundsätzlich folgender Ablauf einzuhalten:

1. Das Repository und den fachlichen Kontext zunächst analysieren.
    - Für GitHub-Zugriffe ausschließlich den verbundenen GitHub-Connector verwenden.
    - Bestehende Architektur, Dokumentation, Issues, Pull Requests, Labels und Milestones prüfen, soweit sie für die Planung relevant sind.
    - Bereits vorhandene Funktionen und Stories berücksichtigen, damit keine unnötigen Doppelungen entstehen.
    - Vor der Story-Erstellung noch keine Implementierung vornehmen.

2. Die Anforderungen in sinnvoll geschnittene Stories aufteilen.
    - Jede Story soll einen klar abgegrenzten, nachvollziehbaren Nutzer- oder Produktwert liefern.
    - Stories sollen weder unnötig groß noch künstlich kleinteilig sein.
    - Technische Vorarbeiten dürfen als eigene Story erfasst werden, wenn sie einen klaren Zweck für nachfolgende Funktionen haben.
    - Abhängigkeiten und eine sinnvolle Umsetzungsreihenfolge zwischen Stories ausdrücklich benennen.

3. Sinnvolle Milestones definieren und die Stories zuordnen.
    - Milestones sollen fachlich zusammengehörige Entwicklungsziele bündeln, zum Beispiel eine erste nutzbare Version oder einen klar abgegrenzten Ausbauzustand.
    - Bestehende passende Milestones sollen wiederverwendet werden; neue Milestones nur anlegen, wenn dies für die Planung erforderlich ist.
    - Jede Story soll genau dem Milestone zugeordnet werden, in dem ihr Ergebnis erstmals benötigt wird.

4. Für jede Story ein GitHub-Issue erstellen.
    - Jede Story erhält das Label `story`.
    - Die Story soll mindestens enthalten:
        - Ziel und Nutzen,
        - fachliche Beschreibung,
        - konkrete Akzeptanzkriterien,
        - relevante Abhängigkeiten oder Vorbedingungen,
        - betroffene Bereiche oder Komponenten, soweit bereits erkennbar.
    - Technische Lösungsdetails nur so weit festlegen, wie sie für das gewünschte Verhalten oder notwendige Randbedingungen relevant sind.

5. Bei Stories mit neuen oder geänderten GUI-Ansichten ein einfaches Wireframe oder Mockup in die Story aufnehmen.
    - Das Wireframe soll die wesentlichen Bereiche, Bedienelemente und Navigationswege der Zielansicht zeigen.
    - Ein einfaches textbasiertes ASCII-Wireframe oder vergleichbares Markdown-Mockup ist ausreichend.
    - Das Wireframe dient der Verständigung über das Zielbild und ist keine pixelgenaue Designvorgabe.
    - Relevante Zustände wie leer, erfolgreich, Fehler oder Laden sollen dargestellt werden, wenn sie für die Story wesentlich sind.

6. Dem Benutzer anschließend die erstellten Milestones und Stories verlinken.
   Zusätzlich kurz mitteilen:
    - wie die Anforderungen geschnitten wurden,
    - welche Abhängigkeiten zwischen den Stories bestehen,
    - welche Story bzw. welcher Milestone als nächster sinnvoll umgesetzt werden sollte.

## Implementierung von Stories

Wenn der Benutzer die Umsetzung einer Story beauftragt, ist grundsätzlich folgender Ablauf einzuhalten:

1. Vor der Implementierung die Story und den aktuellen Repository-Stand analysieren.
    - Die zugehörige Story vollständig lesen und ihre Akzeptanzkriterien als verbindlichen Umfang behandeln.
    - Relevante Abhängigkeiten, bestehende Architektur, vorhandene Implementierungen und offene Pull Requests prüfen.
    - Keine zusätzlichen fachlichen Anforderungen stillschweigend in die Story aufnehmen.
    - Falls für die Umsetzung eine größere Vorarbeit oder ein umfangreiches Refactoring nötig wäre, dies als eigene Story behandeln statt den Umfang unbemerkt zu vergrößern.

2. Einen eigenen Branch für die Story verwenden.
    - Der Branch soll ausschließlich Änderungen enthalten, die für die Story erforderlich sind.
    - Unabhängige Refactorings, Aufräumarbeiten und andere Funktionen nicht beiläufig mit umsetzen.

3. Die Story entlang der bestehenden Architektur implementieren.
    - UI, fachliche Logik, Persistenz und externe Kommunikation klar voneinander trennen.
    - Screens und Widgets dürfen keine GitHub-API-Details, HTTP-Header oder API-Payloads selbst zusammensetzen.
    - GitHub-Zugriffe zentral über Services bzw. dafür vorgesehene Abstraktionen kapseln.
    - Secure Storage, Plattformintegration und andere technische Infrastruktur ebenfalls an klaren Schnittstellen halten.
    - Gemeinsame fachliche Abläufe nur einmal implementieren und von mehreren Einstiegspunkten wiederverwenden.

4. Während der Implementierung die Architekturleitplanken einhalten.
    - Mobile first: Bedienung, Navigation und Layout zuerst für kleine Touch-Geräte entwerfen; größere Displays anschließend sinnvoll mit unterstützen.
    - Möglichst barrierefrei: verständliche Beschriftungen, ausreichende Touch-Ziele, sinnvolle Semantik, keine ausschließlich farbbasierte Zustandsvermittlung und gute Bedienbarkeit mit vergrößerter Schrift berücksichtigen.
    - Leicht testbar: fachliche Logik möglichst unabhängig von konkreten Widgets und Plattformdetails halten; externe Abhängigkeiten so kapseln, dass sie in Tests ersetzt werden können.
    - Clean Code: sprechende Namen, kleine klar abgegrenzte Methoden und Klassen, geringe Kopplung und möglichst wenig versteckte Seiteneffekte.
    - Keine Architektur auf Vorrat: neue Frameworks, Schichten, Abstraktionen oder State-Management-Lösungen nur einführen, wenn ein konkreter Bedarf besteht.
    - Plattformneutral, wo sinnvoll: allgemeine Fachlogik in Dart/Flutter halten und Android-spezifische Funktionen klar isolieren.
    - Konfiguration statt Hardcoding: Wiki-Repository, Workflow-Informationen und andere nutzerspezifische Werte nicht unnötig fest im Code verdrahten; sinnvolle Defaults dürfen vorhanden sein, müssen aber überschreibbar bleiben.
    - Secrets niemals in Quellcode, Logs, Fehlermeldungen oder Testdaten einchecken.

5. Beim Codestyle folgende Regeln einhalten.
    - Dart- und Flutter-Konventionen sowie die bestehenden Linter-Regeln des Projekts befolgen.
    - Klassen in `UpperCamelCase`, Variablen und Funktionen in `lowerCamelCase`, Dateien in `snake_case.dart` benennen.
    - Namen sollen fachliche Absicht ausdrücken und unnötige Abkürzungen vermeiden.
    - `const` verwenden, wo dies sinnvoll ist.
    - Kontrollstrukturen mit geschweiften Klammern schreiben.
    - Keine unnötig langen oder komprimierten Codezeilen erzeugen.
    - Kommentare sollen vor allem das Warum erklären und nicht offensichtlichen Code wiederholen.
    - Strukturierte Daten bevorzugt über klar benannte Modelle statt über lose Maps durch mehrere Schichten reichen.

6. Fehler- und Zustandsbehandlung robust umsetzen.
    - Lade-, Erfolgs-, Leer- und Fehlerzustände sichtbar und verständlich behandeln, sofern sie für die Story relevant sind.
    - Eingaben des Nutzers bei Netzwerk- oder API-Fehlern nach Möglichkeit erhalten.
    - Relevante Fehler nicht still ignorieren und keine leeren `catch`-Blöcke verwenden.
    - Nach asynchronen Operationen bei UI-Zugriffen den Widget-Lebenszyklus beachten.
    - Mehrfachauslösung derselben Aktion während laufender Requests vermeiden, wenn dies zu doppelten Seiteneffekten führen könnte.

7. Abhängigkeiten sparsam einsetzen.
    - Neue Packages nur hinzufügen, wenn sie gegenüber Flutter-/Dart-Bordmitteln einen klaren Nutzen bieten.
    - Vor der Aufnahme Wartungszustand, Plattformunterstützung, Lizenz und tatsächlichen Bedarf prüfen.
    - Keine Bibliothek für triviale Funktionalität einführen, die mit wenig verständlichem Code ohne zusätzliche Abhängigkeit lösbar ist.

8. Die Umsetzung prüfen.
    - Akzeptanzkriterien der Story gegen die Implementierung prüfen.
    - `dart format` auf geänderten Dart-Dateien ausführen.
    - `flutter analyze` ausführen und keine neuen Fehler oder Warnungen hinterlassen.
    - Geeignete Unit-, Widget- oder Integrationstests ergänzen bzw. ausführen, soweit dies für die Story sinnvoll ist.
    - Fachliche Logik möglichst durch Unit Tests, relevante UI-Verhalten durch Widget Tests und wichtige Integrationspfade durch geeignete Integrationstests absichern.

9. Einen Pull Request erstellen.
    - Der PR verweist auf die Story.
    - Der PR beschreibt kurz Umsetzung, wesentliche Architekturentscheidungen und durchgeführte Prüfungen.
    - Abweichungen von Akzeptanzkriterien oder verbleibende Unsicherheiten ausdrücklich nennen.
    - Keine Story als vollständig umgesetzt darstellen, wenn Akzeptanzkriterien noch offen sind.

10. Dem Benutzer anschließend den Pull Request verlinken.
    - Kurz erläutern, was umgesetzt wurde.
    - Die durchgeführten Prüfungen nennen.
    - Auf offene Punkte oder notwendige lokale Prüfungen hinweisen.

## Architekturleitplanken

Für die Weiterentwicklung der App gelten zusätzlich folgende Leitplanken:

- Die App ist ein Client des persönlichen Developer-Wikis, nicht das Wiki selbst. Quellen erfassen, GitHub-Issues erzeugen und Wiki-Workflows auslösen gehören in die App; Importlogik, Archivierung und Wissensaufbereitung bleiben im Wiki-Repository.
- Eine fachliche Funktion soll einen zentralen Implementierungsweg besitzen. Unterschiedliche Einstiegspunkte wie normale Erfassung und Android-Share sollen dieselbe Fachlogik wiederverwenden.
- Abhängigkeiten sollen in eine klare Richtung laufen: UI verwendet Fachlogik und Services; Fachlogik und Services dürfen nicht von konkreten Screens abhängen.
- Datenmodelle sollen möglichst unabhängig von Flutter-Widgets und externen API-Formaten bleiben.
- Externe Systeme wie GitHub werden an den Rändern der Anwendung angebunden und nicht über die gesamte Codebasis verteilt.
- Die Architektur soll einfach genug bleiben, dass neue Entwickler oder KI-Assistenten den Daten- und Kontrollfluss ohne umfangreiche Einarbeitung nachvollziehen können.
- Wiederverwendbarkeit ist sinnvoll, aber kein Selbstzweck. Abstraktionen sollen erst entstehen, wenn mindestens ein konkreter Wiederverwendungs- oder Entkopplungsbedarf vorhanden ist.
- Mobile Bedienbarkeit, Barrierefreiheit und Testbarkeit sind Qualitätsmerkmale und sollen bereits beim Entwurf einer Story berücksichtigt werden, nicht erst nachträglich.

## Grundsatz

Ein gemeldeter Defekt soll nicht direkt „still“ repariert werden.
Die Reihenfolge lautet grundsätzlich:

Analyse → Issue → Implementierung → Prüfung → Pull Request → Rückmeldung

Neue Funktionen und größere Erweiterungen sollen nicht direkt aus einer groben Idee implementiert werden.
Die Reihenfolge für die Planung lautet grundsätzlich:

Analyse → Story-Schnitt → Milestones → Stories mit Akzeptanzkriterien und ggf. Wireframes → Rückmeldung

Die Umsetzung einer Story erfolgt grundsätzlich in dieser Reihenfolge:

Story prüfen → Branch → Implementierung entlang der Architekturleitplanken → Tests und Analyse → Pull Request → Rückmeldung
