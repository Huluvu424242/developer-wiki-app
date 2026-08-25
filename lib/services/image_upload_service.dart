import '../models/created_issue.dart';
import '../models/image_source_file.dart';
import '../models/pending_image_upload.dart';
import '../models/source_template.dart';
import '../models/wiki_configuration.dart';
import 'configuration_service.dart';
import 'external_url_service.dart';
import 'github_attachment_parser.dart';
import 'github_service.dart';
import 'pending_image_upload_store.dart';

abstract interface class ImageUploadGateway {
  Future<PendingImageUpload?> loadPending();

  Future<PendingImageUpload> start({
    required String title,
    required Map<String, String> values,
    required ImageSourceFile image,
  });

  Future<CreatedIssue> verify(PendingImageUpload upload);

  Future<void> discard(PendingImageUpload upload);

  Future<void> open(PendingImageUpload upload);
}

class GitHubImageUploadService implements ImageUploadGateway {
  GitHubImageUploadService({
    ConfigurationService? configurationService,
    ExternalUrlService? externalUrlService,
    PendingImageUploadStore? store,
    GitHubAttachmentParser? parser,
  })  : _configurationService =
            configurationService ?? ConfigurationService(),
        _externalUrlService = externalUrlService ?? ExternalUrlService(),
        _store = store ?? PendingImageUploadStore(),
        _parser = parser ?? GitHubAttachmentParser();

  static const pendingContent =
      'Bild-Upload ausstehend. Bitte dieses Issue nicht importieren.';

  final ConfigurationService _configurationService;
  final ExternalUrlService _externalUrlService;
  final PendingImageUploadStore _store;
  final GitHubAttachmentParser _parser;

  @override
  Future<PendingImageUpload?> loadPending() => _store.load();

  @override
  Future<PendingImageUpload> start({
    required String title,
    required Map<String, String> values,
    required ImageSourceFile image,
  }) async {
    final configuration = await _configurationService.load();
    final service = _githubService(configuration);
    final startedAt = DateTime.now().toUtc();
    final pendingValues = {...values, 'content': pendingContent};
    final issue = await service.createIssue(
      title: '${imageSourceTemplate.titlePrefix}${title.trim()}',
      body: GitHubService.issueBody(imageSourceTemplate, pendingValues),
      labels: const [],
    );
    final upload = PendingImageUpload(
      issueNumber: issue.number,
      issueUrl: issue.url,
      createdAt: startedAt,
      title: title.trim(),
      values: Map.unmodifiable(values),
      image: image,
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
      // Der persistierte Ablauf kann über „GitHub öffnen“ fortgesetzt werden.
    }
    return upload;
  }

  @override
  Future<CreatedIssue> verify(PendingImageUpload upload) async {
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
        'Noch kein GitHub-Attachment gefunden. Das Bild als Kommentar '
        'hochladen, den Kommentar absenden und erneut prüfen.',
      );
    }
    if (attachmentUrls.length > 1) {
      throw const FormatException(
        'Mehrere Attachments gefunden. Bitte nur ein Bild im Pending-Issue '
        'belassen und erneut prüfen.',
      );
    }

    final values = {
      ...upload.values,
      'content': _imageMarkdown(upload.image.name, attachmentUrls.single),
    };
    await service.updateIssueBody(
      upload.issueNumber,
      GitHubService.issueBody(imageSourceTemplate, values),
    );
    await service.addIssueLabel(upload.issueNumber, 'quelle');
    await _store.clear();
    return CreatedIssue(number: upload.issueNumber, url: upload.issueUrl);
  }

  @override
  Future<void> discard(PendingImageUpload upload) async {
    final configuration = await _configurationService.load();
    await _githubService(configuration).closeIssue(upload.issueNumber);
    await _store.clear();
  }

  @override
  Future<void> open(PendingImageUpload upload) {
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

  String _imageMarkdown(String name, String url) {
    final safeName = name.replaceAll(RegExp(r'[\[\]\r\n]'), '_');
    return '![$safeName]($url)';
  }
}
