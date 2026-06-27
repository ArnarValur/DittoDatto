# Pulse — Current Project State

**Last Updated:** 2026-06-27 13:42
**Session Focus:** Wire MediaPickerWidget into establishment edit + fix deploy pipeline

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (27 tests). Preview toggle deployed to Saturn.
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial. Saturn SDB connectivity ✅, user-verified E2E ✅.
- **Auth Service** (`auth_service_20260624`) — **Paused.** Phases 1-3 ✅, Phase 4 consumer wiring waiting on Marketplace.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E ✅. Deployed.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed.

## ✅ Recently Completed

- **2026-06-27 13:42** — **MediaPickerWidget wired into establishment edit.** New "Bilder" scrollspy section with cover layout mode selector (Bento/Showcase/Spotlight), cover image picker, gallery picker, logo picker. Establishment model extended with `logoUrl`, `coverUrl`, `galleryUrls`, `coverLayoutMode`. Save/load with URL-to-MediaItem resolution. 172 tests green (72 BP widget + 100 media_manager). Deployed to Saturn.
- **2026-06-27 13:42** — **Deploy pipeline fixed.** Created `scripts/deploy-to-saturn.sh` with hardcoded canonical Caddy paths, served-file hash verification, and integrated smoke test. AGENTS.md updated to ban raw rsync. Stale decoy directory removed from Saturn.
- **2026-06-27 05:32** — **Post-deploy smoke test.** Built `scripts/post-deploy-smoke.sh`. Verified live against Saturn (3/3 passed, Marketplace skipped). Wired into deploy gate as step 5. Blocker resolved.
- **2026-06-27 05:21** — **Media Gallery V2: Category Rows Layout.** Redesigned gallery from filter-chip grid to Netflix-style category rows. 235 tests green. Deployed.
- **2026-06-27 04:53** — **Media Manager: Test Coverage + CORS + Merge.** 100 package + 63 BP integration tests. CORS fix. Merged to `develop`.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- ✅ ~~**No post-deploy verification.**~~ Resolved.
- ✅ ~~**Deploy path confusion.**~~ Resolved — `deploy-to-saturn.sh` with hash verification.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty.

## 🧠 Session Memory

### Session 2026-06-27 13:42 — MediaPicker Integration + Deploy Fix
- **MediaPickerWidget wired into establishment edit:**
  - New `_BilderSection` scrollspy section (between Generelt and Lokasjon)
  - Cover layout mode selector: Bento Grid / Showcase / Spotlight (visual cards)
  - 3 pickers: Cover (single), Gallery (multi), Logo (single)
  - Establishment model: added `logoUrl`, `coverUrl`, `galleryUrls`, `coverLayoutMode`
  - `_resolveMediaSelections()` maps saved URLs → MediaItem objects on load
  - Save flow persists to `images.logo/cover/gallery` + `cover_layout_mode`
  - Tests: 72/72 BP widget, 100/100 media_manager, 63/63 integration — all green
  - Deployed to Saturn, user verified Bilder section visible
- **Deploy pipeline root cause found and fixed:**
  - Bug: raw rsync deployed to `/home/arnar/DittoDatto/apps/web/business-portal/` but Caddy serves from `/srv/dittodatto/business-portal/web/`. Different paths → stale code served indefinitely.
  - Fix: `scripts/deploy-to-saturn.sh` encodes canonical Caddy mount paths, does hash verification (local build vs curl-served file), runs smoke test.
  - AGENTS.md step 4 now requires the deploy script; raw rsync banned.
  - Stale decoy dir `/home/arnar/DittoDatto/apps/web/` removed from Saturn.
- **Polish items for next session:** Missing icon in Bilder scrollspy nav, preview media support (Task 5).

### Session 2026-06-27 05:32 — Post-Deploy Smoke Test
- **Built:** `scripts/post-deploy-smoke.sh` — curls Admin Panel (:8002), BP (:8003), Marketplace (:8004, auto-skips), Hub health (:8001).
- **Tested live:** 3/3 passed against Saturn. Marketplace correctly skipped (not deployed).
- **Deploy gate updated:** AGENTS.md step 5 now runs smoke test after rsync. Step 6 is test-db-down.
- **Blocker resolved:** "No post-deploy verification" cleared from pulse.

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🟡 **Polish Bilder section** — fix missing icon in scrollspy nav, refine layout.
2. 🟡 **Preview media support (Task 5)** — add media fields to `EstablishmentData` in `establishment_ui` package.
3. 🟡 **Marketplace tests** — `apps/marketplace/test/` is empty.
4. 🟡 **BP Establishment Preview Phase 4** — integration test for preview toggle.
5. 🟢 **Logo:** User is working on a logo — swap when ready.
