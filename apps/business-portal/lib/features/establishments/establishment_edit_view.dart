import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'establishment_model.dart';
import 'establishment_providers.dart';

/// Tabbed edit view for a single Establishment.
///
/// Spec F5: 4 tabs — Generelt, Lokasjon, Kontakt, Innstillinger.
class EstablishmentEditView extends ConsumerStatefulWidget {
  const EstablishmentEditView({
    super.key,
    required this.establishmentId,
  });

  final String establishmentId;

  @override
  ConsumerState<EstablishmentEditView> createState() =>
      _EstablishmentEditViewState();
}

class _EstablishmentEditViewState extends ConsumerState<EstablishmentEditView> {
  Establishment? _establishment;
  bool _saving = false;

  // ── Generelt tab controllers ──
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  BusinessType _businessType = BusinessType.store;
  String? _category;

  // ── Lokasjon tab controllers ──
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  // ── Kontakt tab controllers ──
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  // ── Innstillinger tab state ──
  bool _isPublished = false;
  bool _resourcesEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _loadEstablishment(Establishment est) {
    _establishment = est;
    _nameController.text = est.name;
    _aboutController.text = est.about ?? '';
    _businessType = est.businessType;
    _category = est.category;
    _addressController.text = est.address;
    _cityController.text = est.city;
    _zipController.text = est.zip;
    _phoneController.text = est.phone ?? '';
    _emailController.text = est.email ?? '';
    _websiteController.text = est.website ?? '';
    _isPublished = est.isPublished;
    _resourcesEnabled = est.resourcesEnabled;
  }

  Future<void> _save() async {
    if (_establishment == null) return;
    setState(() => _saving = true);

    final updated = _establishment!.copyWith(
      name: _nameController.text.trim(),
      about: _aboutController.text.trim().isEmpty
          ? null
          : _aboutController.text.trim(),
      businessType: _businessType,
      category: _category,
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zip: _zipController.text.trim(),
      phone:
          _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      email:
          _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      website: _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim(),
      isPublished: _isPublished,
      resourcesEnabled: _resourcesEnabled,
    );

    await ref.read(establishmentsProvider.notifier).updateEstablishment(updated);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lagret')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncEstablishments = ref.watch(establishmentsProvider);
    final theme = Theme.of(context);

    return asyncEstablishments.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Feil: $e')),
      data: (establishments) {
        final est = establishments.where((e) => e.id == widget.establishmentId);
        if (est.isEmpty) {
          return const Center(child: Text('Virksomheten ble ikke funnet'));
        }

        // Initialize controllers on first load or when ID changes.
        if (_establishment?.id != est.first.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _loadEstablishment(est.first));
            }
          });
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text(_establishment?.name ?? ''),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Generelt'),
                  Tab(text: 'Lokasjon'),
                  Tab(text: 'Kontakt'),
                  Tab(text: 'Innstillinger'),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: DittoSpacing.base),
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Lagre'),
                  ),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                _GenereltTab(
                  nameController: _nameController,
                  aboutController: _aboutController,
                  businessType: _businessType,
                  category: _category,
                  onTypeChanged: (t) => setState(() => _businessType = t),
                  onCategoryChanged: (c) => setState(() => _category = c),
                ),
                _LokasjonTab(
                  addressController: _addressController,
                  cityController: _cityController,
                  zipController: _zipController,
                ),
                _KontaktTab(
                  phoneController: _phoneController,
                  emailController: _emailController,
                  websiteController: _websiteController,
                ),
                _InnstillingerTab(
                  isPublished: _isPublished,
                  resourcesEnabled: _resourcesEnabled,
                  onPublishedChanged: (v) =>
                      setState(() => _isPublished = v),
                  onResourcesChanged: (v) =>
                      setState(() => _resourcesEnabled = v),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Tab 1: Generelt ──

class _GenereltTab extends StatelessWidget {
  const _GenereltTab({
    required this.nameController,
    required this.aboutController,
    required this.businessType,
    this.category,
    required this.onTypeChanged,
    required this.onCategoryChanged,
  });

  final TextEditingController nameController;
  final TextEditingController aboutController;
  final BusinessType businessType;
  final String? category;
  final ValueChanged<BusinessType> onTypeChanged;
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Navn'),
            ),
            const SizedBox(height: DittoSpacing.base),

            Text(
              'Virksomhetstype',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: DittoSpacing.sm),
            SegmentedButton<BusinessType>(
              segments: BusinessType.values
                  .map((t) => ButtonSegment(
                        value: t,
                        label: Text(t.label),
                        icon: Icon(t.icon),
                      ))
                  .toList(),
              selected: {businessType},
              onSelectionChanged: (s) => onTypeChanged(s.first),
            ),
            const SizedBox(height: DittoSpacing.base),

            TextFormField(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                hintText: 'f.eks. Frisør, Pizza, Konsert',
              ),
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: DittoSpacing.base),

            TextFormField(
              controller: aboutController,
              decoration: const InputDecoration(
                labelText: 'Om virksomheten',
                hintText: 'Kort beskrivelse...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab 2: Lokasjon ──

class _LokasjonTab extends StatelessWidget {
  const _LokasjonTab({
    required this.addressController,
    required this.cityController,
    required this.zipController,
  });

  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Gateadresse',
                hintText: 'Storgata 1',
              ),
            ),
            const SizedBox(height: DittoSpacing.base),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'By'),
                  ),
                ),
                const SizedBox(width: DittoSpacing.base),
                Expanded(
                  child: TextFormField(
                    controller: zipController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Postnummer'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DittoSpacing.lg),
            // Map preview placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: DittoBorderRadius.mediumAll,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    Text(
                      'Kartvisning kommer snart',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab 3: Kontakt ──

class _KontaktTab extends StatelessWidget {
  const _KontaktTab({
    required this.phoneController,
    required this.emailController,
    required this.websiteController,
  });

  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController websiteController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefon',
                hintText: '+47 XXX XX XXX',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: DittoSpacing.base),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-post',
                hintText: 'post@virksomhet.no',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: DittoSpacing.base),
            TextFormField(
              controller: websiteController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Nettside',
                hintText: 'https://virksomhet.no',
                prefixIcon: Icon(Icons.language_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab 4: Innstillinger ──

class _InnstillingerTab extends StatelessWidget {
  const _InnstillingerTab({
    required this.isPublished,
    required this.resourcesEnabled,
    required this.onPublishedChanged,
    required this.onResourcesChanged,
  });

  final bool isPublished;
  final bool resourcesEnabled;
  final ValueChanged<bool> onPublishedChanged;
  final ValueChanged<bool> onResourcesChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Publish toggle
            SwitchListTile(
              title: const Text('Publiser virksomhet'),
              subtitle: const Text(
                'Gjør denne virksomheten synlig for kunder',
              ),
              value: isPublished,
              onChanged: onPublishedChanged,
            ),

            const Divider(height: DittoSpacing.xl),

            // Resource management toggle
            SwitchListTile(
              title: const Text('Ressurshåndtering'),
              subtitle: const Text(
                'Aktiver behandling av ressurser og kapasitet',
              ),
              value: resourcesEnabled,
              onChanged: onResourcesChanged,
            ),
          ],
        ),
      ),
    );
  }
}
