# Pulse — Current Project State

**Last Updated:** 2026-06-23 11:51
**Session Focus:** Company form enum/schema mismatch fix

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Phase 5 layout implemented. Pending: Admin Panel E2E (create users → create company → test BP login).
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete. Integration test suite added (28+11 tests). Deploy gate rule established.

## ✅ Recently Completed

- **2026-06-23** — Fixed company form → SurrealDB pipeline. 4 bugs: (1) `OnboardingStatus` enum had `inProgress`/`completed` instead of schema's `ai_suggested`/`verified`/`complete`, (2) `CompanyTier` had `enterprise` not in schema (`free`/`premium` only), (3) `CompanySocialLinks` had `website` field that SCHEMAFULL rejects (`social_links.website` not defined — `website` is top-level), (4) form set `dbSlug` to bare slug instead of `company_${slug}`. Removed "Fill Mock Data" button. Added 11 form round-trip integration tests exercising full CRUD with all enum values against real SurrealDB. 37/38 tests pass (1 pre-existing stats test isolation issue).
- **2026-06-20** — Project health assessment + agent rules overhaul. Diagnosed root cause of Flutter migration pain (AI-generated Dart↔SurrealDB code passing widget tests but failing on real DB). Agent rules: dropped `clean-code.mini.md` + `domain-driven-design-distilled.mini.md` (generic noise); added `surrealdb-dart.md` (9 foot-gun patterns) + `user-first.md` (concrete triggers for asking user instead of fumbling). Trimmed global `GEMINI.md` from 27→23 lines. Switched GH remote from HTTPS→SSH.
- **2026-06-20** — Built Admin Panel integration test suite: 28 tests against real SurrealDB covering Users/Companies/Categories/Stats CRUD + NS-level auth. Caught and fixed 3 production bugs.
- **2026-06-20** — Saturn DB wiped clean. Re-applied init + schemas. Fixed Admin Panel CREATE user NULL→NONE coercion for `company_slug` and `vipps_sub`. Verified against real Saturn DB. Rebuilt + deployed.
- **2026-06-20** — Quality audit of overnight Gemini 3.5 session (8.2/10). Fixed 4 stale `platform`→`registry` references.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **Recurring pattern:** Dart models built against assumed schemas instead of reading `schemas/*.surql`. Root cause of repeated enum/field mismatches across sessions.
- **Stats test isolation:** `surreal_admin_repository_stats_test.dart` fails when run alongside other tests due to shared DB state. Pre-existing, not blocking.

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
- **NULL vs NONE (2026-06-20):** SurrealDB `option<T>` accepts `NONE` (absent) or `T`, but rejects `NULL`. Dart null maps to SurrealDB NULL. ALL optional fields in CREATE/UPDATE queries must coerce.
- **Deploy gate rule (2026-06-20):** `.agents/AGENTS.md` mandates: test-db-up → flutter test --tags integration → all green → build → deploy. No exceptions.
- **Integration test suite (2026-06-23):** 38 tests total — original 28 + 11 form round-trip tests. Form tests exercise full CRUD with all enum values against real SurrealDB. 1 pre-existing stats isolation failure.
- **Enum fix (2026-06-23):** `OnboardingStatus` → `notStarted`/`aiSuggested`/`verified`/`complete`. `CompanyTier` → `free`/`premium`. `CompanySocialLinks` → `fb`/`ig`/`x` only (no `website` — that's top-level on company). Form `dbSlug` → `company_${slug}`.
- **Agent rules:** 4 rules in `conductor/agent-rules/`: `code-safety.md`, `flutter-app-development.md`, `surrealdb-dart.md`, `user-first.md`.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Admin Panel E2E:** Log in as `arnarvalur` → create users (Arnar, Höddi) → create company → verify company DB gets blueprint applied.
2. 🟡 **BP E2E:** Log in as business user → list establishments → create establishment → verify scrollspy edit view.
3. 🟡 **Fix stats test isolation:** Run stats test in its own group or reset DB state between test files.
4. 🟡 **Schema-first audit:** Systematically diff ALL Dart models against `schemas/*.surql` to find remaining mismatches before they bite.
