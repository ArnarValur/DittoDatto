# Pulse — Current Project State

**Last Updated:** 2026-06-19 13:29
**Session Focus:** 🔴 Critical security fix — BP auth was using DB namespace admin credentials for portal login. Replaced with RECORD ACCESS (password_hash via argon2).

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. **Auth rewrite in progress (ADR-0016)**: replaced namespace-level system user auth with RECORD ACCESS on `users/users` + DB-level service user on `company_{slug}`. Code changes done, needs compile verification + integration test run.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional (NS-level, VPN-only — separate trust model). Premium Users screen completed. Categories screen upgraded. Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-19** — **🔴 ADR-0016: RECORD ACCESS auth fix.** Rewrote 7 files: `surreal_connection.dart`, `surreal_auth_service.dart`, `auth_provider.dart`, `users.surql` (DEFINE ACCESS bp_auth), `test-db-seed.sh`, both integration test files. ADR-0013 superseded. Needs compile + test verification.
- **2026-06-19** — **Production-grade testing infrastructure.** Docker Compose ephemeral test DB, seed scripts (real schemas), test reorganization (widget/unit/integration dirs), 20 integration tests against live SurrealDB. Fixed `profiles`→`users` DB name mismatch bug caught by first test run.
- **2026-06-14** — **BP Login + Establishments Phases 1–4.** Light theme (Stitch Enterprise Slate), login redesign (Norwegian bokmål), establishments list (card grid + tab filters + badges), create dialog, 4-tab edit view. 94 tests across 3 suites. 7 commits on `track/bp-login-establishments`.
- **2026-06-09** — **Business Portal E2E Login & Saturn Deployment.** Wired `SURREAL_URL` dart-define, verified login against Saturn SurrealDB, deployed to Saturn port 8005.
- **2026-06-09** — **Code Quality Safeguards.** ADR-0015 (no hardcoded secrets/IDs). Created `code-safety.md` agent rule.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **Auth rewrite needs verification.** Code changes complete but not yet compiled or tested. Must run `flutter analyze` + integration tests against ephemeral DB before deploying.
- **BP_PORTAL_PASS must be provisioned on Saturn.** The new auth model requires a `bp_portal` DB-level user on each company database + the password injected via `--dart-define=BP_PORTAL_PASS=<secret>` at build time.
- **Saturn bootstrap.surql needs updating.** Production namespace users (`arnarvalur`, `gurkudrengur`) need `password_hash` set on their user records + RECORD ACCESS definition applied to `users/users` DB.

## 🧠 Session Memory

- *2026-06-19 - 13:29* — **🔴 CRITICAL: BP auth was using namespace admin credentials for portal login.** The entire auth flow was copy-pasted from the Admin Panel, using `DEFINE USER ON NAMESPACE ROLES OWNER` for company portal users. This meant the user's login password WAS the database namespace admin password, giving them OWNER access to all databases in both namespaces. Zero tenant isolation — `routeToTenant()` was cosmetic. Fixed by ADR-0016: RECORD ACCESS on `users/users` (validates `password_hash` via argon2) + DB-level service user on company DBs. _(ADR-0016)_
- *2026-06-19 - 13:29* — **BP port changed to :8003 on Saturn.** User confirmed container reorganization. Ports 8004, 8005 reserved for public marketplace and booking engine. _(operational)_
- *2026-06-19 - 13:29* — **Dart SDK `surrealdb ^1.1.2` supports `access` parameter in `signin()`.** Maps to `AC` on the wire — compatible with SurrealDB 3.x `DEFINE ACCESS`. No package upgrade needed. _(operational)_
- *2026-06-19 - 13:29* — **User expressed deep frustration with repeated security issues.** Hardcoded credentials (ADR-0015), sensitive data in logs, and now namespace admin passwords for portal login. Pattern: auth/security shortcuts during implementation that violate basic production security. Must treat all future auth decisions as 🔴 Critical. _(operational)_

- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Admin deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Business Portal:** `http://dittodatto:8003` — port updated per user (was 8005).
- **Portal deploy command:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces) — Admin Panel only. BP now uses RECORD ACCESS.
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration` for real DB tests. `./scripts/test-db-down.sh` to tear down.
- **BP service credential:** `bp_portal` DB-level user on each company DB. Password injected via `--dart-define=BP_PORTAL_PASS=<secret>`. For tests: `BP_PORTAL_PASS=test-portal-pass`.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Verify auth rewrite compiles** — `flutter analyze` in `apps/business-portal/`. Fix any type errors from the new connection API.
2. 🔴 **Run integration tests** — `./scripts/test-db-up.sh` then `flutter test --tags integration --dart-define=BP_PORTAL_PASS=test-portal-pass`. Verify RECORD ACCESS + DB-level service user work end-to-end.
3. 🔴 **Provision Saturn** — Apply `users.surql` (with DEFINE ACCESS bp_auth) to Saturn's `users/users` DB. Create `bp_portal` DB user on `company_sawasdee`. Set `password_hash` on real user records.
4. 🚀 **Deploy + E2E verify** — Build with `--dart-define=BP_PORTAL_PASS=<secret>`, deploy to Saturn :8003, verify login with real user credentials.
5. 🧪 **Update unit/widget tests** — Verify mock-based tests still compile with the new `SurrealAuthService` constructor (serviceUser/servicePass params).
