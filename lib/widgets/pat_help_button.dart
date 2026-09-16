import 'package:flutter/material.dart';

import 'app_support.dart';

class PatHelpButton extends StatelessWidget {
  const PatHelpButton({super.key});

  static const tooltip = 'Hilfe zu PAT-Berechtigungen';

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) => const _PatHelpDialog(),
      ),
      icon: const Icon(Icons.help_outline),
    );
  }
}

class _PatHelpDialog extends StatelessWidget {
  const _PatHelpDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('GitHub PAT einrichten'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Für den normalen Betrieb brauchst du genau ein Fine-grained '
              'Personal Access Token für dein persönliches Developer-Wiki.',
            ),
            SizedBox(height: 16),
            Text(
              'Benötigt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Fine-grained PAT nur für das persönliche Developer-Wiki.'),
            Text('• Actions: Read and write'),
            Text('• Contents: Read-only'),
            Text('• Issues: Read and write'),
            Text('• Metadata: Read-only'),
            SizedBox(height: 16),
            Text(
              'Nicht benötigt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• kein PAT für das Repository developer-wiki-app'),
            Text('• kein SOURCE_IMAGE_TOKEN'),
            Text('• kein SOURCE_ATTACHMENT_TOKEN'),
            Text('• keine GitHub-Actions- oder Repository-Secrets'),
            SizedBox(height: 8),
            Text(
              'SOURCE_IMAGE_TOKEN und SOURCE_ATTACHMENT_TOKEN sind '
              'ausschließlich interne Secrets des Wiki-Imports. Der Wiki-PAT '
              'der App darf nicht für Bugreports oder andere Repositories '
              'wiederverwendet werden.',
            ),
            SizedBox(height: 16),
            Text(
              'Token auf GitHub anlegen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('1. GitHub öffnen und Settings aufrufen.'),
            Text('2. Developer settings öffnen.'),
            Text('3. Personal access tokens → Fine-grained tokens öffnen.'),
            Text('4. Generate new token wählen.'),
            Text(
              '5. Einen eindeutigen Namen und eine möglichst begrenzte '
              'Gültigkeitsdauer festlegen.',
            ),
            Text(
              '6. Als Resource owner den Owner deines persönlichen '
              'Developer-Wiki-Repositories auswählen.',
            ),
            Text('7. Repository access → Only select repositories wählen.'),
            Text('8. Ausschließlich dein Developer-Wiki auswählen.'),
            Text(
              '9. Repository permissions setzen: Actions und Issues auf '
              'Read and write, Contents auf Read-only; Metadata bleibt '
              'Read-only.',
            ),
            Text(
              '10. Keine zusätzlichen Account Permissions vergeben, solange '
              'sie nicht ausdrücklich benötigt werden.',
            ),
            Text(
                '11. Token erzeugen und den einmal angezeigten Wert kopieren.'),
            Text(
              '12. In der App unter Einstellungen bzw. Ersteinrichtung in '
              'Fine-grained PAT einfügen.',
            ),
            Text(
              '13. GitHub Wiki und Import-Workflow kontrollieren und '
              '„Verbindung und Rechte testen“ ausführen.',
            ),
            Text('14. Erst nach erfolgreichem Test Speichern wählen.'),
            SizedBox(height: 16),
            Text(
              'Wofür die Felder stehen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'GitHub Wiki: Repository-URL oder owner/repo des persönlichen '
              'Developer-Wikis.',
            ),
            Text(
              'Fine-grained PAT: Zugang nur zu diesem Wiki. Er wird '
              'ausschließlich im geschützten lokalen App-Speicher abgelegt.',
            ),
            Text(
              'Import-Workflow: Dateiname des workflow_dispatch-Workflows, '
              'den die App über „Quellen ins Wiki importieren“ startet.',
            ),
            SizedBox(height: 16),
            Text('Sicherheit', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'Das Token nicht in Quellcode, Screenshots, Issues, Logs, '
              'Dokumentation oder URLs veröffentlichen. Bei Verdacht auf '
              'Offenlegung den Token auf GitHub widerrufen und neu erstellen.',
            ),
          ],
        ),
      ),
      actions: [
        const BugReportButton(contextName: 'PAT-Hilfedialog'),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Schließen'),
        ),
      ],
    );
  }
}
