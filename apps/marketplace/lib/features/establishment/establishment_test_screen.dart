import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(establishmentDebugProvider);

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
      data: (data) => Stack(
        children: [
          EstablishmentPage(data: data),
          // Debug refresh button — tap to re-fetch after BP edits.
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 8,
            child: IconButton.filled(
              onPressed: () =>
                  ref.invalidate(establishmentDebugProvider),
              icon: const Icon(Icons.refresh, size: 20),
              tooltip: 'Oppdater fra databasen',
              style: IconButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
