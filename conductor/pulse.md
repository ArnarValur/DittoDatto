# Pulse — Current Project State

**Last Updated:** 2026-05-29 18:30 (post `/checkpoint`)
**Session Focus:** Admin Panel connectivity sprint — SurrealDB healthcheck, Riverpod reactive provider refactoring, and Tailscale service routing

## 🚀 Active Tracks

- **admin_panel_20260527** — Admin Panel Flutter breaker box. Deployed to Saturn at `http://dittodatto:8002` behind Tailscale. Wired to real SurrealDB (namespace auth, dual-WS connections). Core screens implemented. Deployment verification and polish in progress.

## ✅ Recently Completed

- **2026-05-29** — **Admin Panel connectivity sprint.** Restructured `adminRepositoryProvider` to watch `authProvider` reactively to prevent stale mock-data caching. Restricted Saturn ports to local loopback (`127.0.0.1`) for exclusive Tailscale service routing. Solved SurrealDB's Docker healthcheck using the native distroless-friendly `is-ready` command (database container is now 100% healthy!). Built and deployed the production web app (`USE_MOCKS=false`) to Saturn via `rsync` and verified successful Surrealist connectivity.
- **2026-05-29** — **Saturn deployment sprint.** Admin panel deployed to Saturn via Caddy-in-Docker. SurrealDB bootstrapped (namespaces, schemas, namespace users, 23 seed records). `SurrealAuthService` + `SurrealAdminRepository` implemented. Flutter web build served at `http://saturn:8002` with `/rpc` reverse proxying to SurrealDB on `dittodatto-net`. ADR-0006 written.
- **2026-05-29** — **Phase 1 & 2 complete.** Created three emulators (`pixel_7_api_35`, `pixel_tablet_api_35`, `generic_tablet_api_35`) and verified them with Flutter. Wrote robust widget test suite in `apps/admin` (100% green) utilizing synchronous `FakeAuthService` to prevent async timer leaks. Audited codebase for hardcoded mocks and aligned on extracting them to separate JSON files to obey Clean Code rules.
- **2026-05-27** — **`/new-track admin-panel` created.** Track `admin_panel_20260527` with 5-phase TDD plan. Spec anchored to PRD v1.1 + ADR-0004/0005/0006. Key decisions: mock-first API (no backend dependency), clean-room port from old architecture, Dart Workspaces monorepo (3 packages from day one), Riverpod 3.3.1 + GoRouter 17.2.3 + all deps latest stable.
- **2026-05-27 (~00:22)** — **`/grill flutter-design-system` complete.** ADR-0005 written. `ditto_design` package defined. SolarTheme exploration doc written.
- **2026-05-26 (late night)** — **`/grill admin-panel` complete.** PRD v1.0 created. 6 glossary updates. Scope locked: 5 screens + Inbox.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine) · Dart / Flutter / Riverpod / GoRouter (Admin + future Portal + Marketplace) · TypeScript / Vue 3 / Nuxt 4 (`dittodatto.no` landing only) · SurrealDB 3.0 (sole platform DB).
- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy on `dittodatto-net` listening locally on `127.0.0.1:8002` and reverse proxying to SurrealDB, fully sandboxed behind Tailscale.
- _2026-05-29_ — Restrict container port bindings to 127.0.0.1 on Saturn to route strictly through Tailscale services _(operational)_
- _2026-05-29_ — Refactor adminRepositoryProvider to watch authProvider reactively to prevent silent mock caching _(operational)_
- _2026-05-29_ — HTTP on Tailscale for now. HTTPS deferred — needs caddy-tailscale plugin (custom build) or sudo for `tailscale cert`. WireGuard encrypts transport. _(operational)_
- _2026-05-29_ — Single-origin architecture: Caddy on :8002 serves Flutter web + reverse proxies `/rpc` to SurrealDB. No CORS needed. _(operational)_
- _2026-05-29_ — Mock/real toggle via `--dart-define=USE_MOCKS=true`. Local dev uses mocks, production builds use real SurrealDB. _(operational)_

## 📋 Next Session Suggestions

1. 📋 **Plan next domains** — Prepare `/grill business-portal` or `/grill public-marketplace` to scope subsequent developer tracks.
2. 🔒 **HTTPS setup** — Resolve Tailscale cert provisioning (caddy-tailscale plugin or manual `tailscale cert` with sudo).
3. 🔄 **CI/CD pipeline** — Automate `flutter build web → rsync → Saturn` for future deploys.

