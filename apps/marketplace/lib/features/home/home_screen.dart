import 'dart:async';

import 'package:discovery_service/discovery_service.dart';
import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'discovery_providers.dart';
import 'establishment_listing_card.dart';

/// Marketplace Home screen — DittoBar search, category chips, listing cards.
///
/// Reads from `companies/discovery` via [DiscoveryRepository].
/// Anonymous browsing per ADR-0020.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).update(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).update('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final listingsAsync = ref.watch(listingsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── DittoBar Header ──
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 120,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(
                  DittoSpacing.md,
                  0,
                  DittoSpacing.md,
                  DittoSpacing.sm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand header
                    Text(
                      'DittoDatto',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: DittoSpacing.sm),
                    // Search field
                    _DittoBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onClear: _clearSearch,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Category chips ──
          SliverToBoxAdapter(
            child: categoriesAsync.when(
              data: (categories) => _CategoryChipRow(
                categories: categories,
                selected: selectedCategory,
                onSelected: (slug) {
                  ref.read(selectedCategoryProvider.notifier).select(
                      slug == selectedCategory ? null : slug);
                },
                onClearFilter: () {
                  ref.read(selectedCategoryProvider.notifier).select(null);
                },
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DittoSpacing.md,
                  vertical: DittoSpacing.sm,
                ),
                child: _ShimmerChipRow(),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),

          // ── Listings ──
          listingsAsync.when(
            data: (listings) {
              if (listings.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(hasSearch: _searchController.text.isNotEmpty),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  DittoSpacing.md,
                  DittoSpacing.sm,
                  DittoSpacing.md,
                  // Extra bottom padding for glass bottom nav.
                  80,
                ),
                sliver: SliverList.separated(
                  itemCount: listings.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: DittoSpacing.compact),
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    return EstablishmentListingCard(
                      listing: listing,
                      onTap: () => _onListingTap(listing),
                    );
                  },
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: _ErrorState(
                error: error,
                onRetry: () => ref.invalidate(listingsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onListingTap(EstablishmentListing listing) {
    // Phase 4 will replace this with two-phase detail load.
    // For now, navigate to the debug establishment-test route.
    context.push('/establishment-test');
  }
}

// ── DittoBar ───────────────────────────────────────────────────────────────

class _DittoBar extends StatelessWidget {
  const _DittoBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Søk etter tjenester, steder, bedrifter...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.primary,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 20),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: DittoBorderRadius.extraLargeAll,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DittoSpacing.md,
          vertical: DittoSpacing.compact,
        ),
      ),
    );
  }
}

// ── Category Chip Row ──────────────────────────────────────────────────────

class _CategoryChipRow extends StatelessWidget {
  const _CategoryChipRow({
    required this.categories,
    required this.selected,
    required this.onSelected,
    required this.onClearFilter,
  });

  final List<DiscoveryCategory> categories;
  final String? selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onClearFilter;

  /// Map stored icon names to Material icons.
  static final _iconMap = <String, IconData>{
    'content_cut': Icons.content_cut,
    'restaurant': Icons.restaurant,
    'local_hospital': Icons.local_hospital,
    'spa': Icons.spa,
    'fitness_center': Icons.fitness_center,
    'car_repair': Icons.car_repair,
    'event': Icons.event,
    'store': Icons.store,
    'music_note': Icons.music_note,
    'home_repair_service': Icons.home_repair_service,
  };

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DittoSpacing.md),
        separatorBuilder: (_, _) => const SizedBox(width: DittoSpacing.sm),
        itemCount: categories.length + 1, // +1 for "Alle" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            // "Alle" (clear filter) chip
            final isSelected = selected == null;
            return FilterChip(
              label: const Text('Alle'),
              selected: isSelected,
              onSelected: (_) {
                if (!isSelected) onClearFilter();
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
              backgroundColor: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: DittoBorderRadius.extraLargeAll,
              ),
            );
          }

          final cat = categories[index - 1];
          final isSelected = selected == cat.slug;
          final icon = _iconMap[cat.icon];

          return FilterChip(
            avatar: icon != null
                ? Icon(icon, size: 16)
                : null,
            label: Text(cat.name),
            selected: isSelected,
            onSelected: (_) => onSelected(cat.slug),
            selectedColor: colorScheme.primaryContainer,
            checkmarkColor: colorScheme.onPrimaryContainer,
            backgroundColor:
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: DittoBorderRadius.extraLargeAll,
            ),
          );
        },
      ),
    );
  }
}

// ── Shimmer / Loading ──────────────────────────────────────────────────────

class _ShimmerChipRow extends StatelessWidget {
  const _ShimmerChipRow();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 32,
      child: Row(
        children: List.generate(
          4,
          (i) => Padding(
            padding: const EdgeInsets.only(right: DittoSpacing.sm),
            child: Container(
              width: 70 + (i * 10.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: DittoBorderRadius.extraLargeAll,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasSearch});

  final bool hasSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DittoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSearch ? Icons.search_off_rounded : Icons.storefront_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: DittoSpacing.md),
            Text(
              hasSearch
                  ? 'Ingen resultater'
                  : 'Ingen virksomheter funnet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DittoSpacing.sm),
            Text(
              hasSearch
                  ? 'Prøv et annet søkeord'
                  : 'Nye bedrifter dukker opp her når de publiserer',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error State ────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DittoSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: theme.colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: DittoSpacing.md),
            Text(
              'Kunne ikke laste virksomheter',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: DittoSpacing.md),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Prøv igjen'),
            ),
          ],
        ),
      ),
    );
  }
}
