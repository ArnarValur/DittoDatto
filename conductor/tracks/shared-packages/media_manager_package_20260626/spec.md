# Spec: Media Manager Shared Package

## Overview

The Business Portal's media management code (~1,288 lines across 3 files) is tightly coupled to BP. Per ADR-0021, media management needs to be a shared Dart package at `packages/media_manager/` — reusable by BP, Admin Panel, and Marketplace. This track extracts the existing code, refactors it into a clean architecture (repository + storage abstraction + reusable widgets), and wires BP to import from the package.

## Functional Requirements

### Package Structure (`packages/media_manager/`)

1. **Data Model** — `MediaItem`, `MediaCategory` (7 categories with Norwegian labels), validation logic (MIME types, max 10MB).
2. **Repository** — `MediaRepository` class with fetch, create, delete methods. Takes a `TenantConnection` (from `ditto_auth`). Owns all SurrealDB query patterns for the `media` table.
3. **Storage Abstraction** — `MediaStorageBackend` abstract interface defining `upload()`, `delete()`, `getUrl()`. Firebase implementation (`FirebaseMediaStorage`) stays as the concrete impl for now.
4. **MediaGalleryPage** — Full-page standalone gallery widget (responsive grid, upload, delete, search, category filter, tag filter). Currently 802 lines — refactored into composable sub-widgets.
5. **MediaPickerWidget** — NEW inline form widget. Shows current selection as thumbnails + "Velg bilde" button. Takes `maxSelection` (1 for logo/cover, unlimited for gallery) and optional `defaultCategory` for auto-filtering.
6. **MediaPickerModal** — NEW modal/dialog overlay opened by the picker widget. Shows the company's media library with select/multi-select + upload-from-within capability. Category-filtered by default (from `defaultCategory`), user can browse all.
7. **Upload State** — `MediaUploadState` and progress tracking, re-exported for consuming apps.

### BP Integration

8. BP's `/media` route becomes a thin wrapper around the package's `MediaGalleryPage`.
9. BP provides `FirebaseMediaStorage` as the concrete storage backend via Riverpod.
10. BP's existing media integration tests continue to pass against the package's repository.

## Non-Functional Requirements

- Package has zero Flutter app dependencies (no BP imports, no firebase_core — only firebase_storage via the abstract interface).
- `MediaStorageBackend` is the only class that knows about the storage provider. Swapping to European S3-compatible storage means writing one new class.
- Package tests run standalone (`cd packages/media_manager && flutter test`).

## Acceptance Criteria

1. `packages/media_manager/` exists with its own `pubspec.yaml`, exports, and tests.
2. `MediaPickerWidget` renders inline with configurable `maxSelection` and `defaultCategory`.
3. `MediaPickerModal` opens from the picker, shows media library, supports select + upload.
4. `MediaGalleryPage` renders identically to current BP gallery (responsive grid, filters, upload progress).
5. `MediaStorageBackend` is an abstract class; `FirebaseMediaStorage` implements it.
6. `MediaRepository` handles all SurrealDB CRUD for media (no raw queries in consuming apps).
7. BP compiles and all existing 118 tests pass (46 integration + 72 widget).
8. Package has its own widget + unit tests (target: ≥20 tests covering picker, modal, repository, model).

## Edge Cases & Constraints

- Firebase Storage is wrapped in try-catch on Saturn (no Firebase available). The package must gracefully handle storage backend failures without crashing the app.
- `file_picker` with `withData: true` loads entire files into memory — max 10MB validation must happen before upload.
- SurrealDB returns `NONE` not `NULL` for optional fields — repository must handle this.
- Category badge and Norwegian labels must render correctly across all consuming apps (labels live in `MediaCategory` enum, not in BP).
- **Firebase Storage path isolation:** The same bucket (`cs-poc-4zmxog23jmy4io0d4yx6rj0.firebasestorage.app`) is shared with the live Nuxt media manager. Our Flutter path is `companies/{slug}/media/{file}`. **Never write outside the `/media/` subfolder.** Never list, modify, or delete files in sibling folders. The Nuxt app's existing data is untouchable.

## Dependencies

- `ditto_auth` — for `TenantConnection` type used by `MediaRepository`.
- `ditto_design` — for spacing/border radius constants used by widgets.
- `file_picker` — for file selection dialog.
- `firebase_storage` — only in the concrete `FirebaseMediaStorage` impl (dev dependency or optional).

## Out of Scope

- Wiring `MediaPickerWidget` into establishment edit view (separate task/track).
- Admin Panel or Marketplace integration (separate future tracks).
- Drag-and-drop upload zone (`super_drag_and_drop` — addable later).
- Image cropping before upload (`croppy` — addable later).
- European storage backend swap (ADR-0021 defers this).
- Video support (images only for now).
