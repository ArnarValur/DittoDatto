import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/auth_provider.dart';
import '../../core/theme_provider.dart';
import '../favorites/favorite_providers.dart';
import 'establishment_providers.dart';

/// Test screen wired to **real DB data** from House of the North.
///
/// Fetches live data via [establishmentDebugProvider]. The provider is
/// `autoDispose` — navigating away closes the WebSocket, navigating back
/// triggers a fresh fetch. So BP edits show up immediately.
///
/// Temporary — will be replaced by a proper discovery-driven route.
class EstablishmentTestScreen extends ConsumerWidget {
  const EstablishmentTestScreen({super.key});

  /// The target ID used for favorites. Uses the establishment slug
  /// (not full record ID) to avoid SurrealDB record-link coercion.
  static const _targetId = 'house-of-the-north';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(establishmentDebugProvider);
    final authState = ref.watch(authProvider);
    final isAuthenticated = switch (authState) {
      AsyncData(:final value) => value is Authenticated,
      _ => false,
    };

    // Only check favorite state when authenticated.
    final isFavorited = isAuthenticated
        ? ref.watch(isFavoritedProvider(_targetId))
        : const AsyncData(false);
    final isFav = switch (isFavorited) {
      AsyncData(:final value) => value,
      _ => false,
    };

    return asyncData.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Establishment Test')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Kunne ikke laste etablering',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () =>
                      ref.invalidate(establishmentDebugProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Prøv igjen'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (data) => EstablishmentPage(
        data: data,
        onBack: () => context.pop(),
        onRefresh: () => ref.invalidate(establishmentDebugProvider),
        onThemeToggle: () => ref.read(isDarkModeProvider.notifier).toggle(),
        isDarkMode: ref.watch(isDarkModeProvider),
        isFavorited: isFav,
        onFavoriteTapped: () => _handleFavoriteTap(context, ref),
        onBookTapped: () => context.push('/booking', extra: data),
      ),
    );
  }

  void _handleFavoriteTap(BuildContext context, WidgetRef ref) {
    final authState = switch (ref.read(authProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

    if (authState is! Authenticated) {
      // Not logged in → navigate to login.
      context.go('/profile/login');
      return;
    }

    // Authenticated → toggle favorite.
    ref
        .read(toggleFavoriteProvider.notifier)
        .toggle(_targetId)
        .catchError((Object e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kunne ikke lagre favoritt: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    });
  }
}
