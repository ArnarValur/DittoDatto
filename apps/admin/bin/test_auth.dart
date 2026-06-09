import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Command-line verification tool for DittoDatto Hub authentication.
///
/// Validates:
/// 1. WebSocket connection to Caddy proxy /rpc endpoint.
/// 2. Incorrect credentials rejection (security check).
/// 3. Correct namespace user signin & JWT token generation.
///
/// Usage:
///   SURREAL_USER=arnarvalur SURREAL_PASS=xxx dart run bin/test_auth.dart [host]
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

  // Test 1: Incorrect credentials must FAIL
  stderr.writeln('\n🔒 Test 1: Verifying that incorrect login fails...');
  try {
    await db.signin(
      user: user,
      pass: 'wrongpassword',
      namespace: 'users',
    );
    stderr.writeln('❌ FAIL: Incorrect credentials allowed signin!');
    exit(1);
  } catch (e) {
    stderr.writeln('✅ SUCCESS: Incorrect login was rejected as expected: $e');
  }

  // Test 2: Correct credentials must SUCCEED
  stderr.writeln('\n🔑 Test 2: Verifying that correct login works...');
  try {
    final token = await db.signin(
      user: user,
      pass: pass,
      namespace: 'users',
    );
    if (token.isNotEmpty) {
      stderr.writeln('✅ SUCCESS: Correct login succeeded. Token generated.');
    } else {
      stderr.writeln('❌ FAIL: Correct login succeeded but token was empty.');
      exit(1);
    }
  } catch (e) {
    stderr.writeln('❌ FAIL: Correct login rejected: $e');
    exit(1);
  }

  db.close();
  stderr.writeln('\n🎉 All authentication validation tests passed successfully!');
  exit(0);
}
