import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/auth_provider.dart';
import '../../core/theme_provider.dart';

/// Consumer profile screen — "Hei, {name}" + current date + sign out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkModeProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Feil: $e')),
      ),
      data: (state) {
        if (state is! Authenticated) {
          // Router should redirect, but just in case.
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final firstName = _extractFirstName(state.name);
        final now = DateTime.now();
        final dateStr = DateFormat('EEEE d. MMMM yyyy', 'nb_NO').format(now);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil'),
            centerTitle: true,
            actions: [
              // Dark mode toggle.
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Lyst tema' : 'Mørkt tema',
                onPressed: () {
                  ref.read(isDarkModeProvider.notifier).toggle();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Avatar.
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Text(
                        _initials(state.name),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Greeting.
                  Center(
                    child: Text(
                      'Hei, $firstName 👋',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date.
                  Center(
                    child: Text(
                      'I dag er $dateStr',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email.
                  Center(
                    child: Text(
                      state.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Sign out button.
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logg ut'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Extract first name from full name.
  static String _extractFirstName(String? name) {
    if (name == null || name.trim().isEmpty) return 'der';
    return name.trim().split(' ').first;
  }

  /// Generate initials from name (e.g. "Arnar Valur" → "AV").
  static String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
