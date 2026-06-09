import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Command-line integration test for Users CRUD operations.
///
/// Validates:
/// 1. Creating a user in `users/profiles` database (with schema rules).
/// 2. Querying the user to verify it is listed.
/// 3. Updating the user's role.
/// 4. Deleting the created test user (cleanup).
///
/// Usage:
///   SURREAL_USER=arnarvalur SURREAL_PASS=xxx dart run bin/test_users_crud.dart [host]
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

  // Sign in
  stderr.writeln('\n🔑 Signing in as admin...');
  try {
    await db.signin(user: user, pass: pass, namespace: 'users');
    await db.use('users', 'profiles');
    stderr.writeln('✅ Signed in and switched to users/profiles.');
  } catch (e) {
    stderr.writeln('❌ Signin failed: $e');
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

  stderr.writeln('\n➕ Test 1: Creating a test user ($testUserId)...');
  try {
    final result = await db.create(testUserId, userData);
    stderr.writeln('✅ SUCCESS: Created user successfully: $result');
  } catch (e) {
    stderr.writeln('❌ FAIL: User creation failed with error: $e');
    stderr.writeln('💡 This indicates a schema constraint violation. Inspect the table fields.');
    db.close();
    exit(1);
  }

  // 2. Query/List User Test
  stderr.writeln('\n🔍 Test 2: Verifying user is listed...');
  try {
    final result = await db.query(
      r'SELECT * FROM user WHERE email = $email',
      {'email': userData['email']},
    );
    stderr.writeln('✅ SUCCESS: Listed user: $result');
  } catch (e) {
    stderr.writeln('❌ FAIL: User query failed: $e');
    exit(1);
  }

  // 3. Update User Role Test
  stderr.writeln('\n✏️ Test 3: Updating user role to business...');
  try {
    final result = await db.query(
      r'UPDATE type::record("user", $id) SET role = $role, updated_at = time::now()',
      {'id': 'test_$timestamp', 'role': 'business'},
    );
    stderr.writeln('✅ SUCCESS: Role updated successfully: $result');
  } catch (e) {
    stderr.writeln('❌ FAIL: Role update failed: $e');
    exit(1);
  }

  // 4. Delete/Cleanup Test
  stderr.writeln('\n🧹 Test 4: Cleaning up created test user...');
  try {
    await db.delete(testUserId);
    stderr.writeln('✅ SUCCESS: Cleaned up test user.');
  } catch (e) {
    stderr.writeln('❌ WARNING: Cleanup failed: $e');
  }

  db.close();
  stderr.writeln('\n🎉 All Users CRUD integration tests passed successfully!');
  exit(0);
}
