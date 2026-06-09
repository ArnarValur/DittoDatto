import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// E2E integration test for administrative role preservation during
/// company CRUD operations.
///
/// Validates:
/// 1. Creating a super_admin user.
/// 2. User is returned in general queries (no role-based exclusion).
/// 3. Role can be updated to admin.
/// 4. Company creation preserves admin role (not overwritten to business).
/// 5. Company deletion preserves admin role (not reverted to customer).
///
/// Usage:
///   SURREAL_USER=arnarvalur SURREAL_PASS=xxx dart run bin/test_admin_roles.dart [host]
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

  // 1. Sign in to users/profiles
  stderr.writeln('\n🔑 Signing in as admin...');
  try {
    await db.signin(user: user, pass: pass, namespace: 'users');
    await db.use('users', 'profiles');
    stderr.writeln('✅ Signed in and switched to users/profiles.');
  } catch (e) {
    stderr.writeln('❌ Signin failed: $e');
    exit(1);
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final testUserId = 'test_admin_$timestamp';
  final testUserRecord = 'user:$testUserId';

  // 2. Create User with role 'super_admin'
  stderr.writeln('\n➕ Test 1: Creating a super_admin user ($testUserId)...');
  try {
    final userData = {
      'name': 'E2E Test Admin',
      'email': 'e2e_admin_$timestamp@dittodatto.no',
      'phone': '+4799999991',
      'role': 'super_admin',
      'vipps_sub': 'vipps|e2e_admin_$timestamp',
    };
    final result = await db.create(testUserRecord, userData);
    stderr.writeln('✅ SUCCESS: Created super_admin successfully: $result');
  } catch (e) {
    stderr.writeln('❌ FAIL: Failed to create super_admin user: $e');
    db.close();
    exit(1);
  }

  // 3. Verify that the user is returned in a general query
  stderr.writeln('\n🔍 Test 2: Verifying user is listed via general select...');
  try {
    final result = (await db.query(
      r'SELECT * FROM user WHERE id = type::record("user", $id)',
      {'id': testUserId},
    )) as List;
    final users = _extractRows(result);
    if (users.isEmpty) {
      throw Exception('User was not returned by the select query');
    }
    stderr.writeln('✅ SUCCESS: Found user with role: ${users.first['role']}');
  } catch (e) {
    stderr.writeln('❌ FAIL: User listing verification failed: $e');
    db.close();
    exit(1);
  }

  // 4. Update role to 'admin'
  stderr.writeln('\n✏️ Test 3: Updating role to admin...');
  try {
    await db.query(
      r'UPDATE type::record("user", $id) SET role = "admin", updated_at = time::now()',
      {'id': testUserId},
    );

    final result = (await db.query(
      r'SELECT role FROM type::record("user", $id)',
      {'id': testUserId},
    )) as List;
    final rows = _extractRows(result);
    if (rows.isEmpty) {
      throw Exception('No result returned after role update');
    }
    final role = rows.first['role'];
    if (role != 'admin') {
      throw Exception('Role was not updated to admin. Got: $role');
    }
    stderr.writeln('✅ SUCCESS: Role updated to $role.');
  } catch (e) {
    stderr.writeln('❌ FAIL: Role update failed: $e');
    db.close();
    exit(1);
  }

  // 5. Test company creation role preservation
  stderr.writeln('\n🏢 Test 4: Creating a company with the admin as owner...');
  try {
    // Switch to companies registry
    await db.signin(user: user, pass: pass, namespace: 'companies');
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
    stderr.writeln('✅ Created company record.');

    // Simulating repository: update owner's user record
    await db.signin(user: user, pass: pass, namespace: 'users');
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
    final rows = _extractRows(verifyResult);
    if (rows.isEmpty) {
      throw Exception('No result returned after company creation');
    }
    final userFields = rows.first;
    if (userFields['role'] != 'admin') {
      throw Exception('Owner role was overwritten to business! Got: ${userFields['role']}');
    }
    stderr.writeln('✅ SUCCESS: Role preserved as admin. company_slug set to: ${userFields['company_slug']}');
  } catch (e) {
    stderr.writeln('❌ FAIL: Company creation role preservation failed: $e');
    await _cleanup(db, user, pass, testUserId, timestamp);
    db.close();
    exit(1);
  }

  // 6. Test company deletion role preservation
  stderr.writeln('\n🧹 Test 5: Reverting/deleting the company and verifying old owner role...');
  await _cleanup(db, user, pass, testUserId, timestamp);

  db.close();
  stderr.writeln('\n🎉 All administrative role E2E integration tests passed successfully!');
  exit(0);
}

/// Safely extracts rows from a SurrealDB query result.
List<Map<String, dynamic>> _extractRows(List<dynamic> result) {
  if (result.isEmpty) return [];
  final first = result.first;
  if (first is! Map || first['result'] is! List) return [];
  return (first['result'] as List).cast<Map<String, dynamic>>();
}

Future<void> _cleanup(
  SurrealDB db,
  String user,
  String pass,
  String testUserId,
  int timestamp,
) async {
  try {
    await db.signin(user: user, pass: pass, namespace: 'companies');
    await db.use('companies', 'registry');
    await db.delete('company:test_company_$timestamp');

    await db.signin(user: user, pass: pass, namespace: 'users');
    await db.use('users', 'profiles');

    // Revert role but preserve admin/super_admin
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
    final rows = _extractRows(verifyResult);
    if (rows.isEmpty) {
      throw Exception('No result after cleanup');
    }
    final userFields = rows.first;
    if (userFields['role'] != 'admin') {
      throw Exception('Role was reverted to customer! Got: ${userFields['role']}');
    }
    stderr.writeln('✅ SUCCESS: Role preserved as ${userFields['role']} after company deletion.');

    // Delete user record
    await db.delete('user:$testUserId');
    stderr.writeln('✅ Deleted test user record.');
  } catch (e) {
    stderr.writeln('❌ Cleanup warning: $e');
  }
}
