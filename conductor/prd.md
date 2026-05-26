# Product Requirements — Admin Panel v1.0

> **Created:** 2026-05-26 (`/grill admin-panel`)
> **Version:** 1.0
> **Surface:** Admin Panel (`apps/admin/`)
> **Domain:** Platform infrastructure operations

---

## Overview

The Admin Panel is DittoDatto's internal **"breaker box"** — a 2-user private tool for Arnar and Höddi (Merkurial Studio) to manage platform infrastructure. It is NOT a customer-facing product and NOT a replacement for the Business Portal. Merkurial Studio dogfoods the Business Portal as a company on the platform; the Admin Panel manages the platform itself.

**Stack:** Flutter (Dart) · Riverpod · GoRouter · Material 3 Dark · Moody Blue `#6f71cc`
**Targets:** Android + Linux desktop + Web (same codebase). No iOS.
**Users:** 2 (Arnar Valur, Höddi). No public access.
**URL (web, future):** `panel.dittodatto.no` (replaces current Nuxt admin when Flutter web build is ready)

---

## In Scope (v1.0)

### Screens

| Screen | Capabilities |
|--------|-------------|
| **Login** | Lock icon + email field + password field + Sign In button. Moody Blue dark theme. No application-identifying text. No error feedback on failure. Maximum opacity. |
| **Dashboard** | 4 stat cards: user count, company count, category count, engine health status. Pull-to-refresh. |
| **Users** | Paginated data table. Columns: ID, name, email, company, role. Inline role editing via dropdown/popup. Role badges (customer, business, admin, super_admin). |
| **Companies** | Paginated data table. Columns: ID, name, slug, tier, onboarding status, created date, owner. Create/edit dialog with sections: basic info, contact, address, social links, policies, features, tier. Tier and onboarding badges. |
| **Categories** | Full CRUD data table. Columns: ID, name, slug, icon, description. Create/edit dialog with slug auto-generation. Delete with confirmation. |
| **Inbox** | Within-platform messaging. Receive feedback, support messages, notifications from businesses and users on the platform. Minimal v1 implementation. |

### Shell & Navigation

- **Responsive shell** — `LayoutBuilder` + Material 3 adaptive navigation:
  - Wide (≥600px): `NavigationRail` or permanent sidebar with 5 nav items (Dashboard, Users, Companies, Categories, Inbox)
  - Narrow (<600px): `NavigationBar` (bottom nav) or `Drawer`
- **Theme:** Material 3 `ColorScheme.fromSeed(seedColor: #6f71cc)`, dark mode only
- **Typography:** Inter (Google Fonts)

### Shared Package

- `packages/mercury_client/` — HTTP client, JWT injection, auth service, models, admin API endpoints
- Consumed by Admin Panel, future Business Portal, and future Marketplace
- Path dependency: `path: ../../packages/mercury_client`

### Auth

- `POST /auth/dev-login` (email + password) → JWT
- JWT stored via `flutter_secure_storage`
- No Vipps OIDC in Admin Panel (deferred to Business Portal / Marketplace)
- No biometric re-auth in Admin Panel (2-user tool, unnecessary)
- Engine middleware: `require_admin` / `require_super_admin` per ADR-0005

### Migration

- Fresh `flutter create` at `apps/admin/`
- Port feature-first architecture from `DittoDatto-old/apps/admin/`
- Port `mercury_client` package from `DittoDatto-old/packages/mercury_client/`
- Version bump: Flutter 3.44 / Dart 3.12, all dependencies to latest stable

---

## Out of Scope

| Item | Reason | Where it belongs |
|------|--------|-----------------|
| Establishments management | Company-scoped, not platform-level | Business Portal |
| Services / Staff management | Company-scoped | Business Portal |
| Booking oversight | Privacy boundary — admin should not inspect company–customer bookings | Business Portal |
| Reviews, Media | Future v1.x features | Business Portal |
| Search Analytics / Shadow Demand | Separate project under conceptualization | `predict.dittodatto.no` (SearchAnalytics) |
| Settings screen | Unnecessary for 2 users | N/A |
| iOS compilation | Not needed — Android + Linux + Web covers both users | N/A |
| BankID re-auth | 2-user private tool, overhead unjustified | Business Portal / Marketplace |
| Device restrictions | Unnecessary | N/A |
| Operator impersonation | Only 2 users; Surrealist for direct DB access | N/A |
| MasterDatto AI agent | Future concept | Future — Inbox is the human precursor |
| System Alerts broadcasting | Simple for now; full design in messaging system grill | Future `/grill` session |

---

## Non-Functional Requirements

- **Security:** Maximum opacity login. No information leakage on auth failure. JWT-based auth with `flutter_secure_storage`.
- **Performance:** Sub-200ms screen transitions. Paginated data tables (page size 50).
- **Accessibility:** WCAG 2.1 AA — high-contrast text, clear touch targets, screen-reader-friendly.
- **Responsive:** Works on phone (360px+), tablet, desktop, and browser.
- **Offline:** No offline requirement — always-connected admin tool.

---

## Open Questions (deferred to future grills)

1. **Platform messaging/notification system architecture** — human-readable + A2A (agent-to-agent) messaging model. Full design in a dedicated `/grill` session. Impacts Inbox screen depth.
2. **SearchAnalytics merge** — whether `predict.dittodatto.no` functionality merges into the Admin Panel or stays as a separate project.
3. **System Alerts in Inbox** — currently simple; full design when messaging system is grilled.
4. **Server configuration** — Tailscale topology for staging deployment. Deferred to Saturn deployment session.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-05-26 | Initial PRD from `/grill admin-panel` session. 5 screens + Inbox locked. Platform targets, auth, exclusions defined. |
