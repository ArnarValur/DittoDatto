import 'package:flutter/material.dart';

import '../tokens/ditto_spacing.dart';

/// A centered empty-state display with icon, message, and optional action.
class DittoEmptyView extends StatelessWidget {
  /// Creates an empty-state view.
  const DittoEmptyView({
    super.key,
    required this.message,
    this.icon,
    this.action,
  });

  /// Message describing why the view is empty.
  final String message;

  /// Icon displayed above the message. Defaults to [Icons.inbox_rounded].
  final IconData? icon;

  /// Optional action widget (e.g., a button to create a first item).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DittoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: DittoSpacing.base),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: DittoSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
