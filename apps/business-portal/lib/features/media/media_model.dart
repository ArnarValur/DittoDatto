/// Media item model for the company media library.
///
/// Matches the SurrealDB `media` table schema from
/// `schemas/company-blueprint.surql`.
///
/// Actual image bytes live in Firebase Storage (PoC) — the [url] field
/// contains the download URL. The storage backend is swappable; only the
/// provider layer knows about Firebase.
class MediaItem {
  const MediaItem({
    required this.id,
    required this.uploaderId,
    required this.url,
    required this.storagePath,
    required this.filename,
    required this.mimeType,
    required this.size,
    this.establishmentId,
    this.tags = const [],
    this.name,
  });

  final String id;
  final String? establishmentId;
  final String uploaderId;

  /// Firebase Storage download URL (or any future object store URL).
  final String url;

  /// Full storage path for deletion (e.g. `companies/slug/general/1234-photo.jpg`).
  final String storagePath;

  final String filename;
  final String mimeType;

  /// File size in bytes.
  final int size;

  /// Tags for categorization, e.g. `['logo', 'cover']`.
  final List<String> tags;

  /// Optional user-friendly display name.
  final String? name;

  /// Parse from SurrealDB JSON response.
  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      establishmentId: json['establishment'] as String?,
      uploaderId: json['uploader_id'] as String,
      url: json['url'] as String,
      storagePath: json['storage_path'] as String,
      filename: json['filename'] as String,
      mimeType: json['mime_type'] as String,
      size: json['size'] as int,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String?,
    );
  }

  /// Serialize to JSON for SurrealDB CREATE.
  ///
  /// Strips null values — SurrealDB SCHEMAFULL rejects JSON `null` for
  /// `option<T>` fields. Omitting the key sends NONE, which is accepted.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'uploader_id': uploaderId,
      'url': url,
      'storage_path': storagePath,
      'filename': filename,
      'mime_type': mimeType,
      'size': size,
      'tags': tags,
    };
    if (establishmentId != null) json['establishment'] = establishmentId;
    if (name != null) json['name'] = name;
    return json;
  }

  /// Human-readable file size.
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Allowed MIME types for upload validation.
  static const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/svg+xml',
  ];

  /// Maximum file size: 10 MB.
  static const maxFileSize = 10 * 1024 * 1024;

  /// Validate a file before upload.
  static String? validateFile(String mimeType, int size) {
    if (!allowedMimeTypes.contains(mimeType)) {
      return 'Filtypen "$mimeType" er ikke støttet. Bruk JPEG, PNG, WebP eller SVG.';
    }
    if (size > maxFileSize) {
      return 'Filen er for stor (${(size / (1024 * 1024)).toStringAsFixed(1)} MB). Maks 10 MB.';
    }
    return null;
  }
}
