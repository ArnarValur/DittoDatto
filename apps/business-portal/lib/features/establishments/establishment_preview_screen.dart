import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen establishment preview — no sidebar, no dashboard chrome.
///
/// Renders the shared [EstablishmentPage] edge-to-edge with a slim
/// top bar for navigation (back) and future features (search, dark
/// mode toggle, user avatar, etc.).
class EstablishmentPreviewScreen extends StatelessWidget {
  const EstablishmentPreviewScreen({
    required this.data,
    super.key,
  });

  final EstablishmentData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // ── Top bar — mirrors original Nuxt marketplace bar ──
          Container(
            color: colorScheme.surface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  // Back button
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    label: const Text('Tilbake'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DittoSpacing.base,
                      ),
                    ),
                  ),

                  // Center — placeholder for future search / AI input
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DittoSpacing.lg,
                      ),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Spør Datto om hva som helst...',
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Right — future features (dark mode, avatar, etc.)
                  const SizedBox(width: DittoSpacing.base),
                ],
              ),
            ),
          ),

          // Subtle divider
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),

          // ── Establishment page fills remaining space ──
          Expanded(
            child: EstablishmentPage(
              data: data,
              isPreview: true,
            ),
          ),
        ],
      ),
    );
  }
}
