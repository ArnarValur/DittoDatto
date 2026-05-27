import 'package:flutter/material.dart';

/// Shows a confirmation dialog and returns `true` if the user confirms.
///
/// ```dart
/// final confirmed = await showDittoConfirmDialog(
///   context: context,
///   title: 'Delete listing?',
///   message: 'This action cannot be undone.',
///   confirmLabel: 'Delete',
///   confirmColor: DittoColors.error,
/// );
/// if (confirmed) { /* proceed */ }
/// ```
Future<bool> showDittoConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  Color? confirmColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      final effectiveColor = confirmColor ?? theme.colorScheme.primary;

      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: effectiveColor,
            ),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
