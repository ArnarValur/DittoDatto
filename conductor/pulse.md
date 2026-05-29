# Pulse — Current Project State

**Last Updated:** 2026-05-29 15:40 (post `/checkpoint`)
**Session Focus:** Admin Panel Saturn deployment — real SurrealDB wiring + Caddy reverse proxy

## 🚀 Active Tracks

- **admin_panel_20260527** — Admin Panel Flutter breaker box. Deployed to Saturn at `http://saturn:8002`. Wired to real SurrealDB (namespace auth, dual-WS connections). All 5 screens implemented. Minor tweaks needed (non-blocking cleanup). [Link](./tracks/admin-panel/admin_panel_20260527/)

## ✅ Recently Completed

- **2026-05-29** — **Saturn deployment sprint.** Admin panel deployed to Saturn via Caddy-in-Docker. SurrealDB bootstrapped (namespaces, schemas, namespace users, 23 seed records). `SurrealAuthService` + `SurrealAdminRepository` implemented. Flutter web build served at `http://saturn:8002` with `/rpc` reverse proxying to SurrealDB on `dittodatto-net`. ADR-0015 written.
- **2026-05-29** — **Phase 1 & 2 complete.** Created three emulators (`pixel_7_api_35`, `pixel_tablet_api_35`, `generic_tablet_api_35`) and verified them with Flutter. Wrote robust widget test suite in `apps/admin` (100% green) utilizing synchronous `FakeAuthService` to prevent async timer leaks. Audited codebase for hardcoded mocks and aligned on extracting them to separate JSON files to obey Clean Code rules.
- **2026-05-27** — **`/new-track admin-panel` created.** Track `admin_panel_20260527` with 5-phase TDD plan. Spec anchored to PRD v1.1 + ADR-0006/0013/0014. Key decisions: mock-first API (no backend dependency), clean-room port from old architecture, Dart Workspaces monorepo (3 packages from day one), Riverpod 3.3.1 + GoRouter 17.2.3 + all deps latest stable.
- **2026-05-27 (~00:22)** — **`/grill flutter-design-system` complete.** ADR-0014 written. `ditto_design` package defined. SolarTheme exploration doc written.
- **2026-05-26 (late night)** — **`/grill admin-panel` complete.** ADR-0013 written. PRD v1.0 created. 6 glossary updates. Scope locked: 5 screens + Inbox.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine) · Dart / Flutter / Riverpod / GoRouter (Admin + future Portal + Marketplace) · TypeScript / Vue 3 / Nuxt 4 (`dittodatto.no` landing only) · SurrealDB 3.0 (sole platform DB).
- **Admin Panel deployed:** `http://saturn:8002` — Caddy on `dittodatto-net`, SurrealDB on port 8001. Two namespace users (arnar + hoddi).
- *2026-05-29* — HTTP on Tailscale for now. HTTPS deferred — needs caddy-tailscale plugin (custom build) or sudo for `tailscale cert`. WireGuard encrypts transport. _(operational)_
- *2026-05-29* — Single-origin architecture: Caddy on :8002 serves Flutter web + reverse proxies `/rpc` to SurrealDB. No CORS needed. _(operational)_
- *2026-05-29* — Mock/real toggle via `--dart-define=USE_MOCKS=true`. Local dev uses mocks, production builds use real SurrealDB. _(operational)_
- *2026-05-29* — Some minor tweaks needed from this deployment session — non-blocking cleanup. Details to be reviewed next session.
- *2026-05-29* — Ask Arnar about the network setup / Tailscale FQDN resolution next session.

## 📋 Next Session Suggestions

1. 🔍 **Browser-verify Saturn deployment** — Open `http://saturn:8002`, login as arnar@dittodatto.no, verify Dashboard stats + CRUD on all screens.
2. 🧹 **Cleanup tweaks** — Minor non-blocking cleanup from deployment sprint.
3. 🔒 **HTTPS setup** — Resolve Tailscale cert provisioning (caddy-tailscale plugin or manual `tailscale cert` with sudo).
4. 🔄 **CI/CD pipeline** — Automate `flutter build web → rsync → Saturn` for future deploys.
5. 📋 **Update track plan** — Plan.md is stale (reflects Phase 2, but Phases 3-4 are implemented + Saturn deployment is done). Sync plan with reality.
