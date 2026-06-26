import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

import '../models/media_category.dart';
import '../models/media_item.dart';

/// A single media grid tile with hover overlay showing actions and info.
class MediaGridTile extends StatefulWidget {
  const MediaGridTile({
    super.key,
    required this.item,
    required this.onDelete,
    this.onTap,
    this.selected = false,
    this.selectable = false,
  });

  final MediaItem item;
  final VoidCallback onDelete;

  /// Called when the tile is tapped (used in picker mode for selection).
  final VoidCallback? onTap;

  /// Whether this tile is currently selected (picker mode).
  final bool selected;

  /// Whether selection UI should be shown (picker mode).
  final bool selectable;

  @override
  State<MediaGridTile> createState() => _MediaGridTileState();
}

class _MediaGridTileState extends State<MediaGridTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: ClipRRect(
          borderRadius: DittoBorderRadius.mediumAll,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                widget.item.url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 40,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),

              // Selection indicator (picker mode)
              if (widget.selectable)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.selected
                          ? theme.colorScheme.primary
                          : Colors.black.withValues(alpha: 0.4),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: widget.selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),

              // Category badge (always visible)
              if (widget.item.category != MediaCategory.general)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.item.category.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Hover overlay
              if (_hovering && !widget.selectable) ...[
                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                // Delete button
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton.filled(
                    icon:
                        const Icon(Icons.delete_outline_rounded, size: 18),
                    onPressed: widget.onDelete,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(32, 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),

                // File info
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name ?? widget.item.filename,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.item.formattedSize,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tag chips
                if (widget.item.tags.isNotEmpty)
                  Positioned(
                    top: widget.item.category != MediaCategory.general
                        ? 36
                        : 8,
                    left: 8,
                    child: Wrap(
                      spacing: 4,
                      children: widget.item.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
