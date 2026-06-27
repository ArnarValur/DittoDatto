import 'dart:typed_data';

import 'package:mercury_client/mercury_client.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_manager/media_manager.dart';

import '../auth/auth_provider.dart';

// ── Firebase Storage Backend (BP-specific) ───────────────────────────────────

/// Concrete [MediaStorageBackend] backed by Firebase Storage.
///
/// This is the ONLY class that knows about Firebase. To swap to a
/// European-sovereign object store, replace this class only.
class FirebaseMediaStorage extends MediaStorageBackend {
  FirebaseMediaStorage(this._storage);

  final FirebaseStorage _storage;

  @override
  Future<StorageUploadResult> upload({
    required Uint8List bytes,
    required String companySlug,
    required String filename,
    required String mimeType,
    void Function(double progress)? onProgress,
  }) async {
    final safeName = _safeFilename(filename);
    final storagePath = 'companies/$companySlug/media/$safeName';
    final ref = _storage.ref(storagePath);

    final metadata = SettableMetadata(contentType: mimeType);
    final uploadTask = ref.putData(bytes, metadata);

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
    }

    await uploadTask;
    final url = await ref.getDownloadURL();

    return StorageUploadResult(url: url, storagePath: storagePath);
  }

  @override
  Future<void> delete(String storagePath) async {
    await _storage.ref(storagePath).delete();
  }

  String _safeFilename(String original) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safe = original
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-z0-9.\-]'), '');
    return '$timestamp-$safe';
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

/// Firebase Storage instance.
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

/// The swappable storage backend — BP uses Firebase.
final mediaStorageProvider = Provider<MediaStorageBackend>((ref) {
  return FirebaseMediaStorage(ref.watch(firebaseStorageProvider));
});

/// Media repository backed by the tenant connection.
final mediaRepositoryProvider = Provider<MediaRepository?>((ref) {
  final conn = ref.watch(tenantConnectionProvider);
  if (conn == null) return null;
  return MediaRepository(conn);
});

/// Upload state notifier — observable by the UI for progress bars.
final mediaUploadStateProvider =
    NotifierProvider<MediaUploadStateNotifier, MediaUploadState>(
        MediaUploadStateNotifier.new);

class MediaUploadStateNotifier extends Notifier<MediaUploadState> {
  @override
  MediaUploadState build() => MediaUploadState.idle;

  void update(MediaUploadState newState) => state = newState;

  void modify(MediaUploadState Function(MediaUploadState) updater) =>
      state = updater(state);

  void reset() => state = MediaUploadState.idle;
}

/// Media library provider — manages CRUD via [MediaRepository] + [MediaStorageBackend].
final mediaProvider =
    AsyncNotifierProvider<MediaNotifier, List<MediaItem>>(MediaNotifier.new);

class MediaNotifier extends AsyncNotifier<List<MediaItem>> {
  @override
  Future<List<MediaItem>> build() async {
    ref.watch(tenantConnectionProvider);
    return _fetchMedia();
  }

  MediaRepository? get _repo => ref.read(mediaRepositoryProvider);

  MediaUploadStateNotifier get _uploadState =>
      ref.read(mediaUploadStateProvider.notifier);

  Future<List<MediaItem>> _fetchMedia() async {
    final repo = _repo;
    if (repo == null) return [];
    return repo.fetchAll();
  }

