import '../models/admin_stats.dart';

/// Repository interface for admin data operations.
///
/// Implementations can be mock (development) or HTTP (production).
/// The admin app depends on this abstraction, never on concrete
/// implementations.
abstract class AdminRepository {
  /// Fetch dashboard statistics.
  Future<AdminStats> getStats();
}

/// Mock implementation returning realistic fake data.
///
/// Simulates network latency for realistic UI development.
class MockAdminRepository implements AdminRepository {
  MockAdminRepository({
    this.latency = const Duration(milliseconds: 600),
  });

  final Duration latency;

  @override
  Future<AdminStats> getStats() async {
    await Future<void>.delayed(latency);
    return const AdminStats(
      userCount: 847,
      companyCount: 126,
      categoryCount: 34,
      engineHealthy: true,
    );
  }
}
