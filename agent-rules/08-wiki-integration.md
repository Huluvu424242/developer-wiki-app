# Wiki-Integration

Dieses Modul beschreibt die fachliche Verantwortungsgrenze zwischen Developer-Wiki-App und persönlichem Developer-Wiki.

- Die App ist Client des Developer-Wikis und nicht selbst das Wissenssystem.
- Quellen erfassen, strukturierte GitHub-Issues erzeugen und ausdrücklich vorgesehene Wiki-Workflows anstoßen gehören zur App.
- Importlogik, Archivierung, Quelleneinarbeitung und Wissensaufbereitung bleiben im Developer-Wiki-Repository.
- Unterschiedliche App-Einstiegspunkte wie normale Quellenerfassung und Android-Share verwenden möglichst denselben fachlichen Implementierungsweg.
- GitHub-Zugriffe bleiben an klaren Service- beziehungsweise Abstraktionsgrenzen gekapselt.
- Der Wiki-Zugang der App und ein Zugang zum App-Repository bleiben strikt nach Repository und Zweck getrennt.
- Nutzer- und repositoryspezifische Zielwerte wie Wiki-Repository und Workflow-Informationen werden nicht unnötig fest verdrahtet; sinnvolle Defaults dürfen vorhanden sein, müssen aber überschreibbar bleiben.
- Wiki-interne Regeln zu OKF, Quellenarchiv, Wissenssynthese, Retrieval oder `wiki-data` werden nicht in den App-Harness dupliziert.
