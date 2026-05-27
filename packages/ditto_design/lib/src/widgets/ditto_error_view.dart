import 'package:flutter/material.dart';

import '../tokens/ditto_colors.dart';
import '../tokens/ditto_spacing.dart';

/// A centered error display with icon, message, and optional retry button.
class DittoErrorView extends StatelessWidget {
  /// Creates an error view.
  const DittoErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  /// Error message to display.
  final String message;

  /// Called when the user taps the retry button. If null, no button is shown.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DittoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: DittoColors.error,
            ),
            const SizedBox(height: DittoSpacing.base),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: DittoSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
