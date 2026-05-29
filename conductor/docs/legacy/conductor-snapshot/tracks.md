# Project Tracks

Tracks organized by domain. Each track has its own folder with plan.md and metadata.json.

**Last Updated:** 2026-05-06

---

## 🗂️ Domain Structure

| Domain             | Path                                    | ⚠️ Level                                                       |
| ------------------ | --------------------------------------- | -------------------------------------------------------------- |
| MercuryEngine   | `services/mercury-engine/`              | 🔴 **Critical** — See [BOOKING_ENGINE.md](./BOOKING_ENGINE.md) |
| Flutter Admin      | `apps/admin/`                           | 🟡 **Active** — [ADR-0011](../.docs/adr/0011-flutter-admin-panel.md) |
| Flutter Marketplace| `apps/marketplace/` (future)            | ⏳ After admin panel validates patterns                        |
| Shared Packages    | `packages/mercury_client/`              | 🟡 **Active** — shared Dart package for all Flutter apps       |
| ~~TheOracle~~      | ~~`packages/the-oracle/`~~              | ✅ **Absorbed** into MercuryEngine ([ADR-0007 revised](../.docs/adr/0007-dittobar-search-on-theoracle.md)) |
| Infrastructure     | Saturn (GX10) + SurrealDB               | 🟡 Incoming hardware                                          |

### Chapter 1 — Frozen (reference only)

| Domain             | Path                                    | Status                                                         |
| ------------------ | --------------------------------------- | -------------------------------------------------------------- |
| Admin Panel        | `apps/web/admin-panel/`                 | ❄️ Frozen — Nuxt web (Chapter 1)                               |
| Business Portal    | `apps/web/business-portal/`             | ❄️ Frozen — Nuxt web (Chapter 1)                               |
| Public Marketplace | `apps/web/public-marketplace/`          | ❄️ Frozen — replaced by Flutter app                            |
| Shared Types       | `packages/shared-types/`                | ❄️ Frozen — Zod schemas (Chapter 1 reference)                  |
| MercuryEngine V1   | `packages/mercury-engine/`              | ❄️ Frozen — TypeScript/Hono (Chapter 1 reference, 156 tests)   |

> Use `/new-track` workflow to create new tracks with domain selection.

---

## 🔄 Active Tracks — Chapter 2

### Step 1: MercuryEngine — Core Platform

The engine is the foundation. Everything else depends on it.

| What | Status | Notes |
|---|---|---|
| Python/FastAPI/Pydantic scaffold | ✅ Done | `services/mercury-engine/`, uv, Pydantic models |
| Core domain port (TS → Python) | ✅ Done | 197 unit tests — slots, hold, booking, reservations |
| SurrealDB data layer (10 repos) | ✅ Done | Dual-connection (titan + enceladus), repository pattern |
| CRUD routes (establishments, services, staff) | ✅ Done | FastAPI DI, company-scoped injection |
| Integration testing (live SurrealDB) | ✅ Done | 27 integration tests, 5 critical bugs fixed |
| Auth middleware (ADR-0010) | ✅ Done | JWT tiers, company access guard, dev bypass, 25 tests |
| Wire auth onto write endpoints | ✅ Done | `require_operator` on 13 endpoints, `require_auth` on 4 holds endpoints, 50 route auth tests |
| **Admin routes (ADR-0011)** | ✅ Done (S18) | `require_admin` middleware, 11 endpoints, 4-tier auth, 73 new tests |
| Rebook endpoint | ❌ Not started | Atomic cancel-old + hold-new transaction |
| Waitlist schema + engine | ❌ Not started | Depends on rebook — slot freed → notify waitlisted |
| Reschedule enforcement | ❌ Not started | `minRescheduleNoticeHours` — wire when rebook exists |
| Discovery routes (ex-TheOracle) | ❌ Not started | Phase 4: `/search`, `/categories`, `/areas` — see [ADR-0007](../.docs/adr/0007-dittobar-search-on-theoracle.md) |
| Company provisioning service | ❌ Not started | Automate DB creation + schema application when volume justifies it |

**Current stats:** 377 tests (197 unit + 73 admin + 50 auth + 32 integration + 25 token), lint clean.

### Step 2: Flutter Admin Panel — Platform Management (ADR-0011)

Internal super-admin tool. First Flutter app to consume MercuryEngine. Android-first (LineageOS tablet).

| What | Status | Notes |
|---|---|---|
| Engine admin routes (S18) | ✅ Done | `ADMIN`/`SUPER_ADMIN` roles, `require_admin`, user/company/category CRUD, 377 tests |
| `packages/mercury_client/` (S19) | ✅ Done | Shared Dart package: HTTP client, JWT auth, 7 models, 11 admin endpoints, 9 tests |
| Flutter scaffold + login (S19) | ✅ Done | `apps/admin/`, GoRouter, Riverpod, Moody Blue `#6f71cc`, sidebar shell, login + server presets |
| Dashboard screen (S20) | ✅ Done | 4 stat cards (users, companies, categories, engine health), pull-to-refresh |
| Users screen (S20) | ✅ Done | Paginated table, role badges, inline role editing via PopupMenuButton |
| Companies screen (S20) | ✅ Done | Paginated table, tier/onboarding badges, 7-section create/edit dialog |
| Categories screen (S20) | ✅ Done | Full CRUD table, create/edit dialogs, delete confirmation, slug auto-gen |
| Shared widgets (S20) | ✅ Done | StatCard, ConfirmDialog, RoleBadge/TierBadge/OnboardingBadge |
| Inbox (stub) | ✅ Done (S19) | Nav slot reserved for MasterDatto messaging |
| Biometric re-auth | ❌ Not started | `local_auth` — fingerprint/PIN unlock for stored JWT |

