# Pulse — Current Project State

**Last Updated:** 2026-06-14 18:17
**Session Focus:** BP Phase 4b/5 — Tenant-scoped login wiring (ADR-0013 steps 2+3). Debug DB communication layer.

## 🚀 Active Tracks

- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phases 1–4 complete. Phase 4b (tenant-scoped login) partially complete: login flow works, session restore broken. Phase 5 (integration) blocked until DB layer is tested properly.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional. Premium Users screen completed. Categories screen upgraded. Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-14** — **BP Tenant-Scoped Login (partial).** Wired ADR-0013 3-step login: NS auth → role verification via `users/profiles` → tenant routing to `company_{slug}`. Login confirmed working from server logs. Session restore (page refresh) hangs — needs investigation.
- **2026-06-14** — **BP Login + Establishments Phases 1–4.** Light theme (Stitch Enterprise Slate), login redesign (Norwegian bokmål), establishments list (card grid + tab filters + badges), create dialog, 4-tab edit view. 94 tests across 3 suites. 7 commits on `track/bp-login-establishments`.
- **2026-06-09** — **Business Portal E2E Login & Saturn Deployment.** Wired `SURREAL_URL` dart-define, verified login against Saturn SurrealDB, deployed to Saturn port 8005.
- **2026-06-09** — **Code Quality Safeguards.** ADR-0015 (no hardcoded secrets/IDs). Created `code-safety.md` agent rule.
- **2026-06-09** — **Business Portal Scaffold Track COMPLETE.** 22 tests green. Track closed.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **Session restore hangs on page refresh.** `tryRestore()` → `connectWithTokens()` → WebSocket `.wait()` or `.use()` never resolves. Root cause unknown. Blank screen, zero Dart console output. Needs focused investigation: compare Admin Panel pattern, test `surrealdb` SDK behavior with token-based auth + `.use()`.
- **No integration tests for DB communication.** All 48 BP tests use mock providers — none test real SurrealDB queries. Can't verify DB wiring changes without manual testing, which is unacceptable for production.

## 🧠 Session Memory

- *2026-06-14 - 18:17* — Login lookup uses `username` field (not `email`). NS auth username is the link between namespace identity and user records. Email domain in the login form is irrelevant — only the prefix matters for NS signin. _(operational)_
- *2026-06-14 - 18:17* — Session restore (`tryRestore`) hangs on page refresh. `connectWithTokens` with `.use()` on token-restored WebSocket connections causes blank screen. Needs investigation next session. _(operational)_
- *2026-06-14 - 18:17* — Existing BP tests use mock providers, not real SurrealDB. Integration tests against a real SurrealDB instance needed for auth+DB layer verification. _(operational)_
- *2026-06-14 - 18:17* — Two NS users confirmed in `users/profiles`: `arnarvalur` (slug: dittodatto-as, email: arnarvalur@avj.info) and `gurkudrengur` (slug: merkurial-studio, email: gurkudrengur@merkurial-studio.com). Both `super_admin`. Both have `username` field populated. _(operational)_
- *2026-06-14 - 15:30* — BP uses `DittoTheme.light` (Stitch Enterprise Slate), Admin stays `DittoTheme.dark`. Typography split: Outfit+Manrope (BP light), Inter (Admin dark). _(operational)_
- *2026-06-14 - 15:30* — Establishments `store_type` enum (store/restaurant/venue) mapped to Norwegian labels (Butikk/Restaurant/Spillested). Matches SurrealDB schema. _(operational)_
- *2026-06-14 - 15:30* — Saturn Tailscale Service: `dittodatto` → `100.121.237.101`, ports 8001-8005. Short domain `dittodatto`, full domain `dittodatto.tailb251cd.ts.net`. _(operational)_
- *2026-06-14 - 15:30* — Local dev workflow: `flutter run -d chrome --web-port 8085 --dart-define=SURREAL_URL=ws://dittodatto:8001/rpc` on Pluto. Deploy to Saturn when happy. _(operational)_
- *2026-06-14 - 15:30* — BP Caddy container (`dittodatto-portal-caddy`) runs standalone — NOT in `dittodatto-net` compose file. Needs cleanup in future infra session. _(operational)_

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

1. 🔍 **Investigate session restore hang** — Compare Admin Panel's `tryRestore`/reconnection pattern. Test `surrealdb` Dart SDK: does `.authenticate()` + `.use()` work on web? Add timeout and fallback.
2. 🧪 **Write integration tests for DB layer** — Create test harness that talks to real SurrealDB (embedded or Saturn). Test: login flow, tenant routing, establishments query, session restore.
3. 🚀 **Deploy working BP to Saturn** — Once DB wiring is verified, build and deploy. Login flow confirmed working — just session restore to fix.
4. 🎨 **UI tweaks** — User has gathered UI polish items to address.
5. 🛠️ **Create deploy skill** — Automate build + deploy for both Admin and BP apps.
