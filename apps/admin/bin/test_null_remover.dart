import 'dart:io';
import 'package:surrealdb/surrealdb.dart';

/// Standalone CLI test verifying the recursive null remover logic
/// against SurrealDB's strict schema coercion rules.
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

  // 1. Prepare raw payload matching EXACTLY what the UI Form produces
  // with nested maps containing nulls.
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final testCompanyId = 'company:test_null_comp_$timestamp';
  
  final rawCompanyData = {
    'name': 'Form Coercion Test Salon',
    'slug': 'form-coercion-salon-$timestamp',
    'email': 'coercion_$timestamp@dittodatto.no',
    'phone': '+4733333333',
    'address': 'Skolegata 9',
    'city': 'Drammen',
    'zip': '3046',
    'country': 'NO',
    'tier': 'enterprise',
    'onboarding_status': 'completed',
    'owner_id': 'arnarvalur',
    'owner_email': 'arnarvalur@avj.info',
    'db_slug': 'form-coercion-salon-$timestamp',
    'created_at': DateTime.now().toUtc().toIso8601String(),
    'updated_at': DateTime.now().toUtc().toIso8601String(),
    
    // Nested policy (some valid non-null fields)
    'store_policy': {
      'max_stores': 1,
      'can_create_own_stores': false,
    },
    
    // Nested features (some valid non-null fields)
    'enabled_features': {
      'table_reservation': false,
      'ai_assistance': false,
      'ticket_system': false,
      'event_system': false,
    },
    
    // Nested social links with NULL values (the EXACT trigger of the crash)
    'social_links': {
      'website': null,
      'fb': null,
      'ig': null,
      'x': null,
    },
  };

  // Clean the payload using the recursive logic
  print('\n🧹 Cleaning payload recursively to strip out all nested nulls...');
  final cleanedCompanyData = removeNullsFromMap(rawCompanyData);

  // Assert that nested nulls are completely gone
  final socialLinks = cleanedCompanyData['social_links'] as Map;
  print('Resulting social_links keys: ${socialLinks.keys.toList()}');
  if (socialLinks.isNotEmpty) {
    print('❌ FAIL: social_links should be empty but has keys: ${socialLinks.keys}');
    exit(1);
  } else {
    print('✅ SUCCESS: Nested nulls successfully stripped from social_links!');
  }

  // 3. Attempt to save the cleaned payload to the database
  print('\n➕ Test: Writing recursively cleaned payload to SurrealDB ($testCompanyId)...');
  try {
    final result = await db.create(testCompanyId, cleanedCompanyData);
    print('✅ SUCCESS: Created company with nested fields successfully: $result');
  } catch (e) {
    print('❌ FAIL: Company creation failed with error: $e');
    db.close();
    exit(1);
  }

  // 4. Cleanup
  print('\n🧹 Cleaning up test company...');
  try {
    await db.delete(testCompanyId);
    print('✅ SUCCESS: Cleaned up test company.');
  } catch (e) {
    print('❌ WARNING: Cleanup failed: $e');
  }

  db.close();
  print('\n🎉 All recursive null-removing verification tests passed successfully!');
  exit(0);
}

Map<String, dynamic> removeNullsFromMap(Map<String, dynamic> map) {
  final copy = <String, dynamic>{};
  map.forEach((key, value) {
    if (value != null) {
      if (value is Map<String, dynamic>) {
        copy[key] = removeNullsFromMap(value);
      } else if (value is Map) {
        copy[key] = removeNullsFromMap(Map<String, dynamic>.from(value));
      } else if (value is List) {
        copy[key] = removeNullsFromList(value);
      } else {
        copy[key] = value;
      }
    }
  });
  return copy;
}

List<dynamic> removeNullsFromList(List<dynamic> list) {
  return list.map((item) {
    if (item is Map<String, dynamic>) {
      return removeNullsFromMap(item);
    } else if (item is Map) {
      return removeNullsFromMap(Map<String, dynamic>.from(item));
    } else if (item is List) {
      return removeNullsFromList(item);
    }
    return item;
  }).toList();
}

