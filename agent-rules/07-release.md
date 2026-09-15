# Releasevorbereitung

Die Releasevorbereitung ist ein eigener, verbindlicher Arbeitsablauf. Sie wird auf einem eigenen Arbeitsbranch durchgeführt und über einen Pull Request gegen `master` bereitgestellt. Repository-Vorbereitung und produktive Veröffentlichung sind getrennte Vorgänge.

## 1. Releaseumfang und Zielversion bestimmen

Vor Änderungen werden geprüft:

- aktueller Stand von `master`;
- letzter veröffentlichter Release beziehungsweise Tag;
- seitdem aufgenommene nutzer- oder maintainerrelevante Änderungen;
- vorgesehene Zielversion einschließlich Buildnummer.

Eine Zielversion wird nicht geraten. Ist sie im Auftrag eindeutig angegeben, ist sie verbindlich; fehlt eine ausreichende Grundlage, bleibt die Versionsentscheidung offen und wird dem menschlichen Entwickler benannt.

## 2. Zentrale technische Versionsquelle

`pubspec.yaml` ist die zentrale technische Versionsquelle der Flutter-App.

- Die gewünschte Releaseversion einschließlich Buildnummer muss dort eingetragen sein.
- Stellen, die die installierte Version direkt oder abgeleitet anzeigen, werden auf Konsistenz mit `pubspec.yaml` geprüft.
- Zusätzliche hartcodierte Aussagen über die aktuelle Releaseversion dürfen nicht davon abweichen.
- Historische Versionsangaben werden nicht mechanisch ersetzt.

## 3. Changelog als fachlicher Master

`CHANGELOG.md` ist der fachliche Master für die veröffentlichte Änderungshistorie.

- Relevante Einträge aus `Unreleased` werden für das Release in einen Abschnitt mit Releaseversion und ISO-Datum überführt.
- Kategorien wie `Added`, `Changed`, `Fixed` und `Security` bleiben fachlich sinnvoll erhalten.
- Vergleichslinks werden geprüft und bei Bedarf angepasst.
- Dokumentiert werden nur Änderungen, die tatsächlich im vorgesehenen Release enthalten sind; der Changelog ist keine Commitliste.

## 4. In-App-Änderungshistorie

Existiert eine in der App sichtbare Änderungshistorie, wird sie im selben Releasevorbereitungs-PR mit dem Changelog abgeglichen.

- Sie darf für die UI gekürzt oder sprachlich angepasst werden, aber keine fachlich relevante Releaseänderung hinzufügen, weglassen oder in ihrer Bedeutung verändern.
- Wird der Changelog nachträglich geändert, wird die sichtbare Änderungshistorie erneut geprüft.
- Existiert keine solche Ansicht, wird dies im Release-PR als `nicht vorhanden` dokumentiert. Allein für die Releasevorbereitung wird keine neue UI eingeführt.

## 5. Benutzerdokumentation prüfen

Alle für den vorgesehenen Release sichtbaren Funktionsänderungen werden gegen die Benutzerdokumentation geprüft. Dazu zählen insbesondere Installation und Bezug der App, Bedienabläufe, Quellentypen, Einstellungen, GitHub-/PAT-Anforderungen, bekannte Einschränkungen, Workflow-Anstöße, Bugreport-/Supportwege und Plattformanforderungen.

Nur tatsächlich betroffene Dokumentation wird geändert; die Prüfung selbst ist verpflichtend.

## 6. Entwickler-, Architektur- und Sicherheitsdokumentation prüfen

Änderungen seit dem letzten Release, die Architektur, Integrationen, GitHub-Kommunikation, Sicherheit, Build, Release oder Plattformverhalten betreffen, müssen in der zuständigen Dokumentation korrekt beschrieben sein.

Erkennbare Deltas zum Implementierungsstand werden im Release-PR korrigiert oder als klarer Blocker beziehungsweise Folgestory benannt. Eine Releasevorbereitung soll keine fachfremde Großdokumentation auf Vorrat erzeugen.

## 7. Repositoryweite Suche nach aktuellen Versionsangaben

