import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'establishment_model.dart';
import 'establishment_providers.dart';

/// Dialog for creating a new Establishment.
///
/// Spec F4: Virksomhetstype, Navn, Adresse, By, Postnummer.
/// On save → SurrealDB CREATE → redirect to edit view.
///
/// The address field uses Kartverket autocomplete to auto-fill
/// street, city, and postal code from real Norwegian address data.
class CreateEstablishmentDialog extends ConsumerStatefulWidget {
  const CreateEstablishmentDialog({super.key});

  @override
  ConsumerState<CreateEstablishmentDialog> createState() =>
      _CreateEstablishmentDialogState();
}

class _CreateEstablishmentDialogState
    extends ConsumerState<CreateEstablishmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  BusinessType _selectedType = BusinessType.store;
  bool _saving = false;

  // ── Kartverket autocomplete state ──
  final _kartverket = KartverketService();
  List<NorwegianAddress> _suggestions = [];
  bool _searching = false;
  DateTime _lastSearch = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _kartverket.dispose();
    super.dispose();
  }

  Future<void> _onAddressChanged(String query) async {
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

  void _onSuggestionSelected(NorwegianAddress addr) {
    _addressController.text = addr.streetAddress;
    _cityController.text = addr.city;
    _zipController.text = addr.postalCode;
    setState(() => _suggestions = []);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final slug = _nameController.text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    final establishment = Establishment(
      id: '', // SurrealDB generates this
      name: _nameController.text.trim(),
      slug: slug,
      businessType: _selectedType,
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zip: _zipController.text.trim(),
    );

    try {
      await ref.read(establishmentsProvider.notifier).create(establishment);
      if (mounted) {
        Navigator.of(context).pop(true); // true = created successfully
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kunne ikke opprette virksomhet: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(DittoSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ny virksomhet',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: DittoSpacing.lg),

                // Business type selector
                Text(
                  'Virksomhetstype',
                  style: theme.textTheme.labelLarge,
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
                  selected: {_selectedType},
                  onSelectionChanged: (selected) {
                    setState(() => _selectedType = selected.first);
                  },
                ),

                const SizedBox(height: DittoSpacing.base),

                // Name field
                TextFormField(
                  controller: _nameController,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Navn',
                    hintText: 'Virksomhetens navn',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Påkrevd';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: DittoSpacing.base),

                // ── Address field with Kartverket autocomplete ──
                TextFormField(
                  controller: _addressController,
                  enabled: !_saving,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    hintText: 'Søk etter adresse...',
                    suffixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Icon(Icons.search, size: 20),
                  ),
                  onChanged: _onAddressChanged,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Påkrevd';
                    }
                    return null;
                  },
                ),

                // Suggestions dropdown
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    constraints: const BoxConstraints(maxHeight: 200),
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
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: _suggestions.map((addr) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                          ),
                          title: Text(
                            addr.streetAddress,
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            '${addr.postalCode} ${addr.city}',
                            style: theme.textTheme.bodySmall,
                          ),
                          onTap: () => _onSuggestionSelected(addr),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: DittoSpacing.base),

                // City + Zip row (auto-filled by Kartverket selection)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cityController,
                        enabled: !_saving,
                        decoration: const InputDecoration(
                          labelText: 'By',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Påkrevd';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: DittoSpacing.base),
                    Expanded(
                      child: TextFormField(
                        controller: _zipController,
                        enabled: !_saving,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Postnummer',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Påkrevd';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DittoSpacing.lg),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('Avbryt'),
                    ),
                    const SizedBox(width: DittoSpacing.sm),
                    ElevatedButton(
                      onPressed: _saving ? null : _handleSave,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Lagre'),
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
}
