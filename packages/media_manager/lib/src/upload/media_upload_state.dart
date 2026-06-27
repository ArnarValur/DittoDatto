/// Upload state for progress tracking across the media upload lifecycle.
///
/// Observable by the UI for rendering progress bars, file names, and errors.
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

  /// Upload progress from 0.0 to 1.0.
  final double progress;

  /// Name of the file currently being uploaded.
  final String? currentFileName;

  /// 1-indexed position in a multi-file upload queue.
  final int currentIndex;

  /// Total number of files in the current upload batch.
  final int totalFiles;

  /// Error message from the last failed upload, if any.
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

  /// Reset to idle state (no upload in progress, no error).
  static const idle = MediaUploadState();
}
