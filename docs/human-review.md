# Menschliche PR-Abnahme

Dieser Abschnitt beschreibt den empfohlenen Ablauf für die manuelle Prüfung von Pull Requests. Der menschliche Reviewer behält jederzeit die Entscheidungshoheit und darf einzelne Prüfschritte bewusst überspringen. Der Standardfall ist jedoch eine vollständige lokale Prüfung jedes Branches unmittelbar vor seinem Merge.

## Grundprinzip

Ein Pull Request wird erst dann als konkreter Review-Kandidat behandelt, wenn alle Pull Requests unterhalb von ihm im Stack bereits gemergt wurden und sein Branch auf die danach aktuelle Zielbasis umgesetzt wurde.

Bei einem Stack

```text
master
  └── story/A
        └── story/B
              └── story/C
```

werden die Pull Requests zunächst so angelegt:

```text
A → master
B → story/A
C → story/B
```

Geprüft und gemergt wird von unten nach oben: zuerst A, danach B, danach C.

## Lokale Prüfung eines Review-Kandidaten

Der Reviewer checkt den Branch lokal aus und aktualisiert ihn. Anschließend wird für eine Flutter-App standardmäßig folgende Prüfung durchgeführt:

```powershell
git checkout story/A
git pull

flutter clean
flutter pub get
flutter analyze
flutter test
flutter run
```

Dabei gilt:

- `flutter clean` stellt sicher, dass die Prüfung nicht versehentlich von alten Build-Artefakten abhängt.
- `flutter pub get` stellt die zum Branch gehörenden Abhängigkeiten bereit.
- `flutter analyze` muss ohne neue Fehler oder Warnungen durchlaufen.
- `flutter test` führt die automatisierten Tests aus.
- `flutter run` dient der manuellen Funktions- und Plausibilitätsprüfung auf einem geeigneten Zielgerät oder Emulator.
- Je nach Art der Änderung können zusätzliche fachliche Prüfschritte notwendig sein.
- Der Reviewer darf einzelne Schritte bewusst überspringen, wenn sie für den konkreten Pull Request nicht sinnvoll oder bereits ausreichend anderweitig abgesichert sind. Das Überspringen ist eine bewusste menschliche Entscheidung und nicht der Standardablauf.

Wenn bei der Prüfung Fehler oder fachliche Auffälligkeiten auftreten, wird der Pull Request nicht gemergt. Die Korrektur erfolgt auf dem Arbeitsbranch und die betroffenen Prüfungen werden anschließend erneut durchgeführt.

## Merge

Nach erfolgreicher manueller Prüfung wird der Pull Request mit **Rebase and merge** in seinen Zielbranch übernommen. `master` selbst wird niemals rebased.

Bei einem nicht gestapelten Pull Request ist der Vorgang damit abgeschlossen. Bei einem Stack muss vor der Prüfung des nächsten Pull Requests dessen Branch auf die durch den Merge neu entstandene Basis umgesetzt werden.

## Nächsten Branch eines Stacks vorbereiten

Nach einem Rebase-Merge besitzt `master` neue Commit-SHAs für die soeben übernommenen Änderungen. Der darüberliegende Branch basiert dagegen noch auf den ursprünglichen Commits seines Elternbranches. Deshalb darf der nächste Pull Request nicht lediglich auf `master` umgestellt werden.

Nach dem Merge von A wird B stattdessen so vorbereitet, dass ausschließlich die zusätzlichen Commits von B auf dem aktuellen `master` neu aufgesetzt werden:

```powershell
git fetch origin
git checkout story/B
git rebase --onto origin/master origin/story/A story/B
```

Eventuelle Konflikte werden fachlich aufgelöst. Nach erfolgreichem Rebase werden die vorgeschriebenen Prüfungen für den Arbeitsbranch erneut durchgeführt. Ein bereits veröffentlichter Branch wird anschließend ausschließlich mit Lease-Schutz aktualisiert:

```powershell
git push --force-with-lease
```

Erst danach wird der Pull Request von

```text
story/B → story/A
```

auf

```text
story/B → master
```

umgestellt. Der Pull Request ist nun der nächste Review-Kandidat und wird vom menschlichen Reviewer vollständig geprüft.

Das gleiche Verfahren wird anschließend für C und weitere Ebenen des Stacks wiederholt.

## Warum `rebase --onto` verwendet wird

Ein einfaches `git rebase origin/master` kann bei gestapelten Branches versuchen, bereits über den Elternbranch eingeführte Commits erneut abzuspielen. Mit

```powershell
git rebase --onto origin/master origin/story/A story/B
```

wird dagegen ausdrücklich nur der Teil von B übernommen, der gegenüber A zusätzlich entstanden ist. Dadurch bleibt der Diff des nächsten Pull Requests auf seine eigene Story oder Änderung begrenzt.

## Rollen im Stacked-PR-Prozess

Der menschliche Reviewer entscheidet über Abnahme und Merge. Er prüft standardmäßig jeden final vorbereiteten Branch lokal und führt den Merge erst nach erfolgreicher Prüfung aus.

Der KI-Assistent kann nach dem Merge eines Stack-Elements den verbleibenden Stack technisch vorbereiten: aktuellen `master` prüfen, den nächsten Branch auf die neue Basis umsetzen, Konflikte fachlich auflösen, den Pull Request auf `master` ausrichten und genau den nächsten Review-Kandidaten benennen. Die lokale manuelle Abnahme wird dadurch nicht ersetzt.

Ein Pull Request weiter oben im Stack kann bereits existieren und automatisierte Checks ausführen, gilt aber erst nach dem Merge und der Neu-Basierung aller darunterliegenden Änderungen als finaler Review-Kandidat. Dadurch wird vermieden, dass der menschliche Reviewer einen Branch ausführlich prüft, der vor seinem Merge ohnehin noch umgeschrieben werden muss.

## Kurzablauf

```text
Stack-PRs erstellen
        ↓
untersten PR als Review-Kandidaten wählen
        ↓
Branch lokal vollständig prüfen
        ↓
Rebase and merge
        ↓
nächsten Branch mit rebase --onto auf aktuellen master setzen
        ↓
mit --force-with-lease veröffentlichen und PR auf master ausrichten
        ↓
nächsten Branch lokal vollständig prüfen
        ↓
Rebase and merge
        ↓
für weitere Stack-Ebenen wiederholen
```
