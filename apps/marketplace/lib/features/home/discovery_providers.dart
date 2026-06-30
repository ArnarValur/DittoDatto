import 'dart:async';

import 'package:ditto_auth/ditto_auth.dart';
import 'package:discovery_service/discovery_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surrealdb/surrealdb.dart';

/// WebSocket URL injected at build time via `--dart-define=SURREAL_URL=...`.
const _surrealUrl = String.fromEnvironment('SURREAL_URL');

/// Discovery read user credentials.
///
/// In production, this will be a dedicated `marketplace_reader` user.
/// For now, we use `bp_portal` which has EDITOR access (superset of read).
const _discoveryUser =
    String.fromEnvironment('DISCOVERY_USER', defaultValue: 'bp_portal');
const _discoveryPass =
    String.fromEnvironment('DISCOVERY_PASS', defaultValue: 'test-portal-pass');

// ── Helpers ────────────────────────────────────────────────────────────────

/// Open a short-lived connection to `companies/discovery`.
///
/// Connects, signs in, and returns the [SurrealDB] instance.
/// Caller MUST close when done.
Future<SurrealDB> _openDiscoveryDb() async {
  final wsEndpoint = _surrealUrl.isNotEmpty
      ? _surrealUrl
      : SurrealAuthBackend.deriveWsUrl();

  final db = SurrealDB(wsEndpoint);
  db.connect();
  await db.wait();

  await db.signin(
    user: _discoveryUser,
    pass: _discoveryPass,
    namespace: 'companies',
    database: 'discovery',
  );
  return db;
}

/// Execute a read query against discovery DB with connect-use-close.
Future<T> _withDiscoveryDb<T>(Future<T> Function(DiscoveryRepository) fn) async {
  final db = await _openDiscoveryDb();
  try {
    return await fn(DiscoveryRepository(db));
  } finally {
    db.close();
  }
}

// ── State Notifiers ────────────────────────────────────────────────────────

/// Currently selected category slug for filtering. Null = "Alle".
class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? slug) => state = slug;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
        SelectedCategoryNotifier.new);

/// DittoBar search query. Empty = no active search.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

// ── Data Providers ─────────────────────────────────────────────────────────

/// All discovery categories for chip display.
final categoriesProvider = FutureProvider<List<DiscoveryCategory>>((ref) async {
  return _withDiscoveryDb((repo) => repo.fetchCategories());
});

/// Active listings — filtered by category and/or search query.
///
/// Re-fetches whenever [selectedCategoryProvider] or [searchQueryProvider] changes.
final listingsProvider =
    FutureProvider<List<EstablishmentListing>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider);

  return _withDiscoveryDb((repo) {
    if (query.trim().isNotEmpty) {
      return repo.searchListings(query);
    }
    return repo.fetchListings(category: category);
  });
});
