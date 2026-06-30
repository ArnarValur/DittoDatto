import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import 'favorite_repository.dart';

/// Provides a [FavoriteRepository] wired to the consumer's authenticated
/// SurrealDB connection.
///
/// Returns `null` when the user is not authenticated (no consumer DB).
final favoriteRepositoryProvider = Provider<FavoriteRepository?>((ref) {
  final dittoAuth = ref.watch(dittoAuthProvider);
  final db = dittoAuth.consumerDb;
  if (db == null) return null;
  return FavoriteRepository(db);
});

/// Whether the given [targetId] is favorited by the current user.
///
/// Returns `false` when not authenticated (no DB check needed).
/// Auto-disposes when the widget leaves the tree.
final isFavoritedProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, targetId) async {
  final repo = ref.watch(favoriteRepositoryProvider);
  if (repo == null) return false;
  return repo.isFavorited(targetId);
});

/// Notifier for toggling favorites with optimistic UI.
///
/// Call `toggle(targetId)` to add/remove a favorite. The provider
/// `isFavoritedProvider` is invalidated on success so the heart icon
/// updates across the app.
final toggleFavoriteProvider =
    AsyncNotifierProvider<ToggleFavoriteNotifier, void>(
  ToggleFavoriteNotifier.new,
);

class ToggleFavoriteNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Toggle the favorite state for [targetId].
  ///
  /// Reads current state from [isFavoritedProvider], then adds or removes.
  /// On success, invalidates the cached favorite state.
  /// On error, re-invalidates to revert optimistic UI.
  Future<bool> toggle(String targetId) async {
    final repo = ref.read(favoriteRepositoryProvider);
    if (repo == null) {
      throw StateError('Cannot toggle favorite — not authenticated');
    }

    // Read current state.
    final currentlyFavorited =
        await ref.read(isFavoritedProvider(targetId).future);

    try {
      if (currentlyFavorited) {
        await repo.removeFavorite(targetId);
      } else {
        await repo.addFavorite(targetId);
      }

      // Invalidate cached state so UI refreshes.
      ref.invalidate(isFavoritedProvider(targetId));

      return !currentlyFavorited;
    } catch (e) {
      debugPrint('⚠️ Favorite toggle error: $e');
      // Re-invalidate to revert any optimistic UI.
      ref.invalidate(isFavoritedProvider(targetId));
      rethrow;
    }
  }
}

/// Count of user's favorites (for profile sticker).
///
/// Returns 0 when not authenticated.
final favoritesCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(favoriteRepositoryProvider);
  if (repo == null) return 0;
  final favorites = await repo.listFavorites();
  return favorites.length;
});
