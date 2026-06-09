import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Database healing script: syncs user roles and company memberships
/// by cross-referencing companies/registry owners with users/profiles.
///
/// Usage:
///   SURREAL_USER=arnarvalur SURREAL_PASS=xxx dart run bin/sync_users.dart [host]
///
/// TODO(ADR-0015): Wrap per-user updates in BEGIN TRANSACTION ... COMMIT
/// to ensure atomicity. Currently, a mid-execution failure leaves the
/// database in a partially updated state.
void main(List<String> args) async {
  final host = args.isNotEmpty ? args[0] : 'dittodatto';
  final url = 'ws://$host:8002/rpc';

  final user = Platform.environment['SURREAL_USER'];
  final pass = Platform.environment['SURREAL_PASS'];
  if (user == null || pass == null) {
    stderr.writeln('Error: Set SURREAL_USER and SURREAL_PASS environment variables.');
    exit(1);
  }

  stderr.writeln('📡 Connecting to SurrealDB at $url...');
  final db = SurrealDB(url);

  try {
    db.connect();
    await db.wait().timeout(const Duration(seconds: 5));
    stderr.writeln('✅ Connection established.');
  } catch (e) {
    stderr.writeln('❌ Connection failed: $e');
    exit(1);
  }

  try {
    // 1. Fetch all companies
    stderr.writeln('\n🔑 Signing in to companies/registry...');
    await db.signin(user: user, pass: pass, namespace: 'companies');
    await db.use('companies', 'registry');

    final companiesResult = await db.query('SELECT * FROM company') as List;
    final companiesList = (companiesResult.first['result'] as List? ?? []);
    stderr.writeln('🏢 Found ${companiesList.length} companies.');

    // Map owner_id -> list of owned companies
    final Map<String, List<Map<String, dynamic>>> ownerToCompanies = {};
    for (final comp in companiesList.cast<Map<String, dynamic>>()) {
      final ownerId = comp['owner_id'] as String;
      ownerToCompanies.putIfAbsent(ownerId, () => []).add(comp);
    }

    // 2. Sign in to users/profiles
    stderr.writeln('\n🔑 Signing in to users/profiles...');
    await db.signin(user: user, pass: pass, namespace: 'users');
    await db.use('users', 'profiles');

    // Fetch all users
    final usersResult = await db.query('SELECT * FROM user') as List;
    final usersList = (usersResult.first['result'] as List? ?? []).cast<Map<String, dynamic>>();
    stderr.writeln('👥 Found ${usersList.length} users.');

    for (final userRecord in usersList) {
      final userId = (userRecord['id'] as String).split(':').last;
      final owned = ownerToCompanies[userId] ?? [];

      if (owned.isNotEmpty) {
        // This user owns companies!
        final allSlugs = owned.map((c) => c['slug'] as String).join(', ');

        final currentRole = userRecord['role'] as String? ?? 'customer';
        final targetRole = (currentRole == 'admin' || currentRole == 'super_admin')
            ? currentRole
            : 'business';

        stderr.writeln('⚡ Healing owner $userId (owns: $allSlugs) -> setting slug to $allSlugs and role to $targetRole.');

        await db.query(
          r'UPDATE type::record("user", $userId) SET role = $role, company_slug = $slug, company_membership_ids = $compIds, company_memberships = $memberships',
          {
            'userId': userId,
            'role': targetRole,
            'slug': allSlugs,
            'compIds': owned.map((c) => (c['id'] as String).split(':').last).toList(),
            'memberships': owned.map((c) => {
              'company_id': (c['id'] as String).split(':').last,
              'role': 'owner',
              'assigned_at': DateTime.now().toUtc().toIso8601String(),
            }).toList(),
          },
        );
      } else {
        // This user owns no companies!
        if (userRecord['role'] == 'business' || userRecord['company_slug'] != null) {
          final currentRole = userRecord['role'] as String? ?? 'customer';
          final targetRole = (currentRole == 'admin' || currentRole == 'super_admin')
              ? currentRole
              : 'customer';

          stderr.writeln('⚡ Healing non-owner user $userId -> setting role to $targetRole and clearing slug.');
          await db.query(
            r'UPDATE type::record("user", $userId) SET role = $role, company_slug = none, company_membership_ids = [], company_memberships = []',
            {
              'userId': userId,
              'role': targetRole,
            },
          );
        }
      }
    }

    stderr.writeln('\n🎉 Database healing completed successfully!');
  } catch (e, stack) {
    stderr.writeln('❌ Error during healing: $e');
    stderr.writeln(stack);
  } finally {
    db.close();
  }
}
