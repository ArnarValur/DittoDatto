# Pulse — Current Project State

**Last Updated:** 2026-05-30 13:35
**Session Focus:** Conductor workflow standardization, init workflow removal, and Admin Panel track status reversion

## 🚀 Active Tracks

- **Admin Panel** — In-progress; pending complete `/grill` and alignment session. The codebase was scaffolded in previous sessions but has not been reviewed or approved.

## ✅ Recently Completed

- **2026-05-29** — **Saturn infrastructure sprint.** Solved SurrealDB's Docker healthcheck on Saturn using the native `is-ready` command. Restrained all database/caddy staging ports to local loopback (`127.0.0.1`) for Tailscale service routing. Deployed Caddy staging reverse proxy to serve static web files and proxy `/rpc` on `dittodatto-net`.
- **2026-05-27** — **`/new-track admin-panel` created.** Track `admin_panel_20260527` initialized.
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

