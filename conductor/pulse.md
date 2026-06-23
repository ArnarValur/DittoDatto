# Pulse — Current Project State

**Last Updated:** 2026-06-23 12:25
**Session Focus:** Stabilization — test isolation fix, Schema Gate, build+deploy, E2E verification

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–5 complete. Admin Panel E2E partially verified (login ✅, dashboard ✅, company creation ✅ via form). Pending: full E2E through the UI for BP login.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete. Integration test suite: 39 tests green. Stats test isolation fixed. Deploy gate enforced.

## ✅ Recently Completed

- **2026-06-23** — Stabilization session. (1) Fixed stats test isolation: root cause was `flutter test` running test files concurrently against shared DB — added `concurrency: 1` to `dart_test.yaml`, rewrote stats assertions to be delta-free. 39/39 admin + 92/92 BP all green. (2) Added Schema Gate (step 3) to `conductor/workflow.md` — mandatory `schemas/*.surql` verification before writing DB-touching code. (3) Added "E2E Means E2E" principle to workflow — no CLI hacks for form testing. (4) Built + deployed both Admin Panel and Business Portal to Saturn. (5) E2E verified: login as arnarvalur → dashboard (1 User, 0 Companies, 0 Categories, Healthy Engine) → company form works.
- **2026-06-23** — Fixed company form → SurrealDB pipeline. 4 bugs: (1) `OnboardingStatus` enum had `inProgress`/`completed` instead of schema's `ai_suggested`/`verified`/`complete`, (2) `CompanyTier` had `enterprise` not in schema (`free`/`premium` only), (3) `CompanySocialLinks` had `website` field that SCHEMAFULL rejects (`social_links.website` not defined — `website` is top-level on company), (4) form set `dbSlug` to bare slug instead of `company_${slug}`. Removed "Fill Mock Data" button. Added 11 form round-trip integration tests exercising full CRUD with all enum values against real SurrealDB.
- **2026-06-20** — Project health assessment + agent rules overhaul. Diagnosed root cause of Flutter migration pain (AI-generated Dart↔SurrealDB code passing widget tests but failing on real DB). Agent rules: dropped 2 generic book rules, added `surrealdb-dart.md` (9 foot-gun patterns) + `user-first.md` (ask-before-fumbling). Switched GH remote HTTPS→SSH.
- **2026-06-20** — Built Admin Panel integration test suite: 28 tests against real SurrealDB covering Users/Companies/Categories/Stats CRUD + NS auth. Caught and fixed 3 production bugs.
- **2026-06-20** — Saturn DB wiped clean. Re-applied init + schemas. Fixed Admin Panel CREATE user NULL→NONE coercion. Rebuilt + deployed.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **Recurring schema drift pattern mitigated:** Schema Gate now mandatory in workflow (step 3). Root cause addressed structurally, no longer a blocker — it's a guardrail.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Portal deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden + `conductor/docs/keys/saturn-db-root.env` (gitignored)
- **Surreal CLI remote:** `surreal sql --endpoint ws://100.121.237.101:8001/rpc -u dittodatto_root -p <pw> --ns <ns> --db <db> --hide-welcome --multi`
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces, password `admin123`) — Admin Panel only.
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash validation via **full email** (not username prefix). Service user `bp_portal` (EDITOR) on each `company_{slug}` DB. Password via `--dart-define=BP_PORTAL_PASS=<secret>`.
- **Schemas source of truth:** `schemas/` at project root.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh` to tear down.
- **Port reservations:** :8001 SurrealDB Hub, :8002 Admin Panel, :8003 Business Portal, :8004 Public Marketplace (reserved), :8005 Booking Engine (reserved).
- **BP build password:** `BP_PORTAL_PASS=test-portal-pass` (staging-only).
- **DB topology (as of 2026-06-23 12:21):** `companies` NS (registry — 1 company "Merkurial Studio") + `users` NS (users — 1 user "arnarvalur"). Company created via CLI (should be deleted and re-created through form per E2E-means-E2E rule).
- **NULL vs NONE:** SurrealDB `option<T>` accepts `NONE` (absent) or `T`, rejects `NULL`. Dart null → SurrealDB NULL. All optional fields must coerce.
- **Deploy gate rule:** `.agents/AGENTS.md` mandates: test-db-up → flutter test --tags integration → all green → build → deploy.
- **Integration test suite (2026-06-23):** 39 tests (admin) + 92 tests (BP). `dart_test.yaml` enforces `concurrency: 1` for integration tests.
- **Workflow updates (2026-06-23):** Schema Gate (step 3), E2E Means E2E (principle 5), 12-step lifecycle.
- **Agent rules:** 4 rules in `conductor/agent-rules/`: `code-safety.md`, `flutter-app-development.md`, `surrealdb-dart.md`, `user-first.md`.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Clean E2E through UI:** Delete CLI-created "Merkurial Studio" company. Re-create through Admin Panel form. Verify full round-trip.
2. 🟡 **BP E2E:** Log in as business user → list establishments → create establishment → verify scrollspy edit view.
3. 🟢 **Forward motion:** Once E2E is validated, pick next feature work from tracks.
