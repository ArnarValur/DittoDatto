import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme_provider.dart';

/// Viewport presets for preview mode.
enum _PreviewViewport {
  desktop(label: 'Desktop', icon: Icons.desktop_windows_outlined, width: null),
  tablet(label: 'Nettbrett', icon: Icons.tablet_outlined, width: 1024),
  mobile(label: 'Mobil', icon: Icons.phone_android_outlined, width: 412);

  const _PreviewViewport({
    required this.label,
    required this.icon,
    required this.width,
  });

  /// Norwegian label for the toggle button.
  final String label;

  /// Icon for the toggle button.
  final IconData icon;

  /// Fixed viewport width in pixels, or `null` for "use full window width".
  final double? width;
}

/// Full-screen establishment preview — no sidebar, no dashboard chrome.
///
/// Renders the shared [EstablishmentPage] edge-to-edge with a slim
/// top bar for navigation (back), viewport toggle (desktop/tablet/mobile),
/// and future features (search, dark mode toggle, user avatar, etc.).
class EstablishmentPreviewScreen extends ConsumerStatefulWidget {
  const EstablishmentPreviewScreen({
    required this.data,
    super.key,
  });

  final EstablishmentData data;

  @override
  ConsumerState<EstablishmentPreviewScreen> createState() =>
      _EstablishmentPreviewScreenState();
}

class _EstablishmentPreviewScreenState
    extends ConsumerState<EstablishmentPreviewScreen> {
  _PreviewViewport _viewport = _PreviewViewport.desktop;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // ── Top bar — back + search pill + viewport toggle ──
          _buildTopBar(context, colorScheme),

          // Subtle divider
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),

          // ── Establishment page fills remaining space ──
          Expanded(
            child: _buildPreviewBody(colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
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

            // Right — viewport toggle + theme toggle
            _buildViewportToggle(colorScheme),
            const SizedBox(width: DittoSpacing.sm),
            _buildThemeToggle(colorScheme),
            const SizedBox(width: DittoSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildViewportToggle(ColorScheme colorScheme) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _PreviewViewport.values.map((vp) {
          final isSelected = _viewport == vp;
          return Tooltip(
            message: vp.label,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _viewport = vp),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    vp.icon,
                    size: 18,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThemeToggle(ColorScheme colorScheme) {
    final isDark = ref.watch(isDarkModeProvider);
    return Tooltip(
      message: isDark ? 'Bytt til lyst tema' : 'Bytt til mørkt tema',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => ref.read(isDarkModeProvider.notifier).toggle(),
          child: Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewBody(ColorScheme colorScheme) {
    final targetWidth = _viewport.width;

    // Desktop — no constraint, full width
    if (targetWidth == null) {
      return EstablishmentPage(
        data: widget.data,
        isPreview: true,
      );
    }

    // Tablet / Mobile — constrain width and override MediaQuery
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final effectiveWidth =
            targetWidth > availableWidth ? availableWidth : targetWidth;

        // Override MediaQuery so the EstablishmentPage sees the
        // constrained width and adjusts its responsive layout.
        final parentMediaQuery = MediaQuery.of(context);
        final overriddenMediaQuery = parentMediaQuery.copyWith(
          size: Size(effectiveWidth, parentMediaQuery.size.height),
        );

        return Container(
          color: colorScheme.surfaceContainerLow,
          child: Center(
            child: Container(
              width: effectiveWidth,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: MediaQuery(
                data: overriddenMediaQuery,
                child: EstablishmentPage(
                  data: widget.data,
                  isPreview: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
