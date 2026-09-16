# Developer-Wiki-App Dokumentation

Die Developer-Wiki-App ist der mobile Client zur Erfassung strukturierter Quellen für das persönliche Developer-Wiki. Diese Dokumentation beschreibt Bedienung, Einrichtung, Quellenflüsse, Architektur, Entwicklung, Sicherheit und Releasebetrieb.

## Für Nutzer

- [Benutzerhandbuch](benutzerhandbuch/index.md) – Einstieg in Ersteinrichtung und typische End-to-End-Abläufe.
- [Fine-grained PAT einrichten](pat-setup.md) – benötigte GitHub-Berechtigungen und Schritt-für-Schritt-Einrichtung.
- [PDF-Dokumentquellen](document-sources.md) – lokale PDFs, Pending-Attachments und Verifikation.
- [Bildquellen](image-sources.md) – lokale Bilder und GitHub-Attachment-Ablauf.
- [Android-Share-Ziele](share-targets.md) – Teilen von Links, Texten, Bildern und PDF-Dokumenten.
- [Barrierefreiheit und UX](accessibility.md) – Bedienhilfen, Fehlersammler und Supportfunktionen.

## Für Entwicklung und Wartung

- [Architektur](architecture.md) – Systemkontext und technische Verantwortungsgrenzen.
- [Dynamische Quellenmodelle](dynamic-source-models.md) – Vertrag zwischen App und Developer-Wiki.
- [Entwicklungsumgebung](development-environment.md) – Flutter-, Android-, JDK- und Build-Toolchain.
- [Agenten-Harness](agent-harness.md) – verbindliche Regeln für KI-gestützte Repository-Arbeit.
- [Menschliche PR-Abnahme](human-review.md) – Review-, Rebase- und Merge-Abläufe.
- [Dokumentationswerkzeugkette](documentation-toolchain.md) – MkDocs, GitHub Actions und GitHub Pages.
- [Android-Release](android-release.md) – signierter APK-Release und Sicherheitsgrenzen.
- [App-Logo und Launcher-Icons](app-icon.md) – Branding und reproduzierbare Asset-Ableitung.

## Dokumentationsprinzip

Die Markdown-Dateien unter `docs/` sind die versionierte fachliche Quelle. MkDocs erzeugt daraus eine statische, durchsuchbare Website. Das generierte Verzeichnis `site/` ist ein Build-Artefakt und wird nicht eingecheckt.

Änderungen an Nutzerverhalten, Architektur, Integrationen, Sicherheit oder Betriebsabläufen aktualisieren die jeweils betroffene Markdown-Dokumentation im selben Pull Request.
