# Pulse — Current Project State

**Last Updated:** 2026-06-20 12:26
**Session Focus:** Quality Audit + Saturn DB Wipe + Admin Panel NULL→NONE Fix + Deploy

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Phase 5 layout implemented. Saturn DB wiped clean and re-provisioned with schemas only. Admin Panel CREATE user NULL→NONE bug fixed and deployed. Pending: create users/companies from Admin Panel, then E2E verification.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete in plan. Auth is NS-level (VPN-only, ADR-0007). Redeployed to Saturn with NULL→NONE fix.

## ✅ Recently Completed

- **2026-06-20** — Saturn DB wiped clean (all company DBs + users removed). Re-applied init + schemas (users, registry, discovery). Created 2 NS OWNER users (arnarvalur, gurkudrengur). Fixed Admin Panel CREATE user NULL→NONE coercion for `company_slug` and `vipps_sub`. Verified fix against real Saturn DB. Rebuilt + deployed Admin Panel. Removed oasai references from conductor context.
- **2026-06-20** — Quality audit of overnight Gemini 3.5 session (8.2/10). Fixed 4 stale `platform`→`registry` references across README, seed script, platform.surql (commit `12511cf`).
- **2026-06-20** — Database cleanup: fixed `opening_schedule` schema blocker (DEFAULT {}), dropped legacy `users/profiles` on Saturn, fixed `init.surql` naming (platform→registry), updated stale ADR-0002 and ADR-0016.
- **2026-06-19** — Phase 5 layout: scrollspy edit view, sidebar identity, login branding, Riverpod state sync fix.
- **2026-06-19** — Admin Panel rebuilt + deployed to Saturn. Company-blueprint applied to `company_house-of-the-north`.

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
- **NULL vs NONE (2026-06-20):** SurrealDB `option<T>` accepts `NONE` (absent) or `T`, but rejects `NULL`. Dart null maps to SurrealDB NULL. All CREATE queries must coerce: `IF $field = NULL THEN none ELSE $field END`. UPDATE in admin repo already did this; CREATE didn't — now fixed.
- **Quality audit (2026-06-20):** Overall 8.2/10. Code 8, Schema 8, Tests 7, ADR 9, Shared pkg 9. Nice-to-have: widget tests for DittoScrollspyLayout/DittoDashboardShell, magic number extraction, AnimatedDefaultTextStyle cleanup.
- **Mock tests blind spot (2026-06-20):** Admin Panel user creation tests mock the repository (`createUser => user`), so the NULL coercion bug was invisible. Integration tests only cover the login path, not creation. Always verify DB-touching fixes against real SurrealDB before deploying.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Admin Panel E2E:** Log in as `arnarvalur` → create users (Arnar, Höddi) → create company → verify company DB gets blueprint applied.
2. 🟡 **BP E2E:** Log in as business user → list establishments → create establishment → verify scrollspy edit view.
3. 🟡 **BP Web Build + Deploy:** Rebuild BP web and deploy to Saturn after users/companies exist.
4. 🟢 **Phase 5 Completion:** Fix navigation/state issues, responsive tweaks, coverage gate. Checkpoint Phase 5.
