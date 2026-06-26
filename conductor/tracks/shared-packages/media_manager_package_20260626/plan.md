# Plan: Media Manager Shared Package

## Phase 1 — Package Scaffold + Data Layer

- [ ] Task: Create `packages/media_manager/` with `pubspec.yaml`, library exports, analysis_options
    - [ ] Write pubspec with dependencies: `ditto_auth`, `ditto_design`, `file_picker`, `flutter_riverpod`
    - [ ] Create `lib/media_manager.dart` barrel export
    - [ ] Create `lib/src/` directory structure (models/, repository/, storage/, widgets/)
- [ ] Task: Extract and refine `MediaItem` model + `MediaCategory` enum
    - [ ] Write tests for model serialization (fromJson/toJson), validation, category enum
    - [ ] Move `MediaItem`, `MediaCategory`, validation logic from BP to package
    - [ ] Ensure `NONE` handling for optional fields
- [ ] Task: Create `MediaStorageBackend` abstract interface
    - [ ] Write tests for the interface contract (upload returns result, delete by path)
    - [ ] Define abstract class with `upload()`, `delete()`, `getUrl()` methods
    - [ ] Move `FirebaseMediaStorage` to package as the concrete implementation
    - [ ] Move `StorageUploadResult` to package
- [ ] Task: Create `MediaRepository` with `TenantConnection`
    - [ ] Write integration tests for fetch, create, delete against real SurrealDB
    - [ ] Implement repository methods (fetchAll, fetchByCategory, create, delete)
    - [ ] Move SurrealDB query logic from `MediaNotifier._parseRows` and related methods
- [ ] Task: Extract `MediaUploadState` and upload orchestration
    - [ ] Write tests for upload state transitions (idle → uploading → complete/error)
    - [ ] Move `MediaUploadState`, `MediaUploadStateNotifier` to package
    - [ ] Create `MediaUploadOrchestrator` that coordinates repository + storage backend

## Phase 2 — Gallery Page Widget

- [ ] Task: Extract `MediaGalleryPage` to package
    - [ ] Write widget tests for gallery rendering (empty state, grid, filters, upload progress)
    - [ ] Refactor 802-line monolith into composable sub-widgets: `_FilterBar` → `MediaFilterBar`, `_MediaGrid` → `MediaGrid`, `_MediaGridTile` → `MediaGridTile`, etc.
    - [ ] Gallery takes `MediaRepository` + `MediaStorageBackend` as constructor params (not hardcoded providers)
    - [ ] Verify responsive grid behavior (2/3/4 columns)
- [ ] Task: Extract support widgets (upload progress bar, error banner, empty states, loading skeleton)
    - [ ] Write widget tests for each support widget
    - [ ] Move to `lib/src/widgets/` with public exports

## Phase 3 — Inline Picker + Modal

- [ ] Task: Build `MediaPickerWidget`
    - [ ] Write widget tests for single-select and multi-select modes
    - [ ] Implement inline widget: thumbnail grid of current selection + "Velg bilde" / "Endre" button
    - [ ] Support `maxSelection` parameter (1 = single image display, N = thumbnail row)
    - [ ] Support `defaultCategory` parameter for category pre-filtering
    - [ ] Support `onChanged` callback returning selected `MediaItem`(s)
- [ ] Task: Build `MediaPickerModal`
    - [ ] Write widget tests for modal (opens, shows grid, select/deselect, upload, confirm)
    - [ ] Implement modal dialog showing company media library
    - [ ] Category filter bar (default to `defaultCategory` if provided)
    - [ ] Selection mode: tap to select/deselect, selection indicator overlay
    - [ ] "Last opp" button within modal to upload + auto-select
    - [ ] "Velg" confirm button returns selected items
    - [ ] Respect `maxSelection` — disable further selection when limit reached

## Phase 4 — BP Integration + Verification

- [ ] Task: Wire BP to import from `packages/media_manager/`
    - [ ] Add `media_manager` dependency to BP `pubspec.yaml`
    - [ ] Replace BP's `features/media/` with thin wrappers importing from package
    - [ ] Wire `FirebaseMediaStorage` as the concrete backend in BP's provider tree
    - [ ] Verify `/media` route renders the package's `MediaGalleryPage`
- [ ] Task: Run full test suite
    - [ ] Run package tests: `cd packages/media_manager && flutter test`
    - [ ] Run BP integration tests: `cd apps/business-portal && flutter test --tags integration`
    - [ ] Run BP widget tests: `cd apps/business-portal && flutter test --exclude-tags integration`
    - [ ] All existing 118 BP tests must pass
    - [ ] Package must have ≥20 new tests
- [ ] Task: Static analysis + cleanup
    - [ ] Run `dart analyze` on package and BP — 0 issues
    - [ ] Remove dead code from BP's `features/media/` (files fully replaced by package imports)
    - [ ] Verify no circular dependencies between packages
