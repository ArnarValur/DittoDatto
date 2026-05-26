# Flutter Admin Panel

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0011 post-S16.5 grill; namespace rename + Android-first dropped + API presets removed + admin tier reference updated)
> **Status:** accepted

## Context

The Chapter 1 Nuxt admin panel (`apps/web/admin-panel/`) had 24 pages, many incomplete given the new SurrealDB + Surrealist tooling. With MercuryEngine V2 stable (377 tests at v2.1 init time, auth wired), the platform needed a management tool that:

1. Runs natively on Android, iOS, Linux desktop, and Web (cross-platform Flutter).
2. Connects to MercuryEngine over Tailscale (staging on Saturn — ADR-0003) or Cloud Run (production).
3. Manages users and companies — the two pillars of multi-tenant onboarding.
4. Establishes reusable Flutter patterns (auth, API client, state management) for the consumer and business apps.

SurrealDB's Surrealist UI handles raw data exploration, schema design, and query execution — eliminating the need for database-level admin pages in our app.

## Decisions

### 1. App Identity — Platform Super-Admin Tool

The admin panel is an **internal tool for platform administrators** (Merkurial Studio operators). Not a customer-facing product. Not a replacement for the Business Portal (a separate Flutter app for company operators — see ADR-0007).

Primary user role: `super_admin` (see ADR-0005). Secondary: `admin`.

### 2. Scope — 5 Screens + Stub

**MVP screens:**

| Screen | Purpose |
|---|---|
| Login | Email + password → `POST /auth/dev-login` → JWT. Lock icon, two fields, one button. |
| Dashboard | 4 stat cards (user count, company count, system health, recent activity). Minimal. |
| Users | List, create, edit, role management, company assignment. Paginated data table. |
| Companies | List, provision (orchestrated: create `companies/{slug}` DB + seed schema + assign owner), edit, tier management. |
| Categories | Platform-wide service taxonomy (from `companies/discovery.category`). CRUD. |
| Inbox | Stub — nav slot reserved for future MasterDatto ← Datto messaging. |

**Explicitly cut (handled by Surrealist or future apps):**

- Bookings, Stores/Establishments, Services, Media (company-scoped → Business Portal).
- Feedback, Reviews (future v1.x).
- MercuryEngine Sandbox (Saturn staging replaces this — ADR-0003).
- Icon Manager (deferred — managed via schema migration scripts).
- Security settings (SurrealDB auth panel handles this).

### 3. Monorepo Location — `apps/admin/`

Clean break from the Nuxt-era admin. The frozen Nuxt version stays at `apps/web/admin-panel/` as Chapter 1 reference; retired on Flutter feature-parity (bug-fix-only in the interim).

### 4. Platform Target — Cross-Platform Flutter

All four Flutter targets are first-class: Android, iOS, Linux desktop, Web. The tablet form-factor is a convenient test surface for the Admin operator role but is not a design-discipline constraint. The app is designed responsive — tablet, phone, desktop, and browser all work.

### 5. API Connection — Runtime-Configurable

API endpoint configuration is runtime-mechanical and lives outside this ADR. Tailscale handles dev/staging connectivity to Saturn (ADR-0003); production uses the Cloud Run endpoint. Implementation lives in `apps/admin/lib/config/`.

### 6. State Management — Riverpod

Consistent with the consumer Flutter app and Business Portal (ADR-0007). Compile-safe, async-friendly, testable. All Flutter apps share Riverpod.

### 7. Auth Flow — Dev-Login + Vipps + Biometric Re-Auth

**Engine extension (S18, shipped):** `ADMIN` and `SUPER_ADMIN` added to `ActorRole` enum; `require_admin` and `require_super_admin` middleware tiers (see ADR-0005). SurrealDB schema supports the role assertion (`users/profiles.role`).

**Flutter flow:**

1. Login screen: email + password → `POST /auth/dev-login` (dev + staging) or Vipps Login button → `POST /auth/vipps` (production).
2. JWT stored in `flutter_secure_storage`.
3. Subsequent opens: biometric re-auth via `local_auth` (fingerprint/PIN) → unlock stored JWT.
4. No re-typing credentials unless JWT expires or user explicitly logs out.

