import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../auth/auth_provider.dart';

/// Users list state — paginated platform user management.
final usersProvider =
    AsyncNotifierProvider.autoDispose<UsersNotifier, PaginatedResponse<User>>(
        UsersNotifier.new);

class UsersNotifier
    extends AutoDisposeAsyncNotifier<PaginatedResponse<User>> {
  static const _pageSize = 50;

  AdminApi get _adminApi => ref.read(adminApiProvider);

  int _offset = 0;

  @override
  Future<PaginatedResponse<User>> build() async {
    final adminApi = ref.watch(adminApiProvider);
    return adminApi.listUsers(limit: _pageSize, offset: _offset);
  }

  /// Navigate to a specific page (0-indexed).
  Future<void> goToPage(int page) async {
    _offset = page * _pageSize;
    ref.invalidateSelf();
  }

  /// Update a user's role and refresh the list.
  Future<void> updateRole(String id, ActorRole role) async {
    await _adminApi.updateUserRole(id, role);
    ref.invalidateSelf();
  }

  int get currentPage => _offset ~/ _pageSize;
  int get pageSize => _pageSize;
}
