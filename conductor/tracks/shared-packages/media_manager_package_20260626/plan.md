# Plan: Media Manager Shared Package

## Phase 1 — Package Scaffold + Data Layer

- [x] Task: Create `packages/media_manager/` with `pubspec.yaml`, library exports, analysis_options
    - [x] Write pubspec with dependencies: `ditto_auth`, `ditto_design`, `file_picker`, `flutter_riverpod`
    - [x] Create `lib/media_manager.dart` barrel export
    - [x] Create `lib/src/` directory structure (models/, repository/, storage/, widgets/)
- [x] Task: Extract and refine `MediaItem` model + `MediaCategory` enum
    - [x] Write tests for model serialization (fromJson/toJson), validation, category enum
    - [x] Move `MediaItem`, `MediaCategory`, validation logic from BP to package
    - [x] Ensure `NONE` handling for optional fields
- [x] Task: Create `MediaStorageBackend` abstract interface
    - [x] Define abstract class with `upload()`, `delete()`, `clearCache()`, `getThumbnailUrl()` methods
    - [x] Move `StorageUploadResult` to package
- [x] Task: Create `MediaRepository` with `TenantConnection`
    - [x] Implement repository methods (fetchAll, fetchByCategory, fetchByEstablishment, create, delete)
    - [x] Move SurrealDB query logic including `_parseRows`
- [x] Task: Extract `MediaUploadState` and upload orchestration
    - [x] Write tests for upload state transitions (idle → uploading → complete/error)
    - [x] Move `MediaUploadState` to package with copyWith

## Phase 2 — Gallery Page Widget

- [x] Task: Create `MediaGalleryPage` stateless-from-Riverpod widget
    - [x] Accept data + callbacks (no Riverpod dependency at widget level)
    - [x] Include filter bar, grid, upload progress, error/empty states
- [x] Task: Create supporting widgets
    - [x] `MediaFilterBar` — search, category chips, tag chips
    - [x] `MediaGridTile` — image thumbnail with hover overlay, category badge, delete
    - [x] `MediaUploadProgressBar`, `MediaErrorBanner`, `MediaEmptyState`, etc.

## Phase 3 — Inline Picker + Modal

- [x] Task: Create `MediaPickerWidget` (inline, for form fields)
    - [x] Shows selected images, "Velg bilde" / "Endre" button
    - [x] Opens `MediaPickerModal` on tap
- [x] Task: Create `MediaPickerModal` (full-screen selection dialog)
    - [x] Category filter, grid selection (single/multi), upload from modal
- [x] Task: SwanFlutter-inspired patterns
    - [x] `MediaError` + `MediaErrorCode` error taxonomy
    - [x] `MediaCategory.fromExtension()` auto-suggestion
    - [x] `MediaStorageBackend.clearCache()` + `getThumbnailUrl()` lifecycle methods

## Phase 4 — BP Integration + Verification

- [x] Task: Add `media_manager` dependency to BP `pubspec.yaml`
- [x] Task: Rewrite `media_providers.dart` — Riverpod glue using package types
    - [x] Keep `FirebaseMediaStorage` as BP-specific concrete storage backend
    - [x] Use `MediaRepository` from package (no inline SurrealDB queries)
    - [x] Use `MediaUploadState`, `MediaItem`, `MediaCategory` from package
- [x] Task: Replace `media_gallery_screen.dart` with thin `ConsumerWidget` bridge
    - [x] Delegates all rendering to package `MediaGalleryPage`
    - [x] ~800 lines → ~50 lines
- [x] Task: Delete `media_model.dart` (fully replaced by package)
- [x] Task: Update integration test imports to use `package:media_manager`
- [x] Task: Static analysis — 0 errors, 0 warnings
- [x] Task: All tests pass — 51 package + 72 BP widget = 123 green
