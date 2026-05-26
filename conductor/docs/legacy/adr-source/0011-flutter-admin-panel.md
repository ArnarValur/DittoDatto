---
title: "ADR-0011: Flutter Admin Panel"
type: "adr"
status: "accepted"
date: "2026-05-05"
session: "Grill Session (post-S16.5)"
domain: "Flutter / Admin"
tags:
  - "flutter"
  - "admin"
  - "riverpod"
  - "mercury-client"
  - "material3"
---

# Flutter Admin Panel

## Context

The Chapter 1 Nuxt admin panel (`apps/web/admin-panel/`) has 24 pages, many incomplete or unnecessary given the new SurrealDB + Surrealist tooling. With MercuryEngine V2 stable (304 tests, auth wired), the platform needs a management tool that:

1. Runs natively on the Captain's LineageOS tablet (Lenovo Tab M10 Plus)
2. Connects to Saturn (MercuryEngine) over LAN or internet
3. Manages users and companies — the two pillars of multi-tenant onboarding
4. Establishes reusable Flutter patterns (auth, API client, state management) for the consumer and business apps

SurrealDB's Surrealist UI handles raw data exploration, schema design, and query execution — eliminating the need for database-level admin pages in our app.

## Decisions

### 1. App Identity — Platform Super-Admin Tool

The admin panel is an **internal tool for platform administrators** (Captain / Merkurial Studio). Not a customer-facing product. Not a replacement for the Business Portal (which is a separate future app for company operators).

Primary user: `super_admin` role.

### 2. Scope — 5 Screens + Stub

**MVP screens:**

| Screen | Purpose |
|--------|---------|
| **Login** | Email + password → `POST /auth/dev-login` → JWT. Lock icon, two fields, one button. Nothing else. |
| **Dashboard** | 4 stat cards (user count, company count, system health, recent activity). Minimal. |
| **Users** | List, create, edit, role management, company assignment. Paginated data table. |
| **Companies** | List, provision (orchestrated: create `titan/company_{slug}` DB + seed schema + assign owner), edit, tier management. |
| **Categories** | Platform-wide service taxonomy (from `titan/discovery.category`). CRUD. |
| **Inbox** | Stub — nav slot reserved for future MasterDatto ← Datto messaging. |

**Explicitly cut (handled by Surrealist or future apps):**

- Bookings, Stores/Establishments, Services, Media (company-scoped → Business Portal)
- Feedback, Reviews (never finished → future v1.x)
- MercuryEngine Sandbox (Saturn staging replaces this)
- Icon Manager (deferred — managed via `.surql` migration scripts)
- Security settings (SurrealDB auth panel handles this)

### 3. Monorepo Location — `apps/admin/`

Clean break from the web era. The frozen Nuxt version stays at `apps/web/admin-panel/` as Chapter 1 reference.

### 4. Platform Target — Android-First (Tablet)

| Priority | Target | Rationale |
|----------|--------|-----------|
| **Primary** | Android APK | LineageOS tablet — portable command bridge |
| **Secondary** | Linux desktop | Dev convenience on Pluto |
| **Tertiary** | Web | Browser access, zero extra effort |

Design for 10.6" tablet screens first, responsive down to phone.

### 5. API Connection — Runtime Config with Presets

First launch shows "Server URL" field. Three presets:

| Preset | URL |
|--------|-----|
| Saturn (LAN) | `http://saturn.local:8000` |
| Saturn (Internet) | `https://api.merkurial-studio.com` |
| Dev (Pluto) | `http://pluto.local:8000` |

Persisted in SharedPreferences. Editable in Settings.

**v1.1 enhancement:** WiFi SSID detection via `network_info_plus` — auto-select LAN URL when on known home network. Requires `ACCESS_FINE_LOCATION` on Android (no concern on personal LineageOS device).

### 6. State Management — Riverpod

Consistent with the consumer Flutter app tech stack. Compile-safe, async-friendly, testable. All three Flutter apps (admin, marketplace, business portal) will share the same state management paradigm.

### 7. Auth Flow — Extended Dev-Login with Admin Roles

**Engine extension required:** Add `ADMIN` and `SUPER_ADMIN` to `ActorRole` enum. Add `require_admin` middleware tier.

