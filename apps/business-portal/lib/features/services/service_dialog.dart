import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../establishments/establishment_providers.dart';
import 'service_providers.dart';

/// Dialog for creating or editing a Service.
class ServiceDialog extends ConsumerStatefulWidget {
  const ServiceDialog({super.key, this.existing});

  /// If non-null, we're editing an existing service.
  final Service? existing;

  @override
  ConsumerState<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends ConsumerState<ServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late String _bookingMode;
  late String _currency;
  late bool _isActive;
  String? _selectedGroupId;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  static const _bookingModes = {
    'standard': 'Standard',
    'tableReservation': 'Bordreservasjon',
    'ticketSystem': 'Billettsystem',
  };

  static const _durationPresets = [15, 30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existing?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.existing?.description ?? '');
    _priceController = TextEditingController(
      text: widget.existing != null
          ? (widget.existing!.price == widget.existing!.price.truncateToDouble()
              ? widget.existing!.price.toInt().toString()
              : widget.existing!.price.toString())
          : '',
    );
    _durationController = TextEditingController(
      text: widget.existing?.duration.toString() ?? '30',
    );
    _bookingMode = widget.existing?.bookingMode ?? 'standard';
    _currency = widget.existing?.currency ?? 'NOK';
    _isActive = widget.existing?.isActive ?? true;
    _selectedGroupId = widget.existing?.groupId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final notifier = ref.read(servicesProvider.notifier);
      final price = double.tryParse(
            _priceController.text.trim().replaceAll(',', '.'),
          ) ??
          0;
      final duration =
          int.tryParse(_durationController.text.trim()) ?? 30;

      if (_isEditing) {
        await notifier.updateService(Service(
          id: widget.existing!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          groupId: _selectedGroupId,
          duration: duration,
          price: price,
          currency: _currency,
          bookingMode: _bookingMode,
          isActive: _isActive,
        ));
      } else {
        final establishments = ref.read(establishmentsProvider).value ?? [];
        if (establishments.isEmpty) {
          throw StateError('Ingen virksomheter funnet');
        }
        final estId = establishments.first.id;

        await notifier.create(
          establishmentId: estId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          groupId: _selectedGroupId,
          duration: duration,
          price: price,
          currency: _currency,
          bookingMode: _bookingMode,
          isActive: _isActive,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feil: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = ref.watch(serviceGroupsProvider).value ?? [];

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DittoSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Rediger tjeneste' : 'Ny tjeneste',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: DittoSpacing.lg),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tittel *',
                    hintText: 'f.eks. Herreklipp, Farge og klipp',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Påkrevd' : null,
                  autofocus: true,
                ),
                const SizedBox(height: DittoSpacing.base),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Beskrivelse',
                    hintText: 'Valgfri beskrivelse for kunder',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: DittoSpacing.base),

                // Price + Duration row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Pris (kr) *',
                          hintText: '0 = Gratis',
                          prefixText: 'kr ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Påkrevd';
                          final parsed = double.tryParse(
                            v.trim().replaceAll(',', '.'),
                          );
                          if (parsed == null || parsed < 0) {
                            return 'Ugyldig pris';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: DittoSpacing.base),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                      initialValue: int.tryParse(
                              _durationController.text.trim(),
                            ) ??
                            30,
                        decoration: const InputDecoration(
                          labelText: 'Varighet *',
                        ),
                        items: _durationPresets.map((d) {
                          return DropdownMenuItem(
                            value: d,
                            child: Text(formatDuration(d)),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            _durationController.text = v.toString();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DittoSpacing.base),

                // Booking mode + Group row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                      initialValue: _bookingMode,
                        decoration: const InputDecoration(
                          labelText: 'Bestillingsmodus',
                        ),
                        items: _bookingModes.entries.map((e) {
                          return DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _bookingMode = v);
                        },
                      ),
                    ),
                    const SizedBox(width: DittoSpacing.base),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                      initialValue: _selectedGroupId,
                        decoration: const InputDecoration(
                          labelText: 'Gruppe',
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Ingen gruppe'),
                          ),
                          ...groups.map((g) {
                            return DropdownMenuItem(
                              value: g.id,
                              child: Text(g.name),
                            );
                          }),
                        ],
                        onChanged: (v) =>
                            setState(() => _selectedGroupId = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DittoSpacing.base),

                // Active toggle
                SwitchListTile(
                  title: const Text('Aktiv'),
                  subtitle: const Text(
                    'Inaktive tjenester vises ikke for kunder',
                  ),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: DittoSpacing.lg),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
                      child: const Text('Avbryt'),
                    ),
                    const SizedBox(width: DittoSpacing.sm),
                    FilledButton(
                      onPressed: _saving ? null : _handleSave,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(_isEditing ? 'Lagre' : 'Opprett'),
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
