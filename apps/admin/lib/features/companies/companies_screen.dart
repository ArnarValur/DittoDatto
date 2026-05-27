import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../dashboard/dashboard_screen.dart';
import '../shared/badges.dart';
import '../shared/format_date.dart';
import '../shared/slug_utils.dart';

/// Provider for paginated companies list.
final companiesProvider = AsyncNotifierProvider.autoDispose<
    CompaniesNotifier, PaginatedResponse<Company>>(CompaniesNotifier.new);

class CompaniesNotifier
    extends AsyncNotifier<PaginatedResponse<Company>> {
  int _page = 1;

  @override
  Future<PaginatedResponse<Company>> build() {
    final repo = ref.watch(adminRepositoryProvider);
    return repo.getCompanies(page: _page);
  }

  Future<void> goToPage(int page) async {
    _page = page;
    ref.invalidateSelf();
  }

  Future<void> createCompany(Company company) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.createCompany(company);
    ref.invalidateSelf();
  }

  Future<void> updateCompany(Company company) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.updateCompany(company);
    ref.invalidateSelf();
  }
}

/// Companies management screen.
class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);

    return companiesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => DittoErrorView(
        message: 'Failed to load companies',
        onRetry: () => ref.invalidate(companiesProvider),
      ),
      data: (response) => _CompaniesTable(response: response),
    );
  }
}

class _CompaniesTable extends ConsumerWidget {
  const _CompaniesTable({required this.response});
  final PaginatedResponse<Company> response;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Companies', style: theme.textTheme.headlineMedium),
            FilledButton.icon(
              onPressed: () => _showCompanyDialog(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Company'),
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
                DataColumn(label: Text('Slug')),
                DataColumn(label: Text('Tier')),
                DataColumn(label: Text('Onboarding')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Owner')),
                DataColumn(label: Text('Created')),
              ],
              rows: response.items.map((company) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(company.name),
                      onTap: () => _showCompanyDialog(context, ref, company: company),
                    ),
                    DataCell(Text(company.slug)),
                    DataCell(TierBadge(tier: company.tier)),
                    DataCell(OnboardingBadge(status: company.onboardingStatus)),
                    DataCell(Text(company.city ?? '—')),
                    DataCell(Text(company.ownerEmail ?? '—')),
                    DataCell(Text(formatDate(company.createdAt))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showCompanyDialog(BuildContext context, WidgetRef ref, {Company? company}) {
    final isEdit = company != null;
    final nameCtrl = TextEditingController(text: company?.name ?? '');
    final slugCtrl = TextEditingController(text: company?.slug ?? '');
    final emailCtrl = TextEditingController(text: company?.email ?? '');
    final phoneCtrl = TextEditingController(text: company?.phone ?? '');
    final cityCtrl = TextEditingController(text: company?.city ?? '');
    final addressCtrl = TextEditingController(text: company?.address ?? '');
    final postalCtrl = TextEditingController(text: company?.postalCode ?? '');
    var selectedTier = company?.tier ?? CompanyTier.free;
    var selectedOnboarding = company?.onboardingStatus ?? OnboardingStatus.notStarted;
    var slugManuallyEdited = isEdit;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Company' : 'New Company'),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Core
                    Text('Core', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (v) {
                        if (!slugManuallyEdited) {
                          slugCtrl.text = generateSlug(v);
                        }
                      },
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: slugCtrl,
                      decoration: const InputDecoration(labelText: 'Slug'),
                      onChanged: (_) => slugManuallyEdited = true,
                    ),
                    const SizedBox(height: DittoSpacing.base),

                    // Contact
                    Text('Contact', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
                    const SizedBox(height: DittoSpacing.base),

                    // Address
                    Text('Address', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Address')),
                    const SizedBox(height: DittoSpacing.sm),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City'))),
                        const SizedBox(width: DittoSpacing.sm),
                        SizedBox(width: 120, child: TextField(controller: postalCtrl, decoration: const InputDecoration(labelText: 'Postal Code'))),
                      ],
                    ),
                    const SizedBox(height: DittoSpacing.base),

                    // Tier & Status
                    Text('Tier & Status', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    DropdownButtonFormField<CompanyTier>(
                      initialValue: selectedTier,
                      decoration: const InputDecoration(labelText: 'Tier'),
                      items: CompanyTier.values.map((t) => DropdownMenuItem(value: t, child: TierBadge(tier: t))).toList(),
                      onChanged: (v) => setState(() => selectedTier = v!),
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    DropdownButtonFormField<OnboardingStatus>(
                      initialValue: selectedOnboarding,
                      decoration: const InputDecoration(labelText: 'Onboarding'),
                      items: OnboardingStatus.values.map((s) => DropdownMenuItem(value: s, child: OnboardingBadge(status: s))).toList(),
                      onChanged: (v) => setState(() => selectedOnboarding = v!),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              FilledButton(
                onPressed: () {
                  final now = DateTime.now();
                  final result = Company(
                    id: company?.id ?? 'c${now.millisecondsSinceEpoch}',
                    name: nameCtrl.text,
                    slug: slugCtrl.text,
                    email: emailCtrl.text.isNotEmpty ? emailCtrl.text : null,
                    phone: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : null,
                    address: addressCtrl.text.isNotEmpty ? addressCtrl.text : null,
                    city: cityCtrl.text.isNotEmpty ? cityCtrl.text : null,
                    postalCode: postalCtrl.text.isNotEmpty ? postalCtrl.text : null,
                    tier: selectedTier,
                    onboardingStatus: selectedOnboarding,
                    createdAt: company?.createdAt ?? now,
                    updatedAt: now,
                  );
                  if (isEdit) {
                    ref.read(companiesProvider.notifier).updateCompany(result);
                  } else {
                    ref.read(companiesProvider.notifier).createCompany(result);
                  }
                  Navigator.pop(context);
                },
                child: Text(isEdit ? 'Save' : 'Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}
