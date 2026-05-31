import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/providers.dart';
import '../shared/badges.dart';

/// Provider for paginated users list.
final usersProvider =
    AsyncNotifierProvider.autoDispose<UsersNotifier, PaginatedResponse<User>>(
  UsersNotifier.new,
);

/// Manages paginated user data, search query, role updates, and creation.
class UsersNotifier extends AsyncNotifier<PaginatedResponse<User>> {
  int _page = 1;
  static const _pageSize = 50;
  String _searchQuery = '';

  @override
  Future<PaginatedResponse<User>> build() async {
    final repo = ref.watch(adminRepositoryProvider);
    return repo.getUsers(page: _page, pageSize: _pageSize, searchQuery: _searchQuery);
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

  Future<void> search(String query) async {
    _searchQuery = query;
    _page = 1;
    ref.invalidateSelf();
  }

  Future<void> createUser(User user) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.createUser(user);
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

class _UsersTable extends ConsumerStatefulWidget {
  const _UsersTable({required this.response});

  final PaginatedResponse<User> response;

  @override
  ConsumerState<_UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends ConsumerState<_UsersTable> {
  final Set<String> _selectedUserIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final response = widget.response;
    final allSelected = response.items.isNotEmpty &&
        response.items.every((user) => _selectedUserIds.contains(user.id));

    return ListView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Users', style: theme.textTheme.headlineMedium),
                const SizedBox(width: DittoSpacing.sm),
                Text(
                  '${response.total} total',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextField(
                    onChanged: (v) {
                      ref.read(usersProvider.notifier).search(v);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Colors.white38),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: DittoSpacing.sm),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: DittoColors.moodyBlue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: DittoSpacing.base),
                FilledButton.icon(
                  onPressed: () => _showAddUserDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add User'),
                  style: FilledButton.styleFrom(
                    backgroundColor: DittoColors.moodyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: DittoSpacing.base),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: 24,
                    child: Checkbox(
                      value: allSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedUserIds.addAll(response.items.map((u) => u.id));
                          } else {
                            _selectedUserIds.removeAll(response.items.map((u) => u.id));
                          }
                        });
                      },
                    ),
                  ),
                ),
                const DataColumn(label: Text('ID')),
                const DataColumn(label: Text('Name')),
                const DataColumn(label: Text('Email')),
                const DataColumn(label: Text('Company')),
                const DataColumn(label: Text('Role')),
                const DataColumn(label: SizedBox(width: 32)),
              ],
              rows: response.items.map((user) {
                final isSelected = _selectedUserIds.contains(user.id);
                return DataRow(
                  selected: isSelected,
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedUserIds.add(user.id);
                              } else {
                                _selectedUserIds.remove(user.id);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    DataCell(Text(
                      user.id.length > 8 ? '${user.id.substring(0, 8)}...' : user.id,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: Colors.white38,
                      ),
                    )),
                    DataCell(Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: DittoColors.moodyBlue.withValues(alpha: 0.1),
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: DittoColors.moodyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: DittoSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(user.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(user.email, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                      ],
                    )),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.companySlug ?? '—')),
                    DataCell(RoleBadge(role: user.role)),
                    DataCell(
                      PopupMenuButton<ActorRole>(
                        icon: const Icon(Icons.more_vert_rounded, size: 20, color: Colors.white54),
                        onSelected: (role) {
                          ref.read(usersProvider.notifier).updateRole(user.id, role);
                        },
                        itemBuilder: (context) => [ActorRole.customer, ActorRole.business]
                            .map((role) => PopupMenuItem(
                                  value: role,
                                  child: Row(
                                    children: [
                                      RoleBadge(role: role),
                                      const SizedBox(width: DittoSpacing.xs),
                                      if (user.role == role)
                                        const Icon(Icons.check_rounded, size: 16, color: Colors.green)
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
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

  void _showAddUserDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final companyCtrl = TextEditingController();
    ActorRole selectedRole = ActorRole.customer;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add User'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: DittoSpacing.sm),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: DittoSpacing.sm),
                  TextField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone (optional)'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: DittoSpacing.sm),
                  TextField(
                    controller: companyCtrl,
                    decoration: const InputDecoration(labelText: 'Company Slug (optional)'),
                  ),
                  const SizedBox(height: DittoSpacing.base),
                  DropdownButtonFormField<ActorRole>(
                    initialValue: selectedRole,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: [ActorRole.customer, ActorRole.business]
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: RoleBadge(role: role),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedRole = val;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final now = DateTime.now();
                final newUser = User(
                  id: 'user${now.millisecondsSinceEpoch}',
                  vippsSub: 'vipps|${now.millisecondsSinceEpoch}',
                  name: nameCtrl.text,
                  email: emailCtrl.text,
                  phone: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : null,
                  role: selectedRole,
                  companySlug: companyCtrl.text.isNotEmpty ? companyCtrl.text : null,
                  createdAt: now,
                  updatedAt: now,
                );
                await ref.read(usersProvider.notifier).createUser(newUser);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
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
