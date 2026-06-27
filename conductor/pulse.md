# Pulse — Current Project State

**Last Updated:** 2026-06-27 04:03
**Session Focus:** Firebase Storage fix on Saturn + Media Manager deploy finalization

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (27 tests). Preview toggle deployed to Saturn.
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial. Saturn SDB connectivity ✅, user-verified E2E ✅.
- **Auth Service** (`auth_service_20260624`) — **In-progress.** Phases 1-3 ✅, Phase 4 consumer wiring ✅.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E ✅. Deployed.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed.

## ✅ Recently Completed

- **2026-06-27 04:03** — **Firebase Storage fixed on Saturn.** Root cause: stale web plugin registrant missing `FirebaseCoreWeb`/`FirebaseStorageWeb`. `flutter clean` regenerated it. Also added Firebase JS SDK compat scripts to `web/index.html`. User confirmed login works on Saturn.
- **2026-06-27 03:43** — **Media Manager Package: Track Complete.** Phase 4 wired BP to `packages/media_manager/`. 169 tests green. Deployed to Saturn.
- **2026-06-27 03:09** — **Media Manager: SwanFlutter patterns incorporated.** Error taxonomy, `fromExtension()`, cache management. 14 new tests.
- **2026-06-26 15:06** — **Media Manager Package (Phases 1-3):** Grilled design, ADR-0021, scaffolded package. 37 tests.
- **2026-06-26 00:22** — **BP Media Manager Saturn Deploy:** 118 tests, rsync `--checksum`, Firebase try-catch.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🟡 **No post-deploy verification.** Deploy gate tests against local DB, not deployed product.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty.

## 🧠 Session Memory

### Session 2026-06-27 04:03 — Firebase Storage Fix on Saturn
- **Continued from 2026-06-27 03:43 checkpoint.**
- User confirmed category picker dialog renders on Saturn (shared package UI works).
- **Firebase investigation:**
  1. Removed try-catch → white screen (Uncaught Error in minified JS).
  2. Re-added try-catch with `firebaseInitialized` flag → app loads but uploads show Norwegian error.
  3. Console error: `PlatformException(channel-error, Unable to establish connection on channel: "...FirebaseCoreHostApi.initializeCore")`.
  4. Added Firebase JS SDK compat scripts to `web/index.html` → still same error.
  5. **Root cause found:** Stale `.dart_tool` web plugin registrant — `FirebaseCoreWeb` and `FirebaseStorageWeb` were NOT registered. Only `FlutterSecureStorageWeb` was present.
  6. `flutter clean && flutter pub get && flutter build web --release` → regenerated registrant with all 4 web plugins.
- **Final state:** Firebase inits properly on Saturn. User confirmed login works. Try-catch removed, `firebaseInitialized` guard removed.
- **Key learning:** After adding Firebase dependencies to a monorepo workspace, `flutter clean` is required to regenerate the web plugin registrant. Stale registrants persist across incremental builds.

### Session 2026-06-27 03:43 — Media Manager: Phase 4 BP Wiring + Deploy
- Completed Phase 4. Rewrote `media_providers.dart`, replaced `media_gallery_screen.dart` (800→50 lines), deleted `media_model.dart`. 169 tests green. Deployed to Saturn.

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🔴 **Media Manager: unit + integration + E2E tests with polish** — User's stated next session goal.
2. 🟡 **Test actual media upload E2E on Saturn** — Firebase inits now; verify upload → Storage → SurrealDB metadata round-trip.
3. 🟡 **Wire picker into establishment edit** — Use `MediaPickerWidget` for logo/cover/gallery fields.
4. 🟡 **Merge `track/bp-media-manager` to develop** — Branch is stable, deployed, track complete.
5. 🟢 **Logo:** User is working on a logo — swap when ready.
