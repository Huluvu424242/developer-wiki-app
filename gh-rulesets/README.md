# GitHub Rulesets

Dieses Verzeichnis enthält importierbare GitHub-Rulesets für das Repository.

## `master-protection.json`

Das Ruleset schützt den Branch `master` mit bewusst einfachen Regeln, die zu einem persönlichen Ein-Personen-Projekt passen:

- Änderungen an `master` müssen über einen Pull Request erfolgen.
- Es ist keine fremde Freigabe vorgeschrieben, da das Repository von einer Person gepflegt wird.
- Offene Review-Unterhaltungen müssen vor dem Merge aufgelöst sein.
- `master` darf nicht gelöscht werden.
- Force Pushes auf `master` sind verboten.

Bewusst noch nicht enthalten sind verpflichtende Status Checks. Solche Checks sollten erst dann in das Ruleset aufgenommen werden, wenn stabile, dauerhaft verfügbare CI-Checks mit festen Namen existieren. Andernfalls könnte ein umbenannter oder entfernter Check den Branch unnötig blockieren.

Ebenso werden derzeit keine signierten Commits vorgeschrieben, damit lokale Entwicklung, GitHub-Web-Merges und automatisierte/assistierte Änderungen nicht unnötig eingeschränkt werden.

## Import in GitHub

1. Repository auf GitHub öffnen.
2. `Settings` → `Rules` → `Rulesets` öffnen.
3. `New ruleset` → `Import a ruleset` wählen.
4. `gh-rulesets/master-protection.json` auswählen.
5. Das importierte Ruleset prüfen.
6. Sicherstellen, dass ausschließlich `refs/heads/master` betroffen ist.
7. Ruleset erstellen bzw. aktivieren.

Nach dem Import sollten Änderungen am geschützten Branch ausschließlich über Pull Requests erfolgen.
