import 'package:flutter/material.dart';

/// DittoDatto Admin Panel color system.
///
/// Built on Material 3 dark theme with Moody Blue (#6f71cc) as primary seed.
class AppColors {
  AppColors._();

  /// Primary seed color — Moody Blue.
  static const Color moodyBlue = Color(0xFF6f71cc);

  /// Surface colors matching the Chapter 1 Nuxt admin panel aesthetic.
  static const Color surfaceDark = Color(0xFF0f1117);
  static const Color surfaceContainer = Color(0xFF161922);
  static const Color surfaceContainerHigh = Color(0xFF1c1f2b);

  /// Sidebar background (slightly lighter than main surface).
  static const Color sidebarBg = Color(0xFF141720);

  /// Status/tier badge colors.
  static const Color premiumBadge = Color(0xFF3b82f6);
  static const Color freeBadge = Color(0xFF6b7280);

  /// Success / error.
  static const Color success = Color(0xFF22c55e);
  static const Color error = Color(0xFFef4444);
  static const Color warning = Color(0xFFf59e0b);
}
