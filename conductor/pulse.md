# Pulse — Current Project State

**Last Updated:** 2026-07-01 12:25
**Session Focus:** BP bugfixes (media picker state + Kartverket autocomplete) + Discovery Phase 5 E2E debugging

## 🚀 Active Tracks

- **Discovery Layer** (`discovery_layer_20260630`) — **Phases 1-2+4 complete. Phase 5 E2E in progress.** User recreated House of the North under Dream On AS. Card shows on Marketplace home but: (1) images missing on card (user didn't save after adding — not a bug), (2) **detail page hangs on open** — `fn::get_establishment_detail()` via `marketplace_reader` VIEWER not returning. Open bug for next session.
- **Booking Flow UI** (`booking_flow_ui_20260630`) — **Phases 1–4 complete. Deployed to phone.** All 5 steps built. 18 unit tests. Remaining: visual polish, ME availability wiring.
- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests, `pendingFavorite` login-return flow, merge to develop.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-07-01 12:15** — **BP bugfixes deployed to Saturn.** (1) Media picker state refresh: `onUpload` now returns `List<MediaItem>`, modal merges locally. (2) Kartverket autocomplete wired into "Ny virksomhet" creation dialog. (3) Deleted 2 dead integration test files (old bespoke auth). 72/72 widget + 54/54 integration tests green. Deploy hash verified + smoke passed.
- **2026-07-01 11:56** — **Auth reconciliation complete.** Switched marketplace discovery from `bp_portal` to `marketplace_reader` NS VIEWER. Deleted 2 dead BP auth files (–413 lines). Updated deploy script dart-defines. Graduated auth service track.
- **2026-07-01 11:24** — **Auth Service track graduated.** Research agent confirmed all Phase 4 deliverables complete.
- **2026-06-30 23:40** — **Discovery Layer Phases 2 + 4 complete.** Built Marketplace Home. Discovered SurrealDB NS-level VIEWER pattern. Built `fn::get_establishment_detail()`. Deployed to Galaxy S21.
- **2026-06-30 22:06** — **Discovery Layer Phase 1 complete + deployed.** Created `packages/discovery_service/`. Wired BP publish sync.

> 📦 Full history: `conductor/pulse-archive/2026-07-01.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **Marketplace detail page hangs** — `EstablishmentDetailService` connects as `marketplace_reader` (NS VIEWER) → `USE company_dreamonas` → `fn::get_establishment_detail()`. Spinner never resolves. Likely cause: VIEWER role can't execute functions, or company DB name mismatch. **Next session must look up the SurrealDB root password on Saturn** (it was set by Hermes in a prior session, stored somewhere on Saturn — NOT a user-known value).

## 🧠 Session Memory

### Session 2026-07-01 12:25 — BP Bugfixes + Discovery Phase 5 E2E Debugging

- **Media picker state refresh bug (FIXED):**
  - Root cause: `MediaPickerModal` is a dialog overlay. It receives a snapshot of items at open-time and doesn't see Riverpod state updates from the parent.
  - Fix: Changed `onUpload` to return `List<MediaItem>`. `MediaPickerModal` merges new items into local `_localItems` immediately after upload.
  - 100/100 `media_manager` + 72/72 BP widget tests green.
  - Commit: `72cdaa8`

- **Kartverket autocomplete in creation dialog (FIXED):**
  - "Ny virksomhet" dialog was plain text fields. Now queries `ws.geonorge.no` when typing ≥3 chars and auto-fills street/city/zip on selection.
  - Reuses `KartverketService` from `establishment_ui` (already a BP dep).
  - 72/72 BP widget tests green.
  - Commit: `808ec6d`

- **Dead test cleanup:**
  - Integration tests for deleted `SurrealAuthService` and `SurrealConnection` were still in `test/integration/`. Caused 3 load failures. Deleted.
  - Commit: `160b284`

- **BP deployed to Saturn:**
  - 54/54 integration tests green (post-cleanup).
  - Build + rsync + hash verified + smoke passed.
  - Live at `http://dittodatto:8003`.

- **Discovery Phase 5 E2E (user-driven):**
  - User published House of the North under Dream On AS.
  - Card appears on Marketplace home — ✅
  - Card images missing — user hadn't saved after adding images (not a bug, just workflow).
  - **Detail page hangs on tap** — open bug. Investigated: `marketplace_reader` NS VIEWER connects, switches to company DB, calls `fn::get_establishment_detail()`. Auth failed in CLI testing. Root cause unclear — need production DB root password to inspect further.
  - **Pattern noted:** Agent keeps asking user for DB root password that was created and stored by the agent itself in a prior session. Agent must find it autonomously.

- **Edited files this session:**
  - `packages/media_manager/lib/src/widgets/media_picker_modal.dart` — `onUpload` return type
  - `packages/media_manager/lib/src/widgets/media_picker_widget.dart` — `onUpload` signature
  - `apps/business-portal/lib/features/establishments/establishment_edit_view.dart` — `handleUpload` return
  - `packages/media_manager/test/widgets_test.dart` — test helper signature
  - `apps/business-portal/lib/features/establishments/create_establishment_dialog.dart` — Kartverket autocomplete
  - Deleted: `test/integration/surreal_auth_service_test.dart`, `test/integration/surreal_connection_test.dart`

### Session 2026-07-01 11:56 — Auth Reconciliation + Discovery Phase 5 E2E

- Auth reconciliation completed (see Recently Completed above).
- Discovery Phase 5 E2E started by user — recreating establishments under correct companies.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-07-01.md`

## 📋 Next Session Suggestions

1. 🔴 **Debug detail page hang** — Find Saturn's SurrealDB root password (agent-created), verify `marketplace_reader` VIEWER can call `fn::get_establishment_detail()`, check company DB slug. Fix the hang.
2. 🔴 **Discovery Phase 5 completion** — user re-saves establishment with images, verifies card images, tests detail page (after fix).
3. 🟡 **BP delete establishment** — add delete action to establishment list/edit.
4. 🟡 **MercuryEngine Availability Wiring** — Replace mock time slots in booking flow.
5. 🟡 **Favorites Toggle polish** — Widget tests, `pendingFavorite` flow, merge.
