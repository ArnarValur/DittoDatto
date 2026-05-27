# Pulse — Current Project State

**Last Updated:** 2026-05-27 15:28 (post `/new-track admin-panel`)
**Session Focus:** Conductor resume → `/new-track admin-panel` — first implementation track created

## 🚀 Active Tracks

- **admin_panel_20260527** — Admin Panel Flutter breaker box. Phase 1 starting: Monorepo + `ditto_design` + Shell Scaffold. Mock-first API strategy. [Link](./tracks/admin-panel/admin_panel_20260527/)

## ✅ Recently Completed

- **2026-05-27** — **`/new-track admin-panel` created.** Track `admin_panel_20260527` with 5-phase TDD plan. Spec anchored to PRD v1.1 + ADR-0006/0013/0014. Key decisions: mock-first API (no backend dependency), clean-room port from old architecture, Dart Workspaces monorepo (3 packages from day one), Riverpod 3.3.1 + GoRouter 17.2.3 + all deps latest stable. Old codebase inventoried (~3,500 lines across admin + mercury_client). Committed `df41cdc`.
- **2026-05-27 (~00:22)** — **`/grill flutter-design-system` complete.** ADR-0014 written. `ditto_design` package defined: tokens + theme + `DittoDashboardShell` + `DittoWindowClass`. SolarTheme acknowledged as future layer. `context.md` updated (4 new terms). PRD bumped to v1.1. SolarTheme exploration doc written.
- **2026-05-26 (late night)** — **Flutter design system cohesion briefing prepared.** 6 key decisions identified, grill briefing artifact created. ADR-0014 candidate identified.
- **2026-05-26 (late night)** — **`/grill admin-panel` complete.** ADR-0013 written. PRD v1.0 created. 6 glossary updates. Scope locked: 5 screens + Inbox.
- **2026-05-26 (late evening)** — **PlutoII Flutter dev environment setup.** Flutter 3.44.0 / Dart 3.12.0, all toolchains green.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine V2) · Dart / Flutter / Riverpod / GoRouter (Admin + future Portal + Marketplace) · TypeScript / Vue 3 / Nuxt 4 (`dittodatto.no` landing only) · SurrealDB 3.0 (sole platform DB).
- **Admin Panel track started:** `admin_panel_20260527`. 5 phases. Mock-first. Clean-room port. All dependency versions verified 2026-05-27.
- *2026-05-27* — Mock-first API strategy chosen for admin panel — build UI against fakes, wire to real MercuryEngine V2 in a future backend track. Repository interface pattern enables clean swap. _(operational)_
- *2026-05-27* — Old admin codebase inventoried: 18 `.dart` files (~2,600 lines), 15 mercury_client files (~900 lines + 256 generated), 1 test file (model serialization only). Key patterns to preserve: sealed AuthState ADT, feature-first dirs, auto-slug, PaginatedResponse<T>, invalidateSelf(). Key patterns to rethink: no dart:io (web compat), Riverpod v3, extract duplicate widgets, split monolithic company dialog. _(operational)_
- *2026-05-27* — User setting up Android Studio concurrently with Phase 1 implementation. Will reconvene when there's something visual. _(operational)_

## 📋 Next Session Suggestions

1. 🟢 **Phase 1 in progress** — Monorepo + `ditto_design` + Shell Scaffold. Reconvene when shell renders on Android + Linux + Web.
2. **Phase 2: Auth + Login** — after Phase 1 checkpoint.
3. **`/grill business-portal`** — greenfield grill after admin panel reaches a checkpoint. User plans to use Flash for speed.
4. **`/grill mercury-engine`** — Pydantic v2 datetime conventions, 377-test review, schema migration. Needed before wiring real backend.
