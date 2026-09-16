import 'package:flutter/material.dart';

import 'models/shared_content.dart';
import 'models/source_capture_definition.dart';
import 'models/source_template.dart';
import 'models/wiki_configuration.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/configuration_service.dart';
import 'services/share_intent_service.dart';
import 'services/source_template_service.dart';
import 'widgets/app_support.dart';

void main() => runApp(const WikiSourceApp());

class WikiSourceApp extends StatefulWidget {
  const WikiSourceApp({super.key});

  @override
  State<WikiSourceApp> createState() => _WikiSourceAppState();
}

class _WikiSourceAppState extends State<WikiSourceApp> {
  final _configurationService = ConfigurationService();
  final _sourceTemplateService = SourceTemplateService();
  final _shareIntentService = ShareIntentService();
  late Future<_BootstrapState> _bootstrap;
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

  Future<_BootstrapState> _loadBootstrap() async {
    final configuration = await _configurationService.load();
    if (!configuration.isComplete) {
      return _BootstrapState(configuration: configuration);
    }
    final loadedTemplates = await _sourceTemplateService.load(configuration);
    replaceSourceTemplates(loadedTemplates.templates);
    return _BootstrapState(
      configuration: configuration,
      templates: loadedTemplates,
    );
  }

  void _reloadConfiguration() {
    _bootstrap = _loadBootstrap();
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
      home: FutureBuilder<_BootstrapState>(
        future: _bootstrap,
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
                actions: const [AppSupportMenu(contextName: 'Startfehler')],
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
          final bootstrap = snapshot.data!;
          if (bootstrap.configuration.isComplete) {
            return Stack(
              children: [
                HomeScreen(sharedContent: _sharedContent),
                if (bootstrap.templates?.warning case final warning?)
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 72, 16, 0),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Semantics(
                            liveRegion: true,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                warning,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
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

class _BootstrapState {
  const _BootstrapState({required this.configuration, this.templates});

  final WikiConfiguration configuration;
  final LoadedSourceTemplates? templates;
}
