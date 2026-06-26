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

## Phase 2 — Gallery Page Widget

- [x] Task: Extract `MediaGalleryPage` to package
    - [x] Write widget tests for gallery rendering (empty state, grid, filters, upload progress)
    - [x] Refactor 802-line monolith into composable sub-widgets: `MediaFilterBar`, `MediaGrid`, `MediaGridTile`, etc.
    - [x] Gallery takes data + callbacks as constructor params (not hardcoded providers)
    - [x] Verify responsive grid behavior (2/3/4 columns)
- [x] Task: Extract support widgets (upload progress bar, error banner, empty states, loading skeleton)
    - [x] Write widget tests for each support widget
    - [x] Move to `lib/src/widgets/` with public exports

## Phase 3 — Inline Picker + Modal

- [x] Task: Build `MediaPickerWidget`
    - [x] Write widget tests for single-select and multi-select modes
    - [x] Implement inline widget: thumbnail grid of current selection + "Velg bilde" / "Endre" button
    - [x] Support `maxSelection` parameter (1 = single image display, N = thumbnail row)
    - [x] Support `defaultCategory` parameter for category pre-filtering
    - [x] Support `onChanged` callback returning selected `MediaItem`(s)
- [x] Task: Build `MediaPickerModal`
    - [x] Write widget tests for modal (opens, shows grid, select/deselect, upload, confirm)
    - [x] Implement modal dialog showing company media library
    - [x] Category filter bar (default to `defaultCategory` if provided)
    - [x] Selection mode: tap to select/deselect, selection indicator overlay
    - [x] "Last opp" button within modal to upload + auto-select
    - [x] "Velg" confirm button returns selected items
    - [x] Respect `maxSelection` — disable further selection when limit reached

## Phase 4 — BP Integration + Verification

- [ ] Task: Wire BP to import from `packages/media_manager/`
    - [ ] Add `media_manager` dependency to BP `pubspec.yaml`
    - [ ] Replace BP's `features/media/` with thin wrappers importing from package
    - [ ] Wire `FirebaseMediaStorage` as the concrete backend in BP's provider tree
    - [ ] Verify `/media` route renders the package's `MediaGalleryPage`
- [ ] Task: Run full test suite
    - [x] Run package tests: `cd packages/media_manager && flutter test` — 37 green
    - [ ] Run BP integration tests: `cd apps/business-portal && flutter test --tags integration`
    - [ ] Run BP widget tests: `cd apps/business-portal && flutter test --exclude-tags integration`
    - [ ] All existing 118 BP tests must pass
    - [x] Package must have ≥20 new tests — 37 achieved
- [ ] Task: Static analysis + cleanup
    - [x] Run `dart analyze` on package — 0 issues
    - [ ] Run `dart analyze` on BP — 0 issues
    - [ ] Remove dead code from BP's `features/media/` (files fully replaced by package imports)
    - [ ] Verify no circular dependencies between packages
