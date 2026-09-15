# Dokumentationspflege

Diese Regeln gelten für Features, Bugfixes und sonstige Änderungen an Quellen oder technischer Infrastruktur.

- `CHANGELOG.md` nach Keep a Changelog 1.1.0 pflegen. Nutzer- oder maintainerrelevante Änderungen unter `Unreleased` eintragen; Releases in umgekehrt chronologischer Reihenfolge mit ISO-Datum dokumentieren und Vergleichslinks soweit sinnvoll pflegen.
- `README.md` nach Standard Readme pflegen. Bei Änderungen an Einstieg, Installation, Nutzung, Sicherheit, Release oder Navigation aktualisieren.
- Weiterführende Projektdokumentation unter `docs/` als Markdown pflegen.
- Geeignete Diagramme bevorzugt als Mermaid versionieren; SVG ist zulässig, wenn Mermaid nicht zweckmäßig ist.
- Architekturübersichten und Architekturdiagramme nach dem C4-Modell strukturieren, soweit dies einen konkreten Nutzen hat.
- Keine Architektur oder Dokumentation auf Vorrat erzeugen.
- Änderungen an Architektur, Integrationen, Persistenz, Abläufen oder externen Schnittstellen aktualisieren die zugehörigen Dokumentationsartefakte im selben Pull Request.
- Wenn keine Dokumentationsaktualisierung erforderlich ist, wird dies im Pull Request kurz begründet.
- Der Pull Request nennt Umsetzung, wesentliche Entscheidungen, Prüfungen, Dokumentationsstatus, offene Akzeptanzkriterien und verbleibende Unsicherheiten.
- Eine Story wird nicht als vollständig umgesetzt dargestellt, solange Akzeptanzkriterien offen sind.
