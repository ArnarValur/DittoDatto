import 'package:flutter/material.dart';

/// DittoDatto color system.
///
/// Built on Moody Blue (#6F71CC) primary seed with hand-tuned
/// dark surface grades extracted from the existing admin theme.
abstract final class DittoColors {
  /// Primary seed — Moody Blue.
  static const Color moodyBlue = Color(0xFF3F51B5);

  // ── Dark surface grades ──

  /// Darkest background surface.
  static const Color surfaceDark = Color(0xFF0f1117);

  /// Sidebar / navigation background.
  static const Color sidebarBg = Color(0xFF141720);

  /// Card / container surface.
  static const Color surfaceContainer = Color(0xFF161922);

  /// Elevated container surface.
  static const Color surfaceContainerHigh = Color(0xFF1c1f2b);

  // ── Light surface grades (Stitch Enterprise Slate) ──

  /// Light background surface — warm off-white.
  static const Color surfaceLight = Color(0xFFF9F9FC);

  /// Light container surface.
  static const Color surfaceContainerLight = Color(0xFFEEEEF0);

  /// Light elevated container surface.
  static const Color surfaceContainerHighLight = Color(0xFFE8E8EA);

  // ── Status colors ──

  /// Success green.
  static const Color success = Color(0xFF22c55e);

  /// Error red.
  static const Color error = Color(0xFFBA1A1A);

  /// Warning amber.
  static const Color warning = Color(0xFFf59e0b);

  // ── Badge colors ──

  /// Premium tier badge.
  static const Color premiumBadge = Color(0xFF3b82f6);

  /// Free tier badge.
  static const Color freeBadge = Color(0xFF6b7280);
}
