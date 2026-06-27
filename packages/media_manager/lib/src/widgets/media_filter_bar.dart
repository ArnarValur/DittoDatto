import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';

/// Filter bar with search, category chips, and tag chips.
///
/// Used by [MediaGalleryPage] and available for custom gallery layouts.
class MediaFilterBar extends StatelessWidget {
  const MediaFilterBar({
    super.key,
    required this.searchController,
    required this.tags,
    required this.selectedTag,
    required this.selectedCategory,
    required this.onTagSelected,
    required this.onCategorySelected,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final List<String> tags;
  final String? selectedTag;
  final MediaCategory? selectedCategory;
  final ValueChanged<String> onTagSelected;
  final ValueChanged<MediaCategory> onCategorySelected;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DittoSpacing.lg,
        DittoSpacing.base,
        DittoSpacing.lg,
        DittoSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            controller: searchController,
            onChanged: (_) => onSearchChanged(),
            decoration: InputDecoration(
              hintText: 'Søk etter filnavn...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged();
                      },
                    )
                  : null,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: DittoBorderRadius.mediumAll,
              ),
            ),
          ),

          // Category filter chips
          const SizedBox(height: DittoSpacing.sm),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MediaCategory.values.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: DittoSpacing.xs),
              itemBuilder: (context, index) {
                final cat = MediaCategory.values[index];
                final isSelected = selectedCategory == cat;
                return FilterChip(
                  label: Text(cat.label),
                  selected: isSelected,
                  onSelected: (_) => onCategorySelected(cat),
                );
              },
            ),
          ),

          // Tag chips
          if (tags.isNotEmpty) ...[
            const SizedBox(height: DittoSpacing.xs),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: DittoSpacing.xs),
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  final isSelected = selectedTag == tag;
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => onTagSelected(tag),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
