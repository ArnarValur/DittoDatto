import 'package:ditto_auth/ditto_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';
import 'package:surrealdb/surrealdb.dart';

import '../auth/auth_provider.dart';

/// A category entry from the platform discovery DB.
class CategoryEntry {
  const CategoryEntry({required this.name, this.icon});

  final String name;
  final String? icon;
}

/// Material icon lookup from snake_case icon name strings.
///
/// Maps the icon names stored in the DB (e.g. 'smart_toy', 'local_bar')
/// to their corresponding Material [IconData].
IconData? resolveIcon(String? iconName) {
  if (iconName == null) return null;
  return _iconMap[iconName];
}

const _iconMap = <String, IconData>{
  'smart_toy': Icons.smart_toy,
  'local_bar': Icons.local_bar,
  'fitness_center': Icons.fitness_center,
  'content_cut': Icons.content_cut,
  'computer': Icons.computer,
  'nightlife': Icons.nightlife,
  'restaurant': Icons.restaurant,
  'local_shipping': Icons.local_shipping,
  'theater_comedy': Icons.theater_comedy,
  'favorite': Icons.favorite,
  'store': Icons.store,
  'shopping_bag': Icons.shopping_bag,
  'spa': Icons.spa,
  'music_note': Icons.music_note,
  'school': Icons.school,
  'medical_services': Icons.medical_services,
  'pets': Icons.pets,
  'sports_esports': Icons.sports_esports,
  'build': Icons.build,
  'camera_alt': Icons.camera_alt,
  'brush': Icons.brush,
  'directions_car': Icons.directions_car,
  'flight': Icons.flight,
  'hotel': Icons.hotel,
  'local_cafe': Icons.local_cafe,
  'local_pizza': Icons.local_pizza,
};

/// Platform-wide category list fetched from `companies/discovery`.
///
/// Uses the same `bp_portal` credentials as the tenant connection.
/// Categories are admin-managed and rarely change.
final categoriesProvider = FutureProvider<List<CategoryEntry>>((ref) async {
  // Wait for auth to be ready (we need the ws URL and credentials).
  final authState = ref.watch(authProvider).value;
  if (authState is! Authenticated) return [];

  final auth = ref.read(dittoAuthProvider);
  final backend = auth.backend;

  // Only works with SurrealAuthBackend (which provides wsUrl + creds).
  if (backend is! SurrealAuthBackend) return [];

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

    final result =
        await db.query('SELECT name, icon FROM category ORDER BY name ASC');

    // Parse the SurrealDB response.
    List<dynamic> rows;
    if (result is List && result.isNotEmpty) {
      final first = result.first;
      if (first is Map && first.containsKey('result')) {
        rows = first['result'] as List<dynamic>? ?? [];
      } else {
        rows = result;
      }
    } else {
      return [];
    }

    return rows.whereType<Map<String, dynamic>>().map((row) {
      return CategoryEntry(
        name: row['name'] as String,
        icon: row['icon'] as String?,
      );
    }).toList();
  } finally {
    db.close();
  }
});