SurrealDB schema already supports this — `users.surql` has `['customer', 'business', 'admin', 'super_admin']` in the role assertion.

**Flutter flow:**

1. Login screen: email + password → `POST /auth/dev-login`
2. JWT stored in `flutter_secure_storage`
3. Subsequent opens: biometric re-auth via `local_auth` (fingerprint/PIN) → unlock stored JWT
4. No re-typing credentials unless JWT expires or user explicitly logs out

**Future:** When Vipps OIDC is ready, the login screen adds a "Login with Vipps" button. Middleware doesn't change — only the authentication endpoint.

### 8. UI Toolkit — Material 3 Dark + Data Table Package

- **Theme:** Material 3 `ColorScheme.dark()` with `#6f71cc` Moody Blue as primary seed color
- **Shell:** Material 3 components (NavigationRail, AppBar, Cards, Forms)
- **Data tables:** Specialized package (e.g., `data_table_2` or `pluto_grid`) for Users/Companies/Categories — sorting, pagination, column resizing
- **Typography:** Google Fonts (Inter or Outfit)

### 9. Package Architecture — Shared `mercury_client` from Day One

Three Flutter apps are on the near horizon (admin, marketplace, business portal). All consume MercuryEngine. Shared code lives in a Dart package:

```
packages/
└── mercury_client/
    ├── lib/src/
    │   ├── api/         # HTTP client, JWT header injection, error mapping
    │   ├── auth/        # Login, token storage, biometric guard
    │   └── models/      # User, Company, Category, Auth DTOs
    ├── pubspec.yaml
    └── test/
```

Each app imports via `path:` dependency:

```yaml
dependencies:
  mercury_client:
    path: ../../packages/mercury_client
```

### 10. Execution Strategy — Engine First, No Mocks

**Session order:**

| Session | Focus | Deliverable |
|---------|-------|-------------|
| **S18** | Engine admin routes | `ADMIN`/`SUPER_ADMIN` in `ActorRole`, `require_admin` middleware, platform admin routes (users list, company CRUD, categories CRUD), tests |
| **S19** | Flutter scaffold + `mercury_client` | Shared package (API client, models, auth). `apps/admin/` scaffold (GoRouter, Riverpod, Moody Blue theme, login screen wired to real engine). |
| **S20** | Flutter screens | Dashboard, Users, Companies, Categories — all wired to real engine data. |

TypeScript reference code exists in `apps/web/admin-panel/server/api/` for users, companies, and settings handlers.

## Architecture

```
LineageOS Tablet / Pluto Desktop / Browser
    │
    └── Flutter Admin Panel (apps/admin/)
            │
            ├── mercury_client (packages/mercury_client/)
            │       ├── API client → HTTP → MercuryEngine
            │       ├── Auth → JWT → flutter_secure_storage
            │       └── Models → User, Company, Category
            │
            └── Riverpod providers → feature screens

MercuryEngine V2 (FastAPI) — on Saturn
    ├── POST /auth/dev-login (extended: admin/super_admin)
    ├── GET  /admin/stats
    ├── GET  /admin/users
    ├── PUT  /admin/users/{id}/role
    ├── GET  /admin/companies
    ├── POST /admin/companies (orchestrated provisioning)
    ├── PUT  /admin/companies/{id}
    ├── GET  /admin/categories
    ├── POST /admin/categories
    ├── PUT  /admin/categories/{id}
    └── DELETE /admin/categories/{id}

SurrealDB 3.0
    ├── titan/platform     → company registry
    ├── titan/discovery    → categories, search events
    ├── titan/company_{slug} → per-company data
    └── enceladus/users    → user profiles (GDPR-isolated)
```

## Consequences

- Chapter 1 Nuxt admin panel is officially superseded (remains as frozen reference)
- A shared `mercury_client` package eliminates duplication across all future Flutter apps
- Admin roles in the engine enable platform-level operations beyond company-scoped access
- Android-first design means the tablet becomes a dedicated, portable admin console
- The Surrealist UI handles database-level operations, keeping the Flutter admin focused on business-logic orchestration
- Biometric re-auth provides fast, secure access without credential fatigue

---

*Origin: Post-S16.5 Grill Session — 10 decisions locked (2026-05-05)*
