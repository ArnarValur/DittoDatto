import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

void main(List<String> args) async {
  final host = args.isNotEmpty ? args[0] : 'dittodatto';
  final url = 'ws://$host:8002/rpc';

  print('📡 Connecting to SurrealDB at $url...');
  final db = SurrealDB(url);
  
  try {
    db.connect();
    await db.wait().timeout(const Duration(seconds: 5));
    print('✅ Connection established.');
  } catch (e) {
    print('❌ Connection failed: $e');
    exit(1);
  }

  try {
    // 1. Fetch all companies
    print('\n🔑 Signing in to companies/registry...');
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'companies',
    );
    await db.use('companies', 'registry');
    
    final companiesResult = await db.query('SELECT * FROM company') as List;
    final companiesList = (companiesResult.first['result'] as List? ?? []);
    print('🏢 Found ${companiesList.length} companies.');

    // Map owner_id -> list of owned companies
    final Map<String, List<Map<String, dynamic>>> ownerToCompanies = {};
    for (final comp in companiesList.cast<Map<String, dynamic>>()) {
      final ownerId = comp['owner_id'] as String;
      ownerToCompanies.putIfAbsent(ownerId, () => []).add(comp);
    }

    // 2. Sign in to users/profiles
    print('\n🔑 Signing in to users/profiles...');
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'users',
    );
    await db.use('users', 'profiles');

    // Fetch all users
    final usersResult = await db.query('SELECT * FROM user') as List;
    final usersList = (usersResult.first['result'] as List? ?? []).cast<Map<String, dynamic>>();
    print('👥 Found ${usersList.length} users.');

    for (final user in usersList) {
      final userId = (user['id'] as String).split(':').last;
      final owned = ownerToCompanies[userId] ?? [];

      if (owned.isNotEmpty) {
        // This user owns companies!
        final allSlugs = owned.map((c) => c['slug'] as String).join(', ');

        print('⚡ Healing owner $userId (owns: $allSlugs) -> setting slug to $allSlugs and role to business.');
        
        await db.query(
          r'UPDATE type::record("user", $userId) SET role = "business", company_slug = $slug, company_membership_ids = $compIds, company_memberships = $memberships',
          {
            'userId': userId,
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
        if (user['role'] == 'business' || user['company_slug'] != null) {
          print('⚡ Healing non-owner user $userId -> reverting role to customer and clearing slug.');
          await db.query(
            r'UPDATE type::record("user", $userId) SET role = "customer", company_slug = none, company_membership_ids = [], company_memberships = []',
            {
              'userId': userId,
            },
          );
        }
      }
    }

    print('\n🎉 Database healing completed successfully!');
  } catch (e, stack) {
    print('❌ Error during healing: $e');
    print(stack);
  } finally {
    db.close();
  }
}
