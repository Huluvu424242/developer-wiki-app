# Arbeitsregeln für KI-Assistenten

## Kommunikation mit menschlichen Entwicklern

Jegliche Kommunikation zwischen KI-Agenten und menschlichen Entwicklern erfolgt grundsätzlich in deutscher Sprache.

- Dies gilt insbesondere für direkte Rückmeldungen, Analysen, Planungen, Review-Rückmeldungen und Abschlussmeldungen sowie für vom KI-Agenten formulierte GitHub-Stories, Fehlerreports bzw. Bug-Issues, Pull-Request-Titel und Pull-Request-Beschreibungen.
- Technische Bezeichner, API-Namen, Dateinamen, Kommandos, Code, Log-Ausgaben und unveränderte externe Zitate dürfen in ihrer technisch notwendigen Originalsprache verbleiben. Der erläuternde Kontext des KI-Agenten bleibt deutsch.
- Nach Fertigstellung einer Arbeit oder beim Erreichen eines klaren Zwischenstands informiert der KI-Agent den menschlichen Entwickler aktiv über Ergebnis und aktuellen Stand.
- Die Abschluss- bzw. Zwischenstandsmeldung nennt die durchgeführten Prüfungen sowie bekannte offene Punkte, Risiken oder notwendige manuelle Prüfungen. Wenn noch Arbeit offen ist, wird der nächste sinnvolle Schritt genannt.
- Neu erstellte oder für den aktuellen Arbeitsstand relevante GitHub-Artefakte werden als direkt aufrufbare Links angeboten. Dies gilt insbesondere für Stories, Fehlerreports bzw. Bug-Issues und Pull Requests.
- Gehören mehrere GitHub-Artefakte zur konkreten Arbeit, werden alle relevanten Links gemeinsam genannt.

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

Auch Aufgaben „auf Zuruf“, bei denen der Benutzer unmittelbar um eine Änderung oder Realisierung bittet, müssen grundsätzlich vor der Umsetzung als Story erfasst werden. Dies gilt unabhängig von Umfang oder betroffener Datei auch für kleine funktionale Änderungen, UX- oder Barrierefreiheitsvorgaben, Konfigurationsanpassungen und Änderungen an den Arbeitsregeln. Für solche Aufträge gilt grundsätzlich: zuerst Repository und Kontext analysieren, dann eine Story mit dem Label `story` und prüfbaren Akzeptanzkriterien erstellen, anschließend auf einem eigenen Branch realisieren und einen Pull Request mit einem passenden Closing-Keyword für die Story erstellen.

Von dieser Story-Pflicht darf ausschließlich nach folgendem Entscheidungsdialog abgewichen werden:
- Vor Beginn der Umsetzung muss der KI-Assistent dem Benutzer wörtlich die Rückfrage `Soll ich zunächst eine Story erstellen?` stellen und die Antwort abwarten.
- Antwortet der Benutzer mit `Ja`, wird zwingend zuerst die Story erstellt und erst anschließend nach dem Story-Workflow umgesetzt.
- Antwortet der Benutzer mit `Nein`, darf die konkret angefragte Änderung ohne vorherige Story direkt auf einem eigenen Branch umgesetzt und als Pull Request bereitgestellt werden.
- Ist die Antwort nicht eindeutig, darf die Story-Pflicht nicht als aufgehoben betrachtet werden; der KI-Assistent muss nachfragen oder zunächst eine Story erstellen.
- Die Ausnahme gilt nur für den konkret erfragten Auftrag und begründet keine dauerhafte Aufhebung der Story-Pflicht für spätere Aufgaben.

Gemeldete Defekte folgen weiterhin dem gesonderten Ablauf aus `Fehlerbehebung` und werden als Bug-Issue erfasst.

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

## Sicherheitsvorgaben

Diese Sicherheitsvorgaben gelten verbindlich für App-Code, Entwicklung, Tests, Dokumentation, GitHub Actions, Releases und unterstützende Automationen.

