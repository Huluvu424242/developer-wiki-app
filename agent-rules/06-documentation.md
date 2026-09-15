# Dokumentationspflege

Diese Regeln gelten verbindlich für Features, Bugfixes und sonstige Änderungen an Quellen oder technischer Infrastruktur.

- `CHANGELOG.md` nach Keep a Changelog 1.1.0 pflegen. Nutzer- oder maintainerrelevante Änderungen unter `Unreleased` menschenlesbar eintragen und passend unter `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed` oder `Security` einordnen. Keine Commit-Historie als Changelog wiederholen. Releases in umgekehrt chronologischer Reihenfolge mit ISO-Datum dokumentieren und Vergleichslinks soweit sinnvoll pflegen.
- `README.md` nach Standard Readme pflegen. Sie bleibt die kompakte Einstiegsseite und verlinkt direkt auf die weiterführende Dokumentation unter `docs/`. Bei Änderungen an Einstieg, Installation, Nutzung, Sicherheit, Release oder Navigation aktualisieren.
- Weiterführende Projektdokumentation unter `docs/` als Markdown pflegen.
- Geeignete Diagramme bevorzugt als Mermaid versionieren; SVG ist zulässig, wenn Mermaid nicht zweckmäßig ist.
- Architekturübersichten und Architekturdiagramme nach dem C4-Modell strukturieren, soweit dies einen konkreten Nutzen hat.
- Keine Architektur oder Dokumentation auf Vorrat erzeugen.
- Änderungen an Architektur, Integrationen, Persistenz, Abläufen oder externen Schnittstellen aktualisieren die zugehörigen Markdown-, Mermaid-, SVG- und C4-Artefakte im selben Pull Request.
- Änderungen an Nutzerverhalten, sichtbaren Funktionen, Bedienabläufen oder bekannten Einschränkungen aktualisieren die zuständige Benutzerdokumentation im selben Pull Request, sofern eine solche Dokumentation betroffen ist.
- Sicherheitsrelevante Änderungen aktualisieren die zuständige Sicherheits- oder Entwicklerdokumentation im selben Pull Request.
- Wenn keine Dokumentationsaktualisierung erforderlich ist, wird dies im Pull Request kurz begründet.
- Der Pull Request nennt Umsetzung, wesentliche Entscheidungen, Prüfungen, Dokumentationsstatus, offene Akzeptanzkriterien und verbleibende Unsicherheiten.
- Eine Story wird nicht als vollständig umgesetzt dargestellt, solange Akzeptanzkriterien offen sind.
