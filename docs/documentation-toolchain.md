# Dokumentationswerkzeugkette

Die vollständige Projektdokumentation wird als Markdown unter `docs/` gepflegt. `mkdocs.yml` definiert Navigation und Darstellung; MkDocs Material erzeugt daraus die statische Website für GitHub Pages.

## Quellen und Build-Artefakt

- Fachliche Quelle: Markdown-Dateien unter `docs/`.
- Navigation und Site-Konfiguration: `mkdocs.yml`.
- Reproduzierbare Python-Abhängigkeiten: `requirements-docs.txt`.
- Generiertes Build-Verzeichnis: `site/`.
- `site/` ist ausschließlich ein lokales beziehungsweise CI-Build-Artefakt und wird nicht versioniert.

Die Root-`README.md` bleibt die kompakte Projektübersicht. Ausführliche Benutzer-, Entwickler-, Architektur- und Betriebsdokumentation gehört nach `docs/`.

## Lokaler Build

Voraussetzung ist eine aktuelle Python-3-Installation. Die Dokumentationsabhängigkeiten werden bewusst getrennt von Flutter installiert.

```bash
python -m venv .venv
python -m pip install --disable-pip-version-check --requirement requirements-docs.txt
mkdocs build --strict
```

Für eine lokale Vorschau:

```bash
mkdocs serve
```

Der Strict-Build behandelt relevante MkDocs-Warnungen als Fehler. Neue oder geänderte Dokumentation sollte daher vor dem Merge möglichst mit `mkdocs build --strict` geprüft werden.

## GitHub Action

`.github/workflows/kiagent-documentation-pages.yml` baut und veröffentlicht die Dokumentation.

### Trigger

Der Workflow reagiert nur auf dokumentationsrelevante Änderungen:

- Pull Requests mit Änderungen unter `docs/**`, an `mkdocs.yml`, `requirements-docs.txt` oder der Workflow-Datei selbst;
- Pushes auf `master` mit denselben Pfadfiltern;
- manueller Start über `workflow_dispatch`.

Pull-Request-Läufe führen ausschließlich den reproduzierbaren MkDocs-Build aus. Sie veröffentlichen keine Website.

Ein Lauf auf `master` baut dieselbe Site, erzeugt das GitHub-Pages-Artefakt und veröffentlicht es anschließend. Ein manueller Lauf auf einem anderen Branch dient nur der Build-Prüfung und darf nicht deployen.

## Berechtigungen und Datenflüsse

Der Workflow benötigt keine projektspezifischen Secrets oder Variablen.

Der Build-Job besitzt ausschließlich `contents: read`. Erst der getrennte Deployment-Job erhält die von GitHub Pages benötigten Berechtigungen:

- `pages: write`
- `id-token: write`

Die Werkzeugkette liest den Repository-Inhalt, installiert die in `requirements-docs.txt` festgelegten Dokumentationswerkzeuge und übergibt ausschließlich das generierte `site/`-Verzeichnis an GitHub Pages. Es gibt keine Repository-Schreibwirkung.

Externe GitHub Actions werden auf unveränderliche Commit-SHAs gepinnt. Verwendet werden ausschließlich offizielle Actions der GitHub-Organisation `actions` für Checkout, Python-Setup, Pages-Konfiguration, Pages-Artefakt und Deployment. Die Python-Pakete dienen nur dem Dokumentationsbuild und werden nicht mit der Flutter-App ausgeliefert.

## GitHub-Pages-Einstellung

Der Workflow ändert keine Repository-Settings. Falls GitHub Pages für das Repository noch nicht auf **GitHub Actions** als Veröffentlichungsquelle eingestellt ist, muss der Repository-Owner dies separat in den GitHub-Einstellungen vornehmen. Diese Settings-Änderung ist bewusst nicht Teil des Code-Pull-Requests.

Nach erfolgreicher Einrichtung ist die Dokumentation unter folgendem vorgesehenen Pfad erreichbar:

`https://huluvu424242.github.io/developer-wiki-app/`

## Concurrency und Rollback

Für Pages-Deployments gilt eine gemeinsame Concurrency-Gruppe. Ein bereits laufendes Deployment wird nicht zugunsten eines neueren Laufs abgebrochen.

Zum Rollback wird die fehlerhafte Dokumentations- oder Workflow-Änderung über den normalen Pull-Request-Prozess zurückgenommen. Der Workflow selbst kann zusätzlich über GitHub deaktiviert werden; Änderungen an Repository-Settings bleiben eine separate Owner-Aktion.
