import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/providers.dart';
import '../shared/badges.dart';
import '../shared/format_date.dart';

/// Provider for paginated users list.
final usersProvider =
    AsyncNotifierProvider.autoDispose<UsersNotifier, PaginatedResponse<User>>(
  UsersNotifier.new,
);

/// Manages paginated user data and role updates.
class UsersNotifier extends AsyncNotifier<PaginatedResponse<User>> {
  int _page = 1;
  static const _pageSize = 50;

  @override
  Future<PaginatedResponse<User>> build() async {
    final repo = ref.watch(adminRepositoryProvider);
    return repo.getUsers(page: _page, pageSize: _pageSize);
  }

  Future<void> goToPage(int page) async {
    _page = page;
    ref.invalidateSelf();
  }

  Future<void> updateRole(String userId, ActorRole newRole) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.updateUserRole(userId, newRole);
    ref.invalidateSelf();
  }
}

/// Users management screen with paginated data table.
class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => DittoErrorView(
        message: 'Failed to load users',
        onRetry: () => ref.invalidate(usersProvider),
      ),
      data: (response) => _UsersTable(response: response),
    );
  }
}

class _UsersTable extends ConsumerWidget {
  const _UsersTable({required this.response});

  final PaginatedResponse<User> response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Users', style: theme.textTheme.headlineMedium),
            Text(
              '${response.total} total',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
            ),
          ],
        ),
        const SizedBox(height: DittoSpacing.base),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Company')),
                DataColumn(label: Text('Joined')),
              ],
              rows: response.items.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.name)),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.phone ?? '—')),
                    DataCell(
                      PopupMenuButton<ActorRole>(
                        initialValue: user.role,
                        onSelected: (role) {
                          ref.read(usersProvider.notifier).updateRole(user.id, role);
                        },
                        itemBuilder: (context) => ActorRole.values
                            .map((role) => PopupMenuItem(
                                  value: role,
                                  child: RoleBadge(role: role),
                                ))
                            .toList(),
                        child: RoleBadge(role: user.role),
                      ),
                    ),
                    DataCell(Text(user.companySlug ?? '—')),
                    DataCell(Text(formatDate(user.createdAt))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: DittoSpacing.base),
        _PaginationBar(
          currentPage: response.page,
          totalPages: response.totalPages,
          onPageChanged: (page) {
            ref.read(usersProvider.notifier).goToPage(page);
          },
        ),
      ],
    );
  }
}

/// Reusable pagination bar for data tables.
class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        Text(
          'Page $currentPage of $totalPages',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
