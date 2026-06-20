# Pulse — Current Project State

**Last Updated:** 2026-06-20 17:11
**Session Focus:** Project Health Assessment + Agent Rules Overhaul

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Phase 5 layout implemented. Pending: Admin Panel E2E (create users → create company → test BP login).
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete. Integration test suite added (28 tests). 3 production bugs caught and fixed. Deploy gate rule established.

## ✅ Recently Completed

- **2026-06-20** — Project health assessment: diagnosed root cause of Flutter migration pain (AI-generated Dart↔SurrealDB code passing widget tests but failing on real DB). Trimmed agent rules: dropped generic clean-code + DDD book rules (context noise), added battle-tested `surrealdb-dart.md` covering 9 foot-gun patterns from 25 days of production bugs (NULL/NONE, MERGE vs SET, record IDs, query parsing, argon2, SCHEMAFULL permissions, integration test mandate).
- **2026-06-20** — Built Admin Panel integration test suite: 28 tests against real SurrealDB covering Users/Companies/Categories/Stats CRUD + NS-level auth. Caught and fixed 3 production bugs: (1) `updateUser` used invalid `MERGE+SET` SurrealQL syntax, (2) `deleteCompany` record ID mismatch prevented owner role revert, (3) `createUser` phone field missing NULL→NONE coercion. Extended `test-db-seed.sh` with `testadmin` on `companies` namespace. Added `.agents/AGENTS.md` deploy gate rule: tests must pass before any deploy.
- **2026-06-20** — Saturn DB wiped clean. Re-applied init + schemas. Fixed Admin Panel CREATE user NULL→NONE coercion for `company_slug` and `vipps_sub`. Verified against real Saturn DB. Rebuilt + deployed.
- **2026-06-20** — Quality audit of overnight Gemini 3.5 session (8.2/10). Fixed 4 stale `platform`→`registry` references.
- **2026-06-20** — Database cleanup: fixed `opening_schedule` schema blocker, dropped legacy `users/profiles`, fixed `init.surql` naming, updated ADR-0002 and ADR-0016.
- **2026-06-19** — Phase 5 layout: scrollspy edit view, sidebar identity, login branding, Riverpod state sync fix.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Portal deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/` (then `sudo rsync` from `/tmp/bp-web-deploy/` to `/srv/...`)
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden + `conductor/docs/keys/saturn-db-root.env` (gitignored)
- **Surreal CLI remote:** `/home/solmundur/.surrealdb/surreal sql --endpoint ws://100.121.237.101:8001/rpc -u dittodatto_root -p <pw> --ns <ns> --db <db> --hide-welcome --multi`
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces, password `admin123`) — Admin Panel only.
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash validation via **full email** (not username prefix). Service user `bp_portal` (EDITOR) on each `company_{slug}` DB. Password via `--dart-define=BP_PORTAL_PASS=<secret>`.
- **Schemas source of truth:** `schemas/` at project root.
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh` to tear down.
- **Port reservations:** :8001 SurrealDB Hub, :8002 Admin Panel, :8003 Business Portal, :8004 Public Marketplace (reserved), :8005 Booking Engine (reserved).
- **BP build password:** `BP_PORTAL_PASS=test-portal-pass` (staging-only). Used for `bp_portal` DB user on each `company_{slug}` DB.
- **SurrealDB container name on Saturn:** `dittodatto-hub` (in `dittodatto-net` Docker network). Minimal container — no shell utils, connect remotely via Tailscale instead of `docker exec`.
- **DB topology (clean as of 2026-06-20 12:12):** `companies` NS (discovery, registry — empty) + `users` NS (users — empty). All company DBs removed. Fresh start — create companies from Admin Panel.
- **SurrealDB CLI gotcha:** DB names with hyphens (e.g. `company_dittodatto-as`) must be backtick-quoted in SurrealQL: `` USE NS companies DB `company_dittodatto-as`; ``
- **NULL vs NONE (2026-06-20):** SurrealDB `option<T>` accepts `NONE` (absent) or `T`, but rejects `NULL`. Dart null maps to SurrealDB NULL. ALL optional fields in CREATE/UPDATE queries must coerce: `IF $field = NULL THEN none ELSE $field END`. Phone was missed initially — caught by integration test suite.
- **Deploy gate rule (2026-06-20):** `.agents/AGENTS.md` mandates: test-db-up → flutter test --tags integration → all green → build → deploy. No exceptions. No silent deploys of untested code.
- **Integration test suite (2026-06-20):** 28 tests in `apps/admin/test/integration/` — auth (5), users (9), companies (7), categories (5), stats (2). Caught 3 production bugs on first run.
- **Agent rules trimmed (2026-06-20):** Dropped `clean-code.mini.md` + `domain-driven-design-distilled.mini.md` (generic book noise). Added `surrealdb-dart.md` (project-specific foot-guns). Kept `code-safety.md` + `flutter-app-development.md`. Net: 4→3 rules, all battle-tested.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Admin Panel E2E:** Log in as `arnarvalur` → create users (Arnar, Höddi) → create company → verify company DB gets blueprint applied.
2. 🟡 **BP E2E:** Log in as business user → list establishments → create establishment → verify scrollspy edit view.
3. 🟡 **BP Web Build + Deploy:** Rebuild BP web and deploy to Saturn after users/companies exist.
4. 🟢 **Phase 5 Completion:** Fix navigation/state issues, responsive tweaks, coverage gate. Checkpoint Phase 5.
