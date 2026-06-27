# Pulse — Current Project State

**Last Updated:** 2026-06-27 04:53
**Session Focus:** Media Manager test coverage pass + CORS fix + merge to develop

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (27 tests). Preview toggle deployed to Saturn.
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial. Saturn SDB connectivity ✅, user-verified E2E ✅.
- **Auth Service** (`auth_service_20260624`) — **In-progress.** Phases 1-3 ✅, Phase 4 consumer wiring ✅.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E ✅. Deployed.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed.

## ✅ Recently Completed

- **2026-06-27 04:53** — **Media Manager: Test Coverage + CORS + Merge.** 100 package tests (storage backend, filter bar, grid tile, gallery page filtering, picker modal selection). 63 BP integration tests (MediaRepository via TenantConnection, MediaUploadStateNotifier). Firebase Storage CORS config applied for Saturn origin `http://dittodatto:8003`. `track/bp-media-manager` merged to `develop`.
- **2026-06-27 04:03** — **Firebase Storage fixed on Saturn.** Root cause: stale web plugin registrant missing `FirebaseCoreWeb`/`FirebaseStorageWeb`. `flutter clean` regenerated it.
- **2026-06-27 03:43** — **Media Manager Package: Track Complete.** Phase 4 wired BP to `packages/media_manager/`. 169 tests green. Deployed to Saturn.
- **2026-06-27 03:09** — **Media Manager: SwanFlutter patterns incorporated.** Error taxonomy, `fromExtension()`, cache management. 14 new tests.
- **2026-06-26 15:06** — **Media Manager Package (Phases 1-3):** Grilled design, ADR-0021, scaffolded package. 37 tests.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🟡 **No post-deploy verification.** Deploy gate tests against local DB, not deployed product.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty.

## 🧠 Session Memory

### Session 2026-06-27 04:53 — Media Manager Test Coverage + CORS + Merge
- **Test coverage pass (4 phases):**
  - Phase 1: `storage_backend_test.dart` — 16 tests (defaults, overrides, `_parseRows` parsing)
  - Phase 2: `filter_bar_test.dart` (8), `grid_tile_test.dart` (8), extended `widgets_test.dart` (+26) — gallery filtering, picker selection/search/confirm
  - Phase 3: `media_notifier_test.dart` (7) — Riverpod state machine. `media_crud_test.dart` (+9) — MediaRepository via TenantConnection against real SurrealDB
  - Phase 4: `dart analyze` clean, `dart fix --apply`
- **Final counts:** 100 package tests + 63 BP integration tests, all green
- **CORS fix:** Created `infra/firebase-storage-cors.json`. Installed `gcloud` SDK on Saturn. Applied CORS config. **Bug found:** original config used port 8883 (wrong), BP is on port 8003. Fixed and re-applied.
- **Merge:** `track/bp-media-manager` merged to `develop` (no-ff). Conflicts in `conductor/pulse.md` and `conductor/relay.md` resolved (kept track version).
- **Key learning:** BP on Saturn is port **8003** (Caddy Caddyfile at `/srv/saturn-docker/portal-caddy/Caddyfile`). Admin Panel is port **8002**.
- **User has uploaded visuals** — ready to work on next steps.

### Session 2026-06-27 04:03 — Firebase Storage Fix on Saturn
- Root cause: stale `.dart_tool` web plugin registrant. `flutter clean` regenerated it.
- Key learning: After adding Firebase deps to monorepo, `flutter clean` required to regenerate web plugin registrant.

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🔴 **Verify media upload + thumbnail display E2E on Saturn** — CORS is now fixed, user has uploaded visuals to verify.
2. 🟡 **Wire picker into establishment edit** — Use `MediaPickerWidget` for logo/cover/gallery fields.
3. 🟡 **Marketplace tests** — `apps/marketplace/test/` is empty.
4. 🟢 **Logo:** User is working on a logo — swap when ready.
