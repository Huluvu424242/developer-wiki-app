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
    - Die Dokumentationspflichten aus dem Abschnitt `Dokumentationspflege bei Änderungen` einhalten.

4. Einen Pull Request erstellen.
   Der PR soll:
    - auf das zuvor erstellte Issue verweisen und die Regeln aus `Verknüpfung von Pull Requests mit Stories und Bugs` einhalten,
    - Ursache und Lösung kurz erklären,
    - die durchgeführten Prüfungen nennen,
    - verbleibende Unsicherheiten ausdrücklich erwähnen,
    - angeben, welche Dokumentationsartefakte aktualisiert wurden oder warum keine Aktualisierung erforderlich war.

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

8. Lizenzrechtlich relevante, im Produkt verwendete und mit dem Produkt ausgelieferte Bestandteile prüfen und dokumentieren.
    - Für neue oder geänderte fremde Komponenten und Inhalte prüfen, ob sie lizenzrechtlich relevant sind und mit dem Produkt verwendet sowie ausgeliefert werden. Dazu zählen insbesondere Laufzeitabhängigkeiten, Bibliotheken, Frameworks, Logos, Bilder, Schriften, Audioinhalte und sonstige Assets.
    - Jeder solche Bestandteil muss zwingend mit Herkunft, Rechteinhaber, Lizenz, betroffenen Dateien bzw. Verwendungszweck und gegebenenfalls einzuhaltenden Bedingungen in `ATTRIBUTIONS.md` eingetragen oder dort aktualisiert werden.
    - Vor der Aufnahme prüfen, ob die Lizenzbedingungen mit der MIT-Lizenz des Projekts vereinbar sind und der selbst entwickelte Projektcode weiterhin unter MIT veröffentlicht werden kann.
    - Wenn die MIT-Lizenz wegen der Aufnahme eines Bestandteils geändert oder aufgegeben werden müsste, darf dies nicht stillschweigend erfolgen. Die Auswirkung ist im Pull Request ausdrücklich zu dokumentieren und der menschliche Entwickler muss nach Erstellung des Pull Requests zusätzlich zwingend und unmissverständlich darauf hingewiesen werden.

9. Die Umsetzung prüfen.
    - Akzeptanzkriterien der Story gegen die Implementierung prüfen.
    - `dart format` auf geänderten Dart-Dateien ausführen.
    - `flutter analyze` ausführen und keine neuen Fehler oder Warnungen hinterlassen.
    - Geeignete Unit-, Widget- oder Integrationstests ergänzen bzw. ausführen, soweit dies für die Story sinnvoll ist.
    - Fachliche Logik möglichst durch Unit Tests, relevante UI-Verhalten durch Widget Tests und wichtige Integrationspfade durch geeignete Integrationstests absichern.
    - Tests nicht durch beliebige feste Wartezeiten synchronisieren. Wenn möglich auf das Erscheinen oder Verschwinden des erwarteten Zustands bzw. Widgets warten. Feste Zeitwerte nur als begrenzendes Timeout oder als kleine Polling-Schritte verwenden, nicht als eigentliche Erfolgsbedingung des Tests.
    - Die Dokumentationspflichten aus dem Abschnitt `Dokumentationspflege bei Änderungen` prüfen und erfüllen.

10. Einen Pull Request erstellen.
    - Der PR verweist auf die Story und hält die Regeln aus `Verknüpfung von Pull Requests mit Stories und Bugs` ein.
    - Der PR beschreibt kurz Umsetzung, wesentliche Architekturentscheidungen und durchgeführte Prüfungen.
    - Abweichungen von Akzeptanzkriterien oder verbleibende Unsicherheiten ausdrücklich nennen.
    - Keine Story als vollständig umgesetzt darstellen, wenn Akzeptanzkriterien noch offen sind.
    - Der PR nennt explizit, welche Dokumentationsartefakte aktualisiert wurden oder warum keine Aktualisierung notwendig war.

11. Dem Benutzer anschließend den Pull Request verlinken.
    - Kurz erläutern, was umgesetzt wurde.
    - Die durchgeführten Prüfungen nennen.
    - Auf offene Punkte oder notwendige lokale Prüfungen hinweisen.

