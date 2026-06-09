# Pulse — Current Project State

**Last Updated:** 2026-06-09 16:30
**Session Focus:** E2E steel thread — Business Portal login verification and Saturn staging deployment.

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional. Premium Users screen completed. Categories screen upgraded. Deployed to Saturn. Role management supports administrative roles.

## ✅ Recently Completed

- **2026-06-09** — **Business Portal E2E Login & Saturn Deployment.** Wired `SURREAL_URL` dart-define, verified login against Saturn SurrealDB, built web release, deployed to Saturn port 8005 with dedicated `dittodatto-portal-caddy` container. Login flow confirmed working end-to-end.
- **2026-06-09** — **Code Quality Safeguards.** ADR-0015 (no hardcoded secrets/IDs). Created `code-safety.md` agent rule. Remediated all bin/ scripts. Deleted obsolete scripts.
- **2026-06-09** — **Business Portal Scaffold Track COMPLETE.** 22 tests green. Checkpoint: `eadc310`. Track closed.
- **2026-06-08** — **Business Portal RBAC & Tenant Auth Spec.** ADR-0013 recorded.
- **2026-06-08** — **Administrative Roles Support.** All 4 roles in Admin Panel Users screen.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- *2026-06-09 - 16:30* — Business Portal staging deployed to Saturn port 8005 with dedicated Caddy container (`dittodatto-portal-caddy`). Ports 8003/8004 occupied by terminal-arnar/terminal-hoddi. _(operational)_
- *2026-06-09 - 16:30* — `SURREAL_URL` injected via `--dart-define` at build time per ADR-0015 pattern. No hardcoded URLs. Empty default falls back to page-origin derivation (works behind Caddy reverse proxy). _(operational)_

- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Admin deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Business Portal deployed:** `http://dittodatto:8005` — Caddy serves from `/srv/dittodatto/business-portal/web/`, proxies `/rpc` to SurrealDB.
- **Portal deploy command:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces).
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.
- **PostIt (State Management):** Investigate whether to adopt Riverpod 2.x or BLoC + GetIt for managing SurrealDB real-time Live Queries.
- **PostIt (Offline Cache):** Decide on implementing custom local database caching vs direct-only connection.
- **PostIt (Maps Engine):** Determine if we should adopt OpenStreetMap (`flutter_map`) or stick with Google Maps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🎨 **Design Grill for Business Portal Login** — Refine the login screen aesthetics (user has Nuxt UI reference screenshot for desired look).
2. 🏗️ **Start Establishments CRUD Track** — Begin the next Business Portal feature track: outlet management (create, edit, list establishments).
3. 🔬 **Resolve open PostIts** — State management (Riverpod vs BLoC), offline caching strategy, maps engine decision.
