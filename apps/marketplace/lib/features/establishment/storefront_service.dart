
import 'package:establishment_ui/establishment_ui.dart';
import 'package:surrealdb/surrealdb.dart';

/// Fetches full establishment detail from a company database via SurrealDB
/// WebSocket + server-side `fn::get_storefront()` function.
///
/// Uses the namespace-level `marketplace_reader` VIEWER user (ADR-0025).
/// No per-DB user provisioning needed — one credential covers all company DBs.
///
/// Flow: connect → signin(NS user) → use(company DB) → fn::get_storefront() → close
class StorefrontService {
  static const _surrealUrl = String.fromEnvironment('SURREAL_URL');
  static const _user = 'marketplace_reader';
  static const _pass = String.fromEnvironment(
    'MARKETPLACE_READER_PASS',
    defaultValue: 'marketplace-reader-pass',
  );

  /// Fetch full [EstablishmentData] (establishment + services + service groups)
  /// from `company_{companySlug}` via `fn::get_storefront()`.
  ///
  /// Opens a short-lived WS connection, queries, closes. No persistent state.
  Future<EstablishmentData> fetch(String companySlug) async {
    final wsEndpoint =
        _surrealUrl.isNotEmpty ? _surrealUrl : _deriveWsUrl();

    final db = SurrealDB(wsEndpoint);
    try {
      db.connect();
      await db.wait();

      // Authenticate as NS-level VIEWER (no database — that makes it NS auth).
      await db.signin(
        user: _user,
        pass: _pass,
        namespace: 'companies',
      );

      // Switch to the target company database.
      await db.use('companies', 'company_$companySlug');

      // Call the server-side function — all query logic is in the DB.
      final result = await db.query('RETURN fn::get_storefront()');

      return _mapResponse(result);
    } finally {
      db.close();
    }
  }

  // ── Response mapping ─────────────────────────────────────────────────────

  /// Map the fn::get_storefront() result → [EstablishmentData].
  ///
  /// Expected shape:
  /// ```json
  /// { "establishment": {...}, "services": [...], "service_groups": [...] }
  /// ```
  static EstablishmentData _mapResponse(dynamic result) {
    // SurrealDB query wraps results — unwrap the first statement.
    Map<String, dynamic> payload;
    if (result is List && result.isNotEmpty) {
      final first = result[0];
      if (first is Map && first.containsKey('result')) {
        payload = Map<String, dynamic>.from(first['result'] as Map);
      } else if (first is Map) {
        payload = Map<String, dynamic>.from(first);
      } else {
        throw StorefrontException('Unexpected result format: $first');
      }
    } else if (result is Map) {
      payload = Map<String, dynamic>.from(result);
    } else {
      throw StorefrontException('Unexpected result type: ${result.runtimeType}');
    }

    final estJson = payload['establishment'] as Map<String, dynamic>?;
    if (estJson == null) {
      throw StorefrontException('No published establishment found');
    }

    final images = estJson['images'] as Map<String, dynamic>? ?? {};

    final serviceRows =
        (payload['services'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            const [];
    final groupRows = (payload['service_groups'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        const [];

    final services = serviceRows
        .map((r) => Service.fromJson(Map<String, dynamic>.from(r)))
        .toList();
    final groups = groupRows
        .map((r) => ServiceGroup.fromJson(Map<String, dynamic>.from(r)))
        .toList();

    return EstablishmentData(
      name: estJson['name'] as String,
      businessType:
          EstablishmentType.fromString(estJson['store_type'] as String),
      address: estJson['address'] as String,
      city: estJson['city'] as String,
      zip: estJson['zip'] as String,
      country: (estJson['country'] as String?) ?? 'NO',
      category: estJson['category'] as String?,
      about: estJson['about'] as String?,
      phone: estJson['phone'] as String?,
      email: estJson['email'] as String?,
      website: estJson['website'] as String?,
      isPublished: estJson['is_published'] as bool? ?? false,
      logoUrl: images['logo'] as String?,
      coverUrl: images['cover'] as String?,
      galleryUrls:
          (images['gallery'] as List<dynamic>?)?.cast<String>() ?? const [],
      coverLayoutMode: CoverLayoutMode.fromString(
        estJson['cover_layout_mode'] as String? ?? 'bento',
      ),
      latitude: _parseGeoLat(estJson['location']),
      longitude: _parseGeoLng(estJson['location']),
      services: services,
      serviceGroups: groups,
    );
  }

  // ── Geo helpers ──────────────────────────────────────────────────────────

  static double? _parseGeoLat(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[1] as num?)?.toDouble();
  }

  static double? _parseGeoLng(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[0] as num?)?.toDouble();
  }

  // ── URL derivation ──────────────────────────────────────────────────────

  /// Derive the WebSocket URL from the browser's page origin.
  static String _deriveWsUrl() {
    final base = Uri.base;
    final protocol = base.scheme == 'https' ? 'wss' : 'ws';
    final host = base.host;
    final port = base.hasPort ? ':${base.port}' : '';
    return '$protocol://$host$port/rpc';
  }
}

/// Exception thrown when a storefront fetch fails.
class StorefrontException implements Exception {
  StorefrontException(this.message);
  final String message;

  @override
  String toString() => 'StorefrontException: $message';
}
