# Sicherheit: Tests, CI und Vorfälle

## Tests und CI

- Tests verwenden ausschließlich Fakes, Mocks oder eindeutig ungültige Testwerte und hängen nicht von produktiven Zugängen ab.
- Testausgaben, Snapshots und Fehlerfälle werden darauf geprüft, dass sie keine Zugangsdaten oder sicherheitsrelevanten Nutzerdaten enthalten.
- GitHub-Actions-Workflows erhalten explizite und minimale `permissions`.
- Vertrauliche Laufzeitwerte werden nur den Schritten bereitgestellt, die sie tatsächlich benötigen, und nicht an nicht vertrauenswürdigen Code oder unkontrollierte Fork-Kontexte weitergegeben.
- Sicherheitsprüfungen, Zertifikatsprüfungen, Secret Scanning, Signaturprüfungen und vergleichbare Schutzmechanismen werden nicht ohne dokumentierte fachliche Begründung deaktiviert oder umgangen.
- Neue Abhängigkeiten und externe Actions werden vor Aufnahme auf Herkunft, Wartungszustand, benötigte Berechtigungen und bekannte Sicherheitsrisiken geprüft.
- Für Erstellung, Änderung und Ausführung von GitHub Actions sowie anderen ausführbaren Werkzeugketten gelten zusätzlich die verbindlichen Regeln aus [Sicherheit und Werkzeugketten](05-security-tooling.md).
- Schreibende `kiagent-*`-Workflows müssen ihre automatischen Trigger auf Branches beschränken, auf denen die beabsichtigte Schreiboperation zulässig ist. In diesem Repository dürfen Workflows, die Commits auf den ausgelösten Branch zurückschreiben, insbesondere nicht durch Pushes auf `master` oder `release/*` gestartet werden.
- Besitzt ein schreibender `kiagent-*`-Workflow zusätzlich `workflow_dispatch` oder einen anderen Trigger, der einen geschützten Branch auswählen kann, muss der Workflow selbst vor der ersten schreibenden oder formatierenden Wirkung sicherstellen, dass `master` und `release/*` ausgeschlossen sind. Eine übersprungene Job-Ausführung ist dafür zulässig.
- Branch-Schutzregeln werden nicht als erwartbarer Fehlerpfad benutzt: Wenn ein Workflow auf einem geschützten Branch seine bestimmungsgemäße Schreibwirkung nicht ausführen darf, wird dieser Branch bereits durch Triggerfilter oder eine explizite Guard-Bedingung ausgeschlossen.
- Formatierungs- und Validierungsworkflows, die denselben Dart-/Flutter-Code bearbeiten beziehungsweise prüfen, verwenden denselben Flutter-/Dart-SDK-Stand, lösen vor der Dart-Formatierung dieselben Projektabhängigkeiten auf und prüfen denselben Formatierungsumfang. Insbesondere darf ein schreibender Formatierungsworkflow nicht ohne `flutter pub get` arbeiten, wenn die zugehörige Validation ihre Prüfung erst nach dieser Dependency-Auflösung durchführt.
- Der schreibende Formatierungsworkflow muss dieselbe Dart-Formatierung erzeugen, die der reine Validation-Workflow anschließend mit `dart format --set-exit-if-changed` prüft. Ein Unterschied im Projektzustand, der zu widersprüchlichen Ergebnissen wie `0 changed` im Formatierungsworkflow und Formatierungsfehlern in der Validation führt, gilt als Defekt der Werkzeugkette.

## Sicherheitsvorfall

- Ein möglicherweise offengelegtes Secret wird nicht weiterverwendet, sondern unverzüglich widerrufen beziehungsweise rotiert.
- Das Secret wird aus allen erreichbaren Speicherorten, Artefakten und Ausgaben entfernt; eine Löschung nur aus dem letzten Commit reicht nicht aus.
- Betroffene Berechtigungen, Zugriffe und Logs werden auf Missbrauch geprüft.
- Ursache, Auswirkung und notwendige Schutzmaßnahmen werden nachvollziehbar dokumentiert, ohne das Secret erneut offenzulegen.
- Bei Unsicherheit ist das Secret als kompromittiert zu behandeln.
