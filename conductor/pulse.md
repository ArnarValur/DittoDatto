# Pulse — Current Project State

**Last Updated:** 2026-06-20 02:29
**Session Focus:** Gemini 3.5 Session Audit + Database Cleanup + Schema Fix + Code Commit

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Phase 5 layout implemented (scrollspy, sidebar identity, login branding). Schema blocker (`opening_schedule`) resolved. Pending: E2E verification on Saturn, responsive tweaks, coverage gate.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete in plan. Auth is NS-level (VPN-only, ADR-0007). Deployed to Saturn. Code aligned with `users/users` DB consolidation.

## ✅ Recently Completed

- **2026-06-20** — Database cleanup: fixed `opening_schedule` schema blocker (DEFAULT {}), dropped legacy `users/profiles` on Saturn, fixed `init.surql` naming (platform→registry), updated stale ADR-0002 and ADR-0016. Committed all Gemini 3.5 session code in 6 logical commits. Fixed scrollspy 200px magic number.
- **2026-06-19** — Phase 5 layout: scrollspy edit view, sidebar identity, login branding, Riverpod state sync fix. Schema validation bug diagnosed.
- **2026-06-19** — Admin Panel rebuilt + deployed to Saturn. Company-blueprint applied to `company_house-of-the-north`.
- **2026-06-19** — Nuxt landing page maintenance: global maintenance redirect, Moody Blue coming-soon page, deployed to Cloud Run.
- **2026-06-19** — BP Auth full-stack fix: DB consolidation, argon2 hashing, Saturn migration. All tests green.

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
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces) — Admin Panel only.
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash validation via **full email** (not username prefix). Service user `bp_portal` (EDITOR) on each `company_{slug}` DB. Password via `--dart-define=BP_PORTAL_PASS=<secret>`.
- **Schemas source of truth:** `schemas/` at project root.
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh` to tear down.
- **Port reservations:** :8001 SurrealDB Hub, :8002 Admin Panel, :8003 Business Portal, :8004 Public Marketplace (reserved), :8005 Booking Engine (reserved).
- **BP build password:** `BP_PORTAL_PASS=test-portal-pass` (staging-only). Used for `bp_portal` DB user on each `company_{slug}` DB.
- **Demo Dude login:** email `arnarvalurjonsson@gmail.com`, password `admin123`, company `house-of-the-north`.
- **Company DBs on Saturn:** `company_dittodatto-as`, `company_house-of-the-north`. Both have `bp_portal` service user.
- **SurrealDB container name on Saturn:** `dittodatto-hub` (in `dittodatto-net` Docker network). Minimal container — no shell utils, connect remotely via Tailscale instead of `docker exec`.
- **DB topology (clean as of 2026-06-20):** `companies` NS (company_dittodatto-as, company_house-of-the-north, discovery, registry) + `users` NS (users). Legacy `profiles` DB dropped. `oasai` NS (vectors) is OpenWebUI — leave it.
- **SurrealDB CLI gotcha:** DB names with hyphens (e.g. `company_dittodatto-as`) must be backtick-quoted in SurrealQL: `` USE NS companies DB `company_dittodatto-as`; ``
- **opening_schedule fix (2026-06-20):** Changed to `TYPE object DEFAULT {}` on both company DBs on Saturn. Establishment creation now works without sending this field.
- **Scrollspy threshold fix (2026-06-20):** Replaced hardcoded 200px with dynamic scroll view position calculation in `DittoScrollspyLayout._onScroll()`.
- **Gemini 3.5 audit findings (2026-06-20):** Session had scope creep (touched Admin Panel without being asked), hallucinated Flutter APIs (fixed by trial-and-error), and left all code uncommitted. All cleaned up and committed in logical groups. No lasting damage.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Phase 5 E2E Verification:** Login as Demo Dude → create establishment → verify it persists → verify scrollspy edit view. Test on mobile/tablet/desktop viewports.
2. 🟡 **BP Web Build + Deploy:** Rebuild BP web and deploy to Saturn to verify the fixes live.
3. 🟢 **Phase 5 Completion:** Fix any navigation/state issues discovered in E2E, complete responsive tweaks, run full coverage check. Then checkpoint Phase 5.
4. 🟢 **Phase 6: Theme session** — grill + implement light/dark switching, DittoDashboardShell theme-awareness, typography unification.
