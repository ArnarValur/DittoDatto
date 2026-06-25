import 'dart:typed_data';

import 'package:ditto_auth/ditto_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mercury_client/mercury_client.dart';

import '../auth/auth_provider.dart';
import 'media_model.dart';

// ── Storage Backend (swappable) ──────────────────────────────────────────────

/// Result from a storage upload — URL + path for deletion.
class StorageUploadResult {
  const StorageUploadResult({required this.url, required this.storagePath});
  final String url;
  final String storagePath;
}

/// Uploads bytes to Firebase Storage and returns the download URL.
///
/// This is the ONLY class that knows about Firebase. To swap to a
/// European-sovereign object store, replace this class only.
class FirebaseMediaStorage {
  FirebaseMediaStorage(this._storage);

  final FirebaseStorage _storage;

  /// Upload [bytes] to Firebase Storage.
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

  /// Delete a file from Firebase Storage by its path.
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

/// The swappable storage backend.
final mediaStorageProvider = Provider<FirebaseMediaStorage>((ref) {
  return FirebaseMediaStorage(ref.watch(firebaseStorageProvider));
});

/// Upload state for progress tracking.
class MediaUploadState {
  const MediaUploadState({
    this.isUploading = false,
    this.progress = 0.0,
    this.currentFileName,
    this.currentIndex = 0,
    this.totalFiles = 0,
    this.error,
  });

  final bool isUploading;
  final double progress;
  final String? currentFileName;
  final int currentIndex;
  final int totalFiles;
  final String? error;

  MediaUploadState copyWith({
    bool? isUploading,
    double? progress,
    String? currentFileName,
    int? currentIndex,
    int? totalFiles,
    String? error,
  }) {
    return MediaUploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      currentFileName: currentFileName ?? this.currentFileName,
      currentIndex: currentIndex ?? this.currentIndex,
      totalFiles: totalFiles ?? this.totalFiles,
      error: error,
    );
  }
}

/// Upload state notifier — observable by the UI for progress bars.
final mediaUploadStateProvider =
    NotifierProvider<MediaUploadStateNotifier, MediaUploadState>(
        MediaUploadStateNotifier.new);

class MediaUploadStateNotifier extends Notifier<MediaUploadState> {
  @override
  MediaUploadState build() => const MediaUploadState();

  /// Update the upload state.
  void update(MediaUploadState newState) => state = newState;

  /// Update individual fields via a builder function.
  void modify(MediaUploadState Function(MediaUploadState) updater) =>
      state = updater(state);

  /// Reset to idle state.
  void reset() => state = const MediaUploadState();
}

/// Media library provider — manages CRUD against SurrealDB + Firebase Storage.
final mediaProvider =
    AsyncNotifierProvider<MediaNotifier, List<MediaItem>>(MediaNotifier.new);

class MediaNotifier extends AsyncNotifier<List<MediaItem>> {
  @override
  Future<List<MediaItem>> build() async {
    ref.watch(tenantConnectionProvider);
    return _fetchMedia();
  }

  TenantConnection? get _conn => ref.read(tenantConnectionProvider);

  MediaUploadStateNotifier get _uploadState =>
      ref.read(mediaUploadStateProvider.notifier);

  /// Fetch all media items from the tenant SurrealDB.
  Future<List<MediaItem>> _fetchMedia() async {
    final conn = _conn;
    if (conn == null) return [];

    final result = await conn.companies
        .query('SELECT * FROM media ORDER BY created_at DESC');

    return _parseRows(result);
  }

  /// Upload a file to Firebase Storage and create a SurrealDB media record.
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

    final conn = _conn;
    final authState = ref.read(authProvider).value;
    if (conn == null || authState is! Authenticated) return null;

    final storage = ref.read(mediaStorageProvider);

    _uploadState.update(MediaUploadState(
      isUploading: true,
      currentFileName: filename,
      currentIndex: 1,
      totalFiles: 1,
    ));

    try {
      // 1. Upload to Firebase Storage
      final result = await storage.upload(
        bytes: bytes,
        companySlug: conn.slug,
        filename: filename,
        mimeType: mimeType,
        onProgress: (p) {
          _uploadState.modify((s) => s.copyWith(progress: p));
        },
      );

      // 2. Create metadata record in SurrealDB
      final mediaData = <String, dynamic>{
        'uploader_id': authState.email,
        'url': result.url,
        'storage_path': result.storagePath,
        'filename': filename,
        'mime_type': mimeType,
        'size': size,
        'category': category.value,
        'tags': tags,
      };
      if (establishmentId != null) {
        mediaData['establishment'] = establishmentId;
      }

      final createResult = await conn.companies.query(
        r'CREATE media CONTENT $data',
        {'data': mediaData},
      );

      final rows = _parseRows(createResult);
      if (rows.isEmpty) return null;

      final item = rows.first;

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

  /// Delete a media item from both Firebase Storage and SurrealDB.
  Future<bool> deleteMedia(MediaItem item) async {
    final conn = _conn;
    if (conn == null) return false;

    try {
      // 1. Delete from Firebase Storage
      final storage = ref.read(mediaStorageProvider);
      await storage.delete(item.storagePath);

      // 2. Delete from SurrealDB
      await conn.companies.query(
        r'DELETE $id',
        {'id': item.id},
      );

      // 3. Update local state
      final current = state.value ?? [];
      state = AsyncData(current.where((m) => m.id != item.id).toList());

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Refresh the media list from the database.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchMedia());
  }

  /// Parse SurrealDB query result into MediaItem list.
  List<MediaItem> _parseRows(dynamic result) {
    List<dynamic> rows;
    if (result is List && result.isNotEmpty) {
      final first = result.first;
      if (first is Map && first.containsKey('result')) {
        rows = first['result'] as List<dynamic>? ?? [];
      } else {
        rows = result;
      }
    } else {
      return [];
    }

    return rows
        .whereType<Map<String, dynamic>>()
        .map(MediaItem.fromJson)
        .toList();
  }
}
