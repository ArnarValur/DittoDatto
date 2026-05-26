import 'package:flutter/material.dart';
import 'package:mercury_client/mercury_client.dart';

/// Dialog for creating or editing a company registry entry.
///
/// Returns a [Company] on save, or null on cancel.
/// If [company] is provided, pre-fills the form for editing.
class CompanyDialog extends StatefulWidget {
  const CompanyDialog({super.key, this.company});

  /// If non-null, we're editing this company.
  final Company? company;

  bool get isEditing => company != null;

  @override
  State<CompanyDialog> createState() => _CompanyDialogState();
}

class _CompanyDialogState extends State<CompanyDialog> {
  final _formKey = GlobalKey<FormState>();

  // Core fields
  late final TextEditingController _nameCtl;
  late final TextEditingController _slugCtl;
  late final TextEditingController _ownerIdCtl;
  late final TextEditingController _descCtl;

  // Contact fields
  late final TextEditingController _emailCtl;
  late final TextEditingController _phoneCtl;
  late final TextEditingController _websiteCtl;

  // Address fields
  late final TextEditingController _addressCtl;
  late final TextEditingController _cityCtl;
  late final TextEditingController _zipCtl;

  // Social
  late final TextEditingController _fbCtl;
  late final TextEditingController _igCtl;
  late final TextEditingController _xCtl;

  // Enum selections
  late CompanyTier _tier;
  late OnboardingStatus _onboarding;

  // Feature flags
  late bool _tableReservation;
  late bool _aiAssistance;
  late bool _ticketSystem;
  late bool _eventSystem;

  // Store policy
  late final TextEditingController _maxStoresCtl;
  late bool _canCreateOwnStores;

  bool _slugManuallyEdited = false;

  @override
  void initState() {
    super.initState();
    final c = widget.company;

    _nameCtl = TextEditingController(text: c?.name ?? '');
    _slugCtl = TextEditingController(text: c?.slug ?? '');
    _ownerIdCtl = TextEditingController(text: c?.ownerId ?? '');
    _descCtl = TextEditingController(text: c?.description ?? '');
    _emailCtl = TextEditingController(text: c?.email ?? '');
    _phoneCtl = TextEditingController(text: c?.phone ?? '');
    _websiteCtl = TextEditingController(text: c?.website ?? '');
    _addressCtl = TextEditingController(text: c?.address ?? '');
    _cityCtl = TextEditingController(text: c?.city ?? '');
    _zipCtl = TextEditingController(text: c?.zip ?? '');
    _fbCtl = TextEditingController(text: c?.socialLinks?.fb ?? '');
    _igCtl = TextEditingController(text: c?.socialLinks?.ig ?? '');
    _xCtl = TextEditingController(text: c?.socialLinks?.x ?? '');
    _maxStoresCtl = TextEditingController(
      text: (c?.storePolicy.maxStores ?? 1).toString(),
    );

    _tier = c?.tier ?? CompanyTier.free;
    _onboarding = c?.onboardingStatus ?? OnboardingStatus.notStarted;
    _tableReservation = c?.enabledFeatures.tableReservation ?? false;
    _aiAssistance = c?.enabledFeatures.aiAssistance ?? false;
    _ticketSystem = c?.enabledFeatures.ticketSystem ?? false;
    _eventSystem = c?.enabledFeatures.eventSystem ?? false;
    _canCreateOwnStores = c?.storePolicy.canCreateOwnStores ?? false;

    if (widget.isEditing) _slugManuallyEdited = true;
    _nameCtl.addListener(_onNameChanged);
    _slugCtl.addListener(() => _slugManuallyEdited = true);
  }

