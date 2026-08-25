import '../models/shared_content.dart';
import '../models/source_template.dart';

class SourcePrefillService {
  static final _urlPattern = RegExp(r'https?://[^\s]+', caseSensitive: false);

  Map<String, String> valuesFor(
    SourceTemplate template,
    SharedContent content,
  ) {
    if (content.kind == SharedContentKind.image ||
        content.kind == SharedContentKind.imageError) {
      return const {};
    }
    final text = content.text.trim();
    if (text.isEmpty) {
      return const {};
    }

    if (content.kind == SharedContentKind.link) {
      return _linkValues(template, text);
    }
    return _textValues(template, text);
  }

  Map<String, String> _linkValues(SourceTemplate template, String text) {
    final result = <String, String>{};
    final match = _urlPattern.firstMatch(text);
    final url = match?.group(0);
    final urlField = _firstExistingField(template, const ['urls', 'sources']);

    if (url != null && urlField != null) {
      result[urlField] = url;
      final remaining = text.replaceFirst(url, '').trim();
      if (remaining.isNotEmpty) {
        final notesField = _firstExistingField(
          template,
          const ['summary', 'description', 'agent_notes', 'notes'],
        );
        if (notesField != null) {
          result[notesField] = remaining;
        }
      }
      return result;
    }

    final fallbackField = _firstExistingField(
      template,
      const ['sources', 'urls', 'description', 'person_notes', 'agent_notes', 'notes'],
    );
    if (fallbackField != null) {
      result[fallbackField] = text;
    }
    return result;
  }

  Map<String, String> _textValues(SourceTemplate template, String text) {
    final field = _firstExistingField(
      template,
      const ['description', 'person_notes', 'summary', 'agent_notes', 'notes', 'sources'],
    );
    if (field == null) {
      return const {};
    }
    return {field: text};
  }

  String? _firstExistingField(SourceTemplate template, List<String> candidates) {
    final fieldIds = template.fields.map((field) => field.id).toSet();
    for (final candidate in candidates) {
      if (fieldIds.contains(candidate)) {
        return candidate;
      }
    }
    return null;
  }
}
