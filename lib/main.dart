import 'package:flutter/material.dart';

import 'models/wiki_configuration.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/configuration_service.dart';

void main() => runApp(const WikiSourceApp());

class WikiSourceApp extends StatefulWidget {
  const WikiSourceApp({super.key});

  @override
  State<WikiSourceApp> createState() => _WikiSourceAppState();
}

class _WikiSourceAppState extends State<WikiSourceApp> {
  final _configurationService = ConfigurationService();
  late Future<WikiConfiguration> _configuration;

  @override
  void initState() {
    super.initState();
    _reloadConfiguration();
  }

  void _reloadConfiguration() {
    _configuration = _configurationService.load();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Developer Wiki Quellen',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: FutureBuilder<WikiConfiguration>(
        future: _configuration,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Konfiguration konnte nicht geladen werden: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          if (snapshot.data?.isComplete == true) {
            return const HomeScreen();
          }
          return SettingsScreen(
            isSetup: true,
            onConfigured: _reloadConfiguration,
          );
        },
      ),
    );
  }
}
