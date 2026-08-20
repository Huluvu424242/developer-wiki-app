import 'package:flutter/material.dart';

import '../models/source_template.dart';
import 'settings_screen.dart';
import 'source_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onImportRequested});

  final VoidCallback? onImportRequested;

  void _openSource(BuildContext context, SourceTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SourceFormScreen(initialTemplate: template),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _requestImport(BuildContext context) {
    if (onImportRequested != null) {
      onImportRequested!();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Der Wiki-Import wird in Story #21 umgesetzt.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Wiki'),
        actions: [
          IconButton(
            tooltip: 'Einstellungen öffnen',
            onPressed: () => _openSettings(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Neue Quelle erfassen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Wähle die passende Quellenart aus.'),
          const SizedBox(height: 16),
          ...sourceTemplates.map(
            (template) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  minVerticalPadding: 16,
                  title: Text(template.name),
                  subtitle: Text(template.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openSource(context, template),
                ),
              ),
            ),
          ),
          const Divider(height: 32),
          FilledButton.tonalIcon(
            onPressed: () => _requestImport(context),
            icon: const Icon(Icons.sync),
            label: const Text('Quellen ins Wiki importieren'),
          ),
        ],
      ),
    );
  }
}
