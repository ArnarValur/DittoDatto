# Product Requirements — Admin Panel v1.0

> **Created:** 2026-05-26
> **Version:** 1.0
> **Surface:** Admin Panel (`apps/admin/`)
> **Domain:** Platform Administration

---

## 1. Overview

The Admin Panel is the platform administration interface for DittoDatto. It enables direct database-level management of platform infrastructure, users, companies, and service taxonomies.

- **Stack:** Flutter (Dart), Riverpod, GoRouter, Material 3 Dark
- **Targets:** Web, Linux desktop, Android
- **URL (Web):** `panel.dittodatto.no` (replacing legacy Nuxt admin)

---

## 2. Bounded Context & Scope

### 2.1 In Scope (v1.0)

#### Screens and Capabilities

| Screen | Capabilities |
|--------|-------------|
| **Login** | Secure native database authentication. Moody Blue dark theme. Email and password fields only. Zero error-feedback or information leakage on authentication failure. |
| **Dashboard** | Metrics display: user count, company count, category count, engine health. Pull-to-refresh data fetching. |
| **Users** | Paginated table display. Columns: ID, Name, Email, Company, Role. Role badges (customer, business, admin, super_admin). Inline role updates via popup menus. |
| **Companies** | Paginated table display. Columns: ID, Name, Slug, Tier, Onboarding Status, Created Date, Owner. CRUD operations including company database provisioning and tier management. |
| **Categories** | Full CRUD table display. Columns: ID, Name, Slug, Icon, Description. Automatic slug generation with manual override detection. Delete with confirmation. |
| **Inbox** | Within-platform messaging queue. Receives platform-level feedback, support tickets, and system notifications. |

#### Shell and Navigation

- **Responsive Layout:** Responsive sidebar (`NavigationRail` for wide viewpoints, compact navigation bar or drawer for narrow viewpoints).
- **Theme:** Material 3 `ColorScheme.dark` using Moody Blue (`#6F71CC`) as the seed color.
- **Typography:** Inter (Google Fonts).

#### Shared Workspace Packages

- `packages/ditto_design/` — Shared Material 3 styling tokens, responsive navigation shell, and breakpoint definitions (ADR-0005).

#### Connection & Authentication

- **Direct Database Path:** Connects directly to SurrealDB via WebSockets over the Caddy `/rpc` reverse proxy.
- **Authentication:** Native SurrealDB namespace-level credentials (`companies` and `users` pools) utilizing the `surrealdb` Dart package.
- **No Intermediaries:** Zero dependency on MercuryEngine admin routes or custom JWT/OIDC endpoints for administrative actions (ADR-0006).

### 2.2 Out of Scope

| Item | Bounded Context / Rationale | Target Surface |
|------|-----------------------------|----------------|
| Establishment Management | Belongs to company-scoped domain | Business Portal |
| Service / Staff Management | Belongs to company-scoped domain | Business Portal |
| Booking Oversight | Restricted under customer privacy boundaries | Business Portal |
| Reviews / Media Management | Deferred to future platform versions | Business Portal |
| Search Analytics | Dedicated demand analytics surface | `predict.dittodatto.no` |
| Settings Screen | Platform configuration is managed via database schemas | N/A |
| iOS Compilation | Excluded from target compilation metrics | N/A |
| Biometric Re-authentication | Excluded from desktop/web administrative scopes | N/A |

---

## 3. Non-Functional Requirements

- **Security:** Maximum opacity authentication. Silent failures on credentials mismatch to prevent enumeration attacks.
- **Performance:** Direct WebSocket queries returning in under 200ms. Paginated data loading (limit 50).
- **Responsiveness:** Fluid layout transitions across compact (360px+), medium, and expanded breakpoints.
- **Accessibility:** WCAG 2.1 AA compliant color contrast, explicit semantic labels, and focus traversal.

---

## 4. Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-05-26 | Initial specification from `/grill admin-panel` session. |
| 1.1 | 2026-05-29 | Aligned with direct-to-database WebSocket architecture (ADR-0006) and shared design system renumbering (ADR-0005). |
