import 'package:flutter/material.dart';

import 'models/shared_content.dart';
import 'models/wiki_configuration.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/configuration_service.dart';
import 'services/share_intent_service.dart';
import 'widgets/app_support.dart';

void main() => runApp(const WikiSourceApp());

class WikiSourceApp extends StatefulWidget {
  const WikiSourceApp({super.key});

  @override
  State<WikiSourceApp> createState() => _WikiSourceAppState();
}

class _WikiSourceAppState extends State<WikiSourceApp> {
  final _configurationService = ConfigurationService();
  final _shareIntentService = ShareIntentService();
  late Future<WikiConfiguration> _configuration;
  SharedContent? _sharedContent;

  @override
  void initState() {
    super.initState();
    _reloadConfiguration();
    _initializeShareIntents();
  }

  Future<void> _initializeShareIntents() async {
    final initial = await _shareIntentService.initialize(_handleSharedContent);
    if (initial != null) {
      _handleSharedContent(initial);
    }
  }

  void _handleSharedContent(SharedContent content) {
    if (!mounted) {
      return;
    }
    setState(() => _sharedContent = content);
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
            return Scaffold(
              appBar: AppBar(
                title: const Text('Developer Wiki'),
                actions: const [
                  AppSupportMenu(contextName: 'App wird geladen'),
                ],
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Developer Wiki'),
                actions: const [
                  AppSupportMenu(contextName: 'Startfehler'),
                ],
              ),
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
            return HomeScreen(sharedContent: _sharedContent);
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