  /// Upload a file to storage and create a SurrealDB media record.
  Future<MediaItem?> uploadMedia({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
    required int size,
    MediaCategory category = MediaCategory.general,
    String? establishmentId,
    List<String> tags = const [],
  }) async {
    // Validate
    final validationError = MediaItem.validateFile(mimeType, size);
    if (validationError != null) {
      _uploadState.update(MediaUploadState(error: validationError));
      return null;
    }

    final repo = _repo;
    final authState = ref.read(authProvider).value;
    if (repo == null || authState is! Authenticated) return null;

    final storage = ref.read(mediaStorageProvider);

    _uploadState.update(MediaUploadState(
      isUploading: true,
      currentFileName: filename,
      currentIndex: 1,
      totalFiles: 1,
    ));

    try {
      // 1. Upload to object storage
      final result = await storage.upload(
        bytes: bytes,
        companySlug: repo.slug,
        filename: filename,
        mimeType: mimeType,
        onProgress: (p) {
          _uploadState.modify((s) => s.copyWith(progress: p));
        },
      );

      // 2. Create metadata record in SurrealDB
      final item = await repo.create(
        uploaderId: authState.email,
        url: result.url,
        storagePath: result.storagePath,
        filename: filename,
        mimeType: mimeType,
        size: size,
        category: category,
        establishmentId: establishmentId,
        tags: tags,
      );

      if (item == null) return null;

      // 3. Update local state
      state = AsyncData([item, ...state.value ?? []]);
      _uploadState.reset();

      return item;
    } catch (e) {
      _uploadState.update(MediaUploadState(error: e.toString()));
      return null;
    }
  }

  /// Upload multiple files sequentially.
  Future<List<MediaItem>> uploadMultiple({
    required List<
            ({Uint8List bytes, String filename, String mimeType, int size})>
        files,
    MediaCategory category = MediaCategory.general,
    String? establishmentId,
    List<String> tags = const [],
  }) async {
    final results = <MediaItem>[];

    _uploadState.update(MediaUploadState(
      isUploading: true,
      totalFiles: files.length,
    ));

    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      _uploadState.modify((s) => s.copyWith(
            currentIndex: i + 1,
            currentFileName: file.filename,
            progress: 0.0,
          ));

      final item = await uploadMedia(
        bytes: file.bytes,
        filename: file.filename,
        mimeType: file.mimeType,
        size: file.size,
        category: category,
        establishmentId: establishmentId,
        tags: tags,
      );

      if (item != null) results.add(item);
    }

    _uploadState.reset();
    return results;
  }

  /// Delete a media item from both storage and SurrealDB.
  Future<bool> deleteMedia(MediaItem item) async {
    final repo = _repo;
    if (repo == null) return false;

    try {
      // 1. Delete from object storage
      final storage = ref.read(mediaStorageProvider);
      await storage.delete(item.storagePath);

      // 2. Delete from SurrealDB
      final deleted = await repo.delete(item.id);
      if (!deleted) return false;

      // 3. Update local state
      final current = state.value ?? [];
      state = AsyncData(current.where((m) => m.id != item.id).toList());

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update the display name of a media item.
  Future<bool> updateMediaName(String id, String? name) async {
    final repo = _repo;
    if (repo == null) return false;

    final success = await repo.updateName(id, name);
    if (success) {
      final current = state.value ?? [];
      state = AsyncData(current.map((m) {
        if (m.id == id) {
          return MediaItem(
            id: m.id,
            uploaderId: m.uploaderId,
            url: m.url,
            storagePath: m.storagePath,
            filename: m.filename,
            mimeType: m.mimeType,
            size: m.size,
            category: m.category,
            establishmentId: m.establishmentId,
            tags: m.tags,
            name: name,
          );
        }
        return m;
      }).toList());
    }
    return success;
  }

  /// Update the tags of a media item.
  Future<bool> updateMediaTags(String id, List<String> tags) async {
    final repo = _repo;
    if (repo == null) return false;

    final success = await repo.updateTags(id, tags);
    if (success) {
      final current = state.value ?? [];
      state = AsyncData(current.map((m) {
        if (m.id == id) {
          return MediaItem(
            id: m.id,
            uploaderId: m.uploaderId,
            url: m.url,
            storagePath: m.storagePath,
            filename: m.filename,
            mimeType: m.mimeType,
            size: m.size,
            category: m.category,
            establishmentId: m.establishmentId,
            tags: tags,
            name: m.name,
          );
        }
        return m;
      }).toList());
    }
    return success;
  }

  /// Refresh the media list from the database.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchMedia());
  }
}