## Verknüpfung von Pull Requests mit Stories und Bugs

Für jeden Pull Request, der eine Story umsetzt oder einen Bug behebt, gelten folgende Regeln verbindlich:

1. Der Pull Request muss alle Stories und Bugs explizit referenzieren, die durch seine Änderungen umgesetzt oder behoben werden.
    - Die Referenzen gehören in die Pull-Request-Beschreibung und müssen die konkreten Issue-Nummern enthalten.
    - Bei mehreren betroffenen Issues müssen alle relevanten Issues aufgeführt werden.

2. Vollständig erledigte Issues müssen beim Merge automatisch geschlossen werden.
    - Für jedes durch den Pull Request vollständig erledigte Issue muss ein von GitHub unterstütztes Closing-Keyword verwendet werden, zum Beispiel `Closes #123`, `Fixes #123` oder `Resolves #123`.
    - Wenn mehrere Issues vollständig erledigt werden, muss jedes dieser Issues mit einem Closing-Keyword referenziert werden.
    - Das Closing-Keyword muss in der Pull-Request-Beschreibung stehen, damit GitHub die Verknüpfung sichtbar macht und das Issue beim Merge automatisch schließen kann.

3. Closing-Keywords dürfen nur bei vollständiger Erledigung verwendet werden.
    - Wenn eine Story oder ein Bug durch den Pull Request nur teilweise umgesetzt bzw. behoben wird, darf dafür kein Closing-Keyword verwendet werden.
    - Solche teilweise betroffenen Issues müssen dennoch normal referenziert werden, zum Beispiel mit `Related to #123` oder `Part of #123`.
    - Sobald ein späterer Pull Request die verbleibenden Akzeptanzkriterien bzw. den Bug vollständig erledigt, muss dieser Pull Request das Closing-Keyword enthalten.

4. Vor dem Erstellen oder Aktualisieren eines Pull Requests ist die Issue-Verknüpfung zu prüfen.
    - Es darf kein Pull Request als bereit gemeldet werden, wenn vollständig erledigte Stories oder Bugs nicht mit einem Closing-Keyword verknüpft sind.
    - Bei gestapelten Pull Requests gilt die Regel für jedes Issue in dem Pull Request, in dem es fachlich vollständig erledigt wird; ein Eltern- oder Folge-PR darf dasselbe Issue nicht irrtümlich erneut schließen.

## Dokumentationspflege bei Änderungen

Diese Regeln gelten verbindlich für Features, Bugfixes und sonstige Anpassungen an den Sourcen oder der technischen Infrastruktur:

