# Projektaufsetzung und Grundgerüst

Dieses Repository enthält eine bestehende Flutter-App. Änderungen am Grundgerüst erfolgen nur bei einem konkreten fachlichen Bedarf.

- Bestehende Flutter-, Android-, Asset-, Test- und Dokumentationsstrukturen bleiben erhalten, solange eine Story keine Änderung daran verlangt.
- Projektname, App-Identität, Logo, Lizenz, vorhandene Supportoberflächen und Build-Konfiguration gelten als etablierter Bestand.
- Eine einzelne Feature-Story rechtfertigt keine erneute Projektaufsetzung oder einen Austausch des Grundgerüsts.
- Neue technische Grundbausteine werden nur bei konkretem Bedarf eingeführt und nicht auf Vorrat angelegt.
- Neue Screens und Dialoge berücksichtigen die vorhandenen appweiten Supportfunktionen und die Regeln aus [UX und Barrierefreiheit](04-ux-accessibility.md).
- Regeln anderer Projekte werden nicht mechanisch übernommen. Fremde App-Namen, Datenmodelle und Repositorypfade sowie Wiki-interne Inhalts- und Retrievalregeln gehören nicht in diesen App-Harness.
- Die projektspezifische Grenze zwischen App und Wiki steht in [Wiki-Integration](08-wiki-integration.md).

## Bestehende Support-Grundfunktionen

- Relevante Screens und anwendungseigene Dialoge bieten einen konsistenten Zugang zu `Bug melden` und `Über` oder übergeben ihren eindeutigen fachlichen Kontext an die gemeinsame Supportfunktion.
- Der About-Dialog zeigt App-Name sowie die tatsächlich installierte Releaseversion einschließlich Buildnummer und macht die Barrierefreiheitserklärung erreichbar.
- Die Barrierefreiheitserklärung bleibt offline Bestandteil der App und dauerhaft erreichbar.
- Jeder Bugreport übergibt einen stabilen, nutzerverständlichen fachlichen Aufrufkontext. Fachlich unterschiedliche Screens, Dialoge oder Erfassungsarten verwenden unterscheidbare Kontexte.
- Bugreports übertragen keine Logs, Zugangsdaten, automatisch ausgelesenen Nutzerdaten oder Gerätekennungen.
- Versionsermittlung und externes Öffnen liegen hinter kleinen injizierbaren Plattformabstraktionen, damit Tests ohne reale Browser, Paketinformationen oder Netzwerkzugriffe arbeiten können.
- Fehler beim Laden der Version oder Öffnen eines externen Ziels werden verständlich behandelt; der aktuelle Dialog und vorhandene Eingaben bleiben erhalten.

Die Vorgabe, Name und Logo vor Beginn eines neuen App-Projekts festzulegen, wird nicht als neue operative Pflicht übernommen: Diese bestehende App besitzt ihre Identität bereits.
