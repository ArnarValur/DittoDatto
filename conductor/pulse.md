# Pulse — Current Project State

**Last Updated:** 2026-06-23 20:21
**Session Focus:** Deploy gate + Saturn deployment (Admin Panel + Business Portal)

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–5 complete. **UNBLOCKED:** Company provisioning fixed. `createCompany` now auto-provisions `company_{slug}` DB + blueprint schema + `bp_portal` user. BP login pipeline verified E2E.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete. 50/50 integration tests green (was 39). Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP integration tests green). Built both apps `--release`. Deployed Admin Panel + Business Portal to Saturn via rsync.
- **2026-06-23** — 🔴 **CRITICAL FIX: Company provisioning.** `createCompany` now auto-provisions: (1) creates `company_{slug}` DB, (2) applies `company-blueprint.surql` (18 tables, 3 relations), (3) creates `bp_portal` service user. `deleteCompany` auto-deprovisions. 11 new integration tests. 50 total green. Root cause: SurrealDB identifier quoting (hyphens interpreted as subtraction) + Dart WebSocket SDK can't handle multi-statement responses.
- **2026-06-23** — Stabilization: fixed stats test isolation (`concurrency: 1`), added Schema Gate to workflow, added "E2E Means E2E" rule. Built + deployed both apps to Saturn. E2E verified: login ✅, dashboard ✅, company edit form ✅. Added "same as owner" email checkbox to company form.
- **2026-06-23** — Fixed company form → SurrealDB pipeline. 4 enum/field bugs. Added 11 form round-trip integration tests.
- **2026-06-20** — Project health assessment + agent rules overhaul.
- **2026-06-20** — Built Admin Panel integration test suite: 28 tests. Caught 3 production bugs.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None — provisioning blocker resolved.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Portal deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** stored in `conductor/docs/keys/saturn-db-root.env` (gitignored)
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces, password `admin123`)
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash. Service user `bp_portal` (EDITOR) on each `company_{slug}` DB.
- **Schemas source of truth:** `schemas/` at project root.
- **Test DB:** `./scripts/test-db-up.sh` → port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh`.
- **Port reservations:** :8001 SurrealDB, :8002 Admin, :8003 BP, :8004 Marketplace, :8005 Booking Engine.
- **Deploy gate:** `.agents/AGENTS.md` — tests must pass before deploy.
- **Integration tests:** 50 admin + 92 BP. `dart_test.yaml` enforces `concurrency: 1`.
- **Workflow guardrails:** Schema Gate (step 3), E2E Means E2E (principle 5).
- **Agent rules:** 4 in `conductor/agent-rules/`.
- **Company provisioning (2026-06-23):** `SurrealAdminRepository` constructor accepts optional `blueprintSql` + `bpPortalPassword`. When provided, `createCompany` auto-provisions. Blueprint bundled as Flutter asset (`pubspec.yaml`). Provider loads it via `rootBundle.loadString()`.
- **SDK workarounds:** (1) Backtick-quote DB names with hyphens in SurrealQL. (2) Split multi-statement `.surql` files into individual `query()` calls — Dart WS SDK throws on multi-result responses. (3) Catch "already exists" errors for idempotent re-provisioning.
- **TODO:** `bp_portal` password is hardcoded in `providers.dart` as `_defaultBpPortalPassword`. Must be moved to secure config before production.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟢 **Staging E2E:** Delete CLI-created company on Saturn, re-create through Admin Panel form — verify provisioning pipeline on staging.
2. 🟢 **BP E2E:** Login as business user → list establishments → create establishment.
3. 🟡 **Secure `bp_portal` password:** Move from hardcoded constant to env var / secrets config.
4. 🟡 **BP track Phase 5 remaining:** Fix navigation/state issues, fix layout breakages from E2E walkthrough.
