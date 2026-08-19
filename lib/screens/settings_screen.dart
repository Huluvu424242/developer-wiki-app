import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/github_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  final controller = TextEditingController();
  bool busy = false, obscure = true;
  @override
  void initState() {
    super.initState();
    storage.read(key: 'github_pat').then((v) {
      if (mounted) controller.text = v ?? '';
    });
  }

  Future<void> save() async {
    setState(() => busy = true);
    try {
      final token = controller.text.trim();
      final login = await GitHubService(token).login();
      await storage.write(key: 'github_pat', value: token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gespeichert – verbunden als $login')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verbindung fehlgeschlagen: $e')));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                    labelText: 'GitHub Fine-grained PAT',
                    helperText:
                        'Benötigt Issues: Read and write für Developer-Wiki.',
                    suffixIcon: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(obscure
                            ? Icons.visibility
                            : Icons.visibility_off)))),
            const SizedBox(height: 16),
            FilledButton.icon(
                onPressed: busy ? null : save,
                icon: const Icon(Icons.lock),
                label: Text(busy ? 'Prüfe …' : 'Prüfen und sicher speichern')),
          ])));
}
