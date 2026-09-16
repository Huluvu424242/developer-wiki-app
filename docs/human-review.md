# Menschliche PR-Abnahme

Dieser Abschnitt beschreibt den empfohlenen Ablauf für die manuelle Prüfung von Pull Requests. Der menschliche Reviewer behält jederzeit die Entscheidungshoheit und darf einzelne Prüfschritte bewusst überspringen. Der Standardfall ist jedoch eine vollständige lokale Prüfung jedes Branches unmittelbar vor seinem Merge.

Für gestapelte Pull Requests werden zwei technisch unterschiedliche Verfahren beschrieben:

1. **Manueller Rebase-Merge:** Der Reviewer prüft jeden final auf `master` rebasierten Branch einzeln und übernimmt ihn mit `Rebase and merge`.
2. **Delegierter Stack-Merge mit Merge-Commits:** Nach abgeschlossener menschlicher Review-Lücke kann der Mensch den bereits geprüften Stack in einer neuen Aufgabe an den KI-Agenten zum Merge delegieren. Dabei können Merge-Commits gezielt genutzt werden, um die Parent-Historie des Stacks zu erhalten.

Die verbindlichen Regeln für Review-Lücke, Merge-Delegation, erneute Prüfung und Konfliktbehandlung stehen in [`AGENTS.md`](https://github.com/Huluvu424242/developer-wiki-app/blob/master/AGENTS.md) und insbesondere in [`agent-rules/01-workflow-collaboration.md`](https://github.com/Huluvu424242/developer-wiki-app/blob/master/agent-rules/01-workflow-collaboration.md). Dieses Dokument beschreibt die praktische Durchführung und ersetzt diese normativen Regeln nicht.

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

## Manueller Merge mit Rebase and merge

Nach erfolgreicher manueller Prüfung wird der Pull Request mit **Rebase and merge** in seinen Zielbranch übernommen. `master` selbst wird niemals rebased.

Bei einem nicht gestapelten Pull Request ist der Vorgang damit abgeschlossen. Bei einem Stack muss vor der Prüfung des nächsten Pull Requests dessen Branch auf die durch den Merge neu entstandene Basis umgesetzt werden.

## Nächsten Branch eines Stacks für Rebase-Merge vorbereiten

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

## Warum beim Rebase-Verfahren `rebase --onto` verwendet wird

Ein einfaches `git rebase origin/master` kann bei gestapelten Branches versuchen, bereits über den Elternbranch eingeführte Commits erneut abzuspielen. Mit

```powershell
git rebase --onto origin/master origin/story/A story/B
```

wird dagegen ausdrücklich nur der Teil von B übernommen, der gegenüber A zusätzlich entstanden ist. Dadurch bleibt der Diff des nächsten Pull Requests auf seine eigene Story oder Änderung begrenzt.

## Delegierter Stack-Merge mit Merge-Commits

Nach abgeschlossener menschlicher Review-Lücke kann der Mensch den Merge eines bereits geprüften Stacks in einer **neuen, ausdrücklichen Aufgabe** an den KI-Agenten delegieren. Für einen solchen Auftrag kann es sinnvoll sein, die Stack-PRs mit **Merge-Commits** statt mit Rebase-Merge zu übernehmen.

Der wesentliche Unterschied ist die Historie: Ein Merge-Commit erhält den bisherigen Head des gemergten PRs als Parent. Wenn `story/B` bereits auf `story/A` basiert und A per Merge-Commit nach `master` übernommen wurde, bleibt der ursprüngliche A-Commit dadurch weiterhin Vorfahr von `master`. B muss deshalb häufig nicht neu geschrieben werden. Stattdessen kann sein PR nach dem Merge von A auf `master` retargetet werden.

Für den Beispielstack gilt dann:

```text
A → master
B → story/A
C → story/B
```

Der delegierte Ablauf ist:

1. Aktuellen Zustand aller Stack-PRs prüfen: Head-SHAs, Zielbranches, Reviews, Checks, Mergeability und seit der menschlichen Prüfung hinzugekommene Änderungen.
2. Den untersten PR A mit Merge-Commit nach `master` übernehmen.
3. PR B von `story/A` auf den nun aktuellen `master` retargeten.
4. B erneut prüfen: Der Diff muss weiterhin nur die B-eigenen Änderungen enthalten; außerdem Mergeability, Checks und Head-SHA erneut kontrollieren.
5. B mit Merge-Commit nach `master` übernehmen.
6. C auf `master` retargeten und dieselben Prüfungen wiederholen.
7. So lange fortfahren, bis der gesamte freigegebene Stack abgearbeitet ist.

Schematisch:

```text
Stack und Freigabe erneut prüfen
        ↓
untersten PR per Merge-Commit mergen
        ↓
nächsten PR auf aktuellen master retargeten
        ↓
Diff + Head-SHA + Checks + Mergeability erneut prüfen
        ↓
bei unverändertem fachlichem Inhalt mergen
        ↓
für weitere Stack-Ebenen wiederholen
```

### Warum Merge-Commits hier hilfreich sind

Bei einem bereits aufgebauten Stack ist die gemeinsame Parent-Historie fachlich nützlich. Durch den Merge-Commit wird der zuvor geprüfte Branch-Head nicht in neue Commits umgeschrieben. Dadurch kann Git erkennen, dass die Änderungen des unteren Stack-Elements bereits in `master` enthalten sind. Der nächste PR zeigt nach dem Retargeting im Idealfall nur noch seinen eigenen zusätzlichen Diff.

Das ist kein allgemeines Verbot von Rebase-Merges. Beide Verfahren sind gültig, haben aber unterschiedliche Konsequenzen:

- **Rebase and merge** erzeugt neue Commit-SHAs auf `master`; deshalb muss der nächste Stack-Branch normalerweise mit `rebase --onto` auf die neue Basis gesetzt werden.
- **Merge-Commit** erhält den bisherigen Branch-Head als Vorfahren; deshalb kann beim nächsten Stack-PR oft ein Retargeting auf `master` genügen.

Entscheidend ist nicht die Merge-Methode allein, sondern dass nach jedem Schritt der tatsächlich verbleibende PR-Diff überprüft wird.

## Sonderfall: oberer PR bleibt nach Retargeting konfliktbehaftet

Ein oberer PR kann trotz korrekter Reihenfolge nach dem Retargeting auf `master` weiterhin nicht mergebar sein. Das kann insbesondere passieren, wenn seine Historie neben den eigentlichen Story-Änderungen noch geerbte, später anders gemergte oder zwischenzeitlich veränderte Commits enthält.

In diesem Fall wird nicht blind ein großer Konflikt aufgelöst und auch nicht angenommen, dass alle im Branch sichtbaren Unterschiede zum PR gehören. Stattdessen wird zuerst bestimmt, **welcher Diff fachlich tatsächlich zu diesem PR gehört**.

Wenn dieser PR-eigene Diff eindeutig ist und bereits menschlich geprüft wurde, kann der Arbeitsbranch technisch bereinigt werden:

1. Den aktuellen `master` als neue Basis verwenden.
2. Ausschließlich die bereits geprüften PR-eigenen Änderungen auf diese Basis übernehmen.
3. Keine geerbten Änderungen früherer Stack-Ebenen erneut übernehmen.
4. Den Branch aktualisieren.
5. Anschließend den vollständigen Diff `master...Branch` erneut prüfen.
6. Nur wenn dieser Diff exakt den bereits geprüften fachlichen Inhalt repräsentiert und keine neuen relevanten Änderungen enthält, darf der delegierte Merge fortgesetzt werden.

Ein typischer Dokumentations-PR kann beispielsweise ursprünglich zusätzlich geerbte Code- oder Teständerungen anzeigen. Nach der Bereinigung darf sein Diff dann nur noch die tatsächlich zur Dokumentationsstory gehörenden Dateien enthalten.

Die technische Bereinigung ist **kein Freibrief für neue Entscheidungen**. Sobald bei der Konfliktauflösung fachliche Inhalte neu gewählt, verworfen, kombiniert oder anderweitig relevant verändert werden müssten, endet die bestehende Review-Freigabe. Dann muss der Mensch erneut Gelegenheit zur Prüfung erhalten.

## Prüfungen nach jedem Stack-Schritt

Unabhängig vom verwendeten Verfahren wird nach jedem Merge mindestens geprüft:

- zeigt der nächste PR auf den korrekten Zielbranch?
- ist sein Head-SHA noch der erwartete Stand?
- enthält der Diff nur die erwarteten PR-eigenen Änderungen?
- sind seit der menschlichen Prüfung relevante neue Commits oder Änderungen hinzugekommen?
- ist der PR konfliktfrei beziehungsweise ist ein Konflikt fachlich eindeutig lösbar?
- sind die für diesen Stand verfügbaren Checks erfolgreich beziehungsweise transparent als offen dokumentiert?

Ein erfolgreiches Retargeting allein reicht nicht aus. GitHub kann Mergeability kurzzeitig als unbekannt oder noch nicht neu berechnet anzeigen; deshalb wird der Zustand nach der Basisänderung erneut abgefragt.

## Rollen im Stacked-PR-Prozess

Der menschliche Reviewer entscheidet über Abnahme und Merge. Er prüft standardmäßig jeden final vorbereiteten Branch lokal und führt den Merge selbst aus oder delegiert ihn nach der in den Harness-Regeln vorgesehenen Review-Lücke in einer neuen Aufgabe.

Der KI-Assistent kann innerhalb einer solchen delegierten Merge-Aufgabe den Stack technisch abarbeiten: aktuellen `master` prüfen, Reihenfolge bestimmen, PRs retargeten, notwendige Rebases oder eindeutige Konfliktbereinigungen durchführen, Diffs erneut kontrollieren und die freigegebenen PRs nacheinander mergen.

Ein Pull Request weiter oben im Stack kann bereits existieren und automatisierte Checks ausführen. Entscheidend ist jedoch der nach Merge aller darunterliegenden Änderungen tatsächlich verbleibende Diff. Inhaltlich relevante Änderungen seit der menschlichen Prüfung erfordern erneut eine Review-Möglichkeit.

## Kurzablauf: manueller Rebase-Merge

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

## Kurzablauf: delegierter Merge-Commit-Stack

```text
vollständigen geprüften Stack + aktuelle Head-SHAs kontrollieren
        ↓
untersten PR per Merge-Commit mergen
        ↓
nächsten PR auf master retargeten
        ↓
Diff, Checks und Mergeability erneut prüfen
        ↓
falls sauber: per Merge-Commit mergen
        ↓
falls historisch verunreinigt: auf master neu aufsetzen und nur geprüften PR-Diff übernehmen
        ↓
resultierenden Diff erneut prüfen
        ↓
für weitere Stack-Ebenen wiederholen
```
