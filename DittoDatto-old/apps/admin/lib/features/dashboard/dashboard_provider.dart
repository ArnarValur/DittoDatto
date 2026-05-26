import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../auth/auth_provider.dart';

/// Dashboard stats — fetches platform overview from engine.
final dashboardStatsProvider =
    FutureProvider.autoDispose<AdminStats>((ref) async {
  final adminApi = ref.watch(adminApiProvider);
  return adminApi.getStats();
});
