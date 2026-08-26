# Projektdokumentation

Diese Dokumentation ergänzt die kompakte Projektübersicht in der Root-`README.md`.

## Inhalt

- [Architektur](architecture.md) – Systemkontext und Container-Sicht nach dem C4-Modell.
- [Barrierefreiheit und UX](accessibility.md) – App-Menü, Fehlersammler, Zeichenzähler, About und sicherer Bugreport.
- [App-Logo und Launcher-Icons](app-icon.md) – Masterdatei, Android-Ressourcen und reproduzierbare Ableitung.
- [Android-Release](android-release.md) – reproduzierbarer, signierter APK-Release über GitHub Actions.
- [Bild-Quellen und GitHub-Attachments](image-sources.md) – Eingänge,
  zweistufiger Upload, Wiederaufnahme und Datenschutz.
- [Menschliche PR-Abnahme](human-review.md) – lokale Prüfung, Rebase-Merge und Vorgehen bei gestapelten Branches.

## Dokumentationsregeln

Technische Dokumentation wird bevorzugt als Markdown gepflegt. Geeignete Abläufe und Architektursichten werden als Mermaid-Diagramme versioniert; SVG-Dateien können für Grafiken oder Diagramme verwendet werden, wenn Mermaid nicht zweckmäßig ist.

Architekturdokumentation folgt dem C4-Modell. Es werden nur die Ebenen dokumentiert, die für das aktuelle Projekt einen konkreten Nutzen haben. Änderungen an Features, Bugfixes oder technischer Infrastruktur müssen die betroffene Dokumentation im selben Pull Request aktualisieren.
