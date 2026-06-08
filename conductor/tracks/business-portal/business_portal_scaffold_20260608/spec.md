# Specification — Business Portal Scaffold (`business_portal_scaffold_20260608`)

## Overview

Establish the foundational codebase for the Flutter Business Portal. This track sets up the project structure, compiles Web compile targets (along with Android and iOS native build stubs), configures the Dart monorepo workspace dependencies, and implements the baseline router shell and placeholder screens.

---

## Functional Requirements

- **Workspace Integration:** Register `apps/business-portal/` as a workspace member in the root `pubspec.yaml`.
- **Target Configuration:** Configure compilation support for Web (primary priority), Android, and iOS.
- **Shared Dependency Wiring:** Integrate path workspace dependencies pointing to `packages/ditto_design` and `packages/mercury_client`.
- **Closed Gated Router:** Implement `GoRouter` configuration where all routes redirect to `/login` if unauthenticated.
- **Responsive Navigation Shell:** Wire the shared `DittoDashboardShell` widget for authenticated views, displaying navigation hooks for all key business areas.
- **Outlets Setup Priority:** Structure navigation to ensure the Company can configure/create Establishments before accessing other sections.

---

## Non-Functional Requirements

- **Linter Alignment:** Configure lints to import the shared `analysis_options.yaml` rules from the workspace root.
- **Compilation Health:** Verify warning-free compilation on Dart Web targets.
- **Aesthetic Coherence:** Moody Blue color scheme seed and dark mode layout matches the shared styling directives.

---

## Screen Inventory & Placeholders

1. **Login Screen:** Initial entry point. Simple secure credentials fields, max opacity styling.
2. **Dashboard:** Operator overview page.
3. **Establishments:** Outlet/store registry management.
4. **Appointments:** Staff-oriented calendar grid.
5. **Table Reservations:** Resource-oriented grid.
6. **Staff:** Employee roster management.
7. **Services:** Menu and duration listings.
8. **Inbox:** Messaging thread view.

---

## Acceptance Criteria

- [ ] Workspace resolved successfully via `dart pub get` at root.
- [ ] Application compiles warning-free on Web: `flutter build web --debug`.
- [ ] Initial route redirects to `/login`.
- [ ] Successful credentials submission redirects to `/dashboard`.
- [ ] Navigating between all 8 placeholder screens displays their corresponding shell headers.
- [ ] Linter check passes with zero warnings.

---

## Out of Scope

- Integrating real SurrealDB OIDC Vipps flows or live WebSocket data streams.
- Implementing full CRUD dialogues or database repository calls.
