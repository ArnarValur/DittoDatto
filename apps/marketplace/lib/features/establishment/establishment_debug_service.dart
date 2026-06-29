import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:surrealdb/surrealdb.dart';

/// Debug-only service — fetches real establishment data from the Hub.
///
/// Connects to `companies/company_house-of-the-north` using DB-level
/// credentials injected via `--dart-define`. This is a **temporary debug
/// pipe**, not production architecture. Will be replaced by the discovery
/// layer when that track ships.
///
/// Credentials:
/// - `SURREAL_URL` — WebSocket endpoint (e.g. `ws://dittodatto:8001/rpc`)
/// - `DEBUG_DB_USER` — DB-level user (defaults to `bp_portal`)
/// - `DEBUG_DB_PASS` — password for the DB user
class EstablishmentDebugService {
  static const _surrealUrl = String.fromEnvironment('SURREAL_URL');
  static const _dbUser = String.fromEnvironment(
    'DEBUG_DB_USER',
    defaultValue: 'bp_portal',
  );
  static const _dbPass = String.fromEnvironment('DEBUG_DB_PASS');
  static const _companySlug = 'dittodatto-as';

  SurrealDB? _db;

  /// Connect and authenticate to the company database (lazy, idempotent).
  Future<void> _ensureConnected() async {
    if (_db != null) return;

    if (_dbPass.isEmpty) {
      throw StateError(
        'DEBUG_DB_PASS not set. '
        'Build with --dart-define=DEBUG_DB_PASS=<value>',
      );
    }

    final wsEndpoint =
        _surrealUrl.isNotEmpty ? _surrealUrl : _deriveWsUrl();

    final db = SurrealDB(wsEndpoint);
    db.connect();
    await db.wait();

    await db.signin(
      user: _dbUser,
      pass: _dbPass,
      namespace: 'companies',
      database: 'company_$_companySlug',
    );

    _db = db;
    debugPrint('🔌 Debug pipe connected → company_$_companySlug');
  }

  /// Fetch the first published establishment as [EstablishmentData],
  /// including its services and service groups.
  Future<EstablishmentData> fetch() async {
    await _ensureConnected();

    // Batch query: establishment + its services + service groups.
    final result = await _db!.query(
      '''
      SELECT * FROM establishment WHERE is_published = true LIMIT 1;
      SELECT * FROM service WHERE is_active = true AND deleted_at IS NONE ORDER BY title;
      SELECT * FROM service_group WHERE deleted_at IS NONE ORDER BY sort_order;
      ''',
    );

    final row = _extractRowFromStatement(result, 0);
    if (row == null) {
      throw StateError(
        'No published establishment found in company_$_companySlug',
      );
    }

    final estId = row['id'] as String?;

    // Parse services, filtering to this establishment.
    final serviceRows = _extractAllRows(result, 1);
    final services = serviceRows
        .where((r) => _matchesEstablishment(r, estId))
        .map((r) => Service.fromJson(r))
        .toList();

    // Parse service groups, filtering to this establishment.
    final groupRows = _extractAllRows(result, 2);
    final groups = groupRows
        .where((r) => _matchesEstablishment(r, estId))
        .map((r) => ServiceGroup.fromJson(r))
        .toList();

    return _mapToEstablishmentData(row, services: services, groups: groups);
  }

  /// Close the WebSocket connection.
  void dispose() {
    _db?.close();
    _db = null;
  }

  // ── JSON → EstablishmentData mapping ─────────────────────────────────────

  static EstablishmentData _mapToEstablishmentData(
    Map<String, dynamic> json, {
    List<Service> services = const [],
    List<ServiceGroup> groups = const [],
  }) {
    final images = json['images'] as Map<String, dynamic>? ?? {};

    return EstablishmentData(
      name: json['name'] as String,
      businessType:
          EstablishmentType.fromString(json['store_type'] as String),
      address: json['address'] as String,
      city: json['city'] as String,
      zip: json['zip'] as String,
      country: (json['country'] as String?) ?? 'NO',
      category: json['category'] as String?,
      about: json['about'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      logoUrl: images['logo'] as String?,
      coverUrl: images['cover'] as String?,
      galleryUrls:
          (images['gallery'] as List<dynamic>?)?.cast<String>() ?? const [],
      coverLayoutMode: CoverLayoutMode.fromString(
        json['cover_layout_mode'] as String? ?? 'bento',
      ),
      latitude: _parseGeoLat(json['location']),
      longitude: _parseGeoLng(json['location']),
      services: services,
      serviceGroups: groups,
    );
  }

  /// Extract latitude from SurrealDB `geometry<point>` GeoJSON.
  /// Format: `{ type: "Point", coordinates: [lng, lat] }`
  static double? _parseGeoLat(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[1] as num?)?.toDouble();
  }

  /// Extract longitude from SurrealDB `geometry<point>` GeoJSON.
  static double? _parseGeoLng(dynamic location) {
    if (location is! Map<String, dynamic>) return null;
    final coords = location['coordinates'] as List<dynamic>?;
    if (coords == null || coords.length < 2) return null;
    return (coords[0] as num?)?.toDouble();
  }

  // ── SurrealDB result extraction ──────────────────────────────────────────

  /// Check if a row's `establishment` field matches the target record ID.
  static bool _matchesEstablishment(
    Map<String, dynamic> row,
    String? estId,
  ) {
    if (estId == null) return true;
    final rowEst = row['establishment'];
    if (rowEst is String) return rowEst == estId;
    if (rowEst is Map) return rowEst['id'] == estId;
    return true;
  }

  /// Extract the first row from a specific statement in a batch result.
  static Map<String, dynamic>? _extractRowFromStatement(
    dynamic result,
    int statementIndex,
  ) {
    final rows = _extractAllRows(result, statementIndex);
    return rows.isEmpty ? null : rows.first;
  }

  /// Extract all rows from a specific statement in a batch result.
  static List<Map<String, dynamic>> _extractAllRows(
    dynamic result,
    int statementIndex,
  ) {
    if (result is! List || result.length <= statementIndex) return [];

    final statement = result[statementIndex];

    // SurrealDB SDK wraps each statement as { result: [...], status: 'OK' }
    if (statement is Map && statement.containsKey('result')) {
      final inner = statement['result'];
      if (inner is List) {
        return inner
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList();
      }
      return [];
    }

    // Flat list — SDK might return rows directly.
    if (statement is List) {
      return statement
          .whereType<Map>()
          .map((m) => Map<String, dynamic>.from(m))
          .toList();
    }

    if (statement is Map) {
      return [Map<String, dynamic>.from(statement)];
    }

    return [];
  }

  /// Derive the WebSocket URL from the browser's page origin.
  static String _deriveWsUrl() {
    final base = Uri.base;
    final protocol = base.scheme == 'https' ? 'wss' : 'ws';
    final host = base.host;
    final port = base.hasPort ? ':${base.port}' : '';
    return '$protocol://$host$port/rpc';
  }
}
