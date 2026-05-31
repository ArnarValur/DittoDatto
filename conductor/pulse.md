# Pulse — Current Project State

**Last Updated:** 2026-06-01 00:15
**Session Focus:** Admin Panel — Users screen premium redesign, search & manual registration, and HTTP Web Storage fallback fix.

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional with real SurrealDB namespace users. Web Storage fallback implemented to bypass Web Crypto crashes on non-secure HTTP. Premium Users screen completed (checkbox selections, truncated IDs, initials badges, restricted role promotions, case-insensitive SurrealDB search, and manual user registration dialog). Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-01** — **Users screen premium redesign.** Redesigned table layout to match mockup (initials badges, subtext email, options menu, truncated IDs). Excluded administrative accounts from back-office lists.
- **2026-06-01** — **Staging Web HTTP Secure Context fix.** Solved browser Web Crypto initialization crashes under non-secure HTTP Origin by introducing conditional compile-time `WebStorage` localStorage fallback.
- **2026-06-01** — **SurrealDB search & manual registration.** Implemented dynamic case-insensitive text search and manual user provisioning in `SurrealAdminRepository`.
- **2026-06-01** — **Verification logging.** Created verification log registry and playbooks under `conductor/tests/admin-panel/verification-log.md`.
- **2026-05-30** — **Auth infrastructure overhaul.** Fixed GoRouter recreation bug (→ refreshListenable). Switched AuthNotifier to AsyncNotifier. Added JWT persistence via FlutterSecureStorage. Created namespace users `arnarvalur` and `gurkudrengur`. Cleaned bootstrap.surql to schema-only. Tests green. Deployed.
- **2026-05-30** — **Live SurrealDB wiring.** Removed MockAdminRepository, MockAuthService, USE_MOCKS flag. Fixed login autofill. Migrated schemas. Built and deployed to Saturn. Login verified working.
- **2026-05-30** — **Grill admin-panel.** PRD updated to v1.2. Dashboard deprioritized. Category model confirmed correct. ADR subdirectories created.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto.tailb251cd.ts.net:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces). Legacy `arnar`/`hoddi` still exist on server.
- **Database is empty** — no records. Real data created via Admin Panel.
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`. Global sequential numbering.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.
- *2026-06-01 - 00:10* — Restricted back-office Users screen list and role modification options to `customer` and `business` only. _(operational)_
- *2026-06-01 - 00:12* — Bypass Web Crypto secure-context crashes on Web targets by introducing conditional WebStorage fallback using standard window.localStorage under HTTP. _(operational)_

## 📋 Next Session Suggestions

1. 🖥️ **Verify all other screens (Companies, Categories, Dashboard) on Saturn** to confirm they load and function correctly.
2. 🧹 **Remove legacy namespace users** — `arnar` and `hoddi` still exist on Saturn. Delete if no longer needed.
3. 📦 **Inbox real data path** — Currently hardcoded app-local. Needs repository pattern when messaging is grilled.
