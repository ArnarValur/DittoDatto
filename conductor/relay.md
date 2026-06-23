# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

## 2026-06-23 12:25 — Stabilization: Test Isolation + Schema Gate + Deploy + E2E

- **Session:** Deep diagnostic confirmed recurring regression root cause: schema drift + concurrent test isolation. Fixed stats test (concurrency:1 in dart_test.yaml + delta-free assertions). Added Schema Gate as mandatory workflow step 3 — agents must read .surql before writing DB code. Added "E2E Means E2E" principle — no CLI hacks for form testing. Built + deployed both Admin Panel and Business Portal to Saturn. E2E verified: login ✅, dashboard ✅, company form ✅. CLI-created test company has bad owner_id (record link vs string) — need to delete and re-create through form.
- **Tracks touched:** `admin_panel_20260527`, `bp_login_establishments_20260614`
- **Status:** 39/39 admin + 92/92 BP tests green. Both apps deployed. Workflow hardened with 2 new guardrails.
- **Decisions:** None
- **Next:** Delete CLI company, create through form (clean E2E). Then BP E2E: login as business user → establishments CRUD.

---

## 2026-06-23 11:51 — Company Form Schema Mismatch Fix

- **Session:** Fixed 4 bugs preventing company creation from Admin Panel form: (1) OnboardingStatus enum mismatch (inProgress/completed → aiSuggested/verified/complete), (2) CompanyTier had enterprise not in schema, (3) CompanySocialLinks.website rejected by SCHEMAFULL, (4) form dbSlug missing company_ prefix. Removed "Fill Mock Data" button. Added 11 form round-trip integration tests.
- **Tracks touched:** `admin_panel_20260527`
- **Status:** 37/38 integration tests pass. 1 pre-existing stats test isolation failure. Committed as `b2baa9d`.
- **Decisions:** None

---

- **Session:** Diagnosed root cause of Flutter migration pain (AI code passes widget tests, breaks on real SurrealDB). Overhauled agent rules: dropped 2 generic book rules, added `surrealdb-dart.md` (9 foot-gun patterns) + `user-first.md` (ask-before-fumbling). Trimmed global `GEMINI.md` to essentials. Switched GH remote HTTPS→SSH, pushed branch.
- **Tracks touched:** None (cross-cutting infrastructure)
- **Status:** All committed and pushed to GH. 4 project-specific agent rules, all battle-tested.
- **Decisions:** None
- **Next:** Admin Panel E2E (create users → create company → verify BP login). Consider SurrealDB typed query helper.

---

## 2026-06-20 15:31 — Admin Panel Integration Test Suite + Deploy Gate

- **Session:** Built 28 integration tests for Admin Panel against real SurrealDB (users/companies/categories/stats CRUD + NS auth). First run caught 3 production bugs: (1) `updateUser` invalid MERGE+SET syntax, (2) `deleteCompany` record ID mismatch, (3) `createUser` phone missing NULL→NONE coercion. All fixed, tests green. Added `.agents/AGENTS.md` deploy gate rule — tests must pass before any deploy. Extended `test-db-seed.sh` with `testadmin` on `companies` namespace.
- **Tracks touched:** `admin_panel_20260527`
- **Status:** 28/28 integration tests green. Admin Panel deployed with all 3 fixes. Deploy gate rule enforced.
- **Decisions:** None (deploy gate is an operational rule, not an ADR)
- **Next:** Admin Panel E2E: create users → create company → verify BP login works.

---

## 2026-06-20 12:26 — Saturn DB Wipe + Admin Panel NULL→NONE Fix + Deploy

- **Session:** Wiped Saturn DB clean (all company DBs + user records removed). Re-applied schemas from source of truth (users, registry, discovery). Created 2 NS OWNER users (arnarvalur, gurkudrengur, pw admin123). Fixed Admin Panel CREATE user query — was sending NULL for optional fields (`company_slug`, `vipps_sub`) which SurrealDB `option<string>` rejects. Verified fix against real Saturn DB. Rebuilt + deployed Admin Panel. Removed oasai references from conductor. Quality audit scored overnight work 8.2/10.
- **Tracks touched:** `bp_login_establishments_20260614`, `admin_panel_20260527`
- **Status:** Saturn DB is clean. Admin Panel deployed with fix. User creation verified on real DB. Ready for Admin Panel E2E (create users → create company → test BP login).
- **Decisions:** None
- **Next:** Log into Admin Panel as `arnarvalur` → create users → create company → BP E2E.

---

## 2026-06-20 12:05 — Quality Audit + platform→registry Fix + Saturn DB Assessment

- **Session:** Quality-audited overnight Gemini 3.5 work (scored 8.2/10). Fixed 4 stale `platform`→`registry` references in README, seed script, platform.surql (commit `12511cf`). Seed script was broken — would apply schemas to wrong DB name. User inspected Saturn DB via Surrealist: `company_dittodatto-as` has only 1 table (missing blueprint), `merkurial-studio` in registry with no company DB, stale Surrealist connection. User wants DB wipe + clean re-provision before continuing E2E.
- **Tracks touched:** `bp_login_establishments_20260614` (indirectly — schema infra)
- **Status:** Schema refs fixed. Saturn DB cleanup blocker identified. E2E paused until DB is clean.
- **Decisions:** None
- **Next:** Decide on Saturn DB wipe strategy. Write provisioning script or manual wipe + re-apply schemas. Then resume E2E.

---

## 2026-06-20 02:29 — Gemini 3.5 Session Audit + Database Cleanup + Schema Fix