Vor Abschluss wird repositoryweit nach fest eingetragenen Versions-/Buildangaben und Formulierungen gesucht, die einen aktuellen Release-Stand behaupten, zum Beispiel `aktuelle Version`, `derzeitige Version`, `aktuell ausgeliefert`, Installationsbeispiele mit konkreter aktueller APK-Version oder vergleichbare Aussagen.

Jede Fundstelle wird fachlich klassifiziert:

- **aktuelle Angabe:** auf die Zielversion prüfen und erforderlichenfalls anpassen;
- **historische Angabe:** unverändert lassen, wenn der historische Bezug korrekt ist;
- **unklare Angabe:** Kontext präzisieren statt die Versionsnummer mechanisch zu ersetzen.

## 8. Attributionen und Lizenzen prüfen

Vor dem Release wird geprüft, ob seit dem letzten Release neue lizenzrelevante ausgelieferte Bestandteile hinzugekommen sind, insbesondere Laufzeit-Packages, Logos, Bilder, Schriften und sonstige Assets. Fehlende erforderliche Angaben werden gemäß den Qualitätsregeln in `ATTRIBUTIONS.md` ergänzt.

Eine vollständige Lizenzanalyse aller transitiven Entwicklungswerkzeuge ist nicht Teil dieser Prüfung, sofern sie nach den Projektregeln nicht als ausgelieferter Bestandteil relevant sind.

## 9. Releaseprüfungen

Für geänderten Dart-/Flutter-Code gelten mindestens die Standardprüfungen aus [Qualität](06-quality.md):

```text
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```

Soweit Umgebung und Projektregeln es ermöglichen, wird zusätzlich ein geeigneter Android-Build beziehungsweise eine repräsentative Laufprüfung durchgeführt.

Nicht ausführbare oder fehlgeschlagene Prüfungen werden ausdrücklich benannt und nie als erfolgreich dargestellt. Eine nach [Sicherheit und Werkzeugketten](05-security-tooling.md) freigegebene CI darf nur innerhalb ihrer dokumentierten Gültigkeitsgrenzen verwendet werden.

## 10. Konsistenzprüfung vor Abschluss

Vor Bereitstellung des Releasevorbereitungs-PRs werden mindestens folgende Artefakte gegeneinander geprüft:

- `pubspec.yaml`;
- `CHANGELOG.md`;
- relevante aktuelle Versionsangaben in README und `docs/`;
- die in der App angezeigte Release-/Buildversion;
- gegebenenfalls eine In-App-Änderungshistorie;
- die im Auftrag vorgesehene Releaseversion.

Alle aktuellen Angaben müssen denselben Release-Stand beschreiben.

## 11. Eigener Branch und Pull Request

Eine Releasevorbereitung erfolgt ausschließlich auf einem eigenen Arbeitsbranch und über einen Pull Request gegen `master`. Direkte Änderungen an `master` oder `release/*` sind unzulässig.

Der PR nennt mindestens:

- Zielversion;
- zusammengefassten Releaseumfang;
- geänderte Versions-, Changelog- und Dokumentationsartefakte;
- ausgeführte Prüfungen;
- nicht ausführbare Prüfungen;
- bekannte Restrisiken und Blocker;
- zugehörige Releasevorbereitungsstory beziehungsweise das beauftragte Issue.

## 12. Veröffentlichung ist ein separater Vorgang

Das Vorbereiten oder Mergen eines Release-PRs ist keine Ausführungsfreigabe für `.github/workflows/android-release.yml`.

- Die tatsächliche Verwendung des Workflows richtet sich vollständig nach [Sicherheit und Werkzeugketten](05-security-tooling.md).
- Der Agent darf den Workflow nur ausführen oder erneut ausführen, wenn die konkrete Verwendung ausdrücklich freigegeben ist.
- Der Workflow-Input `release_version` muss exakt der Version in `pubspec.yaml` entsprechen.
- Der Workflow erzeugt Tag und GitHub Release und verwendet Signing-Secrets; diese sicherheitsrelevante Veröffentlichung ist nicht Teil der bloßen Repository-Releasevorbereitung.

## Releasebranches

Ein `release/*`-Branch wird nicht allein aufgrund dieses Vertrags für jede Version verlangt. Wird für einen konkreten Release ein solcher Branch verwendet, gelten die bestehenden Schutz-, PR- und Wartungsregeln vollständig.
