# Spec — Admin Panel (`admin_panel_20260527`)

> **Created:** 2026-05-27
> **Type:** feature
> **Domain:** Admin Panel (`apps/admin/`)
> **Caution Level:** 🟡 Active
> **Source:** PRD v1.1 + ADR-0006 + ADR-0013 + ADR-0014

---

## Overview

Build the DittoDatto Admin Panel — a Flutter platform administration interface for Arnar and Höddi to manage platform infrastructure. This is a **migration** from the legacy admin at `DittoDatto-old/apps/admin/` to a clean-room reimplementation at `apps/admin/`, with shared packages (`ditto_design`, `mercury_client`) established as the foundation for all future Flutter surfaces.

### What this track creates

1. **Dart Workspaces monorepo** — root `pubspec.yaml` with workspace resolution for `apps/admin/`, `packages/mercury_client/`, `packages/ditto_design/`
2. **`packages/ditto_design/`** — shared design tokens, `DittoTheme.dark`/`.light`, `DittoDashboardShell`, `DittoWindowClass` breakpoints (ADR-0014)
3. **`packages/mercury_client/`** — HTTP client with JWT injection, auth service, admin API layer, models — clean-room from old structure, rewritten for MercuryEngine Pydantic schemas
4. **`apps/admin/`** — Flutter app with 6 screens (Login, Dashboard, Users, Companies, Categories, Inbox)

### API strategy

**Mock-first.** The admin app builds against a local mock/fake API layer within `mercury_client`. No real MercuryEngine endpoints are required for this track. The mock layer will:

- Return realistic fake data matching MercuryEngine response shapes
- Simulate auth flows (login success/failure, token expiry)
- Simulate pagination, CRUD operations
- Be swappable with real HTTP calls via a repository interface pattern

Real backend wiring deferred to a future MercuryEngine track.

---

## Functional Requirements

### Screens (per PRD v1.0)

| Screen | Capabilities |
|--------|-------------|
| **Login** | Lock icon + email field + password field + Sign In button. Moody Blue dark theme. No application-identifying text. No error feedback on failure. Maximum opacity. |
| **Dashboard** | 4 stat cards: user count, company count, category count, engine health status. Pull-to-refresh. |
| **Users** | Paginated data table (page size 50). Columns: ID, name, email, company, role. Inline role editing via dropdown/popup. Role badges (customer, business, admin, super_admin). |
| **Companies** | Paginated data table. Columns: ID, name, slug, tier, onboarding status, created date, owner. Create/edit dialog with sections: basic info, contact, address, social links, policies, features, tier. Tier and onboarding badges. |
| **Categories** | Full CRUD data table. Columns: ID, name, slug, icon, description. Create/edit dialog with slug auto-generation. Delete with confirmation. |
| **Inbox** | Within-platform messaging. Minimal v1 — message list + detail view. Human precursor to MasterDatto. |

### Shell & Navigation

- **`DittoDashboardShell`** from `ditto_design` — permanent collapsible sidebar with 5 nav items + header/footer slots
- Wide (≥600px): `NavigationRail` or permanent sidebar
- Narrow (<600px): Drawer or bottom nav
- `DittoWindowClass` breakpoints shared across all surfaces

### Auth

- `POST /auth/dev-login` (email + password) → JWT (mocked in this track)
- JWT stored via `flutter_secure_storage`
- Sealed `AuthState` ADT: `Unauthenticated | Loading | Authenticated | Error`
- GoRouter auth redirect guard

### Shared Packages

- `ditto_design` — tokens, theme, shell, breakpoints, typography
- `mercury_client` — HTTP client, JWT injection, auth service, models, admin API

---

## Non-Functional Requirements

- **Performance:** Sub-200ms screen transitions. Paginated data tables.
- **Responsive:** 360px+ phone → tablet → desktop → browser.
- **Accessibility:** WCAG 2.1 AA — high-contrast, clear touch targets, semantics.
- **Platform targets:** Android + Linux desktop + Web. No iOS.
- **Offline:** None — always-connected admin tool.
- **Security:** Maximum opacity login. No information leakage on auth failure.

---

## Acceptance Criteria

