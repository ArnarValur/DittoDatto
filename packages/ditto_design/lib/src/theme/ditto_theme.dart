import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/ditto_border_radius.dart';
import '../tokens/ditto_colors.dart';

/// DittoDatto theme system.
///
/// Provides [dark] and [light] themes built from the Moody Blue
/// `#6F71CC` seed color. The dark theme exactly reproduces the
/// existing admin panel aesthetic (zero visual regression).
abstract final class DittoTheme {
  /// Dark theme — matches the existing admin panel look.
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DittoColors.moodyBlue,
      brightness: Brightness.dark,
      surface: DittoColors.surfaceDark,
      surfaceContainerLowest: DittoColors.surfaceDark,
      surfaceContainerLow: DittoColors.sidebarBg,
      surfaceContainer: DittoColors.surfaceContainer,
      surfaceContainerHigh: DittoColors.surfaceContainerHigh,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DittoColors.surfaceDark,
      appBarTheme: AppBarTheme(
        backgroundColor: DittoColors.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: DittoColors.sidebarBg,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: DittoColors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DittoBorderRadius.mediumAll,
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DittoColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: DittoBorderRadius.smallAll,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DittoBorderRadius.smallAll,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DittoBorderRadius.smallAll,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white54,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: DittoBorderRadius.smallAll,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.06),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DittoColors.surfaceContainerHigh,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DittoBorderRadius.smallAll,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Light theme — Stitch-driven Material 3 from Moody Blue seed.
  ///
  /// Hand-tuned surface colors from the Stitch Enterprise Slate design
  /// system. Component themes mirror the dark theme's structure.
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: DittoColors.moodyBlue,
      brightness: Brightness.light,
      surface: DittoColors.surfaceLight,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: DittoColors.surfaceLight,
      surfaceContainer: DittoColors.surfaceContainerLight,
      surfaceContainerHigh: DittoColors.surfaceContainerHighLight,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: DittoColors.surfaceLight,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DittoBorderRadius.mediumAll,
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DittoColors.surfaceContainerLight,
        border: OutlineInputBorder(
          borderRadius: DittoBorderRadius.smallAll,
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DittoBorderRadius.smallAll,
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DittoBorderRadius.smallAll,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: DittoBorderRadius.smallAll,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DittoBorderRadius.smallAll,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
