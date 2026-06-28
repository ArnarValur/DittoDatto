import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../../core/providers.dart';
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

  Future<void> deleteCompany(String id) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.deleteCompany(id);
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
                DataColumn(label: SizedBox(width: 32)),
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
                    DataCell(
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded, size: 20, color: Colors.white54),
                        onSelected: (action) async {
                          if (action == 'edit') {
                            _showCompanyDialog(context, ref, company: company);
                          } else if (action == 'delete') {
                            final confirmed = await showDittoConfirmDialog(
                              context: context,
                              title: 'Delete Company',
                              message: 'Are you sure you want to delete "${company.name}"? This action cannot be undone.',
                              confirmLabel: 'Delete',
                              confirmColor: DittoColors.error,
                            );
                            if (confirmed && context.mounted) {
                              try {
                                await ref.read(companiesProvider.notifier).deleteCompany(company.id);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete company: $e'),
                                      backgroundColor: DittoColors.error,
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 18, color: Colors.white70),
                                SizedBox(width: DittoSpacing.sm),
                                Text('Edit Company'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_rounded, size: 18, color: DittoColors.error),
                                const SizedBox(width: DittoSpacing.sm),
                                Text('Delete Company', style: TextStyle(color: DittoColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

    String? selectedOwnerId = company?.ownerId;
    String? selectedOwnerEmail = company?.ownerEmail;

    String? errorMessage;
    bool isSubmitting = false;
    bool useOwnerEmail = false;

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
                    if (errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(DittoSpacing.sm),
                        decoration: BoxDecoration(
                          color: DittoColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: DittoColors.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: DittoColors.error, size: 18),
                            const SizedBox(width: DittoSpacing.xs),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: DittoColors.error, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DittoSpacing.sm),
                    ],

                    // Core
                    Text('Core', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name *'),
                      enabled: !isSubmitting,
                      onChanged: (v) {
                        if (!slugManuallyEdited) {
                          slugCtrl.text = generateSlug(v);
                        }
                      },
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: slugCtrl,
                      decoration: const InputDecoration(labelText: 'Slug *'),
                      enabled: !isSubmitting,
                      onChanged: (_) => slugManuallyEdited = true,
                    ),
                    const SizedBox(height: DittoSpacing.sm),

                    // Owner Dropdown Loader
                    FutureBuilder<PaginatedResponse<User>>(
                      future: ref.read(adminRepositoryProvider).getUsers(page: 1, pageSize: 200),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: DittoSpacing.sm),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: DittoSpacing.sm),
                                Text('Loading users...'),
                              ],
                            ),
                          );
                        }

                        final users = snapshot.data!.items;
                        final hasSelected = users.any((u) => u.id == selectedOwnerId);

                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: hasSelected ? selectedOwnerId : null,
                          decoration: const InputDecoration(labelText: 'Owner / User *'),
                          items: users
                              .map((u) => DropdownMenuItem<String>(
                                    value: u.id,
                                    child: Text('${u.name} (${u.email})', overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged: isSubmitting
                              ? null
                              : (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedOwnerId = val;
                                      selectedOwnerEmail = users.firstWhere((u) => u.id == val).email;
                                      if (useOwnerEmail) {
                                        emailCtrl.text = selectedOwnerEmail!;
                                      }
                                    });
                                  }
                                },
                        );
                      },
                    ),
                    const SizedBox(height: DittoSpacing.base),

                    // Contact
                    Text('Contact', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email *'),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isSubmitting && !useOwnerEmail,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 32,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Same as owner',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            Checkbox(
                              value: useOwnerEmail,
                              visualDensity: VisualDensity.compact,
                              onChanged: isSubmitting
                                  ? null
                                  : (val) {
                                      setState(() {
                                        useOwnerEmail = val ?? false;
                                        if (useOwnerEmail && selectedOwnerEmail != null) {
                                          emailCtrl.text = selectedOwnerEmail!;
                                        }
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: DittoSpacing.base),

                    // Address — Kartverket autocomplete
                    Text('Address', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: DittoSpacing.sm),
                    _KartverketAddressField(
                      addressController: addressCtrl,
                      cityController: cityCtrl,
                      postalController: postalCtrl,
                      enabled: !isSubmitting,
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cityCtrl,
                            decoration: const InputDecoration(labelText: 'City'),
                            enabled: !isSubmitting,
                          ),
                        ),
                        const SizedBox(width: DittoSpacing.sm),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: postalCtrl,
                            decoration: const InputDecoration(labelText: 'Postal Code'),
                            enabled: !isSubmitting,
                          ),
                        ),
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
                      onChanged: isSubmitting ? null : (v) => setState(() => selectedTier = v!),
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    DropdownButtonFormField<OnboardingStatus>(
                      initialValue: selectedOnboarding,
                      decoration: const InputDecoration(labelText: 'Onboarding'),
                      items: OnboardingStatus.values.map((s) => DropdownMenuItem(value: s, child: OnboardingBadge(status: s))).toList(),
                      onChanged: isSubmitting ? null : (v) => setState(() => selectedOnboarding = v!),
                    ),
                  ],
                ),
              ),
            ),
            actions: [

              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        if (nameCtrl.text.trim().isEmpty) {
                          setState(() {
                            errorMessage = 'Name is required';
                          });
                          return;
                        }
                        final slugVal = slugCtrl.text.trim();
                        if (slugVal.isEmpty) {
                          setState(() {
                            errorMessage = 'Slug is required';
                          });
                          return;
                        }
                        final slugRegex = RegExp(r'^[a-z0-9-]+$');
                        if (!slugRegex.hasMatch(slugVal)) {
                          setState(() {
                            errorMessage = 'Slug must only contain lowercase letters, numbers, and hyphens';
                          });
                          return;
                        }
                        if (selectedOwnerId == null) {
                          setState(() {
                            errorMessage = 'Owner User is required';
                          });
                          return;
                        }
                        final emailVal = emailCtrl.text.trim();
                        if (emailVal.isEmpty) {
                          setState(() {
                            errorMessage = 'Email is required';
                          });
                          return;
                        }
                        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(emailVal)) {
                          setState(() {
                            errorMessage = 'Invalid email address format';
                          });
                          return;
                        }

                        setState(() {
                          isSubmitting = true;
                          errorMessage = null;
                        });

                        try {
                          final now = DateTime.now();
                          final result = Company(
                            id: company?.id ?? 'c${now.millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            slug: slugCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            phone: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : null,
                            address: addressCtrl.text.trim().isNotEmpty ? addressCtrl.text.trim() : null,
                            city: cityCtrl.text.trim().isNotEmpty ? cityCtrl.text.trim() : null,
                            postalCode: postalCtrl.text.trim().isNotEmpty ? postalCtrl.text.trim() : null,
                            country: company?.country ?? 'NO',
                            tier: selectedTier,
                            onboardingStatus: selectedOnboarding,
                            ownerId: selectedOwnerId!,
                            ownerEmail: selectedOwnerEmail,
                            dbSlug: 'company_${slugCtrl.text.trim()}',
                            description: company?.description,
                            socialLinks: company?.socialLinks ?? const CompanySocialLinks(),
                            storePolicy: company?.storePolicy ?? const StorePolicy(),
                            enabledFeatures: company?.enabledFeatures ?? const EnabledFeatures(),
                            createdAt: company?.createdAt ?? now,
                            updatedAt: now,
                          );

                          if (isEdit) {
                            await ref.read(companiesProvider.notifier).updateCompany(result);
                          } else {
                            await ref.read(companiesProvider.notifier).createCompany(result);
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() {
                              isSubmitting = false;
                              errorMessage = e.toString().replaceAll('Exception: ', '');
                            });
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isEdit ? 'Save' : 'Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Address text field with Kartverket autocomplete suggestions.
///
/// When the user types ≥ 3 characters, queries the Norwegian Mapping
/// Authority API and shows matching real addresses. Selecting a suggestion
/// auto-fills the [addressController], [cityController], and [postalController].
class _KartverketAddressField extends StatefulWidget {
  const _KartverketAddressField({
    required this.addressController,
    required this.cityController,
    required this.postalController,
    this.enabled = true,
  });

  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController postalController;
  final bool enabled;

  @override
  State<_KartverketAddressField> createState() =>
      _KartverketAddressFieldState();
}

class _KartverketAddressFieldState extends State<_KartverketAddressField> {
  final _kartverket = KartverketService();
  List<NorwegianAddress> _suggestions = [];
  bool _searching = false;
  DateTime _lastSearch = DateTime.now();

  @override
  void dispose() {
    _kartverket.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String query) async {
    if (query.trim().length < KartverketService.minQueryLength) {
      if (_suggestions.isNotEmpty) {
        setState(() => _suggestions = []);
      }
      return;
    }

    // Simple debounce — skip if another keystroke arrived within 300ms.
    final now = DateTime.now();
    _lastSearch = now;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_lastSearch != now || !mounted) return;

    setState(() => _searching = true);
    final results = await _kartverket.search(query);
    if (!mounted) return;
    setState(() {
      _suggestions = results;
      _searching = false;
    });
  }

  void _onSelected(NorwegianAddress addr) {
    widget.addressController.text = addr.streetAddress;
    widget.cityController.text = addr.city;
    widget.postalController.text = addr.postalCode;
    setState(() => _suggestions = []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Search address...',
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.search, size: 20),
          ),
          enabled: widget.enabled,
          onChanged: _onChanged,
        ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _suggestions.map((addr) {
                return ListTile(
                  dense: true,
                  leading:
                      const Icon(Icons.location_on_outlined, size: 18),
                  title: Text(addr.streetAddress,
                      style: theme.textTheme.bodyMedium),
                  subtitle: Text(
                    '${addr.postalCode} ${addr.city}',
                    style: theme.textTheme.bodySmall,
                  ),
                  onTap: () => _onSelected(addr),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
