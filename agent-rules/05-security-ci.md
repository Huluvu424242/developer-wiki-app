# Sicherheit: Tests, CI und Vorfälle

- Tests verwenden ausschließlich Fakes, Mocks oder eindeutig ungültige Testwerte und hängen nicht von produktiven Zugängen ab.
- GitHub-Actions-Workflows erhalten explizite und minimale `permissions`.
- Vertrauliche Laufzeitwerte werden nur den Schritten bereitgestellt, die sie tatsächlich benötigen, und nicht an unkontrollierte Fremdbeiträge weitergegeben.
- Sicherheits-, Zertifikats- und Signaturprüfungen sowie vergleichbare Schutzmechanismen werden nicht ohne dokumentierte fachliche Begründung deaktiviert oder umgangen.
- Neue Abhängigkeiten und externe Actions werden vor Aufnahme auf Herkunft, Wartungszustand, benötigte Berechtigungen und bekannte Sicherheitsrisiken geprüft.
- Ein möglicherweise offengelegter Zugang wird nicht weiterverwendet, sondern unverzüglich widerrufen beziehungsweise rotiert.
- Betroffene Speicherorte, Artefakte, Ausgaben und Zugriffe werden bereinigt beziehungsweise auf Missbrauch geprüft; eine Korrektur nur im letzten Commit reicht nicht aus.
- Ursache, Auswirkung und notwendige Schutzmaßnahmen werden nachvollziehbar dokumentiert, ohne vertrauliche Werte erneut offenzulegen.
- Bei Unsicherheit ist von einer Kompromittierung auszugehen.

Eine weitergehende Governance für ausführbare Werkzeugketten wird in Story #143 behandelt.
