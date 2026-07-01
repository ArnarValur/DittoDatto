import 'package:ditto_design/ditto_design.dart';
import 'package:establishment_ui/establishment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'create_establishment_dialog.dart';
import 'establishment_model.dart';
import 'establishment_providers.dart';

/// Card-based list of the merchant's Establishments.
///
/// Features per spec F3:
/// - Tab filters by business type (Alle, Butikk, Restaurant, Spillested)
/// - Card layout with name, city, type icon, status badge
/// - "+ Legg til virksomhet" action button
/// - Empty state for first-time merchants
class EstablishmentsScreen extends ConsumerStatefulWidget {
  const EstablishmentsScreen({super.key});

  @override
  ConsumerState<EstablishmentsScreen> createState() =>
      _EstablishmentsScreenState();
}

class _EstablishmentsScreenState extends ConsumerState<EstablishmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [null, ...EstablishmentType.values];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  EstablishmentType? get _selectedType => _tabs[_tabController.index];

  List<Establishment> _filter(List<Establishment> all) {
    final type = _selectedType;
    if (type == null) return all;
    return all.where((e) => e.establishmentType == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncEstablishments = ref.watch(establishmentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
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
                  'Virksomheter',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (_) => const CreateEstablishmentDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Legg til virksomhet'),
                ),
              ],
            ),
          ),

          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              const Tab(text: 'Alle'),
              ...EstablishmentType.values.map((t) => Tab(text: t.label)),
            ],
          ),

          const Divider(height: 1),

          // Content
          Expanded(
            child: asyncEstablishments.when(
              data: (all) {
                final filtered = _filter(all);
                if (all.isEmpty) return const _EmptyState();
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'Ingen ${_selectedType?.label.toLowerCase() ?? "virksomheter"} funnet',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return _EstablishmentGrid(establishments: filtered);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Feil: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid of establishment cards.
class _EstablishmentGrid extends StatelessWidget {
  const _EstablishmentGrid({required this.establishments});

  final List<Establishment> establishments;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 3
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(DittoSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2.2,
            crossAxisSpacing: DittoSpacing.base,
            mainAxisSpacing: DittoSpacing.base,
          ),
          itemCount: establishments.length,
          itemBuilder: (context, index) {
            return _EstablishmentCard(establishment: establishments[index]);
          },
        );
      },
    );
  }
}

/// Individual establishment card with name, address, type icon, and status badge.
class _EstablishmentCard extends StatelessWidget {
  const _EstablishmentCard({required this.establishment});

  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        borderRadius: DittoBorderRadius.mediumAll,
        onTap: () {
          // Extract the short ID from 'establishment:abc123' → 'abc123'.
          final shortId = establishment.id.split(':').last;
          context.go('/establishments/$shortId');
        },
        child: Padding(
          padding: const EdgeInsets.all(DittoSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: icon + name + badge
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: DittoColors.moodyBlue.withValues(alpha: 0.1),
                      borderRadius: DittoBorderRadius.smallAll,
                    ),
                    child: Icon(
                      establishment.establishmentType.icon,
                      color: DittoColors.moodyBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: DittoSpacing.sm),
                  Expanded(
                    child: Text(
                      establishment.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: DittoSpacing.sm),
                  _StatusBadge(isPublished: establishment.isPublished),
                ],
              ),

              const SizedBox(height: DittoSpacing.sm),

              // Address + city
              Text(
                '${establishment.address}, ${establishment.city}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Bottom row: type label + category
              Row(
                children: [
                  Text(
                    establishment.establishmentType.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (establishment.category != null) ...[
                    Text(
                      ' · ',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      establishment.category!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Live/Draft status badge.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isPublished});

  final bool isPublished;

  @override
  Widget build(BuildContext context) {
    final color = isPublished ? DittoColors.success : Colors.orange;
    final label = isPublished ? 'Live' : 'Utkast';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DittoSpacing.sm,
        vertical: DittoSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: DittoBorderRadius.smallAll,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// Empty state for merchants with no establishments.
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
            Icons.storefront_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DittoSpacing.base),
          Text(
            'Ingen virksomheter ennå',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DittoSpacing.sm),
          Text(
            'Legg til din første virksomhet for å komme i gang.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