### Step 3: Flutter v1.0 — Public Marketplace (Tracer Bullet)

The consumer-facing app. Depends on MercuryEngine auth + patterns validated by admin panel.

| What | Status | Notes |
|---|---|---|
| Flutter scaffolding | ✅ Done | GoRouter + adaptive layout + device_preview |
| Auth (BankID/Vipps OIDC) | ❌ Blocked | Needs Vipps merchant registration |
| Home + Map + DittoBar | ❌ Not started | Discovery UI consuming MercuryEngine `/search` |
| Browse establishments | ❌ Not started | Consumes `/establishments` route |
| Booking flow | ❌ Not started | Slots → Hold → Confirm (MercuryEngine APIs) |
| My Bookings | ❌ Not started | Consumer profile + booking history |

### Step 4: Infrastructure — Saturn

| What | Status | Notes |
|---|---|---|
| Saturn (GX10) arrival | ⏳ Incoming | Hardware expected next week |
| Day-1 setup checklist | ❌ Not started | Docker, SurrealDB Dome, MercuryEngine deploy |
| Production deployment | ❌ Not started | Move V2 stack from Pluto → Saturn |

### Step 5: Cross-cutting

| What | Status | Notes |
|---|---|---|
| Vipps merchant registration | ❌ Not started | Unlocks payment + auth |
| Comms & notifications | `[~]` Concept ready | Messaging threads done (Chapter 1), cancellation notifications next |

---

## ✅ Chapter 2 Completed

| What | Date | Notes |
|---|---|---|
| MercuryEngine scaffold | 2026-05-05 | FastAPI + Pydantic + uv |
| Core domain port (157→197 tests) | 2026-05-05 | All pure calculators ported |
| Auth architecture grill (ADR-0010) | 2026-05-05 | 8 decisions locked |
| SurrealDB data layer (10 repos) | 2026-05-05 | Dual-connection, CRUD routes |
| Integration testing (27 tests) | 2026-05-05 | Live SurrealDB verification |
| TheOracle absorption | 2026-05-05 | ADR-0007 revised — no separate service |
| Conductor hygiene pass | 2026-05-05 | Chapter 2 realignment 🛁 |
| Auth middleware (ADR-0010) | 2026-05-05 | JWT tiers, dev-login, 25 tests |
| Auth wiring on routes (S16.5) | 2026-05-05 | 17 write endpoints locked, 50 route auth tests |
| Admin routes (S18) | 2026-05-05 | `require_admin` middleware, 11 endpoints, 73 new tests |
| `mercury_client` package (S19) | 2026-05-06 | Shared Dart: HTTP client, auth, 7 models, 9 tests |
| Flutter admin scaffold (S19) | 2026-05-06 | GoRouter, Riverpod, Moody Blue theme, sidebar shell, login screen |
| Flutter admin screens (S20) | 2026-05-06 | Dashboard, Users, Companies, Categories — all wired to AdminApi, 13 new files |

## ✅ Chapter 1 Completed

> See `conductor/tracks/Completed/` for individual track histories.

| What | Completed | Notes |
|---|---|---|
| Business Portal Foundation | 2025-12 | Nuxt web |
| i18n Integration | 2025-12 | Nuxt admin panel |
| Service Groups & Cascade | 2026-01 | Business portal |
| Events System | 2026-01 | Cross-cutting |
| Frontpage Theme & Splash | 2026-02 | Public marketplace (Nuxt) |
| Global Image Overhaul | 2026-02 | Cross-cutting |
| CRM Phase 1-4 | 2026-03 | Business portal |
| Cancellation policy (engine + portal + public) | 2026-03 | Per-establishment, 4 controls |
| Node 22 upgrade + Engine v0.2.0 | 2026-03 | Cloud Run staging |

---

## 🗑️ Removed / Deferred

| Item | Reason |
|---|---|
| ~~Frontpage mobile polish~~ | Deferred — Flutter app covers mobile |
| ~~RBAC full implementation~~ | Deferred — `hasMinRole` sufficient for now |
| ~~Showcasable Resources~~ | Scope creep — deferred |
| ~~Ditto AI Agent~~ | v1.5 roadmap — post-platform-stable |
| ~~BigQuery / Vector Search~~ | Replaced by SurrealDB native capabilities |
| ~~TheOracle microservice~~ | Absorbed into MercuryEngine (ADR-0007 revised) |
| ~~Firestore → SurrealDB sync~~ | Eliminated — single database |

---

## 💡 Ideas Backlog

See [todos-idea-list.md](./todos-idea-list.md)
