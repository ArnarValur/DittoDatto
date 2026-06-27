import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_manager/media_manager.dart';

import 'media_providers.dart';

/// Feature flag: set to `false` to revert to V1 filter-chip + grid layout.
const _useV2Layout = true;

/// Business Portal media gallery screen.
///
/// Thin Riverpod bridge that reads state from BP providers and delegates
/// all rendering to the shared `media_manager` package.
///
/// When [_useV2Layout] is true, renders [MediaGalleryV2Page] (category rows).
/// When false, renders [MediaGalleryPage] (filter chips + flat grid).
class MediaGalleryScreen extends ConsumerWidget {
  const MediaGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMedia = ref.watch(mediaProvider);
    final uploadState = ref.watch(mediaUploadStateProvider);

    final items = asyncMedia.value ?? [];
    final isLoading = asyncMedia.isLoading;
    final error = asyncMedia.error?.toString();

    Future<void> onUpload({
      required MediaCategory category,
      required List<({Uint8List bytes, String filename, String mimeType, int size})>
          files,
    }) async {
      if (files.length == 1) {
        final f = files.first;
        await ref.read(mediaProvider.notifier).uploadMedia(
              bytes: f.bytes,
              filename: f.filename,
              mimeType: f.mimeType,
              size: f.size,
              category: category,
            );
      } else {
        await ref.read(mediaProvider.notifier).uploadMultiple(
              files: files,
              category: category,
            );
      }
    }

    if (_useV2Layout) {
      return MediaGalleryV2Page(
        items: items,
        isLoading: isLoading,
        error: error,
        uploadState: uploadState,
        onUpload: onUpload,
        onDelete: (item) =>
            ref.read(mediaProvider.notifier).deleteMedia(item),
        onRefresh: () => ref.read(mediaProvider.notifier).refresh(),
        onDismissError: () =>
            ref.read(mediaUploadStateProvider.notifier).reset(),
        onUpdateName: (id, name) =>
            ref.read(mediaProvider.notifier).updateMediaName(id, name),
        onUpdateTags: (id, tags) =>
            ref.read(mediaProvider.notifier).updateMediaTags(id, tags),
      );
    }

    // V1 fallback
    return MediaGalleryPage(
      items: items,
      isLoading: isLoading,
      error: error,
      uploadState: uploadState,
      onUpload: onUpload,
      onDelete: (item) =>
          ref.read(mediaProvider.notifier).deleteMedia(item),
      onRefresh: () => ref.read(mediaProvider.notifier).refresh(),
      onDismissError: () =>
          ref.read(mediaUploadStateProvider.notifier).reset(),
    );
  }
}
