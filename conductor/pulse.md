# Pulse — Current Project State

**Last Updated:** 2026-06-19 18:35
**Session Focus:** Nuxt landing page maintenance redirect deployment.

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Auth implementation now code-complete: DB consolidated (`profiles` → `users`), password hashing (argon2) in Admin Panel, RECORD ACCESS `bp_auth` on Saturn, `bp_portal` service users provisioned. BP built with `--dart-define=BP_PORTAL_PASS=test-portal-pass`. **Awaiting E2E login test** (deploy needs `sudo` on Saturn).
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete in plan. Auth is NS-level (VPN-only, ADR-0007). Deployed to Saturn. Password field added to user CRUD dialogs this session.

## ✅ Recently Completed

- **2026-06-19** — Nuxt landing page maintenance: Enforced maintenance mode globally (both client and server-side redirects), revamped the Norwegian coming-soon page with Moody Blue theme and a smiley (removing the Merkurial Studio footer), built the Docker image, and deployed to Cloud Run.
- **2026-06-19** — BP Auth full-stack fix: DB consolidation `profiles` → `users`, argon2 password hashing, Admin Panel password fields, Saturn DB migration (3 users + bp_auth ACCESS + bp_portal service users), BP web build. All tests green (7 admin, 25 BP unit).
- **2026-06-14** — BP Phases 1–4: Stitch Enterprise Slate light theme, Norwegian login UI, Establishments list, create dialog, 4-tab edit view. 94 tests.
- **2026-06-09** — BP scaffold deployed to Saturn. E2E login verified.
- **2026-06-09** — ADR-0015: No hardcoded secrets/IDs. `code-safety.md` agent rule.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **Admin Panel needs rebuild + redeploy** to pick up the DB consolidation (`profiles` → `users`) and password field changes.

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002`
- **Business Portal:** `http://dittodatto:8003`
- **Admin deploy:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Portal deploy:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/` (then `sudo rsync` from `/tmp/bp-web-deploy/` to `/srv/...`)
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both namespaces) — Admin Panel only.
- **BP auth model (ADR-0016):** RECORD ACCESS `bp_auth` on `users/users` → argon2 password_hash validation via **full email** (not username prefix). Service user `bp_portal` (EDITOR) on each `company_{slug}` DB. Password via `--dart-define=BP_PORTAL_PASS=<secret>`.
- **Schemas source of truth:** `schemas/` at project root.
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **Test DB:** `./scripts/test-db-up.sh` → ephemeral SurrealDB on port 18000. `flutter test --tags integration`. `./scripts/test-db-down.sh` to tear down.
- **Port reservations:** :8001 SurrealDB Hub, :8002 Admin Panel, :8003 Business Portal, :8004 Public Marketplace (reserved), :8005 Booking Engine (reserved).
- **DB Consolidation (2026-06-19):** Legacy `users/profiles` DB replaced by canonical `users/users`. All Admin Panel code updated. Saturn migrated — 3 users now exist in `users/users` with argon2 password hashes.
- **BP build password:** `BP_PORTAL_PASS=test-portal-pass` (staging-only). Used for `bp_portal` DB user on each `company_{slug}` DB.
- **Demo Dude login:** email `arnarvalurjonsson@gmail.com`, password `admin123`, company `house-of-the-north`.
- **Company DBs on Saturn:** `company_dittodatto-as`, `company_house-of-the-north`. Both have `bp_portal` service user.
- **RECORD ACCESS permissions (2026-06-19):** SCHEMAFULL tables default to deny-all for record-scoped tokens. Must define `PERMISSIONS FOR select WHERE id = $auth.id` so `$auth` queries work. Applied to `user` table in `schemas/users.surql`, `bootstrap.surql`, and Saturn.
- **Email validation (2026-06-19):** `bp_auth` SIGNIN matches on full `email` field, not `username` prefix. Client sends `email.trim().toLowerCase()`. Tests verify that wrong domain is rejected.
- **Nuxt Landing Page (2026-06-19):** Enforced global maintenance redirect both server-side and client-side. Revamped the Norwegian coming-soon page with Moody Blue brand accents, separated the emoji from the gradient span to fix browser text-clipping issues, and removed the Merkurial Studio footer. Built the container locally and deployed to Cloud Run.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Rebuild + redeploy Admin Panel** — picks up DB consolidation + password fields.
2. 🟡 **Apply company-blueprint schema** to `company_house-of-the-north` — currently empty (no tables), so establishments won't load yet.
3. 🟢 **Clean up legacy `users/profiles` DB** on Saturn.
4. 🟢 **Phase 5: Integration & Polish** — the last phase of the BP track.
