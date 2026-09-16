# Developer-Wiki-Zugang einrichten

Für den normalen Betrieb benötigt die App genau **einen Fine-grained Personal Access Token (PAT) für das persönliche Developer-Wiki**.

## Welche Zugangsdaten werden benötigt?

| Zugang | In der App erforderlich? | Zweck |
| --- | --- | --- |
| Fine-grained PAT für das persönliche Developer-Wiki | Ja | Quellenmodell lesen, Quellen-Issues verwenden und Import-Workflow anstoßen |
| PAT für `developer-wiki-app` | Nein | Der normale App-Betrieb greift nicht mit dem Wiki-PAT auf das App-Repository zu |
| `SOURCE_IMAGE_TOKEN` | Nein | internes Secret des Wiki-Imports |
| `SOURCE_ATTACHMENT_TOKEN` | Nein | internes Secret des Wiki-Imports |
| GitHub-Actions-/Repository-Secrets | Nein | werden ausschließlich serverseitig verwaltet |

Der Wiki-PAT wird **nicht** für Bugreports oder andere Repositories wiederverwendet.

## Fine-grained PAT Schritt für Schritt erstellen

1. Auf GitHub **Settings** öffnen.
2. **Developer settings** öffnen.
3. **Personal access tokens → Fine-grained tokens** öffnen.
4. **Generate new token** wählen.
5. Einen eindeutigen Namen und eine möglichst begrenzte Gültigkeitsdauer festlegen.
6. Als **Resource owner** den Owner des persönlichen Developer-Wikis auswählen.
7. Unter **Repository access** `Only select repositories` wählen.
8. Ausschließlich das persönliche Developer-Wiki auswählen.
9. Unter **Repository permissions** setzen:
   - Actions: `Read and write`
   - Contents: `Read-only`
   - Issues: `Read and write`
   - Metadata: `Read-only`
10. Keine zusätzlichen **Account permissions** vergeben, sofern sie nicht nachweisbar benötigt werden.
11. Token erzeugen und den einmal angezeigten Wert sicher kopieren.
12. In der App **Einstellungen** beziehungsweise bei der **Ersteinrichtung** in `Fine-grained PAT` einfügen.
13. `GitHub Wiki` und `Import-Workflow` kontrollieren und **Verbindung und Rechte testen** ausführen.
14. Erst nach erfolgreichem Test **Speichern** wählen.

## Wo werden die Werte in der App eingetragen?

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
│ [ Speichern ]                      │
└────────────────────────────────────┘
```

`GitHub Wiki` bezeichnet das persönliche Wiki-Repository. `Import-Workflow` ist der Dateiname des per `workflow_dispatch` startbaren Workflows, den die App über **Quellen ins Wiki importieren** aufruft.

## Was prüft der Verbindungstest?

Der Test prüft ohne Probe-Issue oder Probe-Workflow:

- ob Token und Repository erreichbar sind;
- ob `src/config/source-capture.json` gelesen werden kann (`Contents: Read-only`);
- ob Quellen-Issues gelesen werden können (`Issues`);
- ob der konfigurierte Import-Workflow sichtbar ist (`Actions`).

Die tatsächlichen GitHub-Schreibrechte werden zusätzlich bei der jeweiligen Schreibaktion durch GitHub erzwungen. Die App gibt den Token weder in Erfolgs- noch in Fehlermeldungen aus.

## Sicherheit

Der PAT wird standardmäßig verdeckt dargestellt und ausschließlich im geschützten lokalen Speicher abgelegt. Niemals echte Tokens in Screenshots, Issues, Logs oder Dokumentation übernehmen. Bei Verdacht auf Offenlegung den Token auf GitHub widerrufen und neu erstellen.
