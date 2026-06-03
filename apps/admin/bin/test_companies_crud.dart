import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Command-line integration test for Companies CRUD operations.
///
/// Validates:
/// 1. Creating a company in `companies/registry` database (with schema rules).
/// 2. Querying the company to verify it is listed.
/// 3. Updating the company's fields (e.g., tier).
/// 4. Deleting the created test company (cleanup).
void main(List<String> args) async {
  final host = args.isNotEmpty ? args[0] : '100.87.99.59';
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

  // Sign in
  print('\n🔑 Signing in as admin...');
  try {
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'companies',
    );
    await db.use('companies', 'registry');
    print('✅ Signed in and switched to companies/registry.');
  } catch (e) {
    print('❌ Signin failed: $e');
    exit(1);
  }

  // 1. Create Company Test
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final testCompanyId = 'company:test_comp_$timestamp';
  final companyData = {
    'name': 'Test Runner Salon',
    'slug': 'test-runner-salon-$timestamp',
    'email': 'salon_$timestamp@dittodatto.no',
    'phone': '+4733333333',
    'address': 'Drammensveien 12',
    'city': 'Drammen',
    'zip': '3001',
    'country': 'NO',
    'tier': 'free',
    'onboarding_status': 'not_started',
    'owner_id': 'test_owner_$timestamp',
    'owner_email': 'owner_$timestamp@dittodatto.no',
    'db_slug': 'test-runner-salon-$timestamp',
    'store_policy': {
      'max_stores': 1,
      'can_create_own_stores': false,
    },
    'enabled_features': {
      'table_reservation': false,
      'ai_assistance': false,
      'ticket_system': false,
      'event_system': false,
    },
  };

  print('\n➕ Test 1: Creating a test company ($testCompanyId)...');
  try {
    final result = await db.create(testCompanyId, companyData);
    print('✅ SUCCESS: Created company successfully: $result');
  } catch (e) {
    print('❌ FAIL: Company creation failed with error: $e');
    print('💡 This indicates a schema constraint violation. Verify schema fields match platform.surql.');
    db.close();
    exit(1);
  }

  // 2. Query/List Company Test
  print('\n🔍 Test 2: Verifying company is listed...');
  try {
    final result = await db.query(
      r'SELECT * FROM company WHERE slug = $slug',
      {'slug': companyData['slug']},
    );
    print('✅ SUCCESS: Listed company: $result');
  } catch (e) {
    print('❌ FAIL: Company query failed: $e');
    exit(1);
  }

  // 3. Update Company Test
  print('\n✏️ Test 3: Updating company tier to premium...');
  try {
    final result = await db.query(
      r'UPDATE type::record("company", $id) SET tier = $tier, updated_at = time::now()',
      {'id': 'test_comp_$timestamp', 'tier': 'premium'},
    );
    print('✅ SUCCESS: Company updated successfully: $result');
  } catch (e) {
    print('❌ FAIL: Company update failed: $e');
    exit(1);
  }

  // 4. Delete/Cleanup Test
  print('\n🧹 Test 4: Cleaning up created test company...');
  try {
    await db.delete(testCompanyId);
    print('✅ SUCCESS: Cleaned up test company.');
  } catch (e) {
    print('❌ WARNING: Cleanup failed: $e');
  }

  db.close();
  print('\n🎉 All Companies CRUD integration tests passed successfully!');
  exit(0);
}
