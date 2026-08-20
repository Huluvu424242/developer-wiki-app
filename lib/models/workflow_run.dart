enum WorkflowRunState { queued, running, successful, failed }

class WorkflowRun {
  const WorkflowRun({
    required this.id,
    required this.url,
    required this.state,
    required this.createdAt,
  });

  final int id;
  final String url;
  final WorkflowRunState state;
  final DateTime createdAt;

  String get label => switch (state) {
        WorkflowRunState.queued => 'gestartet / wartet',
        WorkflowRunState.running => 'läuft',
        WorkflowRunState.successful => 'erfolgreich abgeschlossen',
        WorkflowRunState.failed => 'fehlgeschlagen',
      };
}
