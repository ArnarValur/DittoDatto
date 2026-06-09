import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Promotes specified users to super_admin role.
///
/// Usage:
///   `SURREAL_USER=arnarvalur SURREAL_PASS=xxx dart run bin/promote_admins.dart <userId1> [userId2] ...`
///   `SURREAL_USER=arnarvalur SURREAL_PASS=xxx dart run bin/promote_admins.dart --host dittodatto <userId1> ...`
void main(List<String> args) async {
  // Parse --host flag
  var host = 'dittodatto';
  final userIds = <String>[];
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--host' && i + 1 < args.length) {
      host = args[++i];
    } else {
      userIds.add(args[i]);
    }
  }

  if (userIds.isEmpty) {
    stderr.writeln('Usage: dart run bin/promote_admins.dart [--host HOST] <userId1> [userId2] ...');
    stderr.writeln('');
    stderr.writeln('Environment variables required:');
    stderr.writeln('  SURREAL_USER  — SurrealDB namespace username');
    stderr.writeln('  SURREAL_PASS  — SurrealDB namespace password');
    exit(1);
  }

  final user = Platform.environment['SURREAL_USER'];
  final pass = Platform.environment['SURREAL_PASS'];
  if (user == null || pass == null) {
    stderr.writeln('Error: Set SURREAL_USER and SURREAL_PASS environment variables.');
    exit(1);
  }

  final url = 'ws://$host:8002/rpc';
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
    stderr.writeln('\n🔑 Signing in to users/profiles...');
    await db.signin(user: user, pass: pass, namespace: 'users');
    await db.use('users', 'profiles');

    for (final userId in userIds) {
      stderr.writeln('⚡ Promoting $userId to super_admin...');
      await db.query(
        r'UPDATE type::record("user", $id) SET role = "super_admin"',
        {'id': userId},
      );
    }

    final verify = await db.query('SELECT id, name, email, role FROM user') as List;
    if (verify.isEmpty || verify.first['result'] is! List) {
      stderr.writeln('⚠️ Could not verify — unexpected response shape.');
    } else {
      final list = verify.first['result'] as List;
      stderr.writeln('\n👥 Updated user roles:');
      for (final u in list) {
        stderr.writeln('  • ${u['name']} (${u['email']}) -> Role: ${u['role']}');
      }
    }

    stderr.writeln('\n🎉 Roles successfully updated!');
  } catch (e) {
    stderr.writeln('❌ Error: $e');
  } finally {
    db.close();
  }
}
