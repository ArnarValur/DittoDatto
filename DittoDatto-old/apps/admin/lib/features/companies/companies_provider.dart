import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../auth/auth_provider.dart';

/// Companies list state — paginated company registry management.
final companiesProvider = AsyncNotifierProvider.autoDispose<CompaniesNotifier,
    PaginatedResponse<Company>>(CompaniesNotifier.new);

class CompaniesNotifier
    extends AutoDisposeAsyncNotifier<PaginatedResponse<Company>> {
  static const _pageSize = 50;

  AdminApi get _adminApi => ref.read(adminApiProvider);

  int _offset = 0;

  @override
  Future<PaginatedResponse<Company>> build() async {
    final adminApi = ref.watch(adminApiProvider);
    return adminApi.listCompanies(limit: _pageSize, offset: _offset);
  }

  /// Navigate to a specific page (0-indexed).
  Future<void> goToPage(int page) async {
    _offset = page * _pageSize;
    ref.invalidateSelf();
  }

  /// Create a new company and refresh the list.
  Future<void> createCompany(Company company) async {
    await _adminApi.createCompany(company);
    ref.invalidateSelf();
  }

  /// Update an existing company and refresh the list.
  Future<void> updateCompany(String id, Company company) async {
    await _adminApi.updateCompany(id, company);
    ref.invalidateSelf();
  }

  int get currentPage => _offset ~/ _pageSize;
  int get pageSize => _pageSize;
}
