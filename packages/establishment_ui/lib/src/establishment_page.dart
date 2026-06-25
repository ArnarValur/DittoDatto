import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import 'models/establishment_data.dart';
import 'sections/establishment_about_grid.dart';
import 'sections/establishment_contact_section.dart';
import 'sections/establishment_gallery_placeholder.dart';
import 'sections/establishment_info_bar.dart';

/// The main establishment storefront page widget.
///
/// Renders a single vertically scrollable page with all establishment
/// sections stacked top-to-bottom. No horizontal tab transitions.
///
/// Consumed by:
/// - **Business Portal** — preview mode (set [isPreview] to `true`)
/// - **Public Marketplace** — customer-facing page
///
/// Uses [CustomScrollView] with slivers for optimal scroll performance
/// and future support for collapsible gallery headers.
class EstablishmentPage extends StatelessWidget {
  const EstablishmentPage({
    required this.data,
    this.isPreview = false,
    super.key,
  });

  /// The establishment data to render.
  final EstablishmentData data;

  /// Whether this is being shown in preview mode (Business Portal).
  /// When true, shows a draft indicator for unpublished establishments.
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        // Draft indicator (preview mode only, unpublished only)
        if (isPreview && !data.isPublished)
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: DittoSpacing.base,
                vertical: DittoSpacing.sm,
              ),
              color: colorScheme.tertiaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    size: 16,
                    color: colorScheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: DittoSpacing.xs),
                  Text(
                    'Utkast — ikke synlig for kunder',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Gallery placeholder (future: real image gallery)
        const EstablishmentGalleryPlaceholder(),

        // Identity bar: name, type badge, address, category
        EstablishmentInfoBar(data: data),

        // Divider
        const SliverToBoxAdapter(
          child: Divider(
            indent: DittoSpacing.base,
            endIndent: DittoSpacing.base,
          ),
        ),

        // About section (hidden if no about text)
        EstablishmentAboutGrid(data: data),

        // Spacing between cards
        if (data.about != null && data.about!.trim().isNotEmpty)
          const SliverToBoxAdapter(
            child: SizedBox(height: DittoSpacing.sm),
          ),

        // Contact section (hidden if no contact info)
        EstablishmentContactSection(data: data),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: DittoSpacing.xl),
        ),
      ],
    );
  }
}
