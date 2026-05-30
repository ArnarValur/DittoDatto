# Pulse — Current Project State

**Last Updated:** 2026-05-30 17:44
**Session Focus:** Admin Panel — real auth, session persistence, router fix

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional with real SurrealDB namespace users. Session persistence via FlutterSecureStorage. Router guard fixed. Deployed to Saturn.

## ✅ Recently Completed

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

## 📋 Next Session Suggestions

1. 🖥️ **Browser-verify all CRUD screens** — Users, Companies, Categories against empty DB, then create real records.
2. 🧹 **Remove legacy namespace users** — `arnar` and `hoddi` still exist on Saturn. Delete if no longer needed.
3. 📦 **Inbox real data path** — Currently hardcoded app-local. Needs repository pattern when messaging is grilled.