1. PATs sind strikt an Repository und Zweck gebunden.
    - Für einen PAT-basierten Zugriff auf das App-Repository `Huluvu424242/developer-wiki-app` darf ausschließlich ein eigens für dieses Repository und den konkreten Zugriffszweck bereitgestelltes PAT verwendet werden.
    - PATs eines persönlichen Developer-Wikis oder anderer Repositories dürfen niemals für Zugriffe auf das App-Repository verwendet werden.
    - Ein für das App-Repository bereitgestelltes PAT darf umgekehrt nicht für andere Repositories, Dienste, Umgebungen oder Aufgaben wiederverwendet werden.
    - Für unterschiedliche Repositories, Umgebungen und Zwecke sind getrennte Zugangsdaten zu verwenden.
    - Das in der App konfigurierte Wiki-PAT darf insbesondere nicht für Bugreports oder andere Zugriffe auf das App-Repository zweckentfremdet werden.

2. GitHub-Connectoren und GitHub Apps sind von PATs zu unterscheiden.
    - Ein verbundener GitHub-Connector oder eine GitHub App authentifiziert sich über eigene Installationsberechtigungen und gilt nicht als wiederverwendetes PAT.
    - Auch Connector- und App-Berechtigungen müssen nach dem Least-Privilege-Prinzip auf die tatsächlich benötigten Repositories und Operationen begrenzt sein.
    - Das Vorhandensein eines Connectors rechtfertigt weder das Auslesen noch das Kopieren oder Ersetzen von PATs.

3. Secrets dürfen niemals hardcodiert oder eingecheckt werden.
    - PATs, Passwörter, private Schlüssel, Keystore-Passwörter, Signierschlüssel, Webhook-Secrets und andere Zugangsdaten dürfen weder direkt noch codiert, verschleiert oder in Base64 im Repository abgelegt werden.
    - Das Verbot gilt insbesondere für Quellcode, Konfigurationsdateien, Umgebungsdateien, Beispiele, Tests, Fixtures, Snapshots, Dokumentation, Issues, Pull Requests, Review-Kommentare, Commit-Nachrichten, URLs, Screenshots, Logs, Fehlermeldungen, Telemetrie und Build-Artefakte.
    - Platzhalter in Beispielen und Tests müssen eindeutig ungültig sein und dürfen keinem echten Secret entsprechen.
    - Dateien wie `.env`, Keystores, Schlüsseldateien und lokal erzeugte Secret-Exporte müssen durch geeignete Ignore-Regeln und Prozesse vor versehentlichem Einchecken geschützt werden.

4. Secrets werden ausschließlich über geeignete sichere Speicher bereitgestellt.
    - Zulässig sind zweckgebundene Secret Stores, GitHub Actions Secrets, nur zur Laufzeit gesetzte Umgebungsvariablen und der geschützte Plattform-Speicher der App.
    - Secrets dürfen nicht über normale App-Konfigurationen, ungeschützte lokale Dateien, Kommandozeilenargumente mit sichtbarer Prozessliste oder öffentlich einsehbare CI-Variablen transportiert werden.
    - Anwendungen und Automationen dürfen Secrets nur so lange im Speicher halten, wie dies für den konkreten Vorgang erforderlich ist.

5. Für alle Zugangsdaten gilt Least Privilege.
    - Repository-Zugriff, Berechtigungen und Gültigkeitsdauer sind auf das technisch notwendige Minimum zu begrenzen.
    - Fine-grained PATs sind gegenüber breit berechtigten Tokens zu bevorzugen.
    - Schreibrechte dürfen nur vergeben werden, wenn reine Leserechte nicht ausreichen.
    - Nicht mehr benötigte Zugangsdaten und Berechtigungen sind zeitnah zu widerrufen.
    - Zugangsdaten für Entwicklung, Tests, CI und Produktion dürfen nicht miteinander geteilt werden.

6. Secrets dürfen nicht umgewidmet, extrahiert oder weitergegeben werden.
    - Zugangsdaten aus Nutzereingaben, Dateien, Logs, verbundenen Diensten oder fremden Kontexten dürfen nicht für einen anderen als den ausdrücklich vorgesehenen Zweck verwendet werden.
    - Secrets dürfen nicht an andere Repositories, Hosts oder Drittdienste übertragen werden.
    - Ein Secret darf nur an den ausdrücklich vorgesehenen Zielhost und ausschließlich über eine verschlüsselte Verbindung übertragen werden.
    - Externe Eingaben, Ziel-URLs und Antworten sind vor der Nutzung zu validieren; Weiterleitungen auf unerwartete Hosts dürfen keine Zugangsdaten erhalten.

