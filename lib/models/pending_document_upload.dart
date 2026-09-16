import 'document_source_file.dart';

class PendingDocumentUpload {
  const PendingDocumentUpload({
    required this.issueNumber,
    required this.issueUrl,
    required this.createdAt,
    required this.templateId,
    required this.title,
    required this.values,
    required this.document,
  });

  final int issueNumber;
  final String issueUrl;
  final DateTime createdAt;
  final String templateId;
  final String title;
  final Map<String, String> values;
  final DocumentSourceFile document;

  Map<String, Object> toJson() => {
        'issueNumber': issueNumber,
        'issueUrl': issueUrl,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'templateId': templateId,
        'title': title,
        'values': values,
        'document': {
          'path': document.path,
          'name': document.name,
          'mimeType': document.mimeType,
          'sizeBytes': document.sizeBytes,
        },
      };

  factory PendingDocumentUpload.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] as Map<String, dynamic>? ?? const {};
    final rawDocument = json['document'] as Map<String, dynamic>? ?? const {};
    return PendingDocumentUpload(
      issueNumber: json['issueNumber'] as int,
      issueUrl: json['issueUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      templateId: json['templateId'] as String,
      title: json['title'] as String,
      values: rawValues.map((key, value) => MapEntry(key, value.toString())),
      document: DocumentSourceFile(
        path: rawDocument['path'] as String,
        name: rawDocument['name'] as String,
        mimeType: rawDocument['mimeType'] as String,
        sizeBytes: rawDocument['sizeBytes'] as int,
      ),
    );
  }
}
