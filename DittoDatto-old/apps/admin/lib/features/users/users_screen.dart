import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../theme/app_colors.dart';
import '../shared/role_badge.dart';
import 'users_provider.dart';

/// Users screen — paginated user list with role management.
class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.people_rounded, size: 20, color: AppColors.moodyBlue),
            const SizedBox(width: 10),
            const Text('Users'),
          ],
        ),
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(usersProvider),
        ),
        data: (paginated) => paginated.items.isEmpty
            ? const _EmptyView()
            : _UsersContent(paginated: paginated),
      ),
    );
  }
}

class _UsersContent extends ConsumerWidget {
  const _UsersContent({required this.paginated});

  final PaginatedResponse<User> paginated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(usersProvider.notifier);
    final currentPage = notifier.currentPage;
    final totalPages = (paginated.total / notifier.pageSize).ceil();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    Colors.white.withValues(alpha: 0.03),
                  ),
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Company')),
                    DataColumn(label: Text('Created')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: paginated.items.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )),
                      DataCell(Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      )),
                      DataCell(RoleBadge(role: user.role)),
                      DataCell(Text(
                        user.companySlug ?? '—',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                      )),
                      DataCell(Text(
                        _formatDate(user.createdAt),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      )),
                      DataCell(_RoleEditButton(user: user)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),

        // Pagination bar
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${paginated.offset + 1}–'
                  '${(paginated.offset + paginated.items.length).clamp(0, paginated.total)} '
                  'of ${paginated.total}',
                  style: const TextStyle(fontSize: 13, color: Colors.white54),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: currentPage > 0
                          ? () => notifier.goToPage(currentPage - 1)
                          : null,
                      tooltip: 'Previous page',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Page ${currentPage + 1} of $totalPages',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: currentPage < totalPages - 1
                          ? () => notifier.goToPage(currentPage + 1)
                          : null,
                      tooltip: 'Next page',
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Inline role editing — shows current role with an edit button.
class _RoleEditButton extends ConsumerWidget {
  const _RoleEditButton({required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<ActorRole>(
      icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white38),
      tooltip: 'Change role',
      onSelected: (newRole) async {
        if (newRole == user.role || user.id == null) return;
        try {
          await ref
              .read(usersProvider.notifier)
              .updateRole(user.id!, newRole);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${user.name} role updated to ${newRole.value}',
                ),
              ),
            );
          }
        } on MercuryApiException catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed: ${e.message}')),
            );
          }
        }
      },
      itemBuilder: (_) => ActorRole.values.map((role) {
        return PopupMenuItem(
          value: role,
          child: Row(
            children: [
              RoleBadge(role: role),
              if (role == user.role) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_rounded, size: 16),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_rounded, size: 48, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'Failed to load users',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: Colors.white30),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return '—';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
