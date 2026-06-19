# Pulse — Current Project State

**Last Updated:** 2026-06-19 20:42
**Session Focus:** Infra prep (Admin rebuild + company-blueprint) + Phase 5 design planning.

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Auth E2E verified. Phase 5 plan approved — sidebar identity, login cleanup, scrollable establishment edit (replace tabs with scrollspy sections), E2E + responsive + coverage. Theme switching deferred to Phase 6.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. All 5 phases complete in plan. Auth is NS-level (VPN-only, ADR-0007). Deployed to Saturn. Password field added to user CRUD dialogs this session.

## ✅ Recently Completed

- **2026-06-19** — Admin Panel rebuilt + deployed to Saturn. Company-blueprint applied to `company_house-of-the-north` (18 tables + 3 relations). Both infra blockers cleared ahead of Phase 5.
- **2026-06-19** — Nuxt landing page maintenance: Enforced maintenance mode globally (both client and server-side redirects), revamped the Norwegian coming-soon page with Moody Blue theme and a smiley (removing the Merkurial Studio footer), built the Docker image, and deployed to Cloud Run.
- **2026-06-19** — BP Auth full-stack fix: DB consolidation `profiles` → `users`, argon2 password hashing, Admin Panel password fields, Saturn DB migration (3 users + bp_auth ACCESS + bp_portal service users), BP web build. All tests green (7 admin, 25 BP unit).
- **2026-06-14** — BP Phases 1–4: Stitch Enterprise Slate light theme, Norwegian login UI, Establishments list, create dialog, 4-tab edit view. 94 tests.
- **2026-06-09** — BP scaffold deployed to Saturn. E2E login verified.
- **2026-06-09** — ADR-0015: No hardcoded secrets/IDs. `code-safety.md` agent rule.

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
- **DB Consolidation (2026-06-19):** Legacy `users/profiles` DB replaced by canonical `users/users`. All Admin Panel code updated. Saturn migrated — 3 users now exist in `users/users` with argon2 password hashes.
- **BP build password:** `BP_PORTAL_PASS=test-portal-pass` (staging-only). Used for `bp_portal` DB user on each `company_{slug}` DB.
- **Demo Dude login:** email `arnarvalurjonsson@gmail.com`, password `admin123`, company `house-of-the-north`.
- **Company DBs on Saturn:** `company_dittodatto-as`, `company_house-of-the-north`. Both have `bp_portal` service user.
- **RECORD ACCESS permissions (2026-06-19):** SCHEMAFULL tables default to deny-all for record-scoped tokens. Must define `PERMISSIONS FOR select WHERE id = $auth.id` so `$auth` queries work. Applied to `user` table in `schemas/users.surql`, `bootstrap.surql`, and Saturn.
- **Email validation (2026-06-19):** `bp_auth` SIGNIN matches on full `email` field, not `username` prefix. Client sends `email.trim().toLowerCase()`. Tests verify that wrong domain is rejected.
- **Nuxt Landing Page (2026-06-19):** Enforced global maintenance redirect both server-side and client-side. Revamped the Norwegian coming-soon page with Moody Blue brand accents, separated the emoji from the gradient span to fix browser text-clipping issues, and removed the Merkurial Studio footer. Built the container locally and deployed to Cloud Run.
- **Phase 5 design decisions (2026-06-19):** Tabs → scrollable card sections with scrollspy. Sidebar: company name top, full name bottom, Inbox after Dashboard. Login: email+password only, "DittoDatto Forretningsportal" branding, "Kontakt oss ved problemer" instead of "Kontakt administrator for tilgang". Theme switching = Phase 6. Implementation plan artifact: `brain/96918de2.../implementation_plan.md`.
- **SurrealDB container name on Saturn:** `dittodatto-hub` (in `dittodatto-net` Docker network). Minimal container — no shell utils, connect remotely via Tailscale instead of `docker exec`.
- **company_house-of-the-north:** Full company-blueprint applied (18 tables + 3 relations). Ready for BP E2E testing.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🟡 **Phase 5: Implement** — open new session, reference implementation plan. Sub-phases: 5a sidebar, 5b login, 5c scrollspy edit, 5d E2E+responsive+coverage.
2. 🟢 **Phase 6: Theme session** — grill + implement light/dark switching, DittoDashboardShell theme-awareness, typography unification.
3. 🟢 **Clean up legacy `users/profiles` DB** on Saturn.