### 8. UI Toolkit — Material 3 Dark + Moody Blue

- Theme: Material 3 `ColorScheme.dark()` with `#6f71cc` Moody Blue as primary seed color.
- Shell: Material 3 components (NavigationRail, AppBar, Cards, Forms).
- Data tables: specialized package (e.g., `data_table_2` or `pluto_grid`) for Users/Companies/Categories — sorting, pagination, column resizing.
- Typography: Google Fonts (Inter or Outfit).

### 9. Package Architecture — Shared `mercury_client` from Day One

All three Flutter apps (Admin, Business Portal, Public Marketplace consumer) consume MercuryEngine. Shared code lives in a Dart package:

```
packages/
└── mercury_client/
    ├── lib/src/
    │   ├── api/        # HTTP client, JWT header injection, error mapping
    │   ├── auth/       # Login, token storage, biometric guard
    │   └── models/     # User, Company, Category, Auth DTOs
    ├── pubspec.yaml
    └── test/
```

Each app imports via `path:` dependency:

```yaml
dependencies:
  mercury_client:
    path: ../../packages/mercury_client
```

See ADR-0007 for the Flutter-only client strategy that extends this pattern to all client surfaces.

### 10. Execution Strategy — Engine-First, No Mocks

| Session | Focus | Deliverable | Status |
|---|---|---|---|
| S18 | Engine admin routes | `ADMIN`/`SUPER_ADMIN` in `ActorRole`, `require_admin` middleware, platform admin routes (users list, company CRUD, categories CRUD), tests | ✅ Shipped |
| S19 | Flutter scaffold + `mercury_client` | Shared package (API client, models, auth). `apps/admin/` scaffold (GoRouter, Riverpod, Moody Blue theme, login screen wired to real engine). | ✅ Shipped |
| S20 | Flutter screens | Dashboard, Users, Companies, Categories — all wired to real engine data. | ✅ Shipped |

The Inbox stub and any further screens are scope for `/grill admin-panel`.

## Architecture

```
Flutter Admin (apps/admin/) — Android / iOS / Linux desktop / Web
    │
    └── mercury_client (packages/mercury_client/)
            ├── API client → HTTP → MercuryEngine V2 (Saturn staging or Cloud Run prod)
            ├── Auth → JWT → flutter_secure_storage + biometric guard
            └── Models → User, Company, Category, Auth DTOs

MercuryEngine V2 (FastAPI · Pydantic v2)
    ├── POST /auth/dev-login (dev + staging) | POST /auth/vipps (production)
    ├── GET  /admin/stats
    ├── GET  /admin/users
    ├── PUT  /admin/users/{id}/role
    ├── GET  /admin/companies
    ├── POST /admin/companies (super_admin — orchestrated provisioning)
    ├── PUT  /admin/companies/{id}
    ├── GET  /admin/categories
    ├── POST /admin/categories
    ├── PUT  /admin/categories/{id}
    └── DELETE /admin/categories/{id}

SurrealDB 3.0
    ├── companies/registry   → company registry, system alerts, audit log
    ├── companies/discovery  → categories, search events
    ├── companies/{slug}     → per-company data
    └── users/profiles       → user profiles (GDPR-isolated)
```

## Consequences

- Chapter 1 Nuxt admin panel is officially superseded (remains as frozen reference; bug-fix-only until Flutter feature-parity).
- A shared `mercury_client` package eliminates duplication across all future Flutter apps.
- Admin roles in the engine enable platform-level operations beyond company-scoped access (formalized in ADR-0005).
- Cross-platform Flutter means the Admin app runs anywhere a Merkurial Studio operator does — tablet, phone, desktop, browser.
- The Surrealist UI handles database-level operations, keeping the Flutter admin focused on business-logic orchestration.
- Biometric re-auth provides fast, secure access without credential fatigue.

---

*Origin: Post-S16.5 Grill Session (2026-05-05) — 10 decisions locked. Promoted into canonical conductor/adr/ with namespace rename, Android-first dropped, API presets stripped, and ADR-0005 cross-reference added during /grill foundation 2026-05-26.*
