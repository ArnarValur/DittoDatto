/// Result from a storage upload — URL + path for deletion.
class StorageUploadResult {
  const StorageUploadResult({required this.url, required this.storagePath});

  /// The publicly accessible download URL.
  final String url;

  /// The storage path used for deletion.
  final String storagePath;
}
