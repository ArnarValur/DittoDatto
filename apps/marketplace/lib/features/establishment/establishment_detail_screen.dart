import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury_client/mercury_client.dart';


import '../../core/auth_provider.dart';
import '../../core/theme_provider.dart';
import '../favorites/favorite_providers.dart';
import 'establishment_detail_service.dart';

/// Provider that fetches full establishment detail via the SurrealDB HTTP API.
///
/// Keyed by `companySlug` — each company slug gets its own auto-disposed fetch.
final establishmentDetailProvider = FutureProvider.autoDispose
    .family<EstablishmentData, String>((ref, companySlug) async {
  final service = EstablishmentDetailService();
  return service.fetch(companySlug);
});

/// Full establishment detail screen — driven by discovery layer.
///
/// Route: `/establishment/:companySlug/:slug`
/// Fetches full data (establishment + services + service groups) from the
/// company database via the `/establishment` HTTP API endpoint.
///
/// Replaces the old `EstablishmentTestScreen` (debug pipe).
class EstablishmentDetailScreen extends ConsumerWidget {
  const EstablishmentDetailScreen({
    required this.companySlug,
    required this.slug,
    super.key,
  });

  /// Company slug (e.g. `dittodatto-as`). Used to call the correct company DB.
  final String companySlug;

  /// Establishment slug (e.g. `house-of-the-north`). Used as favorite target ID.
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(establishmentDetailProvider(companySlug));
    final authState = ref.watch(authProvider);
    final isAuthenticated = switch (authState) {
      AsyncData(:final value) => value is Authenticated,
      _ => false,
    };

    // Only check favorite state when authenticated.
    final isFavorited = isAuthenticated
        ? ref.watch(isFavoritedProvider(slug))
        : const AsyncData(false);
    final isFav = switch (isFavorited) {
      AsyncData(:final value) => value,
      _ => false,
    };

    return asyncData.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        // Connectivity errors → redirect home with snackbar.
        if (error is EstablishmentDetailException) {
          // Schedule the redirect for after the current build frame.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go('/');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(error.message)),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Non-connectivity errors → show retry screen.
        return Scaffold(
          appBar: AppBar(title: const Text('Etablering')),
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
                    onPressed: () => ref.invalidate(
                      establishmentDetailProvider(companySlug),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Prøv igjen'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      data: (data) => EstablishmentPage(
        data: data,
        onBack: () => context.pop(),
        onRefresh: () =>
            ref.invalidate(establishmentDetailProvider(companySlug)),
        onThemeToggle: () => ref.read(isDarkModeProvider.notifier).toggle(),
        isDarkMode: ref.watch(isDarkModeProvider),
        isFavorited: isFav,
        onFavoriteTapped: () => _handleFavoriteTap(context, ref),
        onBookTapped: () => context.push(
              '/booking',
              extra: (data: data, companySlug: companySlug),
            ),
      ),
    );
  }

  void _handleFavoriteTap(BuildContext context, WidgetRef ref) {
    final authState = switch (ref.read(authProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

    if (authState is! Authenticated) {
      context.go('/profile/login');
      return;
    }

    ref.read(toggleFavoriteProvider.notifier).toggle(slug).catchError(
      (Object e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kunne ikke lagre favoritt: $e'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return false;
      },
    );
  }
}
