import 'package:ditto_auth/ditto_auth.dart';
import 'package:discovery_service/discovery_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surrealdb/surrealdb.dart';

import '../auth/auth_provider.dart';
import 'establishment_model.dart';

/// Sync an [Establishment] to discovery when published.
///
/// Opens a dedicated connection to `companies/discovery`, signs in as
/// `bp_portal` (EDITOR), performs the sync, then closes. Follows the
/// same connect-use-close pattern as [categoriesProvider].
Future<void> syncEstablishmentToDiscovery({
  required Establishment establishment,
  required String companySlug,
  required WidgetRef ref,
}) async {
  final db = await _openDiscoveryDb(ref);
  if (db == null) return;

  try {
    final syncService = ListingSyncService(db);
    await syncService.syncListing(
      data: establishment.toJson(),
      companySlug: companySlug,
    );
    debugPrint('✅ Discovery sync: ${establishment.name}');
  } catch (e) {
    debugPrint('⚠️ Discovery sync failed for ${establishment.name}: $e');
  } finally {
    db.close();
  }
}

/// Deactivate a listing in discovery when unpublished.
Future<void> deactivateDiscoveryListing({
  required String companySlug,
  required String establishmentSlug,
  required WidgetRef ref,
}) async {
  final db = await _openDiscoveryDb(ref);
  if (db == null) return;

  try {
    final syncService = ListingSyncService(db);
    await syncService.deactivateListing(
      companySlug: companySlug,
      establishmentSlug: establishmentSlug,
    );
    debugPrint('✅ Discovery deactivated: $establishmentSlug');
  } catch (e) {
    debugPrint('⚠️ Discovery deactivate failed for $establishmentSlug: $e');
  } finally {
    db.close();
  }
}

/// Open a short-lived connection to `companies/discovery`.
///
/// Signs in as `bp_portal` with EDITOR role. Returns null if auth
/// is not available.
Future<SurrealDB?> _openDiscoveryDb(WidgetRef ref) async {
  final auth = ref.read(dittoAuthProvider);
  final backend = auth.backend;
  if (backend is! SurrealAuthBackend) return null;

  final wsEndpoint = backend.wsUrl ?? SurrealAuthBackend.deriveWsUrl();
  final db = SurrealDB(wsEndpoint);
  db.connect();
  await db.wait();

  try {
    await db.signin(
      user: backend.serviceUser,
      pass: backend.servicePass,
      namespace: 'companies',
      database: 'discovery',
    );
    return db;
  } catch (e) {
    debugPrint('⚠️ Discovery DB signin failed: $e');
    db.close();
    return null;
  }
}
