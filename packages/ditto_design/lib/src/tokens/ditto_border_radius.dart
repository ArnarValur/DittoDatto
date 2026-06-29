import 'package:flutter/material.dart';

/// Border radius tokens for consistent corner rounding.
abstract final class DittoBorderRadius {
  /// 4px radius value.
  static const double xs = 4;

  /// 8px radius value.
  static const double sm = 8;

  /// 12px radius value.
  static const double md = 12;

  /// 16px radius value.
  static const double lg = 16;

  /// 24px radius value.
  static const double xl = 24;

  /// 9999px radius value.
  static const double full = 9999;

  /// 4px all-corners [BorderRadius].
  static final BorderRadius extraSmallAll = BorderRadius.circular(xs);

  /// 8px all-corners [BorderRadius].
  static final BorderRadius smallAll = BorderRadius.circular(sm);

  /// 12px all-corners [BorderRadius].
  static final BorderRadius mediumAll = BorderRadius.circular(md);

  /// 16px all-corners [BorderRadius].
  static final BorderRadius largeAll = BorderRadius.circular(lg);

  /// 24px all-corners [BorderRadius].
  static final BorderRadius extraLargeAll = BorderRadius.circular(xl);

  /// 9999px all-corners [BorderRadius].
  static final BorderRadius circularAll = BorderRadius.circular(full);
}
