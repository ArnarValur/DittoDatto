# Pulse — Current Project State

**Last Updated:** 2026-06-27 03:43
**Session Focus:** Media Manager — Phase 4 BP wiring + track completion + deploy

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (27 tests). Preview toggle deployed to Saturn.
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial. Saturn SDB connectivity ✅, user-verified E2E ✅.
- **Auth Service** (`auth_service_20260624`) — **In-progress.** Phases 1-3 ✅, Phase 4 consumer wiring ✅.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E ✅. Deployed.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed.

## ✅ Recently Completed

- **2026-06-27 03:43** — **Media Manager Package: Track Complete.** Phase 4 wired BP to `packages/media_manager/`. Rewrote `media_providers.dart` (Riverpod glue using `MediaRepository`), replaced `media_gallery_screen.dart` (800→50 lines), deleted `media_model.dart`. 169 tests green (51 pkg + 72 BP widget + 46 BP integration). Deployed to Saturn. Net: +115 / −1,057 lines.
- **2026-06-27 03:09** — **Media Manager: SwanFlutter patterns incorporated.** Error taxonomy (`MediaError` + `MediaErrorCode`), `fromExtension()` on `MediaCategory`, `clearCache()` + `getThumbnailUrl()` on `MediaStorageBackend`. 14 new tests.
- **2026-06-26 15:06** — **Media Manager Package (Phases 1-3):** Grilled design, ADR-0021, scaffolded package. 37 tests.
- **2026-06-26 00:22** — **BP Media Manager Saturn Deploy:** 118 tests, rsync `--checksum`, Firebase try-catch.
- **2026-06-25 20:36** — **BP Establishment Preview:** `packages/establishment_ui/`. 130 tests. Deployed.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🟡 **Firebase Storage on Saturn.** `Firebase.initializeApp()` fails on Saturn — uploads silently disabled. Options: (a) authorize Saturn's domain in Firebase Console, (b) build non-Firebase `MediaStorageBackend` (MinIO/disk).
- 🟡 **No post-deploy verification.** Deploy gate tests against local DB, not deployed product.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty.

## 🧠 Session Memory

### Session 2026-06-27 03:43 — Media Manager: Phase 4 BP Wiring + Deploy
- **Continued from 2026-06-27 03:09 checkpoint.**
- Completed discovery of the delta between BP's `features/media/` and `packages/media_manager/`.
- **Phase 4 implementation:**
  1. Added `media_manager` path dependency to BP `pubspec.yaml`.
  2. Rewrote `media_providers.dart` — Riverpod glue using `MediaRepository` from package. `FirebaseMediaStorage` stays as BP-specific concrete storage backend.
  3. Replaced `media_gallery_screen.dart` (~800 lines → ~50 lines) — thin `ConsumerWidget` bridge to package's `MediaGalleryPage`.
  4. Deleted `media_model.dart` — fully replaced by package's `MediaItem`/`MediaCategory`.
  5. Updated integration test imports to use `package:media_manager/media_manager.dart`.
- **Static analysis:** 0 errors, 0 warnings (only pre-existing info lints in unrelated test).
- **Tests:** 51 package + 72 BP widget + 46 BP integration = 169 green.
- **Deploy gate:** test-db-up → integration tests → test-db-down → `flutter build web --release` → `rsync --checksum` → Caddy restart. All passed.
- **Saturn:** Deployed. User confirmed category picker dialog renders correctly from the shared package.
- **Firebase blocker identified:** `Firebase.initializeApp()` fails on Saturn — uploads won't work. Two options discussed: (a) add Saturn's domain to Firebase authorized domains, (b) build a non-Firebase storage backend.
- **Track closed:** `media_manager_package_20260626` marked complete in `tracks.md` and `metadata.json`.

### Session 2026-06-27 03:09 — Media Manager: SwanFlutter Patterns + Close
- Incorporated 3 SwanFlutter-inspired patterns. Package at 51 tests. Phase 4 deferred.

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🔴 **Fix Firebase Storage on Saturn** — Either authorize Saturn's domain in Firebase Console, or build a MinIO/disk-backed `MediaStorageBackend`. Then re-test uploads E2E.
2. 🟡 **Wire picker into establishment edit** — Use `MediaPickerWidget` for logo/cover/gallery fields.
3. 🟡 **Merge `track/bp-media-manager` to develop** — Branch is stable, deployed, track complete.
4. 🟡 **European sovereignty planning** — Research Norwegian/European hosting for object storage.
5. 🟢 **Logo:** User is working on a logo — swap when ready.