1. `CHANGELOG.md` in der Projektroot nach [Keep a Changelog 1.1.0](https://keepachangelog.com/de/1.1.0/) pflegen.
    - Nutzer- oder maintainerrelevante Änderungen unter `Unreleased` eintragen.
    - Passende Kategorien wie `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed` und `Security` verwenden.
    - Keine Commit-Historie als Changelog wiederholen; Änderungen menschenlesbar beschreiben.
    - Releases in umgekehrt chronologischer Reihenfolge mit ISO-Datum dokumentieren und Vergleichslinks soweit sinnvoll pflegen.

2. `README.md` nach der [Standard-Readme-Spezifikation](https://github.com/RichardLitt/standard-readme/blob/main/spec.md) pflegen.
    - README aktualisieren, wenn Einstieg, Installation, Nutzung, Sicherheit, Release oder Navigation in die Dokumentation betroffen sind.
    - Die README bleibt die kompakte Einstiegsseite und verlinkt direkt auf die weiterführende Dokumentation unter `docs/`.

3. Weiterführende Projektdokumentation unter `docs/` pflegen.
    - Markdown ist das Standardformat.
    - Geeignete Diagramme bevorzugt als Mermaid versionieren; SVG ist für Diagramme und Grafiken zulässig, wenn Mermaid nicht zweckmäßig ist.
    - Architekturübersichten und Architekturdiagramme nach dem C4-Modell strukturieren.
    - Nur Dokumentation und Diagramme anlegen, die einen konkreten aktuellen Nutzen haben; keine Architektur auf Vorrat dokumentieren.

4. Bei jeder Änderung prüfen, ob bestehende Dokumentation betroffen ist.
    - Änderungen an Architektur, Integrationen, Persistenz, Abläufen oder externen Schnittstellen aktualisieren die zugehörigen Markdown-, Mermaid-, SVG- und C4-Artefakte im selben Pull Request.
    - Wenn keine Dokumentationsaktualisierung erforderlich ist, muss der Pull Request dies kurz begründen.

## Rebase und Aktualisierung von Arbeitsbranches

Rebase darf verwendet werden, um einen Story-, Bugfix- oder sonstigen Arbeitsbranch vor dem Merge auf den aktuellen Stand von `master` zu bringen. Dabei gelten folgende Regeln:

1. `master` selbst wird niemals rebased oder anderweitig durch History-Rewriting verändert.
    - Rebase findet ausschließlich auf Arbeitsbranches statt.
    - Ein bereits gemergter Branch wird nicht nachträglich rebased.

2. Vor einem Rebase den aktuellen Zielstand und den Branch-Kontext prüfen.
    - Zuerst den aktuellen Stand von `master` abrufen und sicherstellen, dass der richtige Arbeitsbranch aktiv ist.
    - Prüfen, ob der Branch ausschließlich zu dem eigenen Pull Request gehört oder von anderen Personen bzw. Automationen mitverwendet wird.
    - Einen geteilten oder von anderen aktiv verwendeten Branch nicht ohne ausdrückliche Zustimmung rebasen, da Rebase die Commit-Historie umschreibt.

3. Rebase bevorzugen, wenn ein Arbeitsbranch vor dem Merge hinter `master` liegt und eine lineare Historie sinnvoll ist.
    - Den Arbeitsbranch auf den aktuellen `master` rebasen, statt unnötige Merge-Commits nur zur Branch-Aktualisierung zu erzeugen.
    - Rebase nicht als Selbstzweck verwenden; wenn kein Aktualisierungsbedarf besteht, ist kein Rebase erforderlich.

4. Konflikte bewusst und nachvollziehbar auflösen.
    - Bei jedem Konflikt prüfen, welche Änderung fachlich erhalten bleiben muss.
    - Konflikte nicht pauschal mit `ours` oder `theirs` auflösen, wenn dadurch fachliche Änderungen verloren gehen könnten.
    - Wenn die korrekte Auflösung unklar ist, Rebase abbrechen statt zu raten.
    - Nach Konfliktauflösung den Rebase vollständig abschließen und sicherstellen, dass keine Konfliktmarker im Repository verbleiben.

5. Nach einem Rebase die betroffenen Prüfungen erneut ausführen.
    - Mindestens die für die Story oder den Bugfix relevanten Tests und statischen Prüfungen wiederholen.
    - Bei Flutter-Änderungen insbesondere `dart format`, `flutter analyze` und die relevanten Tests erneut ausführen, sofern sie durch die Änderung betroffen sein können.
    - Der Pull Request darf nach einem Rebase erst als mergefähig betrachtet werden, wenn diese Prüfungen wieder erfolgreich sind.

6. Einen bereits veröffentlichten Arbeitsbranch nur kontrolliert aktualisieren.
    - Da Rebase Commit-SHAs verändert, darf ein bereits gepushter Branch nur mit einem sicheren Lease aktualisiert werden.
    - Dafür ausschließlich `git push --force-with-lease` verwenden.
    - `git push --force` ist für Arbeitsbranches dieses Projekts nicht zulässig.
    - Wenn `--force-with-lease` wegen zwischenzeitlicher fremder Änderungen fehlschlägt, diese Änderungen zuerst prüfen und nicht durch einen erzwungenen Push überschreiben.

7. Rebase und Branchschutz müssen zusammenpassen.
    - Der geschützte `master` wird ausschließlich über Pull Requests verändert.
    - Force Pushes auf `master` bleiben durch das Ruleset verboten.
    - History-Rewriting ist nur auf dem zugehörigen Arbeitsbranch und nur nach den oben genannten Regeln zulässig.

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

Story prüfen → Branch → Implementierung entlang der Architekturleitplanken → Tests, Analyse und Dokumentationspflege → Pull Request → Rückmeldung