1. ✅ Root Dart Workspaces monorepo resolves all three packages (`apps/admin`, `packages/mercury_client`, `packages/ditto_design`)
2. ✅ `ditto_design` exports: `DittoTheme.dark`, `DittoTheme.light`, `DittoColors` (Moody Blue palette), `DittoSpacing`, `DittoBorderRadius`, `DittoAnimationDuration`, `DittoWindowClass`, `DittoDashboardShell`
3. ✅ `mercury_client` exports: `MercuryApi`, `AuthService`, `AdminApi`, models (`User`, `Company`, `Category`, `AdminStats`, `PaginatedResponse<T>`, `TokenResponse`), enums (`ActorRole`, `CompanyTier`, `OnboardingStatus`), mock implementations
4. ✅ Login screen matches PRD: lock icon, email, password, Sign In. No branding. No error feedback on failure.
5. ✅ Dashboard shows 4 stat cards with pull-to-refresh
6. ✅ Users table: pagination, role badges, inline role editing
7. ✅ Companies table: pagination, create/edit dialog (all sections), tier/onboarding badges
8. ✅ Categories table: full CRUD, auto-slug generation, delete confirmation
9. ✅ Inbox: minimal message list + detail view
10. ✅ Responsive shell adapts at `DittoWindowClass` breakpoints (compact/medium/expanded/large)
11. ✅ App builds and runs on Android, Linux desktop, and Chrome (web)
12. ✅ Model serialization tests pass (round-trip JSON for all DTOs)
13. ✅ No `dart:io` imports in platform-agnostic code (web compatibility)

---

## Edge Cases & Constraints

- **No `dart:io`** — old `mercury_api.dart` imported `SocketException` which breaks web. Use platform-agnostic error handling.
- **Riverpod v3** — old code used v1-style `Provider`/`NotifierProvider`. New code uses `flutter_riverpod: ^3.3.1` with code-gen annotations (`@riverpod`) where appropriate, manual providers where simpler.
- **Company dialog** — old one was 393 lines. Split into composable form sections.
- **Duplicate widgets** — old code had 3 identical `_ErrorView` / `_EmptyView`. Extract to `ditto_design` shared widgets.
- **Date formatting** — duplicated in old users/companies screens. Extract to shared utility.
- **Server presets** — old code had hardcoded `ServerPreset` list. For mock-first, this simplifies to a single mock backend. Keep the pattern for future real-endpoint switching.

---

## Dependencies

- **Internal:** ADR-0006 (Flutter Admin Panel), ADR-0013 (admin scope & access), ADR-0014 (shared design system)
- **External (Flutter):** Flutter 3.44.0, Dart 3.12.0 (already installed on PlutoII)
- **Packages (latest stable):**
  - `flutter_riverpod: ^3.3.1`
  - `go_router: ^17.2.3`
  - `flutter_secure_storage: ^10.3.0`
  - `google_fonts: ^8.1.0`
  - `json_annotation: ^4.12.0`
  - `json_serializable: ^6.14.0` (dev)
  - `build_runner: ^2.4.15` (dev)
  - `http: ^1.4.0`

---

## Out of Scope

Per PRD v1.0 — see [prd.md](file:///home/solmundur/Projects/DittoDatto/conductor/prd.md#L66-L82) for full exclusion table.

Key exclusions:
- Real MercuryEngine endpoints (future backend track)
- Establishments/Services/Staff/Bookings (→ Business Portal)
- BankID / Vipps OIDC (→ Business Portal / Marketplace)
- iOS build target
- SearchAnalytics merge
- MasterDatto AI agent
- Settings screen

---

## Migration Reference

The old codebase at `DittoDatto-old/apps/admin/` (~2,600 lines) and `DittoDatto-old/packages/mercury_client/` (~900 lines) serve as architectural reference:

### Patterns to preserve
- Sealed `AuthState` ADT
- Feature-first directory structure
- Auto-slug generation with manual override detection
- Generic `PaginatedResponse<T>` with typed factory
- `MercuryApi` → domain API class layering
- Shared badge widgets with switch expressions on enums
- `invalidateSelf()` post-mutation refresh pattern

### Patterns to rethink
- No `dart:io` (web compat)
- Riverpod v3 code-gen where appropriate
- Extract duplicate error/empty views to shared
- Split monolithic company dialog into sections
- Shared date formatting utility
- Repository interface pattern for mock/real swapping

---

## Dependency Versions (verified 2026-05-27)

| Package | Old Version | New Version |
|---------|-------------|-------------|
| flutter_riverpod | ^2.6.1 | ^3.3.1 |
| go_router | ^15.1.2 | ^17.2.3 |
| flutter_secure_storage | ^9.2.4 | ^10.3.0 |
| google_fonts | ^6.2.1 | ^8.1.0 |
| json_annotation | ^4.9.0 | ^4.12.0 |
| json_serializable | ^6.9.5 | ^6.14.0 |
| http | ^1.4.0 | ^1.4.0 |
| Dart SDK | ^3.11.3 | ^3.12.0 |
| Flutter SDK | ≥3.41.0 | 3.44.0 |
