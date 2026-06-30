import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../establishments/establishment_providers.dart';
import 'service_providers.dart';
import 'service_group_dialog.dart';
import 'service_dialog.dart';

/// Services management screen — grouped list with CRUD actions.
///
/// Shows service groups as expandable sections, services as list tiles
/// within each group. Ungrouped services fall under "Øvrige tjenester".
class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGroups = ref.watch(serviceGroupsProvider);
    final asyncServices = ref.watch(servicesProvider);
    final asyncEstablishments = ref.watch(establishmentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DittoSpacing.lg,
              DittoSpacing.lg,
              DittoSpacing.lg,
              DittoSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  'Tjenester',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _showGroupDialog(context, ref),
                  icon: const Icon(Icons.folder_outlined, size: 18),
                  label: const Text('Ny gruppe'),
                ),
                const SizedBox(width: DittoSpacing.sm),
                FilledButton.icon(
                  onPressed: () => _showServiceDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Ny tjeneste'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: asyncGroups.when(
              data: (groups) => asyncServices.when(
                data: (services) {
                  if (groups.isEmpty && services.isEmpty) {
                    return const _EmptyState();
                  }
                  return _ServicesList(
                    groups: groups,
                    services: services,
                    establishments:
                        asyncEstablishments.value ?? [],
                    onEditGroup: (g) =>
                        _showGroupDialog(context, ref, existing: g),
                    onDeleteGroup: (g) =>
                        _confirmDeleteGroup(context, ref, g),
                    onEditService: (s) =>
                        _showServiceDialog(context, ref, existing: s),
                    onDeleteService: (s) =>
                        _confirmDeleteService(context, ref, s),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Feil: $e')),
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Feil: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupDialog(BuildContext context, WidgetRef ref,
      {ServiceGroup? existing}) {
    showDialog(
      context: context,
      builder: (_) => ServiceGroupDialog(existing: existing),
    );
  }

  void _showServiceDialog(BuildContext context, WidgetRef ref,
      {Service? existing}) {
    showDialog(
      context: context,
      builder: (_) => ServiceDialog(existing: existing),
    );
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    ServiceGroup group,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Slett gruppe?'),
        content: Text(
          'Er du sikker på at du vil slette "${group.name}"? '
          'Tjenestene i gruppen blir ikke slettet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Avbryt'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Slett'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(serviceGroupsProvider.notifier).delete(group.id);
    }
  }

  Future<void> _confirmDeleteService(
    BuildContext context,
    WidgetRef ref,
    Service service,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Slett tjeneste?'),
        content: Text(
          'Er du sikker på at du vil slette "${service.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Avbryt'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Slett'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(servicesProvider.notifier).delete(service.id);
    }
  }
}

/// Grouped list of services.
class _ServicesList extends StatelessWidget {
  const _ServicesList({
    required this.groups,
    required this.services,
    required this.establishments,
    required this.onEditGroup,
    required this.onDeleteGroup,
    required this.onEditService,
    required this.onDeleteService,
  });

  final List<ServiceGroup> groups;
  final List<Service> services;
  final List<dynamic> establishments;
  final ValueChanged<ServiceGroup> onEditGroup;
  final ValueChanged<ServiceGroup> onDeleteGroup;
  final ValueChanged<Service> onEditService;
  final ValueChanged<Service> onDeleteService;

  @override
  Widget build(BuildContext context) {
    // Group services by their groupId.
    final grouped = <String?, List<Service>>{};
    for (final s in services) {
      grouped.putIfAbsent(s.groupId, () => []).add(s);
    }

    // Sorted groups first, then ungrouped.
    final sortedGroups = [...groups]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ListView(
      padding: const EdgeInsets.all(DittoSpacing.lg),
      children: [
        for (final group in sortedGroups) ...[
          _GroupHeader(
            group: group,
            onEdit: () => onEditGroup(group),
            onDelete: () => onDeleteGroup(group),
          ),
          ...?(grouped[group.id]?.map(
            (s) => _ServiceTile(
              service: s,
              onEdit: () => onEditService(s),
              onDelete: () => onDeleteService(s),
            ),
          )),
          if (grouped[group.id]?.isEmpty ?? true)
            Padding(
              padding: const EdgeInsets.only(
                left: DittoSpacing.xl,
                bottom: DittoSpacing.base,
              ),
              child: Text(
                'Ingen tjenester i denne gruppen',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
              ),
            ),
          const SizedBox(height: DittoSpacing.sm),
        ],

        // Ungrouped services
        if (grouped.containsKey(null) && grouped[null]!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: DittoSpacing.sm,
              bottom: DittoSpacing.sm,
            ),
            child: Text(
              'Øvrige tjenester',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          ...grouped[null]!.map(
            (s) => _ServiceTile(
              service: s,
              onEdit: () => onEditService(s),
              onDelete: () => onDeleteService(s),
            ),
          ),
        ],
      ],
    );
  }
}

/// Group header with name, description, and action buttons.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.group,
    required this.onEdit,
    required this.onDelete,
  });

  final ServiceGroup group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: DittoSpacing.sm),
      child: Row(
        children: [
          const Icon(
            Icons.folder_rounded,
            size: 20,
            color: DittoColors.moodyBlue,
          ),
          const SizedBox(width: DittoSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (group.description != null)
                  Text(
                    group.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (group.multiSelect)
            Padding(
              padding: const EdgeInsets.only(right: DittoSpacing.sm),
              child: Chip(
                label: const Text('Flervalg'),
                labelStyle: theme.textTheme.labelSmall,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
            tooltip: 'Rediger gruppe',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onDelete,
            tooltip: 'Slett gruppe',
          ),
        ],
      ),
    );
  }
}

/// Individual service list tile.
class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.onEdit,
    required this.onDelete,
  });

  final Service service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(
        left: DittoSpacing.lg,
        bottom: DittoSpacing.xs,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.base,
          vertical: DittoSpacing.xs,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                service.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (!service.isActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DittoSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: DittoBorderRadius.smallAll,
                ),
                child: Text(
                  'Inaktiv',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              formatPrice(service.price, service.currency),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '  ·  ${formatDuration(service.duration)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (service.bookingMode != 'standard') ...[
              Text(
                '  ·  ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                _bookingModeLabel(service.bookingMode),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
              tooltip: 'Rediger',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: onDelete,
              tooltip: 'Slett',
            ),
          ],
        ),
      ),
    );
  }

  static String _bookingModeLabel(String mode) => switch (mode) {
        'tableReservation' => 'Bordreservasjon',
        'ticketSystem' => 'Billettsystem',
        _ => mode,
      };
}

/// Empty state when no services or groups exist.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.design_services_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DittoSpacing.base),
          Text(
            'Ingen tjenester ennå',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DittoSpacing.sm),
          Text(
            'Legg til tjenester kundene dine kan bestille.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
