# Developer-Wiki-App Dokumentation

Die Developer-Wiki-App ist der mobile Client zur Erfassung strukturierter Quellen für das persönliche Developer-Wiki. Diese Dokumentation beschreibt Bedienung, Einrichtung, Quellenflüsse, Architektur, Entwicklung, Sicherheit und Releasebetrieb.

Die Markdown-Dateien unter `docs/` sind die versionierte fachliche Quelle. Aus ihnen wird mit MkDocs Material eine durchsuchbare GitHub-Pages-Dokumentation erzeugt. Das generierte Verzeichnis `site/` ist ausschließlich ein Build-Artefakt und wird nicht eingecheckt.

Nach Aktivierung von GitHub Pages mit **GitHub Actions** als Veröffentlichungsquelle ist die generierte Dokumentation unter `https://huluvu424242.github.io/developer-wiki-app/` vorgesehen. Aufbau, lokaler Strict-Build und Deployment sind in der [Dokumentationswerkzeugkette](documentation-toolchain.md) beschrieben.

## Für Nutzer

- [Benutzerhandbuch](benutzerhandbuch/index.md) – Ersteinrichtung und typische End-to-End-Szenarien für Link, Text, Bild, lokale PDF und Android-Teilen mit Mockups.
- [Fine-grained PAT einrichten](pat-setup.md) – benötigte und nicht benötigte Tokens, Berechtigungen und Schritt-für-Schritt-Einrichtung.
- [PDF-Dokumentquellen](document-sources.md) – lokale PDF-Erfassung, Pending-Attachment und sichere Freigabe.
- [Bildquellen](image-sources.md) – lokale Bilder und GitHub-Attachment-Ablauf.
- [Android-Share-Ziele](share-targets.md) – quellentypspezifisches Teilen von Links, Texten, Bildern und PDF-Dokumenten.
- [Barrierefreiheit und UX](accessibility.md) – Bedienhilfen, Fehlersammler und Supportfunktionen.

## Für Entwicklung und Wartung

- [Architektur](architecture.md) – Systemkontext und technische Verantwortungsgrenzen nach dem C4-Modell.
- [Dynamische Quellenmodelle](dynamic-source-models.md) – versionierter Erfassungsvertrag zwischen App und Developer-Wiki.
- [Entwicklungsumgebung](development-environment.md) – Flutter-, Android-, JDK- und Build-Toolchain.
- [Agenten-Harness](agent-harness.md) – modulare Regelstruktur, Migrationsmatrix und deterministische Strukturprüfung.
- [Menschliche PR-Abnahme](human-review.md) – Review-, Rebase- und Merge-Abläufe.
- [Dokumentationswerkzeugkette](documentation-toolchain.md) – MkDocs, GitHub Actions und GitHub Pages.
- [Android-Release](android-release.md) – signierter APK-Release und Sicherheitsgrenzen.
- [App-Logo und Launcher-Icons](app-icon.md) – Branding und reproduzierbare Asset-Ableitung.

## Dokumentationsregeln

Technische Dokumentation wird bevorzugt als Markdown gepflegt. Geeignete Abläufe und Architektursichten werden als Mermaid-Diagramme versioniert; SVG-Dateien können für Grafiken oder Diagramme verwendet werden, wenn Mermaid nicht zweckmäßig ist.

Architekturdokumentation folgt dem C4-Modell. Es werden nur die Ebenen dokumentiert, die für das aktuelle Projekt einen konkreten Nutzen haben. Änderungen an Features, Bugfixes oder technischer Infrastruktur aktualisieren die betroffene Dokumentation im selben Pull Request.

Screenshots und Mockups ergänzen die textliche Erklärung, ersetzen sie aber nicht. Dokumentationsbilder dürfen keine echten Tokens, privaten Repositorydaten oder persönlichen Dokumentinhalte enthalten.
