import '../models/created_issue.dart';
import '../models/document_source_file.dart';
import '../models/pending_document_upload.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import 'configuration_service.dart';
import 'external_url_service.dart';
import 'github_attachment_parser.dart';
import 'github_service.dart';
import 'pending_document_upload_store.dart';

abstract interface class DocumentUploadGateway {
  Future<PendingDocumentUpload?> loadPending();

  Future<PendingDocumentUpload> start({
    required SourceTemplate template,
    required String title,
    required Map<String, String> values,
    required DocumentSourceFile document,
  });

  Future<CreatedIssue> verify(
    PendingDocumentUpload upload,
    SourceTemplate template,
  );

  Future<void> discard(PendingDocumentUpload upload);

  Future<void> open(PendingDocumentUpload upload);
}

class GitHubDocumentUploadService implements DocumentUploadGateway {
  GitHubDocumentUploadService({
    ConfigurationService? configurationService,
    ExternalUrlService? externalUrlService,
    PendingDocumentUploadStore? store,
    GitHubAttachmentParser? parser,
  })  : _configurationService = configurationService ?? ConfigurationService(),
        _externalUrlService = externalUrlService ?? ExternalUrlService(),
        _store = store ?? PendingDocumentUploadStore(),
        _parser = parser ?? GitHubAttachmentParser();

  static const pendingContent =
      'Dokument-Upload ausstehend. Bitte dieses Issue nicht importieren.';

  final ConfigurationService _configurationService;
  final ExternalUrlService _externalUrlService;
  final PendingDocumentUploadStore _store;
  final GitHubAttachmentParser _parser;

  @override
  Future<PendingDocumentUpload?> loadPending() => _store.load();

  @override
  Future<PendingDocumentUpload> start({
    required SourceTemplate template,
    required String title,
    required Map<String, String> values,
    required DocumentSourceFile document,
  }) async {
    final configuration = await _configurationService.load();
    final service = _githubService(configuration);
    final pendingValues = {...values, 'content': pendingContent};
    final issue = await service.createIssue(
      title: '${template.titlePrefix}${title.trim()}',
      body: GitHubService.issueBody(template, pendingValues),
      labels: const [],
    );
    final upload = PendingDocumentUpload(
      issueNumber: issue.number,
      issueUrl: issue.url,
      createdAt: DateTime.now().toUtc(),
      templateId: template.id,
      title: title.trim(),
      values: Map.unmodifiable(values),
      document: document,
    );
    try {
      await _store.save(upload);
    } catch (_) {
      await service.closeIssue(issue.number);
      rethrow;
    }
    try {
      await open(upload);
    } catch (_) {
      // Der persistierte Pending-Zustand bleibt über die App fortsetzbar.
    }
    return upload;
  }

  @override
  Future<CreatedIssue> verify(
    PendingDocumentUpload upload,
    SourceTemplate template,
  ) async {
    if (template.id != upload.templateId || !template.isFileSource) {
      throw const FormatException(
        'Der gespeicherte Dokument-Upload passt nicht zum aktuellen '
        'Quellenvertrag.',
      );
    }
    final configuration = await _configurationService.load();
    final service = _githubService(configuration);
    final login = await service.login();
    final comments = await service.listIssueComments(upload.issueNumber);
    final attachmentUrls = _parser.stableUrls(
      comments
          .where((comment) => comment.authorLogin == login)
          .map((comment) => comment.body),
    );
    if (attachmentUrls.isEmpty) {
      throw const FormatException(
        'Noch kein GitHub-Attachment gefunden. Die PDF als Kommentar '
        'hochladen, den Kommentar absenden und erneut prüfen.',
      );
    }
    if (attachmentUrls.length > 1) {
      throw const FormatException(
        'Mehrere Attachments gefunden. Bitte nur die vorgesehene PDF im '
        'Pending-Issue belassen und erneut prüfen.',
      );
    }

    final values = {
      ...upload.values,
      'content': _documentMarkdown(upload.document.name, attachmentUrls.single),
    };
    final finalBody = GitHubService.issueBody(template, values);
    await service.updateIssueBody(upload.issueNumber, finalBody);
    final rereadBody = await service.issueBodyFor(upload.issueNumber);
    if (rereadBody.trim() != finalBody.trim()) {
      throw const FormatException(
        'Der finale Issue-Inhalt konnte nach dem Upload nicht bestätigt '
        'werden. Die Quelle bleibt ausstehend.',
      );
    }
    await service.addIssueLabel(upload.issueNumber, 'quelle');
    await _store.clear();
    return CreatedIssue(number: upload.issueNumber, url: upload.issueUrl);
  }

  @override
  Future<void> discard(PendingDocumentUpload upload) async {
    final configuration = await _configurationService.load();
    await _githubService(configuration).closeIssue(upload.issueNumber);
    await _store.clear();
  }

  @override
  Future<void> open(PendingDocumentUpload upload) {
    return _externalUrlService.open('${upload.issueUrl}#new_comment_field');
  }

  GitHubService _githubService(WikiConfiguration configuration) {
    if (!configuration.isComplete) {
      throw const FormatException(
        'Wiki-Konfiguration ist unvollständig. Einstellungen prüfen.',
      );
    }
    final repository = GitHubRepository.parse(configuration.repositoryUrl);
    return GitHubService(
      configuration.token,
      owner: repository.owner,
      repo: repository.name,
    );
  }

  String _documentMarkdown(String name, String url) {
    final safeName = name.replaceAll(RegExp(r'[\[\]\r\n]'), '_');
    return '[$safeName]($url)';
  }
}
