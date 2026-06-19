# Pulse — Current Project State

**Last Updated:** 2026-06-19 12:31
**Session Focus:** Production-grade testing infrastructure for BP + bug fix discovered by integration tests.

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Phase 4b (tenant-scoped login) **fixed** — `profiles`→`users` DB name mismatch resolved. 85 tests total (65 widget/unit + 20 integration against real SurrealDB). Phase 5 (integration & polish) unblocked.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional. Premium Users screen completed. Categories screen upgraded. Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-19** — **Production-grade testing infrastructure.** Docker Compose ephemeral test DB, seed scripts (real schemas), test reorganization (widget/unit/integration dirs), 20 integration tests against live SurrealDB. Fixed `profiles`→`users` DB name mismatch bug caught by first test run.
- **2026-06-14** — **BP Tenant-Scoped Login (partial).** Wired ADR-0013 3-step login: NS auth → role verification via `users/profiles` → tenant routing to `company_{slug}`. Login confirmed working from server logs. Session restore (page refresh) hangs — needs investigation.
- **2026-06-14** — **BP Login + Establishments Phases 1–4.** Light theme (Stitch Enterprise Slate), login redesign (Norwegian bokmål), establishments list (card grid + tab filters + badges), create dialog, 4-tab edit view. 94 tests across 3 suites. 7 commits on `track/bp-login-establishments`.
- **2026-06-09** — **Business Portal E2E Login & Saturn Deployment.** Wired `SURREAL_URL` dart-define, verified login against Saturn SurrealDB, deployed to Saturn port 8005.
- **2026-06-09** — **Code Quality Safeguards.** ADR-0015 (no hardcoded secrets/IDs). Created `code-safety.md` agent rule.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **Session restore may still hang on page refresh.** The `profiles`→`users` fix resolves the DB routing, but the WebSocket `.wait()` hang may still occur. Integration test `reconnects with valid tokens from a previous session` passes against ephemeral DB — needs verification on Saturn deployment.

## 🧠 Session Memory

- *2026-06-19 - 12:31* — **DB name mismatch bug found and fixed.** `surreal_connection.dart` routed users WebSocket to `users/profiles` (empty auto-created DB) instead of `users/users` (where schema and data live). Fixed in both `connect()` (line 75) and `connectWithTokens()` (line 110). Caught by integration tests on first run. _(operational)_
- *2026-06-19 - 12:31* — **Testing infrastructure established.** `docker-compose.test.yml` (ephemeral SurrealDB port 18000), `scripts/test-db-{up,down,seed}.sh`, `dart_test.yaml` with `integration` tag, `test/integration/helpers/mock_secure_storage.dart` for FlutterSecureStorage mock platform channel. _(operational)_
- *2026-06-19 - 12:31* — **Seed script requires `--multi` flag** for `surreal sql` CLI 3.0.5 — without it, multi-line `.surql` statements are parsed line-by-line. _(operational)_
- *2026-06-19 - 12:31* — **MercuryEngine tests aligned.** 3 Python test files updated to use `SURREAL_TEST_URL` env var (default: `ws://localhost:8000/rpc` for backward compat). _(operational)_
- *2026-06-14 - 18:17* — Login lookup uses `username` field (not `email`). NS auth username is the link between namespace identity and user records. Email domain in the login form is irrelevant — only the prefix matters for NS signin. _(operational)_
- *2026-06-14 - 15:30* — BP uses `DittoTheme.light` (Stitch Enterprise Slate), Admin stays `DittoTheme.dark`. Typography split: Outfit+Manrope (BP light), Inter (Admin dark). _(operational)_

- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Admin deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Business Portal deployed:** `http://dittodatto:8005` — Caddy serves from `/srv/dittodatto/business-portal/web/`, proxies `/rpc` to SurrealDB.
- **Portal deploy command:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces).
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration` for real DB tests. `./scripts/test-db-down.sh` to tear down.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🚀 **Deploy BP to Saturn** — Bug is fixed, tests are green. Build and deploy, verify login works on Saturn.
2. 🔍 **Verify session restore on Saturn** — The `profiles`→`users` fix may have been the root cause of the blank-screen hang. Test on deployed instance.
3. 🧪 **Run integration tests on Saturn** — Point tests at Saturn SurrealDB to verify production schema matches.
4. 🎨 **UI tweaks** — User has gathered UI polish items to address.
5. 🛠️ **Create deploy skill** — Automate build + deploy for both Admin and BP apps.
