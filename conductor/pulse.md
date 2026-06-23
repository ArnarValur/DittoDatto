# Pulse — Current Project State

**Last Updated:** 2026-06-23 12:35
**Session Focus:** Diagnostic, stabilization, E2E verification — discovered critical provisioning gap

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–5 complete. **BLOCKED:** `createCompany` does not provision the company database (`company_{slug}`), blueprint schema, or `bp_portal` service user. BP login will always fail after creating a company through Admin Panel.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete. 39/39 integration tests green. Added "same as owner" email checkbox. Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-23** — Stabilization: fixed stats test isolation (`concurrency: 1`), added Schema Gate to workflow, added "E2E Means E2E" rule. Built + deployed both apps to Saturn. E2E verified: login ✅, dashboard ✅, company edit form ✅. Added "same as owner" email checkbox to company form.
- **2026-06-23** — Fixed company form → SurrealDB pipeline. 4 enum/field bugs. Added 11 form round-trip integration tests.
- **2026-06-20** — Project health assessment + agent rules overhaul.
- **2026-06-20** — Built Admin Panel integration test suite: 28 tests. Caught 3 production bugs.
- **2026-06-20** — Saturn DB wiped clean. Re-applied schemas. Fixed NULL→NONE coercion.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **🔴 CRITICAL — Company provisioning missing:** `createCompany` only writes a row to `companies/registry`. It does NOT: (1) create the company database `company_{slug}`, (2) apply `schemas/company-blueprint.surql` (18 tables, 3 relations), (3) create `bp_portal` service user. This is WHY BP login has failed after every company creation for weeks. Must be fixed before any BP E2E testing.

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
- **DB topology (2026-06-23):** `companies` NS (registry — 1 company "Merkurial Studio" created via CLI, bad owner_id). `users` NS (users — 1 user). No company DBs exist.
- **Deploy gate:** `.agents/AGENTS.md` — tests must pass before deploy.
- **Integration tests:** 39 admin + 92 BP. `dart_test.yaml` enforces `concurrency: 1`.
- **Workflow guardrails added this session:** Schema Gate (step 3), E2E Means E2E (principle 5).
- **Company provisioning gap:** `createCompany` needs: bundle `company-blueprint.surql` as Flutter asset → load at runtime → `USE companies/{dbSlug}` → execute blueprint → `DEFINE USER bp_portal ON DATABASE ... ROLES EDITOR`. Partial implementation was started and reverted.
- **Agent rules:** 4 in `conductor/agent-rules/`.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Fix company provisioning in `createCompany`:** Bundle blueprint as asset, load at runtime, provision DB + schema + bp_portal user. This unblocks ALL BP testing.
2. 🟡 **Delete CLI-created company, re-create through form:** Validate the full provisioning pipeline E2E.
3. 🟡 **BP E2E:** Login as business user → list establishments → create establishment.