  void _onNameChanged() {
    if (!_slugManuallyEdited) {
      final slug = _nameCtl.text
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '-')
          .replaceAll(RegExp(r'-{2,}'), '-')
          .replaceAll(RegExp(r'^-|-$'), '');
      _slugCtl.removeListener(() => _slugManuallyEdited = true);
      _slugCtl.text = slug;
      _slugCtl.addListener(() => _slugManuallyEdited = true);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtl, _slugCtl, _ownerIdCtl, _descCtl,
      _emailCtl, _phoneCtl, _websiteCtl,
      _addressCtl, _cityCtl, _zipCtl,
      _fbCtl, _igCtl, _xCtl, _maxStoresCtl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final company = Company(
      id: widget.company?.id,
      ownerId: _ownerIdCtl.text.trim(),
      name: _nameCtl.text.trim(),
      slug: _slugCtl.text.trim(),
      description: _orNull(_descCtl.text),
      email: _orNull(_emailCtl.text),
      phone: _orNull(_phoneCtl.text),
      website: _orNull(_websiteCtl.text),
      address: _orNull(_addressCtl.text),
      city: _orNull(_cityCtl.text),
      zip: _orNull(_zipCtl.text),
      tier: _tier,
      onboardingStatus: _onboarding,
      enabledFeatures: EnabledFeatures(
        tableReservation: _tableReservation,
        aiAssistance: _aiAssistance,
        ticketSystem: _ticketSystem,
        eventSystem: _eventSystem,
      ),
      storePolicy: StorePolicy(
        maxStores: int.tryParse(_maxStoresCtl.text.trim()) ?? 1,
        canCreateOwnStores: _canCreateOwnStores,
      ),
      socialLinks: CompanySocialLinks(
        fb: _orNull(_fbCtl.text),
        ig: _orNull(_igCtl.text),
        x: _orNull(_xCtl.text),
      ),
    );
    Navigator.of(context).pop(company);
  }

  String? _orNull(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing ? 'Edit Company' : 'Create Company',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Core ────────────────────────────
                        _SectionLabel('Core'),
                        _row([
                          _field(_nameCtl, 'Name', required: true),
                          _field(_slugCtl, 'Slug', required: true),
                        ]),
                        const SizedBox(height: 12),
                        _row([
                          _field(_ownerIdCtl, 'Owner ID', required: true),
                          _field(_descCtl, 'Description'),
                        ]),

                        const SizedBox(height: 20),
                        _SectionLabel('Contact'),
                        _row([
                          _field(_emailCtl, 'Email'),
                          _field(_phoneCtl, 'Phone'),
                        ]),
                        const SizedBox(height: 12),
                        _field(_websiteCtl, 'Website'),

                        const SizedBox(height: 20),
                        _SectionLabel('Address'),
                        _row([
                          _field(_addressCtl, 'Street'),
                          _field(_cityCtl, 'City'),
                        ]),
                        const SizedBox(height: 12),
                        _row([
                          _field(_zipCtl, 'ZIP'),
                          const Expanded(child: SizedBox()),
                        ]),

                        const SizedBox(height: 20),
                        _SectionLabel('Tier & Status'),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<CompanyTier>(
                                initialValue: _tier,
                                decoration: const InputDecoration(
                                  labelText: 'Tier',
                                ),
                                items: CompanyTier.values
                                    .map((t) => DropdownMenuItem(
                                          value: t,
                                          child: Text(t.value),
                                        ))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _tier = v!),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child:
                                  DropdownButtonFormField<OnboardingStatus>(
                                initialValue: _onboarding,
                                decoration: const InputDecoration(
                                  labelText: 'Onboarding',
                                ),
                                items: OnboardingStatus.values
                                    .map((s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s.value),
                                        ))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _onboarding = v!),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _SectionLabel('Feature Flags'),
                        Wrap(
                          spacing: 16,
                          children: [
                            _check('Table Reservation', _tableReservation,
                                (v) => setState(
                                    () => _tableReservation = v!)),
                            _check('AI Assistance', _aiAssistance,
                                (v) => setState(
                                    () => _aiAssistance = v!)),
                            _check('Ticket System', _ticketSystem,
                                (v) => setState(
                                    () => _ticketSystem = v!)),
                            _check('Event System', _eventSystem,
                                (v) => setState(
                                    () => _eventSystem = v!)),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _SectionLabel('Store Policy'),
                        _row([
                          _field(_maxStoresCtl, 'Max Stores'),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Can Create Own Stores',
                                  style: TextStyle(fontSize: 14)),
                              value: _canCreateOwnStores,
                              onChanged: (v) => setState(
                                  () => _canCreateOwnStores = v!),
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ]),

                        const SizedBox(height: 20),
                        _SectionLabel('Social Links'),
                        _row([
                          _field(_fbCtl, 'Facebook'),
                          _field(_igCtl, 'Instagram'),
                        ]),
                        const SizedBox(height: 12),
                        _field(_xCtl, 'X (Twitter)'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(widget.isEditing ? 'Save' : 'Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctl,
    String label, {
    bool required = false,
  }) {
    return Expanded(
      child: TextFormField(
        controller: ctl,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (v) => v == null || v.trim().isEmpty ? '$label is required' : null
            : null,
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand((w) sync* {
            yield w;
            yield const SizedBox(width: 16);
          })
          .toList()
        ..removeLast(),
    );
  }

  Widget _check(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white38,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
