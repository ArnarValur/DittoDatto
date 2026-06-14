import 'package:flutter/material.dart';

import 'ditto_border_radius.dart';
import 'ditto_colors.dart';

/// Tonal elevation tokens for surface layering.
///
/// Each variant provides three semantic levels:
/// - [level0] — page background
/// - [level1] — card / sidebar surface
/// - [level2] — elevated overlays, popovers
///
/// Use [dark] or [light] to match the active brightness.
class DittoElevation {
  const DittoElevation._({
    required this.level0,
    required this.level1,
    required this.level2,
  });

  /// Background surface.
  final Color level0;

  /// Card / container surface.
  final Color level1;

  /// Elevated overlay surface.
  final Color level2;

  /// Dark elevation — maps to the existing dark surface grades.
  static const DittoElevation dark = DittoElevation._(
    level0: DittoColors.surfaceDark,
    level1: DittoColors.surfaceContainer,
    level2: DittoColors.surfaceContainerHigh,
  );

  /// Light elevation — Stitch Enterprise Slate light surfaces.
  static const DittoElevation light = DittoElevation._(
    level0: Colors.white,
    level1: DittoColors.surfaceLight,
    level2: DittoColors.surfaceContainerLight,
  );

  /// Moody Blue accent glow for focus states.
  ///
  /// Apply as a `Container` decoration to create a subtle purple
  /// glow around focused or active elements.
  /// Matches Stitch token: `rgba(111, 113, 204, 0.15)`.
  static final BoxDecoration accentGlow = BoxDecoration(
    borderRadius: DittoBorderRadius.smallAll,
    boxShadow: [
      BoxShadow(
        color: DittoColors.moodyBlue.withValues(alpha: 0.15),
        blurRadius: 12,
        spreadRadius: 2,
      ),
    ],
  );
}