7. Logs und Fehlermeldungen müssen frei von Secrets bleiben.
    - Authorization-Header, Tokens, Cookies, signierte URLs, sensible Query-Parameter und andere Zugangsdaten dürfen nicht protokolliert oder ungefiltert in Fehlermeldungen übernommen werden.
    - Potenziell sensible Werte sind vor Logging, Anzeige, Serialisierung und Fehlerweitergabe zuverlässig zu entfernen oder zu redigieren.
    - Debug-Ausgaben mit Zugangsdaten sind auch vorübergehend und lokal nicht zulässig, wenn sie in persistente Logs, Screenshots oder gemeinsam genutzte Ausgaben gelangen können.

8. Tests und Beispiele verwenden keine produktiven Zugangsdaten.
    - Tests verwenden ausschließlich Fakes, Mocks oder eindeutig ungültige Testwerte.
    - Tests dürfen nicht von einem realen PAT, einem privaten Schlüssel oder einem produktiven Repository-Zugriff abhängen.
    - Testausgaben, Snapshots und Fehlerfälle müssen darauf geprüft werden, dass keine Secrets oder sicherheitsrelevanten Nutzerdaten enthalten sind.

9. CI, Abhängigkeiten und Sicherheitsprüfungen werden restriktiv behandelt.
    - GitHub-Actions-Workflows erhalten explizite und minimale `permissions`.
    - Secrets werden nur den Schritten bereitgestellt, die sie tatsächlich benötigen, und nicht an nicht vertrauenswürdigen Code oder unkontrollierte Fork-Kontexte weitergegeben.
    - Sicherheitsprüfungen, Zertifikatsprüfungen, Secret Scanning, Signaturprüfungen oder Schutzmechanismen dürfen nicht ohne dokumentierte fachliche Begründung deaktiviert oder umgangen werden.
    - Neue Abhängigkeiten und externe Actions sind vor der Aufnahme auf Herkunft, Wartungszustand, benötigte Berechtigungen und bekannte Sicherheitsrisiken zu prüfen.

10. Vermutete oder bestätigte Offenlegungen werden als Sicherheitsvorfall behandelt.
    - Ein möglicherweise offengelegtes Secret darf nicht weiterverwendet werden und ist unverzüglich zu widerrufen oder zu rotieren.
    - Das Secret ist aus allen erreichbaren Speicherorten, Artefakten und Ausgaben zu entfernen; eine Löschung nur aus dem letzten Commit gilt nicht als ausreichende Bereinigung.
    - Betroffene Berechtigungen, Zugriffe und Logs sind auf Missbrauch zu prüfen.
    - Ursache, Auswirkung und notwendige Schutzmaßnahmen sind nachvollziehbar zu dokumentieren, ohne das Secret erneut offenzulegen.
    - Bei Unsicherheit ist das Secret als kompromittiert zu behandeln.

## UX- und Barrierefreiheitsregeln

Für alle Screens, Seiten, Formulare und Dialoge der App gelten folgende Regeln verbindlich:

1. Validierungsfehler werden sowohl am betroffenen Eingabefeld als auch in einem Fehlersammler angezeigt.
    - Der Fehlersammler erscheint immer am Anfang des Inhalts und damit oberhalb aller Eingabefelder.
    - Jeder Eintrag im Fehlersammler benennt den Fehler verständlich und ist als Link bzw. fokussierbare Aktion zum zugehörigen invaliden Eingabefeld ausgeführt.
    - Beim Aktivieren eines Eintrags wird das zugehörige Feld sichtbar gemacht und der Eingabefokus dorthin gesetzt.
    - Die Anzeige im Fehlersammler ersetzt niemals die einzelne Fehleranzeige unmittelbar am invaliden Eingabefeld.

