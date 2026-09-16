# Ersteinrichtung

Beim ersten Start benötigt die App drei Angaben: das persönliche Developer-Wiki, einen darauf beschränkten Fine-grained PAT und den Dateinamen des Import-Workflows.

## Mockup

```text
┌────────────────────────────────────┐
│ Developer Wiki – Einrichtung       │
├────────────────────────────────────┤
│ GitHub Wiki                        │
│ [owner/Developer-Wiki            ] │
│                                    │
│ Fine-grained PAT                   │
│ [••••••••••••••••••••••••••••] ? │
│                                    │
│ Import-Workflow                    │
│ [import-source-issues.yml        ] │
│                                    │
│ [ Verbindung und Rechte testen ]   │
│ ✓ Repository und Zugriffe geprüft  │
│                                    │
│ [ Speichern ]                      │
└────────────────────────────────────┘
```

Das Mockup verwendet ausschließlich Platzhalter. Ein echter PAT darf niemals in einem Screenshot, Issue oder Dokumentationsbild erscheinen.

## Ablauf

1. `GitHub Wiki` mit Repository-URL oder `owner/repo` des persönlichen Developer-Wikis befüllen.
2. Einen Fine-grained PAT nach [PAT-Einrichtung](../pat-setup.md) anlegen.
3. Das Token in `Fine-grained PAT` einfügen. Es wird standardmäßig verdeckt dargestellt.
4. Den Dateinamen des vorgesehenen `workflow_dispatch`-Import-Workflows in `Import-Workflow` eintragen.
5. `Verbindung und Rechte testen` wählen.
6. Erst wenn der Test erfolgreich ist, `Speichern` wählen.

Der Verbindungstest prüft Repository/Token, den dynamischen Quellenvertrag, Zugriff auf Issues und Sichtbarkeit des Import-Workflows. Die tatsächlichen GitHub-Schreibrechte werden zusätzlich bei den jeweiligen Aktionen serverseitig erzwungen.

## Benötigte und nicht benötigte Tokens

Benötigt wird genau der Wiki-bezogene Fine-grained PAT. Nicht in die App gehören:

- `SOURCE_IMAGE_TOKEN`;
- `SOURCE_ATTACHMENT_TOKEN`;
- GitHub-Actions- oder Repository-Secrets;
- ein PAT für `developer-wiki-app`.

Diese Trennung verhindert, dass ein Zugang für einen anderen Zweck oder ein anderes Repository wiederverwendet wird.
