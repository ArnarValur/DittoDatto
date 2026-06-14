# Pulse — Current Project State

**Last Updated:** 2026-06-14 15:30
**Session Focus:** BP Login + Establishments — Phases 1–4 implementation (light theme, login redesign, establishments CRUD, create/edit views)

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete (light theme, login, list, create/edit). Phase 5 (DB wiring, integration polish) next session.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional. Premium Users screen completed. Categories screen upgraded. Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-14** — **BP Login + Establishments Phases 1–4.** Light theme (Stitch Enterprise Slate), login redesign (Norwegian bokmål), establishments list (card grid + tab filters + badges), create dialog, 4-tab edit view. 94 tests across 3 suites. 7 commits on `track/bp-login-establishments`.
- **2026-06-09** — **Business Portal E2E Login & Saturn Deployment.** Wired `SURREAL_URL` dart-define, verified login against Saturn SurrealDB, deployed to Saturn port 8005.
- **2026-06-09** — **Code Quality Safeguards.** ADR-0015 (no hardcoded secrets/IDs). Created `code-safety.md` agent rule.
- **2026-06-09** — **Business Portal Scaffold Track COMPLETE.** 22 tests green. Track closed.
- **2026-06-08** — **Business Portal RBAC & Tenant Auth Spec.** ADR-0013 recorded.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- *2026-06-14 - 15:30* — BP uses `DittoTheme.light` (Stitch Enterprise Slate), Admin stays `DittoTheme.dark`. Typography split: Outfit+Manrope (BP light), Inter (Admin dark). _(operational)_
- *2026-06-14 - 15:30* — Establishments `store_type` enum (store/restaurant/venue) mapped to Norwegian labels (Butikk/Restaurant/Spillested). Matches SurrealDB schema. _(operational)_
- *2026-06-14 - 15:30* — Saturn Tailscale Service: `dittodatto` → `100.121.237.101`, ports 8001-8005. Short domain `dittodatto`, full domain `dittodatto.tailb251cd.ts.net`. _(operational)_
- *2026-06-14 - 15:30* — Local dev workflow: `flutter run -d chrome --web-port 8085 --dart-define=SURREAL_URL=ws://dittodatto:8001/rpc` on Pluto. Deploy to Saturn when happy. _(operational)_
- *2026-06-14 - 15:30* — BP Caddy container (`dittodatto-portal-caddy`) runs standalone — NOT in `dittodatto-net` compose file. Needs cleanup in future infra session. _(operational)_
- *2026-06-14 - 15:30* — Establishments screen shows "Feil: Exception: Specify a database to use" — need `USE DB company_{slug}` after login. Wiring deferred to next session. _(operational)_

- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Admin deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **Business Portal deployed:** `http://dittodatto:8005` — Caddy serves from `/srv/dittodatto/business-portal/web/`, proxies `/rpc` to SurrealDB.
- **Portal deploy command:** `rsync -avz --delete apps/business-portal/build/web/ saturn:/srv/dittodatto/business-portal/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces).
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔌 **Wire Establishments to SurrealDB** — Add `USE DB company_{slug}` after login in the auth service. Fix "Specify a database to use" error.
2. 🧪 **Phase 5: Integration & Polish** — E2E login → list → create → edit flow. Responsive layout verification. Coverage gate.
3. 🚀 **Deploy BP to Saturn** — Build web release, rsync to `/srv/dittodatto/business-portal/web/`, verify at `http://dittodatto:8005`.
4. 🛠️ **Create deploy skill** — Automate build + deploy for both Admin and BP apps.
5. 🧹 **Saturn Docker cleanup** — Add BP Caddy to compose, organize port assignments.
