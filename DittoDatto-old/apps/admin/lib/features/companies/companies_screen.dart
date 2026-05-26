import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../theme/app_colors.dart';
import '../shared/role_badge.dart';
import 'companies_provider.dart';
import 'company_dialog.dart';

/// Companies screen — paginated company registry with create/edit.
class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.business_rounded,
              size: 20,
              color: AppColors.moodyBlue,
            ),
            const SizedBox(width: 10),
            const Text('Companies'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () => _createCompany(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create'),
            ),
          ),
        ],
      ),
      body: companiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(companiesProvider),
        ),
        data: (paginated) => paginated.items.isEmpty
            ? _EmptyView(onCreate: () => _createCompany(context, ref))
            : _CompaniesContent(paginated: paginated),
      ),
    );
  }

  Future<void> _createCompany(BuildContext context, WidgetRef ref) async {
    final company = await showDialog<Company>(
      context: context,
      builder: (_) => const CompanyDialog(),
    );
    if (company == null || !context.mounted) return;

    try {
      await ref.read(companiesProvider.notifier).createCompany(company);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company "${company.name}" created')),
        );
      }
    } on MercuryApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.message}')),
        );
      }
    }
  }
}

class _CompaniesContent extends ConsumerWidget {
  const _CompaniesContent({required this.paginated});

  final PaginatedResponse<Company> paginated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(companiesProvider.notifier);
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      Colors.white.withValues(alpha: 0.03),
                    ),
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Slug')),
                      DataColumn(label: Text('Owner')),
                      DataColumn(label: Text('Tier')),
                      DataColumn(label: Text('Onboarding')),
                      DataColumn(label: Text('Created')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: paginated.items.map((company) {
                      return DataRow(cells: [
                        DataCell(Text(
                          company.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(Text(
                          company.slug,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        )),
                        DataCell(Text(
                          company.ownerEmail ?? company.ownerId,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        )),
                        DataCell(TierBadge(tier: company.tier)),
                        DataCell(
                          OnboardingBadge(
                            status: company.onboardingStatus,
                          ),
                        ),
                        DataCell(Text(
                          _formatDate(company.createdAt),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        )),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            tooltip: 'Edit',
                            color: Colors.white38,
                            onPressed: () =>
                                _editCompany(context, ref, company),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Pagination bar
        if (totalPages > 1)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  style:
                      const TextStyle(fontSize: 13, color: Colors.white54),
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

  Future<void> _editCompany(
    BuildContext context,
    WidgetRef ref,
    Company existing,
  ) async {
    final updated = await showDialog<Company>(
      context: context,
      builder: (_) => CompanyDialog(company: existing),
    );
    if (updated == null || existing.id == null || !context.mounted) return;

    try {
      await ref
          .read(companiesProvider.notifier)
          .updateCompany(existing.id!, updated);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company "${updated.name}" updated')),
        );
      }
    } on MercuryApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.message}')),
        );
      }
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.business_rounded,
            size: 48,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'No companies registered',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white54,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provision your first company to get started',
            style: TextStyle(fontSize: 13, color: Colors.white30),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Create Company'),
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
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load companies',
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
