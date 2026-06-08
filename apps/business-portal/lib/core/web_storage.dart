import 'web_storage_stub.dart'
    if (dart.library.html) 'web_storage_web.dart';

/// Platform-agnostic web storage accessor.
///
/// Under Web, accesses standard window.localStorage directly (unencrypted).
/// On native platforms, fallback to no-op since FlutterSecureStorage is used.
abstract class WebStorage {
  static Future<void> write(String key, String value) => implWrite(key, value);
  static Future<String?> read(String key) => implRead(key);
  static Future<void> delete(String key) => implDelete(key);
}
