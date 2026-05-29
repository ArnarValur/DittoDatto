# Pulse — Current Project State

**Last Updated:** 2026-05-29 13:17 (post `/checkpoint`)
**Session Focus:** Android emulator environment setup, Phase 2 (Auth + Login) verification, and Clean Code mock-data alignment

## 🚀 Active Tracks

- **admin_panel_20260527** — Admin Panel Flutter breaker box. Phase 2 complete. High-quality widget tests passing green. Emulators configured. Mock-data cleanup planned. [Link](./tracks/admin-panel/admin_panel_20260527/)

## ✅ Recently Completed

- **2026-05-29** — **Phase 1 & 2 complete.** Created three emulators (`pixel_7_api_35`, `pixel_tablet_api_35`, `generic_tablet_api_35`) and verified them with Flutter. Wrote robust widget test suite in `apps/admin` (100% green) utilizing synchronous `FakeAuthService` to prevent async timer leaks. Audited codebase for hardcoded mocks and aligned on extracting them to separate JSON files to obey Clean Code rules.
- **2026-05-27** — **`/new-track admin-panel` created.** Track `admin_panel_20260527` with 5-phase TDD plan. Spec anchored to PRD v1.1 + ADR-0006/0013/0014. Key decisions: mock-first API (no backend dependency), clean-room port from old architecture, Dart Workspaces monorepo (3 packages from day one), Riverpod 3.3.1 + GoRouter 17.2.3 + all deps latest stable. Old codebase inventoried (~3,500 lines across admin + mercury_client). Committed `df41cdc`.
- **2026-05-27 (~00:22)** — **`/grill flutter-design-system` complete.** ADR-0014 written. `ditto_design` package defined: tokens + theme + `DittoDashboardShell` + `DittoWindowClass`. SolarTheme acknowledged as future layer. `context.md` updated (4 new terms). PRD bumped to v1.1. SolarTheme exploration doc written.
- **2026-05-26 (late night)** — **Flutter design system cohesion briefing prepared.** 6 key decisions identified, grill briefing artifact created. ADR-0014 candidate identified.
- **2026-05-26 (late night)** — **`/grill admin-panel` complete.** ADR-0013 written. PRD v1.0 created. 6 glossary updates. Scope locked: 5 screens + Inbox.
- **2026-05-26 (late evening)** — **PlutoII Flutter dev environment setup.** Flutter 3.44.0 / Dart 3.12.0, all toolchains green.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Project name:** DittoDatto (`dittodatto.no`) — The Agentic Commerce Platform for Norway.
- **Stack:** Python 3.11+ / FastAPI / Pydantic v2 / uv (MercuryEngine) · Dart / Flutter / Riverpod / GoRouter (Admin + future Portal + Marketplace) · TypeScript / Vue 3 / Nuxt 4 (`dittodatto.no` landing only) · SurrealDB 3.0 (sole platform DB).
- **Admin Panel track progress:** `admin_panel_20260527`. Phases 1 and 2 completed. Fakes and widget tests validated.
- *2026-05-29* — Emulators for Phone, Tablet, and Generic Tablet successfully set up and verified via flutter toolchain. *(operational)*
- *2026-05-29* — Aligned with Arnar Valur on mock-data boundaries. Inline hardcoded mock lists in packages and screen files violate Clean Code rules and represent debt. Next session will focus on sanitizing fakes into standalone JSON configuration assets before real database/API wiring. *(operational)*
- *2026-05-27* — Mock-first API strategy chosen for admin panel — build UI against fakes, wire to real MercuryEngine in a future backend track. Repository interface pattern enables clean swap. *(operational)*
- *2026-05-27* — Old admin codebase inventoried: 18 `.dart` files (~2,600 lines), 15 mercury_client files (~900 lines + 256 generated), 1 test file (model serialization only). Key patterns to preserve: sealed AuthState ADT, feature-first dirs, auto-slug, PaginatedResponse<T>, invalidateSelf(). Key patterns to rethink: no dart:io (web compat), Riverpod v3, extract duplicate widgets, split monolithic company dialog. *(operational)*
- *2026-05-27* — User setting up Android Studio concurrently with Phase 1 implementation. Will reconvene when there's something visual. *(operational)*

## 📋 Next Session Suggestions

1. 🧹 **Sanitize Mock Data** — Extract hardcoded arrays from `MockAdminRepository` and `inbox_screen.dart` into a local JSON asset (`apps/admin/assets/mock_data.json`) to satisfy Clean Code and Pragmatic Programmer guidelines.
2. 🟢 **Phase 3 in progress** — Implement Dashboard screen with responsive 2x2 grid of stat cards and pull-to-refresh.
3. **Phase 4: Users + Companies + Categories** — Horizontal datatables and CRUD form dialogs.
