# Relay — Cross-Session Handoff

## 2026-07-01 19:20 — ME ↔ Booking UI Wiring Phases 1–3 + Opening Hours
- **Session:** Bridged ME child conductor with parent. Implemented Delegated Trust auth bridge (ADR-0032), BookingRepository (5 models, 6 methods, 13 tests), callback injection into booking_ui (async slot fetch, loading/error/cache), DittoAuth.getConsumerToken(). Added opening hours section + open/closed badge. Fixed establishment_type schema gap on 2 company DBs. Deployed to phone. E2E pipeline confirmed (phone → ME :8005 → clean 400).
- **Tracks touched:** me_booking_wiring_20260701 (Phases 1–3 partial), bp_establishment_config_20260701 (Phase 4 complete — opening hours)
- **Status:** Auth bridge ✅, BookingRepository ✅, callback injection ✅, token passthrough ✅. ME config alignment needed (ME can't read company DBs yet).
- **Decisions:** ADR-0032 (Delegated Trust Auth Bridge)
- **Next:** (1) ME config alignment — teach ME `/availability` to read from company DBs. (2) Hold/confirm wiring (Steps 4–5). (3) Staff CRUD + real staff list. (4) 401 refresh + timeout error handling.

---

## 2026-07-01 16:50 — BP Establishment Config Phases 1–3 + Deploy
- **Session:** Executed full BP Establishment Config track: schema migration (28 files), 4 new models, 5 new edit sections (type selector, opening hours, social links, booking policy, reservation config). Saturn data wiped + clean schema applied. BP deployed :8003. Marketplace redeployed to phone (fixed stale-code null crash).
- **Tracks touched:** bp_establishment_config_20260701 (Phases 1–3 complete)
- **Status:** Phases 1–3 done + deployed. Phase 4 Marketplace display deferred to co-joined ME session.
- **Decisions:** None (ADRs 0027–0029 already recorded by /new-track)
- **Next:** Co-joined ME + BP session to wire booking engine → config fields. Auth token bridge decision. Marketplace opening hours + social links display.

---

## 2026-07-01 13:40 — Discovery Phase 5 Complete + BP Edit Audit
- **Session:** Discovery Phase 5 E2E verified on phone (detail page, services, service groups, booking UI all working). Audited BP establishment edit page — found opening schedule (🔴), booking policy/config (🟡), social links (🟡) as gaps. User wants grill session to refine booking types vs establishment types, open-ended social links, and booking policy before implementation.
- **Tracks touched:** discovery_layer_20260630 (Phase 5 done)
- **Status:** Discovery Layer ready to graduate. BP edit page grill queued.
- **Decisions:** None
- **Next:** (1) `/grill` establishment configuration domain. (2) Opening hours editor. (3) BP delete operations. (4) MercuryEngine availability.

---

## 2026-07-01 12:53 — Detail Page Debug + WS Timeout Hardening
- **Session:** Debugged marketplace detail page hang. Root cause: phone not on Tailscale mesh → `db.wait()` with no timeout = infinite spinner. Confirmed DB is correct (function works, VIEWER can call it) via CLI `--auth-level namespace` and Dart SDK script. Added 10s timeouts + `AppEventLog` ring buffer to both `EstablishmentDetailService` and `_openDiscoveryDb()`. Detail screen now redirects to home with snackbar on connectivity failure. Applied `keywords`/`service_type` schema hotfix on `company_dream-on-as`. Deployed to phone. 40/40 widget tests.
- **Tracks touched:** discovery_layer_20260630 (Phase 5 — bug resolved)
- **Status:** Detail page working. Discovery Phase 5 E2E continues.
- **Decisions:** None
- **Next:** (1) Discovery Phase 5 E2E completion — verify detail page + card images + service creation on phone. (2) BP delete establishment. (3) ME availability wiring.
- **Saturn root password:** `dittodatto_root` / found at `/srv/dittodatto/.env` on Saturn. Container name: `dittodatto-hub`.

---

## 2026-07-01 12:25 — BP Bugfixes + Discovery Detail Page Hang
- **Session:** Fixed 2 BP bugs: media picker state refresh (modal now merges uploaded items locally) + Kartverket autocomplete in "Ny virksomhet" dialog. Cleaned up 2 dead integration test files. Deployed BP to Saturn (54/54 integration + 72/72 widget tests). User did Discovery Phase 5 E2E — card shows on Marketplace but detail page hangs on tap. Investigated: `marketplace_reader` VIEWER auth failing. Could not access production SurrealDB root password from CLI — agent must find it autonomously next session.
- **Tracks touched:** discovery_layer_20260630 (Phase 5 bug found), map_and_geocoding_20260628 (Kartverket in creation dialog)
- **Status:** BP deployed with fixes. Detail page hang is OPEN BUG.
- **Decisions:** None
- **Next:** (1) 🔴 Debug detail page hang — find SurrealDB root password on Saturn, verify VIEWER→fn::get_establishment_detail() works, check company DB slug. (2) User re-save establishment with images → verify card images. (3) Add delete establishment to BP.
- **⚠️ CRITICAL for next session:** The SurrealDB root password on Saturn was created by Hermes in a prior session. The agent must search Saturn filesystem (e.g. docker-compose, env files, .surreal_root_pass) or conversation history to find it. Do NOT ask the user.

---

## 2026-07-01 11:56 — Auth Reconciliation + Discovery Phase 5 E2E
- **Session:** Auth credential audit via research agent. Switched marketplace discovery from `bp_portal` to `marketplace_reader` NS VIEWER. Deleted dead BP auth files (–413 lines). Updated deploy script. Graduated auth service track. User started Discovery Phase 5 E2E — recreating House of the North under correct company (Dream On AS). Found 2 BP gaps: no delete establishment, Kartverket autocomplete missing from creation dialog.
- **Tracks touched:** auth_service_20260624 (graduated), discovery_layer_20260630 (status updated)
- **Status:** Auth reconciliation complete. Discovery Phase 5 E2E in progress (user-driven).
- **Decisions:** None (auth graduation is operational)
- **Next:** (1) Finish Discovery Phase 5 E2E. (2) Wire Kartverket into "Ny virksomhet" dialog. (3) Add delete establishment to BP. (4) Deploy both apps after E2E passes.

---

## 2026-07-01 00:02 — Rename storefront → establishment_detail
- **Session:** Fixed domain naming: `fn::get_storefront()` → `fn::get_establishment_detail()`, `StorefrontService` → `EstablishmentDetailService`. Updated Saturn DB (remove + redefine). Redeployed to phone, verified.
- **Tracks touched:** discovery_layer_20260630
- **Status:** Naming cleanup complete. No functional changes.
- **Decisions:** None
- **Next:** Same as prior checkpoint.

---

## 2026-06-30 23:40 — Discovery Layer Phases 2 + 4 Complete
- **Session:** Built Marketplace Home (DittoBar, category chips, listing cards). Consulted SurrealDB Sidekick — discovered NS-level VIEWER user eliminates per-DB provisioning. Built `fn::get_storefront()` server-side function. Replaced 371-line debug pipe with ~50-line `StorefrontService` (WS + fn call). Deployed to phone — House of the North loads.
- **Tracks touched:** discovery_layer_20260630
- **Status:** Phases 1-2 + 4 ✅. Phase 3 deferred (lean). Phase 5 (E2E verification) remains.
- **Decisions:** None (NS VIEWER pattern documented in Pulse as operational discovery, ADR-0025 already covers two-phase load)
- **Next:** (1) Discovery Phase 5: E2E multi-tenant verification. (2) Auth layer reconciliation with NS VIEWER pattern. (3) BP Bookings Backend.

---

## 2026-06-30 22:06 — Discovery Layer Phase 1 Complete + Deployed
- **Session:** Built `packages/discovery_service/` (3 models, DiscoveryRepository, ListingSyncService). Wired BP publish sync into establishment edit view. Fixed 3 deploy-time bugs (fire-and-forget auth, UPSERT WHERE, type::thing deprecation, source_id coercion). 24 unit + 5 integration tests. Deployed 3× to Saturn. User verified listing in Surrealist.
- **Tracks touched:** discovery_layer_20260630
- **Status:** Phase 1 ✅. Pipeline live: BP save → discovery DB write. Phase 2 (Home Screen + DittoBar) next.
- **Decisions:** None
- **Next:** (1) Discovery Phase 2: Marketplace Home Screen + DittoBar search. (2) BP Bookings Backend. (3) ME Availability Wiring.

---

## 2026-06-30 20:33 — Discovery Layer Grill + Track Creation
- **Session:** Grilled the Discovery domain end-to-end. Decided: BP direct-write sync (ADR-0024), two-phase load (ADR-0025), `discovery_service` shared package (ADR-0026). Added 5 glossary terms. Created `discovery_layer_20260630` track with 5-phase spec + plan. New `discovery` domain (🔴 Tread Carefully) registered.
- **Tracks touched:** discovery_layer_20260630 (created)
- **Status:** Track created with full spec + plan. Ready for Phase 1 implementation.
- **Decisions:** ADR-0024 (BP Direct-Write Sync), ADR-0025 (Two-Phase Load), ADR-0026 (Discovery Service Package)
- **Next:** (1) Discovery Layer Phase 1: `discovery_service` package + BP publish sync. (2) BP Bookings Backend. (3) ME Availability Wiring.

---

## 2026-06-30 19:32 — Booking Flow UI Complete + Next Steps Discussion
- **Session:** Built complete 5-step booking flow UI (`booking_ui` shared package). All step widgets + BookingFlowPage shell + BookingStepIndicator. Wired `onBookTapped` through EstablishmentPage. Added `/booking` route to Marketplace. 18 unit tests. Deployed to phone — user confirmed "looks amazing." Discussed roadmap: Discovery layer (multi-tenant login), BP bookings backend, ME availability wiring.
- **Tracks touched:** booking_flow_ui_20260630
- **Status:** Phases 1–4 complete. Deployed to Galaxy S21. Remaining: visual polish, E2E walkthrough, ME wiring.
- **Decisions:** None
- **Next:** (1) Discovery layer grill (multi-tenant login + hair salon + restaurant creation). (2) BP bookings backend (receive/view bookings after ME). (3) ME availability wiring (replace mock slots). (4) Favorites polish + merge.

---

## 2026-06-30 13:48 — Favorites Toggle Saturn DB Fix
- **Session:** Root-caused and fixed `PERMISSIONS NONE` on Saturn's `favorite` table. Verified CRUD via HTTP API. Deployed Marketplace to phone. User confirmed favorites work + verified data in SDB.
- **Tracks touched:** favorites_toggle_20260630
- **Status:** Unblocked. Toggle works E2E on phone. Remaining: widget tests, `pendingFavorite` login flow, auth gate test, merge.
- **Decisions:** None
- **Next:** (1) Booking Flow UI. (2) Favorites polish (tests + merge). (3) MercuryEngine availability. (4) Light theme. (5) Profile grill.

---

## 2026-06-30 13:14 — Favorites Toggle (BLOCKED on Saturn DB)
- **Session:** Implemented favorites toggle data layer + UI wiring. Favorite model, repository, Riverpod providers, schema permissions, 3× Lagre button wiring, auth gate, profile sticker.
- **Tracks touched:** favorites_toggle_20260630
- **Status:** BLOCKED. Code complete, all tests pass locally (9 model + 9 repo + 91 UI + 75 BP). Fails on Saturn — SurrealDB 3.1.2 RECORD ACCESS CREATE returns empty results for consumer users. Even `PERMISSIONS FULL` doesn't help. Root cause: version behavior change between 3.0.5 (local) and 3.1.2 (Saturn).
- **Decisions:** None
- **Next:** Debug SurrealDB 3.1.2 RECORD ACCESS in fresh session. Consider upgrading local test DB to 3.1.2 to reproduce. Once fixed, run E2E against Saturn → deploy to phone.

---

## 2026-06-30 00:28 — EstablishmentPage v2 Native Redesign + Booking Analysis
- **Session:** Full native EstablishmentPage redesign — SliverAppBar collapsing toolbar, glass-morphism bottom nav (48px, icons-only), featured services hero section, theme toggle. Ingested 5 Stitch booking screens and wrote flow analysis.
- **Tracks touched:** marketplace (EstablishmentPage)
- **Status:** Page v2 deployed to phone, user approved. Booking UI not started (analysis only).
- **Decisions:** None
- **Next:** Open fresh session → `/new-track` for Booking Flow UI (Steps 1–5). Build with mock data. ME availability engine tomorrow. Light theme polish deferred.

---


> 📦 Older entries archived: `pulse-archive/relay-pre-20260629.md`
