import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Server URL presets per ADR-0011 §5.
class ServerPreset {
  const ServerPreset({required this.label, required this.url});
  final String label;
  final String url;
}

/// Available server presets.
const serverPresets = [
  ServerPreset(label: 'Dev (Pluto)', url: 'http://pluto.local:5002'),
  ServerPreset(label: 'Saturn (LAN)', url: 'http://saturn.local:5002'),
  ServerPreset(label: 'Saturn (Internet)', url: 'https://api.merkurial-studio.com'),
];

const _prefsKey = 'mercury_server_url';

/// Provider for the current server URL. Persisted in SharedPreferences.
final serverUrlProvider =
    AsyncNotifierProvider<ServerUrlNotifier, String>(ServerUrlNotifier.new);

class ServerUrlNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKey) ?? serverPresets.first.url;
  }

  Future<void> setUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, url);
    state = AsyncData(url);
  }
}
