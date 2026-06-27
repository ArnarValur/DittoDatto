import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_manager/media_manager.dart';

import 'media_providers.dart';

/// Business Portal media gallery screen.
///
/// Thin Riverpod bridge that reads state from BP providers and delegates
/// all rendering to [MediaGalleryPage] from the shared `media_manager` package.
class MediaGalleryScreen extends ConsumerWidget {
  const MediaGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMedia = ref.watch(mediaProvider);
    final uploadState = ref.watch(mediaUploadStateProvider);

    return MediaGalleryPage(
      items: asyncMedia.value ?? [],
      isLoading: asyncMedia.isLoading,
      error: asyncMedia.error?.toString(),
      uploadState: uploadState,
      onUpload: ({required category, required files}) async {
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
      },
      onDelete: (item) => ref.read(mediaProvider.notifier).deleteMedia(item),
      onRefresh: () => ref.read(mediaProvider.notifier).refresh(),
      onDismissError: () =>
          ref.read(mediaUploadStateProvider.notifier).reset(),
    );
  }
}
