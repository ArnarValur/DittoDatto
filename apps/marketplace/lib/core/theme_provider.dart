import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for dark mode state.
class IsDarkModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// Whether the app is in dark mode.
///
/// Defaults to false (light theme). Toggled from the profile screen.
final isDarkModeProvider =
    NotifierProvider<IsDarkModeNotifier, bool>(IsDarkModeNotifier.new);
