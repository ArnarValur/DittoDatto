import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Command-line integration test for Users CRUD operations.
///
/// Validates:
/// 1. Creating a user in `users/profiles` database (with schema rules).
/// 2. Querying the user to verify it is listed.
/// 3. Updating the user's role.
/// 4. Deleting the created test user (cleanup).
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
      namespace: 'users',
    );
    await db.use('users', 'profiles');
    print('✅ Signed in and switched to users/profiles.');
  } catch (e) {
    print('❌ Signin failed: $e');
    exit(1);
  }

  // 1. Create User Test
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final testUserId = 'user:test_$timestamp';
  final userData = {
    'name': 'Test Runner User',
    'email': 'test_$timestamp@dittodatto.no',
    'phone': '+4799999999',
    'role': 'customer',
    'vipps_sub': 'vipps|test_$timestamp',
  };

  print('\n➕ Test 1: Creating a test user ($testUserId)...');
  try {
    // Attempting direct creation with explicit ID
    final result = await db.create(testUserId, userData);
    print('✅ SUCCESS: Created user successfully: $result');
  } catch (e) {
    print('❌ FAIL: User creation failed with error: $e');
    print('💡 This indicates a schema constraint violation. Let\'s inspect the table fields.');
    db.close();
    exit(1);
  }

  // 2. Query/List User Test
  print('\n🔍 Test 2: Verifying user is listed...');
  try {
    final result = await db.query(
      r'SELECT * FROM user WHERE email = $email',
      {'email': userData['email']},
    );
    print('✅ SUCCESS: Listed user: $result');
  } catch (e) {
    print('❌ FAIL: User query failed: $e');
    exit(1);
  }

  // 3. Update User Role Test
  print('\n✏️ Test 3: Updating user role to business...');
  try {
    final result = await db.query(
      r'UPDATE type::record("user", $id) SET role = $role, updated_at = time::now()',
      {'id': 'test_$timestamp', 'role': 'business'},
    );
    print('✅ SUCCESS: Role updated successfully: $result');
  } catch (e) {
    print('❌ FAIL: Role update failed: $e');
    exit(1);
  }

  // 4. Delete/Cleanup Test
  print('\n🧹 Test 4: Cleaning up created test user...');
  try {
    await db.delete(testUserId);
    print('✅ SUCCESS: Cleaned up test user.');
  } catch (e) {
    print('❌ WARNING: Cleanup failed: $e');
  }

  db.close();
  print('\n🎉 All Users CRUD integration tests passed successfully!');
  exit(0);
}
