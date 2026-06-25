import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for dark mode state.
class IsDarkModeNotifier extends Notifier<bool> {
  @override
  bool build() => true; // default to dark — easier on the eyes

  void toggle() => state = !state;
}

/// Whether the app is in dark mode.
///
/// Defaults to true (dark theme). Toggled from the sidebar footer.
final isDarkModeProvider =
    NotifierProvider<IsDarkModeNotifier, bool>(IsDarkModeNotifier.new);
