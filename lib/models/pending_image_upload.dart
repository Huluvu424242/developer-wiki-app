import 'image_source_file.dart';

class PendingImageUpload {
  const PendingImageUpload({
    required this.issueNumber,
    required this.issueUrl,
    required this.createdAt,
    required this.title,
    required this.values,
    required this.image,
  });

  final int issueNumber;
  final String issueUrl;
  final DateTime createdAt;
  final String title;
  final Map<String, String> values;
  final ImageSourceFile image;

  Map<String, Object> toJson() => {
        'issueNumber': issueNumber,
        'issueUrl': issueUrl,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'title': title,
        'values': values,
        'image': {
          'path': image.path,
          'name': image.name,
          'mimeType': image.mimeType,
          'sizeBytes': image.sizeBytes,
        },
      };

  factory PendingImageUpload.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] as Map<String, dynamic>? ?? const {};
    final rawImage = json['image'] as Map<String, dynamic>? ?? const {};
    return PendingImageUpload(
      issueNumber: json['issueNumber'] as int,
      issueUrl: json['issueUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      title: json['title'] as String,
      values: rawValues.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      image: ImageSourceFile(
        path: rawImage['path'] as String,
        name: rawImage['name'] as String,
        mimeType: rawImage['mimeType'] as String,
        sizeBytes: rawImage['sizeBytes'] as int,
      ),
    );
  }
}
