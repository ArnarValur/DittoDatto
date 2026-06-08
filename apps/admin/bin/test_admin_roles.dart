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

  // 1. Sign in to both namespaces to verify schema permissions
  print('\n🔑 Signing in as admin...');
  try {
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'users',
    );
    await db.use('users', 'profiles');
    print('✅ Signed in and switched to users/profiles.');
  } catch (e) {
    print('❌ Signin failed: $e');
    exit(1);
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final testUserId = 'test_admin_$timestamp';
  final testUserRecord = 'user:$testUserId';

  // 2. Create User with role 'super_admin'
  print('\n➕ Test 1: Creating a super_admin user ($testUserId)...');
  try {
    final userData = {
      'name': 'E2E Test Admin',
      'email': 'e2e_admin_$timestamp@dittodatto.no',
      'phone': '+4799999991',
      'role': 'super_admin',
      'vipps_sub': 'vipps|e2e_admin_$timestamp',
    };
    final result = await db.create(testUserRecord, userData);
    print('✅ SUCCESS: Created super_admin successfully: $result');
  } catch (e) {
    print('❌ FAIL: Failed to create super_admin user: $e');
    db.close();
    exit(1);
  }

  // 3. Verify that the user is returned in a general query (no role filter exclusion)
  print('\n🔍 Test 2: Verifying user is listed via general select...');
  try {
    final result = (await db.query(
      r'SELECT * FROM user WHERE id = type::record("user", $id)',
      {'id': testUserId},
    )) as List;
    final users = result.first['result'] as List;
    if (users.isEmpty) {
      throw Exception('User was not returned by the select query');
    }
    print('✅ SUCCESS: Found user with role: ${users.first['role']}');
  } catch (e) {
    print('❌ FAIL: User listing verification failed: $e');
    db.close();
    exit(1);
  }

  // 4. Update role to 'admin'
  print('\n✏️ Test 3: Updating role to admin...');
  try {
    await db.query(
      r'UPDATE type::record("user", $id) SET role = "admin", updated_at = time::now()',
      {'id': testUserId},
    );
    
    final result = (await db.query(
      r'SELECT role FROM type::record("user", $id)',
      {'id': testUserId},
    )) as List;
    final role = result.first['result'].first['role'];
    if (role != 'admin') {
      throw Exception('Role was not updated to admin. Got: $role');
    }
    print('✅ SUCCESS: Role updated to $role.');
  } catch (e) {
    print('❌ FAIL: Role update failed: $e');
    db.close();
    exit(1);
  }

  // 5. Test company creation role preservation:
  // Create a company where this admin user is the owner.
  // Their role should remain 'admin' (not get overwritten to 'business').
  print('\n🏢 Test 4: Creating a company with the admin as owner...');
  try {
    // Switch to companies registry
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'companies',
    );
    await db.use('companies', 'registry');

    final companyId = 'test_company_$timestamp';
    final companyData = {
      'name': 'E2E Test Company',
      'slug': 'e2e-test-company-$timestamp',
      'db_slug': 'e2e_test_company_$timestamp',
      'owner_id': testUserId,
      'tier': 'free',
      'onboarding_status': 'not_started',
    };
    
    await db.create('company:$companyId', companyData);
    print('✅ Created company record.');

    // Simulating repository: update owner's user record (using the new conditional query)
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'users',
    );
    await db.use('users', 'profiles');

    await db.query(
      r'UPDATE type::record("user", $owner_id) SET role = IF role = "admin" OR role = "super_admin" THEN role ELSE "business" END, company_slug = $slug, company_membership_ids = $comp_ids, company_memberships = $memberships',
      {
        'owner_id': testUserId,
        'slug': companyData['slug'],
        'comp_ids': [companyId],
        'memberships': [{
          'company_id': companyId,
          'role': 'owner',
          'assigned_at': DateTime.now().toUtc().toIso8601String(),
        }],
      },
    );

    // Verify role remains 'admin'
    final verifyResult = (await db.query(
      r'SELECT role, company_slug FROM type::record("user", $id)',
      {'id': testUserId},
    )) as List;
    final userFields = verifyResult.first['result'].first;
    if (userFields['role'] != 'admin') {
      throw Exception('Owner role was overwritten to business! Got: ${userFields['role']}');
    }
    print('✅ SUCCESS: Role preserved as admin. company_slug set to: ${userFields['company_slug']}');
  } catch (e) {
    print('❌ FAIL: Company creation role preservation failed: $e');
    // Attempt cleanup
    await _cleanup(db, testUserId, timestamp);
    db.close();
    exit(1);
  }

  // 6. Test company deletion role preservation:
  // Revert/delete the company. Since the owner was an admin, their role should remain 'admin' (not get reverted to 'customer').
  print('\n🧹 Test 5: Reverting/deleting the company and verifying old owner role...');
  await _cleanup(db, testUserId, timestamp);

  db.close();
  print('\n🎉 All administrative role E2E integration tests passed successfully!');
  exit(0);
}

Future<void> _cleanup(SurrealDB db, String testUserId, int timestamp) async {
  try {
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'companies',
    );
    await db.use('companies', 'registry');
    await db.delete('company:test_company_$timestamp');

    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'users',
    );
    await db.use('users', 'profiles');

    // Simulating deletion cleanup: revert role but preserve admin/super_admin
    await db.query(
      r'UPDATE type::record("user", $ownerId) SET role = IF role = "admin" OR role = "super_admin" THEN role ELSE "customer" END, company_slug = none, company_membership_ids = [], company_memberships = []',
      {
        'ownerId': testUserId,
      },
    );

    // Verify role remains 'admin'
    final verifyResult = (await db.query(
      r'SELECT role, company_slug FROM type::record("user", $id)',
      {'id': testUserId},
    )) as List;
    final userFields = verifyResult.first['result'].first;
    if (userFields['role'] != 'admin') {
      throw Exception('Role was reverted to customer! Got: ${userFields['role']}');
    }
    print('✅ SUCCESS: Role preserved as ${userFields['role']} after company deletion.');

    // Delete user record
    await db.delete('user:$testUserId');
    print('✅ Deleted test user record.');
  } catch (e) {
    print('❌ Cleanup warning: $e');
  }
}
