// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Web implementation accessing the browser's standard window.localStorage.
Future<void> implWrite(String key, String value) async {
  html.window.localStorage[key] = value;
}

Future<String?> implRead(String key) async {
  return html.window.localStorage[key];
}

Future<void> implDelete(String key) async {
  html.window.localStorage.remove(key);
}
