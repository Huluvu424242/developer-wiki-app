# Architektur: Implementierung

- UI, Fachlogik, Persistenz und externe Kommunikation werden klar getrennt.
- Screens und Widgets setzen keine GitHub-Transportdetails selbst zusammen.
- GitHub-Zugriffe, Plattformintegration und geschützte lokale Speicherung werden über klare Services beziehungsweise Schnittstellen gekapselt.
- Externe Abhängigkeiten und Plattformfunktionen liegen hinter kleinen, testbaren Schnittstellen.
- Eine fachliche Funktion besitzt möglichst einen zentralen Implementierungsweg; normale Erfassung und Android-Share verwenden dieselbe Fachlogik.
- UI verwendet Fachlogik und Services; Fachlogik und Services hängen nicht von konkreten Screens ab.
- Datenmodelle bleiben soweit sinnvoll unabhängig von Widgets und externen API-Formaten.
- Externe Systeme werden an den Rändern der Anwendung angebunden.
- Abstraktionen erst bei konkretem Wiederverwendungs- oder Entkopplungsbedarf einführen.
- Mobile first entwickeln; Android ist die primäre Referenzplattform. Allgemeine Fachlogik bleibt soweit sinnvoll plattformneutral in Dart; Android-spezifischer Code wird an klaren Rändern isoliert.
- Barrierefreiheit und Testbarkeit bereits beim Entwurf berücksichtigen.
- Clean Code, geringe Kopplung und wenige versteckte Seiteneffekte anstreben.
- Keine Architektur auf Vorrat und keine neuen Frameworks oder State-Management-Lösungen ohne konkreten Bedarf.
- Nutzer- und repositoryspezifische Werte nicht unnötig hardcodieren; sinnvolle Defaults müssen überschreibbar bleiben.
- Lade-, Erfolgs-, Leer- und Fehlerzustände sichtbar behandeln, wenn sie relevant sind.
- Nutzereingaben bei Netzwerk-, Validierungs- oder API-Fehlern nach Möglichkeit erhalten.
- Relevante Fehler nicht still ignorieren und keine leeren `catch`-Blöcke verwenden.
- Doppelte Seiteneffekte durch Mehrfachauslösung laufender Aktionen verhindern.

## Asynchrone UI-Zugriffe

- Jeder einzelne `await` in einem `State`-Objekt bildet eine neue asynchrone Lücke.
- Nach jedem `await` wird vor anschließendem Zugriff auf `context`, `Navigator`, `ScaffoldMessenger`, Fokus, Scrollposition oder `setState` erneut der Widget-Lebenszyklus geprüft.
- Eine `mounted`-Prüfung vor einem späteren `await` schützt nicht den Code nach diesem späteren `await`.
- Wird nach einer asynchronen Lücke ein zuvor gespeicherter `BuildContext` verwendet, wird dessen eigener Lebenszyklus über `context.mounted` berücksichtigt.
- Redundante doppelte Lebenszyklusprüfungen werden vermieden.

## Flutter-`const`-Bäume

- Vor `const` an einem zusammengesetzten Widget wird der darunterliegende Widgetbaum geprüft.
- Enthält der Baum direkt oder indirekt einen in der unterstützten Flutter-Version nicht konstanten Konstruktor, etwa `Semantics`, einen Builder oder ein zustandsabhängiges Widget, bleibt der gemeinsame Vorfahr nicht pauschal `const`.
- Konstante Blätter werden bevorzugt einzeln markiert, statt einen gemeinsamen Vorfahren ohne Prüfung konstant zu machen.
- Wird ein nicht konstantes Widget in einen bislang konstanten Baum eingefügt, wird die Vorfahrenkette bis zum nächsten ohnehin nicht konstanten Widget geprüft und erforderliches `const` entfernt.
- Nach solchen UI-Änderungen gilt mindestens `flutter analyze` für den betroffenen Bereich; vor Abschluss gelten zusätzlich die vollständigen Qualitätsprüfungen.
