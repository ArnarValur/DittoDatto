import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory mock for the FlutterSecureStorage platform channel.
///
/// FlutterSecureStorage uses a MethodChannel that doesn't exist in
/// `flutter test` on Linux. This registers a mock handler so tests
/// can read/write/delete without a real keychain/keystore.
///
/// Copied from business-portal test helpers — same pattern.
Map<String, String> setUpMockSecureStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final storage = <String, String>{};

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'read':
          final key = methodCall.arguments['key'] as String;
          return storage[key];
        case 'write':
          final key = methodCall.arguments['key'] as String;
          final value = methodCall.arguments['value'] as String;
          storage[key] = value;
          return null;
        case 'delete':
          final key = methodCall.arguments['key'] as String;
          storage.remove(key);
          return null;
        case 'deleteAll':
          storage.clear();
          return null;
        case 'readAll':
          return storage;
        case 'containsKey':
          final key = methodCall.arguments['key'] as String;
          return storage.containsKey(key) ? 'true' : 'false';
        default:
          return null;
      }
    },
  );

  return storage;
}
