# Pulse — Current Project State

**Last Updated:** 2026-06-19 15:38
**Session Focus:** BP auth implementation — full stack fix from Admin Panel to Saturn DB to deployment.

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Auth implementation now code-complete: DB consolidated (`profiles` → `users`), password hashing (argon2) in Admin Panel, RECORD ACCESS `bp_auth` on Saturn, `bp_portal` service users provisioned. BP built with `--dart-define=BP_PORTAL_PASS=test-portal-pass`. **Awaiting E2E login test** (deploy needs `sudo` on Saturn).
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete in plan. Auth is NS-level (VPN-only, ADR-0007). Deployed to Saturn. Password field added to user CRUD dialogs this session.

## ✅ Recently Completed

- **2026-06-19** — BP Auth full-stack fix: DB consolidation `profiles` → `users`, argon2 password hashing, Admin Panel password fields, Saturn DB migration (3 users + bp_auth ACCESS + bp_portal service users), BP web build. All tests green (7 admin, 25 BP unit).
- **2026-06-14** — BP Phases 1–4: Stitch Enterprise Slate light theme, Norwegian login UI, Establishments list (card grid + tab filters + badges), create dialog, 4-tab edit view. 94 tests across 3 suites.
- **2026-06-09** — BP scaffold deployed to Saturn. E2E login verified.
- **2026-06-09** — ADR-0015: No hardcoded secrets/IDs. `code-safety.md` agent rule.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **BP deployment needs `sudo`** on Saturn to write to `/srv/dittodatto/business-portal/web/`. Build artifacts are staged at `saturn:/tmp/bp-web-deploy/`. Run: `sudo rsync -avz --delete /tmp/bp-web-deploy/ /srv/dittodatto/business-portal/web/`
- **Admin Panel needs rebuild + redeploy** to pick up the DB consolidation (`profiles` → `users`) and password field changes.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Portal deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces) — Admin Panel only.
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash validation. Service user `bp_portal` (EDITOR) on each `company_{slug}` DB. Password via `--dart-define=BP_PORTAL_PASS=<secret>`.
- **Schemas source of truth:** `schemas/` at project root.
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh` to tear down.
- **Port reservations:** :8001 SurrealDB Hub, :8002 Admin Panel, :8003 Business Portal, :8004 Public Marketplace (reserved), :8005 Booking Engine (reserved).
- **DB Consolidation (2026-06-19):** Legacy `users/profiles` DB replaced by canonical `users/users`. All Admin Panel code updated. Saturn migrated — 3 users now exist in `users/users` with argon2 password hashes. Old `profiles` DB still exists on Saturn (data duplicated, not deleted) as fallback.
- **BP build password:** `BP_PORTAL_PASS=test-portal-pass` (staging-only). Used for `bp_portal` DB user on each `company_{slug}` DB.
- **Demo Dude login:** email `arnarvalurjonsson@gmail.com`, username `arnarvalurjonsson`, password `admin123`, company `house-of-the-north`.
- **Company DBs on Saturn:** `company_dittodatto-as`, `company_house-of-the-north` (created this session). Both have `bp_portal` service user.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Deploy BP to Saturn** — `sudo rsync` from `/tmp/bp-web-deploy/` to `/srv/dittodatto/business-portal/web/`.
2. 🔴 **E2E login test** — Login as Demo Dude (arnarvalurjonsson / admin123) → verify `house-of-the-north` company loads.
3. 🟡 **Rebuild + redeploy Admin Panel** — picks up DB consolidation + password fields.
4. 🟡 **Apply company-blueprint schema** to `company_house-of-the-north` — currently empty (no tables), so establishments won't load yet.
5. 🟢 **Clean up legacy `users/profiles` DB** on Saturn once E2E verified.
