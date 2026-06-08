/// Stub implementation for non-web environments (no-op).
Future<void> implWrite(String key, String value) async {}
Future<String?> implRead(String key) async => null;
Future<void> implDelete(String key) async {}
