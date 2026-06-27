# Pulse — Current Project State

**Last Updated:** 2026-06-27 16:23
**Session Focus:** Preview media wiring + deploy dart-define fix + E2E checklist + user verification

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (44 tests). Preview toggle deployed to Saturn. Media fields wired through.
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial. Saturn SDB connectivity ✅, user-verified E2E ✅.
- **Auth Service** (`auth_service_20260624`) — **Paused.** Phases 1-3 ✅, Phase 4 consumer wiring waiting on Marketplace.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E ✅. Deployed.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed.

## ✅ Recently Completed

- **2026-06-27 16:23** — **Media E2E checklist + user verification.** Created 45-scenario E2E testing checklist at `conductor/docs/media-manager-e2e-checklist.md`. User confirmed media upload, selection, removal, and preview rendering all work on Saturn. Layout is crude but functional — polish deferred to EstablishmentPage grill session.
- **2026-06-27 14:17** — **Preview media wiring.** Added `CoverLayoutMode` enum + 4 media fields (`logoUrl`, `coverUrl`, `galleryUrls`, `coverLayoutMode`) to `EstablishmentData`. New `EstablishmentGallerySection` renders cover + gallery thumbnails. Logo avatar in `EstablishmentInfoBar`. BP `_buildPreviewData()` passes media from edit form. 22 model + 22 widget = 44 tests green.
- **2026-06-27 14:17** — **Deploy script dart-define fix.** Root cause: `deploy-to-saturn.sh` ran `flutter build web --release` without `--dart-define` flags. Added `DART_DEFINES` associative array to the script. `BP_PORTAL_PASS=test-portal-pass` now encoded for portal builds. AGENTS.md updated with "No Ad-Hoc Commands, No Questions" deployment rules. Redeployed — hash match ✅, smoke test ✅.
- **2026-06-27 13:42** — **MediaPickerWidget wired into establishment edit.** New "Bilder" scrollspy section with cover layout mode selector, cover/gallery/logo pickers. 172 tests green. Deployed to Saturn.
- **2026-06-27 13:42** — **Deploy pipeline fixed.** Created `scripts/deploy-to-saturn.sh` with hardcoded canonical Caddy paths, served-file hash verification, and integrated smoke test.
- **2026-06-27 05:32** — **Post-deploy smoke test.** Built `scripts/post-deploy-smoke.sh`. Verified live against Saturn. Wired into deploy gate.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- ✅ ~~**No post-deploy verification.**~~ Resolved.
- ✅ ~~**Deploy path confusion.**~~ Resolved — `deploy-to-saturn.sh` with hash verification.
- ✅ ~~**Deploy missing dart-defines.**~~ Resolved — `DART_DEFINES` map in deploy script + AGENTS.md rules.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty.

## 🧠 Session Memory

### Session 2026-06-27 16:23 — E2E Checklist + User Verification
- Created `conductor/docs/media-manager-e2e-checklist.md` — 45 scenarios across 8 areas (upload, gallery, detail modal, picker, establishment edit, preview, delete, edge cases)
- User tested on Saturn: upload ✅, selection ✅, removal ✅, preview rendering ✅
- User confirmed: "media works, layout is crude but shows images" — polish deferred to EstablishmentPage grill
- Deploy dart-define fix committed and deployed — AGENTS.md permanently updated with deployment rules

### Session 2026-06-27 14:17 — Preview Media Wiring + Deploy Dart-Define Fix
- **Preview media wiring (Task 5 from prior session):**
  - Added `CoverLayoutMode` enum (`bento`/`showcase`/`spotlight`) with `fromString` parser to `establishment_data.dart`
  - Added 4 fields to `EstablishmentData`: `logoUrl`, `coverUrl`, `galleryUrls`, `coverLayoutMode`
  - Added `hasMedia` getter, updated `copyWith()`, `==`, `hashCode`
  - New `EstablishmentGallerySection` widget: cover image (220px) + gallery thumbnail row (80px horizontal scroll)
  - `EstablishmentInfoBar`: `CircleAvatar` with `NetworkImage` when `logoUrl` set, business type icon fallback when null
  - `EstablishmentPage`: conditional — `hasMedia` → gallery section, else → placeholder
  - BP `_buildPreviewData()` passes `logoUrl`, `coverUrl`, `galleryUrls`, `coverLayoutMode` from form state
  - Tests: 22 model + 22 widget = 44 green (up from 27)
  - **Deferred:** Bento/Showcase/Spotlight distinct layouts — all render same simple layout for now. Polish in EstablishmentPage grill.
- **Deploy dart-define fix:**
  - Root cause: `deploy-to-saturn.sh` line 74 ran bare `flutter build web --release` without `--dart-define` flags → `BP_PORTAL_PASS` empty in deployed app → auth fails
  - Fix: Added `DART_DEFINES` associative array to deploy script. Portal entry: `--dart-define=BP_PORTAL_PASS=test-portal-pass`
  - AGENTS.md: New "Deployment: No Ad-Hoc Commands, No Questions" section — explicitly bans ad-hoc build commands, says dart-define values live in the script, never ask user
  - Redeployed portal: build ✅, rsync ✅, hash match ✅, smoke test ✅

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

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🔴 **EstablishmentPage UI polish grill** — re-grill to implement bento/showcase/spotlight distinct layouts. User explicitly wants this as next session focus.
2. 🟡 **E2E checklist** — user is working through 45 scenarios gradually. May surface bugs.
3. 🟡 **Marketplace tests** — `apps/marketplace/test/` is empty.
4. 🟡 **BP Establishment Preview Phase 4** — integration test for preview toggle.
5. 🟢 **Logo:** User is working on a logo — swap when ready.
