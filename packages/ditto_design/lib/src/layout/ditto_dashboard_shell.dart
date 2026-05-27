import 'package:flutter/material.dart';

import '../tokens/ditto_animation.dart';
import '../tokens/ditto_colors.dart';
import '../tokens/ditto_spacing.dart';
import 'ditto_window_class.dart';

/// A navigation destination for the dashboard shell.
class DittoNavItem {
  /// Creates a navigation destination.
  const DittoNavItem({
    required this.icon,
    required this.label,
    this.badge,
  });

  /// Icon displayed for this destination.
  final IconData icon;

  /// Label text displayed next to the icon.
  final String label;

  /// Optional badge text (e.g., unread count).
  final String? badge;
}

/// Responsive dashboard shell with collapsible sidebar.
///
/// On wide screens (≥ 600 px): permanent sidebar with navigation items,
/// header, footer, and main content area.
/// On narrow screens (< 600 px): drawer-based navigation.
///
/// This widget is pure Flutter — no Riverpod dependency. Apps wire
/// it to their state management via constructor callbacks.
class DittoDashboardShell extends StatelessWidget {
  /// Creates a responsive dashboard shell.
  const DittoDashboardShell({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.header,
    this.footer,
    this.sidebarWidth = 240,
  });

  /// Navigation destinations shown in the sidebar / drawer.
  final List<DittoNavItem> destinations;

  /// Currently selected destination index.
  final int selectedIndex;

  /// Called when the user taps a destination.
  final ValueChanged<int> onDestinationSelected;

  /// Main content area.
  final Widget body;

  /// Widget displayed at the top of the sidebar (e.g., app branding).
  final Widget? header;

  /// Widget displayed at the bottom of the sidebar (e.g., user info).
  final Widget? footer;

  /// Width of the permanent sidebar on wide screens.
  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowClass = DittoWindowClass.of(constraints.maxWidth);

        if (windowClass.showPermanentSidebar) {
          return _DesktopLayout(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            body: body,
            header: header,
            footer: footer,
            sidebarWidth: sidebarWidth,
          );
        }

        return _MobileLayout(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          body: body,
          header: header,
          footer: footer,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Desktop: permanent sidebar + body
// ─────────────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.header,
    this.footer,
    required this.sidebarWidth,
  });

  final List<DittoNavItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final Widget? header;
  final Widget? footer;
  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: sidebarWidth,
          child: _SidebarContent(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            header: header,
            footer: footer,
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Colors.white.withValues(alpha: 0.06),
        ),
        Expanded(child: body),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Mobile: scaffold with drawer
// ─────────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.header,
    this.footer,
  });

  final List<DittoNavItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: DittoColors.sidebarBg,
        child: SafeArea(
          child: _SidebarContent(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              Navigator.of(context).pop(); // close drawer
              onDestinationSelected(index);
            },
            header: header,
            footer: footer,
          ),
        ),
      ),
      body: body,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Shared sidebar content
// ─────────────────────────────────────────────────────────────────────

class _SidebarContent extends StatelessWidget {
  const _SidebarContent({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.header,
    this.footer,
  });

  final List<DittoNavItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DittoColors.sidebarBg,
      child: Column(
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.all(DittoSpacing.base),
              child: header!,
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: DittoSpacing.sm,
                vertical: DittoSpacing.xs,
              ),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final item = destinations[index];
                final selected = index == selectedIndex;
                return _NavTile(
                  item: item,
                  selected: selected,
                  onTap: () => onDestinationSelected(index),
                );
              },
            ),
          ),
          if (footer != null) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            Padding(
              padding: const EdgeInsets.all(DittoSpacing.base),
              child: footer!,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Single navigation tile with animated selection
// ─────────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DittoNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: AnimatedContainer(
        duration: DittoAnimationDuration.fast,
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DittoSpacing.sm),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(DittoSpacing.sm),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DittoSpacing.md,
                vertical: DittoSpacing.sm + 2,
              ),
              child: Row(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: DittoAnimationDuration.fast,
                    style: TextStyle(
                      color: selected ? primaryColor : Colors.white54,
                    ),
                    child: Icon(
                      item.icon,
                      size: 20,
                      color: selected ? primaryColor : Colors.white54,
                    ),
                  ),
                  const SizedBox(width: DittoSpacing.md),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: DittoAnimationDuration.fast,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w500 : FontWeight.w400,
                        color: selected ? primaryColor : Colors.white70,
                      ),
                      child: Text(item.label),
                    ),
                  ),
                  if (item.badge != null) ...[
                    const SizedBox(width: DittoSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DittoSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(DittoSpacing.md),
                      ),
                      child: Text(
                        item.badge!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
