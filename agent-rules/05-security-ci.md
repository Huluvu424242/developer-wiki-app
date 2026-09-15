# Sicherheit: Tests, CI und Vorfälle

## Tests und CI

- Tests verwenden ausschließlich Fakes, Mocks oder eindeutig ungültige Testwerte und hängen nicht von produktiven Zugängen ab.
- Testausgaben, Snapshots und Fehlerfälle werden darauf geprüft, dass sie keine Zugangsdaten oder sicherheitsrelevanten Nutzerdaten enthalten.
- GitHub-Actions-Workflows erhalten explizite und minimale `permissions`.
- Vertrauliche Laufzeitwerte werden nur den Schritten bereitgestellt, die sie tatsächlich benötigen, und nicht an nicht vertrauenswürdigen Code oder unkontrollierte Fork-Kontexte weitergegeben.
- Sicherheitsprüfungen, Zertifikatsprüfungen, Secret Scanning, Signaturprüfungen und vergleichbare Schutzmechanismen werden nicht ohne dokumentierte fachliche Begründung deaktiviert oder umgangen.
- Neue Abhängigkeiten und externe Actions werden vor Aufnahme auf Herkunft, Wartungszustand, benötigte Berechtigungen und bekannte Sicherheitsrisiken geprüft.
- Für Erstellung, Änderung und Ausführung von GitHub Actions sowie anderen ausführbaren Werkzeugketten gelten zusätzlich die verbindlichen Regeln aus [Sicherheit und Werkzeugketten](05-security-tooling.md).

## Sicherheitsvorfall

- Ein möglicherweise offengelegtes Secret wird nicht weiterverwendet, sondern unverzüglich widerrufen beziehungsweise rotiert.
- Das Secret wird aus allen erreichbaren Speicherorten, Artefakten und Ausgaben entfernt; eine Löschung nur aus dem letzten Commit reicht nicht aus.
- Betroffene Berechtigungen, Zugriffe und Logs werden auf Missbrauch geprüft.
- Ursache, Auswirkung und notwendige Schutzmaßnahmen werden nachvollziehbar dokumentiert, ohne das Secret erneut offenzulegen.
- Bei Unsicherheit ist das Secret als kompromittiert zu behandeln.
