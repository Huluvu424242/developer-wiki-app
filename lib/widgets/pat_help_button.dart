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
              'Verwende ein Fine-grained personal access token und beschränke '
              'es nach dem Least-Privilege-Prinzip auf dein Developer-Wiki.',
            ),
            SizedBox(height: 16),
            Text(
              'Benötigte Repository-Berechtigungen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Actions: Read and write'),
            Text('• Issues: Read and write'),
            Text('• Metadata: Read-only'),
            SizedBox(height: 8),
            Text(
              'Zusätzliche Account Permissions sind für den aktuellen '
              'Funktionsumfang nicht erforderlich.',
            ),
            SizedBox(height: 16),
            Text(
              'Token auf GitHub anlegen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('1. GitHub → Settings → Developer settings öffnen.'),
            Text(
              '2. Personal access tokens → Fine-grained tokens → '
              'Generate new token wählen.',
            ),
            Text(
              '3. Als Resource owner den Owner des Ziel-Wiki-Repositories '
              'auswählen.',
            ),
            Text(
              '4. Bei Repository access „Only select repositories“ wählen '
              'und nur das Developer-Wiki auswählen.',
            ),
            Text(
              '5. Unter Repository permissions Actions und Issues auf '
              '„Read and write“ setzen; Metadata bleibt „Read-only“.',
            ),
            Text('6. Token erzeugen und einmalig in diese App kopieren.'),
            SizedBox(height: 16),
            Text(
              'Sicherheit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Das Token nur in den App-Einstellungen speichern. Nicht in '
              'Quellcode, Screenshots, Issues oder Logs veröffentlichen.',
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
