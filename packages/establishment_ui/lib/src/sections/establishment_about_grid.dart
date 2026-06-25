import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/establishment_data.dart';

/// About section displaying the establishment's description text.
///
/// Renders as a [SliverToBoxAdapter] inside an outlined card.
/// Hidden entirely when [EstablishmentData.about] is null or empty.
class EstablishmentAboutGrid extends StatelessWidget {
  const EstablishmentAboutGrid({
    required this.data,
    super.key,
  });

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    final about = data.about;
    if (about == null || about.trim().isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.base),
        child: Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(DittoSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: DittoSpacing.sm),
                    Text(
                      'Om oss',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DittoSpacing.sm),
                Text(
                  about,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
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
