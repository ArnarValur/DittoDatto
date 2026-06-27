/// Structured error types for media operations.
///
/// Inspired by SwanFlutter's named error taxonomy — provides
/// specific error codes instead of generic exceptions.
enum MediaErrorCode {
  /// File exceeds the maximum allowed size.
  fileTooLarge,

  /// File MIME type is not in the allowed list.
  unsupportedMimeType,

  /// Upload to storage backend failed.
  uploadFailed,

  /// Delete from storage backend failed.
  deleteFailed,

  /// SurrealDB metadata operation failed.
  metadataFailed,

  /// Storage backend is unreachable or not configured.
  storageUnavailable,

  /// Permission denied by the storage backend.
  permissionDenied,

  /// Network error during upload/download.
  networkError,

  /// Unknown/unclassified error.
  unknown,
}

/// A structured error from the media management system.
///
/// Carries a typed [code] for programmatic handling and a
/// human-readable [message] for display.
class MediaError implements Exception {
  const MediaError({
    required this.code,
    required this.message,
    this.details,
  });

  /// The error classification.
  final MediaErrorCode code;

  /// Human-readable message (Norwegian for user-facing, English for logs).
  final String message;

  /// Optional underlying error details.
  final Object? details;

  /// Factory for file validation errors.
  factory MediaError.fileTooLarge(int sizeBytes, int maxBytes) {
    return MediaError(
      code: MediaErrorCode.fileTooLarge,
      message: 'Filen er for stor: ${_formatSize(sizeBytes)} '
          '(maks ${_formatSize(maxBytes)})',
    );
  }

  /// Factory for unsupported MIME type.
  factory MediaError.unsupportedMimeType(String mimeType) {
    return MediaError(
      code: MediaErrorCode.unsupportedMimeType,
      message: 'Filtypen "$mimeType" er ikke støttet',
    );
  }

  /// Factory for upload failures.
  factory MediaError.uploadFailed([Object? cause]) {
    return MediaError(
      code: MediaErrorCode.uploadFailed,
      message: 'Opplastingen feilet',
      details: cause,
    );
  }

  /// Factory for delete failures.
  factory MediaError.deleteFailed([Object? cause]) {
    return MediaError(
      code: MediaErrorCode.deleteFailed,
      message: 'Sletting feilet',
      details: cause,
    );
  }

  /// Factory for metadata operation failures.
  factory MediaError.metadataFailed(String operation, [Object? cause]) {
    return MediaError(
      code: MediaErrorCode.metadataFailed,
      message: 'Metadata-operasjon "$operation" feilet',
      details: cause,
    );
  }

  /// Factory for storage unavailable.
  factory MediaError.storageUnavailable([Object? cause]) {
    return MediaError(
      code: MediaErrorCode.storageUnavailable,
      message: 'Lagringstjenesten er ikke tilgjengelig',
      details: cause,
    );
  }

  @override
  String toString() => 'MediaError(${code.name}): $message';

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
