import 'dart:typed_data';

import 'storage_upload_result.dart';

/// Abstract interface for media storage backends.
///
/// Consuming apps provide a concrete implementation (e.g. Firebase Storage,
/// Supabase Storage, S3-compatible). The media manager package never knows
/// which storage provider is used — only this interface.
///
/// **Path isolation rule:** Implementations MUST write only under
/// `companies/{slug}/media/`. The same bucket may be shared with other
/// systems (e.g. legacy Nuxt media manager).
abstract class MediaStorageBackend {
  /// Upload [bytes] to the storage backend.
  ///
  /// [companySlug] is used to namespace files (e.g. `companies/{slug}/media/...`).
  /// [onProgress] reports upload progress as a value from 0.0 to 1.0.
  Future<StorageUploadResult> upload({
    required Uint8List bytes,
    required String companySlug,
    required String filename,
    required String mimeType,
    void Function(double progress)? onProgress,
  });

  /// Delete a file from storage by its path.
  Future<void> delete(String storagePath);
}
