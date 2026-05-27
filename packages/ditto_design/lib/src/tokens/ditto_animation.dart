/// Standard animation durations for consistent motion.
abstract final class DittoAnimationDuration {
  /// 150ms — micro-interactions, hover states.
  static const Duration fast = Duration(milliseconds: 150);

  /// 300ms — standard transitions.
  static const Duration normal = Duration(milliseconds: 300);

  /// 500ms — deliberate, attention-drawing motion.
  static const Duration slow = Duration(milliseconds: 500);
}
