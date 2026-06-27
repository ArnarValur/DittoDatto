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
    - [x] Define abstract class with `upload()`, `delete()` methods
    - [x] Move `StorageUploadResult` to package
- [x] Task: Create `MediaRepository` with `TenantConnection`
    - [x] Implement repository methods (fetchAll, fetchByCategory, fetchByEstablishment, create, delete)
    - [x] Move SurrealDB query logic including `_parseRows`
- [x] Task: Extract `MediaUploadState` and upload orchestration
    - [x] Write tests for upload state transitions (idle → uploading → complete/error)
    - [x] Move `MediaUploadState` to package with copyWith