2. Der primäre Aktionsbereich befindet sich am unteren Ende der Seite oder des Dialogs, jedoch nicht unmittelbar am unteren Bildschirmrand.
    - Unterhalb der Aktionsschaltflächen bleibt ausreichend Platz für temporäre Meldungen, Systemeinblendungen und Bedienhilfen.
    - Aktionsschaltflächen dürfen durch Snackbars, Toasts, Tooltips, Bildschirmränder, Gestennavigation oder die Bildschirmtastatur nicht verdeckt werden.

3. Werden durch eine ausgelöste Aktion, beispielsweise Speichern, Validierungsfehler sichtbar, erfolgen immer beide Rückmeldungen:
    - Es wird eine kurze temporäre Hinweismeldung angezeigt, dass Eingaben korrigiert werden müssen.
    - Gleichzeitig wird zum Fehlersammler am Anfang des Inhalts gesprungen und der Fokus barrierefrei auf den Fehlersammler gesetzt.
    - Die Hinweismeldung und der Fokuswechsel müssen für assistive Technologien wahrnehmbar sein.

4. Jede App besitzt eine Barrierefreiheitserklärung.
    - Die Erklärung ist innerhalb der App dauerhaft erreichbar.
    - Sie beschreibt mindestens den aktuellen Stand der Barrierefreiheit, bekannte Barrieren und einen barrierefrei nutzbaren Kontakt- oder Meldeweg.

5. Jede App besitzt einen Menüpunkt `Über`.
    - Über diesen Menüpunkt können Nutzer jederzeit die installierte Releaseversion der App ermitteln.
    - Der About-Dialog zeigt zwingend die Releaseversion an.
    - Der About-Dialog enthält zusätzlich eine eindeutig beschriftete Schaltfläche, über die die Barrierefreiheitserklärung geöffnet werden kann.

6. Auf jeder Seite und in jedem Dialog ist eine barrierefrei erreichbare Möglichkeit zum Melden eines Fehlers vorhanden.
    - Der Meldeweg erstellt auf der Projektseite der App ein GitHub-Issue mit dem Label `bug`.
    - Im Bugreport werden der aktuell genutzte Screen bzw. Dialog und die installierte Releaseversion als Kontext automatisch vorbelegt.
    - Der Bugreport enthält ein Pflichtfeld `Fehlerart` als zunächst nicht vorbelegte Auswahlliste; ein Platzhalter darf nicht als gültige Auswahl gelten.
    - Die Auswahlliste enthält zwingend `Barrierefreiheitsfehler` und `Sonstiges`; app-spezifische weitere Fehlerarten sind zulässig.
    - Zusätzlich wird ein Freitextfeld mit einer maximalen Länge von 2000 Zeichen angeboten.
    - Bezeichnungen, Hilfetexte, Pflichtfeldstatus, Validierungsfehler und Bedienelemente des Meldewegs müssen für Screenreader semantisch eindeutig sein.
    - Vor dem Öffnen oder Übermitteln dürfen keine Zugangsdaten, Tokens oder sonstigen Secrets in den Bugreport übernommen werden.

7. Jedes Eingabefeld besitzt eine fachlich festgelegte maximale Zeichenlänge und einen Zeichenzähler.
    - Der Zeichenzähler wird sichtbar, sobald nur noch zehn Zeichen bis zur Längenbegrenzung verbleiben, und bleibt bis zum Erreichen der Grenze sichtbar.
    - Screenreader geben den verbleibenden Umfang in der Form `noch x Zeichen` aus.
    - Nach Eingabe des letzten zulässigen Zeichens ertönt ein akustisches Signal und assistive Technologien geben den Hinweis `Kein Zeichen mehr möglich` aus.
    - Das akustische Signal darf nicht die einzige Rückmeldung sein; der sichtbare Zeichenzähler und die semantische Textausgabe bleiben erforderlich.
    - Zusätzliche Eingaben über die Grenze hinaus werden verhindert, ohne bereits eingegebenen Text zu verlieren.
    - Die Rückmeldung beim Erreichen der Grenze darf pro Grenzerreichung nicht bei jedem weiteren Eingabeversuch ununterbrochen wiederholt werden.

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
