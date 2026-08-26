import 'package:flutter/material.dart';

class ValidationErrorItem {
  const ValidationErrorItem({
    required this.label,
    required this.onActivate,
  });

  final String label;
  final VoidCallback onActivate;
}

class ErrorSummary extends StatelessWidget {
  const ErrorSummary({
    super.key,
    required this.errors,
    this.focusNode,
  });

  final List<ValidationErrorItem> errors;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).colorScheme;
    return Focus(
      focusNode: focusNode,
      child: Semantics(
        container: true,
        liveRegion: true,
        label: '${errors.length} Fehler in den Eingaben',
        child: Card(
          key: const Key('validation-error-summary'),
          color: colors.errorContainer,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fehler in den Eingaben',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...errors.map(
                  (error) => TextButton.icon(
                    onPressed: error.onActivate,
                    icon: const Icon(Icons.arrow_forward),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(error.label),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
