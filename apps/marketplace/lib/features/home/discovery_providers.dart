import 'dart:async';

import 'package:ditto_auth/ditto_auth.dart';
import 'package:discovery_service/discovery_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surrealdb/surrealdb.dart';

import '../../core/app_event_log.dart';

/// WebSocket URL injected at build time via `--dart-define=SURREAL_URL=...`.
const _surrealUrl = String.fromEnvironment('SURREAL_URL');

/// Discovery read user credentials.
///
/// Uses the namespace-level `marketplace_reader` VIEWER user (same as
/// EstablishmentDetailService). One credential covers all `companies/*` DBs.
const _discoveryUser = 'marketplace_reader';
const _discoveryPass = String.fromEnvironment(
  'MARKETPLACE_READER_PASS',
  defaultValue: 'marketplace-reader-pass',
);

/// Connection timeout for each WS operation.
const _timeout = Duration(seconds: 10);

// ── Helpers ────────────────────────────────────────────────────────────────

/// Open a short-lived connection to `companies/discovery`.
///
/// Connects, signs in at NS level, switches to discovery DB.
/// Caller MUST close when done.
/// Times out after [_timeout] per step — records failures in [AppEventLog].
Future<SurrealDB> _openDiscoveryDb() async {
  final wsEndpoint = _surrealUrl.isNotEmpty
      ? _surrealUrl
      : SurrealAuthBackend.deriveWsUrl();

  final db = SurrealDB(wsEndpoint);
  try {
    db.connect();
    await db.wait().timeout(_timeout);

    // NS-level signin (no database param) — VIEWER covers all DBs.
    await db.signin(
      user: _discoveryUser,
      pass: _discoveryPass,
      namespace: 'companies',
    ).timeout(_timeout);
    await db.use('companies', 'discovery').timeout(_timeout);
    return db;
  } on TimeoutException {
    db.close();
    AppEventLog.instance.record(AppEvent.connectionTimeout(
      target: wsEndpoint,
      context: '_openDiscoveryDb',
    ));
    rethrow;
  } on Exception catch (e) {
    db.close();
    AppEventLog.instance.record(AppEvent.connectionError(
      target: wsEndpoint,
      error: e,
      context: '_openDiscoveryDb',
    ));
    rethrow;
  }
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
