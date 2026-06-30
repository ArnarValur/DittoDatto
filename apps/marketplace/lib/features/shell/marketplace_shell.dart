import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Three-tab bottom navigation shell for the Marketplace.
///
/// Home / Bookings / Profile — consumer-facing mobile layout.
/// Uses a glass-morphism bottom bar with backdrop blur and no labels.
class MarketplaceShell extends StatelessWidget {
  const MarketplaceShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: IconTheme(
            data: IconThemeData(size: 23),
            child: NavigationBar(
              height: 48,
              backgroundColor:
                  theme.colorScheme.surface.withValues(alpha: 0.85),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              indicatorColor:
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelBehavior:
                  NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: 'Utforsk',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Bestillinger',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outlined),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