- **Session:** Audited Gemini 3.5 Flash session (c962aebc) — found scope creep (Admin Panel touched without being asked), hallucinated APIs, uncommitted code. All code reviewed and committed in 6 logical groups. Fixed `opening_schedule` schema blocker (DEFAULT {}) on both company DBs on Saturn. Dropped legacy `users/profiles` DB on Saturn. Fixed `init.surql` naming (platform→registry). Updated stale ADR-0002 (profiles→users) and ADR-0016 (username→email). Fixed scrollspy 200px magic number with dynamic offset calculation. Discarded Gemini 3.5 artifacts (.saropa/, reports/, history.txt changes). 138 tests green.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Schema blocker resolved. DB clean. All Phase 5 code committed. Ready for E2E verification tomorrow morning.
- **Decisions:** None
- **Next:** E2E verification: login → create establishment → verify persistence → scrollspy edit view. Then BP web build + deploy to Saturn.

---

## 2026-06-19 22:50 — Phase 5 Layout Implemented & Schema Validation Blockage

- **Session:** Implemented Phase 5 layout updates (sidebar identity header/footer, reordered navigation to put Inbox at index 1, Login screen branding cleanups, and refactored establishment edit screen from tabs to scrollable card sections using `DittoScrollspyLayout`). Resolved Riverpod state sync issue in `surrealConnectionProvider`. Investigated and diagnosed establishment creation disappearance/failure on schema-applied database `company_house-of-the-north` due to missing required `opening_schedule` field in creation JSON.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phase 5 layout implemented and compilation/tests green (92 tests passing). Staged web build deployed to Saturn. Blocked on database schema modification for `opening_schedule`.
- **Decisions:** None (no ADRs recorded)
- **Next:** Fix database schema for `opening_schedule` to define `DEFAULT {}` or make it optional (`TYPE option<object>`), then run E2E verification.

---

## 2026-06-19 20:42 — Infra Prep + Phase 5 Design Planning

- **Session:** Rebuilt Admin Panel + deployed to Saturn. Applied company-blueprint to `company_house-of-the-north` (18 tables + 3 relations). Stored DB root creds in gitignored `conductor/docs/keys/saturn-db-root.env`. Researched professional portal UX patterns and Flutter theming architecture. Designed Phase 5 plan: sidebar identity (company top, full name bottom), login cleanup (email+password only), tabs → scrollable card sections with scrollspy, sticky top bar. Theme switching explicitly deferred to Phase 6.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phase 5 implementation plan approved. Ready for implementation in new session.
- **Decisions:** None (design decisions recorded in Pulse session memory, no ADRs)
- **Next:** Implement Phase 5 (reference `implementation_plan.md` artifact from conversation `96918de2-7254-451b-96f1-2a81bef1a195`). Then Phase 6 theme session.

---

- **Session:** Enforced global maintenance redirect both server-side and client-side on the public landing page. Revamped the Norwegian coming-soon page to fix browser emoji clipping and removed the Merkurial Studio footer. Built the container locally and deployed to Cloud Run.
- **Tracks touched:** None
- **Status:** Deployed and verified live at dittodatto.no.
- **Decisions:** None
- **Next:** Rebuild Admin Panel. Apply company-blueprint to `company_house-of-the-north`. Phase 5 of BP track.

---

## 2026-06-19 17:09 — BP Auth Email Validation + Permissions Fix

- **Session:** Fixed email validation hole (username prefix → full email matching in `bp_auth` SIGNIN). Fixed SCHEMAFULL RECORD ACCESS permissions (table needs explicit `PERMISSIONS FOR select WHERE id = $auth.id`). All 46 tests green before deployment.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Deployed and user-verified on Saturn. BP login works E2E.
- **Decisions:** None
- **Next:** Rebuild Admin Panel. Apply company-blueprint to `company_house-of-the-north`. Phase 5.

---

## 2026-06-19 15:38 — BP Auth Full-Stack Fix

- **Session:** Fixed the fundamental auth plumbing end-to-end. DB consolidation (`users/profiles` → `users/users`), argon2 password hashing in Admin Panel, password fields in Create/Edit User dialogs, Saturn DB migration (3 users with password_hash + DEFINE ACCESS bp_auth + bp_portal service users on 2 company DBs). BP rebuilt with `BP_PORTAL_PASS=test-portal-pass`.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Code-complete. Build staged on Saturn at `/tmp/bp-web-deploy/`. Needs `sudo rsync` to deploy. Admin Panel also needs rebuild+redeploy.
- **Decisions:** None (ADR-0016 already covers this architecture)
- **Next:** Deploy BP → E2E login as Demo Dude → verify correct company loads. Rebuild Admin Panel. Apply company-blueprint schema to `company_house-of-the-north`.

---

## 2026-06-14 15:30 — BP Login + Establishments Phases 1–4

- **Session:** Implemented Stitch Enterprise Slate light theme, Norwegian login redesign, Establishments list screen with card grid + tab filters, create dialog, and 4-tab edit view.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phases 1–4 complete. 94 tests green. 7 commits on `track/bp-login-establishments`.
- **Next:** Auth verification, Phase 5 integration, deploy to Saturn.

---

## 2026-06-09 16:30 — Business Portal E2E Steel Thread & Saturn Deployment

- **Session:** Verified Business Portal login E2E against Saturn SurrealDB. Built and deployed to Saturn port 8003.
- **Status:** Login works. Portal live at `http://dittodatto:8003`.
- **Next:** Establishments CRUD track.

---

> 📦 Pre-portal relay history: `conductor/pulse-archive/2026-06-09-pre-portal.md`
