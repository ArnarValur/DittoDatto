import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../establishments/establishment_providers.dart';
import 'service_providers.dart';

/// Dialog for creating or editing a ServiceGroup.
class ServiceGroupDialog extends ConsumerStatefulWidget {
  const ServiceGroupDialog({super.key, this.existing});

  /// If non-null, we're editing an existing group.
  final ServiceGroup? existing;

  @override
  ConsumerState<ServiceGroupDialog> createState() => _ServiceGroupDialogState();
}

class _ServiceGroupDialogState extends ConsumerState<ServiceGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortOrderController;
  late bool _showOnBookingPanel;
  late bool _multiSelect;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.existing?.description ?? '');
    _sortOrderController = TextEditingController(
      text: (widget.existing?.sortOrder ?? 0).toString(),
    );
    _showOnBookingPanel = widget.existing?.showOnBookingPanel ?? true;
    _multiSelect = widget.existing?.multiSelect ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final notifier = ref.read(serviceGroupsProvider.notifier);

      if (_isEditing) {
        await notifier.updateGroup(ServiceGroup(
          id: widget.existing!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          sortOrder: int.tryParse(_sortOrderController.text.trim()) ?? 0,
          showOnBookingPanel: _showOnBookingPanel,
          multiSelect: _multiSelect,
        ));
      } else {
        // Use the first establishment — BP always has one.
        final establishments = ref.read(establishmentsProvider).value ?? [];
        if (establishments.isEmpty) {
          throw StateError('Ingen virksomheter funnet');
        }
        final estId = establishments.first.id;

        await notifier.create(
          establishmentId: estId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          sortOrder: int.tryParse(_sortOrderController.text.trim()) ?? 0,
          showOnBookingPanel: _showOnBookingPanel,
          multiSelect: _multiSelect,
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

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(DittoSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Rediger gruppe' : 'Ny tjenestegruppe',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: DittoSpacing.lg),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Navn *',
                    hintText: 'f.eks. Hårklipp, Behandlinger',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Påkrevd' : null,
                  autofocus: true,
                ),
                const SizedBox(height: DittoSpacing.base),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Beskrivelse',
                    hintText: 'Valgfri beskrivelse',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: DittoSpacing.base),
                TextFormField(
                  controller: _sortOrderController,
                  decoration: const InputDecoration(
                    labelText: 'Sortering',
                    hintText: '0 = først',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: DittoSpacing.base),
                SwitchListTile(
                  title: const Text('Vis på bestillingspanel'),
                  value: _showOnBookingPanel,
                  onChanged: (v) => setState(() => _showOnBookingPanel = v),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: const Text('Tillat flervalg'),
                  subtitle: const Text(
                    'Kunder kan velge flere tjenester fra denne gruppen',
                  ),
                  value: _multiSelect,
                  onChanged: (v) => setState(() => _multiSelect = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: DittoSpacing.lg),
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
