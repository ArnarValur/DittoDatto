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
    print('\n🔑 Signing in to users/profiles...');
    await db.signin(
      user: 'arnarvalur',
      pass: 'admin123',
      namespace: 'users',
    );
    await db.use('users', 'profiles');

    print('⚡ Promoting arnarvalur (dj6gm82md9uq2yyfxgrg) to super_admin...');
    await db.query(
      r'UPDATE user:dj6gm82md9uq2yyfxgrg SET role = "super_admin"',
    );

    print('⚡ Promoting gurkudrengur (p9hbjyxrlbsc06ieyi4u) to super_admin...');
    await db.query(
      r'UPDATE user:p9hbjyxrlbsc06ieyi4u SET role = "super_admin"',
    );

    final verify = await db.query('SELECT id, name, email, role FROM user') as List;
    final list = verify.first['result'] as List;
    print('\n👥 Updated user roles:');
    for (final u in list) {
      print('  • ${u['name']} (${u['email']}) -> Role: ${u['role']}');
    }

    print('\n🎉 Roles successfully updated!');
  } catch (e) {
    print('❌ Error: $e');
  } finally {
    db.close();
  }
}
