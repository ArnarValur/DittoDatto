---
title: "Session 20: Flutter Admin Screens"
type: "walkthrough"
session: "S20"
date: "2026-05-06"
domain: "Flutter / Admin"
tags:
  - "flutter"
  - "admin"
  - "riverpod"
  - "dashboard"
  - "crud"
---

# Session 20: Flutter Admin Panel Screens

**Objective:** Wire all 4 admin screens (Dashboard, Users, Companies, Categories) to live MercuryEngine data via the `mercury_client` shared package.

**Execution:** 3 vertical slices — S20a (Dashboard + Categories), S20b (Users), S20c (Companies).

---

## What Was Built

### Shared Widgets (`lib/features/shared/`)

| Widget | Purpose |
|--------|---------|
| `stat_card.dart` | Reusable metric card — icon in colored circle, large value, label |
| `confirm_dialog.dart` | Generic "Are you sure?" dialog, returns bool |
| `role_badge.dart` | Colored pill badges for `ActorRole`, `CompanyTier`, `OnboardingStatus` |

### Dashboard (`lib/features/dashboard/`)

- **Provider:** `FutureProvider.autoDispose<AdminStats>` — fetches from `GET /admin/stats`
- **Screen:** 2×2 grid of `StatCard` widgets:
  - Users (Moody Blue), Companies (Blue), Categories (Amber), Engine Health (Green/Red)
- Pull-to-refresh via `RefreshIndicator`
- Error state with retry button

### Categories (`lib/features/categories/`)

- **Provider:** `AsyncNotifierProvider` — full CRUD with `invalidateSelf()` after mutations
- **Dialog:** Create/edit form with:
  - Name (required), Slug (auto-generated from name, manually overridable), Description, Icon
  - Form validation — slug must be lowercase alphanumeric with hyphens
- **Screen:** `DataTable` with columns: Name, Slug, Icon, Count, Actions (edit/delete)
- Delete: `ConfirmDialog` → `AdminApi.deleteCategory(id)`
- Empty state with "Create your first category" CTA

### Users (`lib/features/users/`)

- **Provider:** `AsyncNotifierProvider` — paginated list (50/page) + role update
- **Screen:** `DataTable` with columns: Name, Email, Role (badge), Company, Created, Actions
- **Role badges:** Gold (super_admin), Blue (admin), Gray (operator), Green (agent)
- **Role editing:** `PopupMenuButton` with all roles — calls `AdminApi.updateUserRole(id, role)`
- **Pagination:** Previous/Next controls, "Showing X–Y of Z" counter

### Companies (`lib/features/companies/`)

- **Provider:** `AsyncNotifierProvider` — paginated list (50/page) + create/update
- **Dialog:** 7-section form:
  1. Core (name, slug, owner ID, description)
  2. Contact (email, phone, website)
  3. Address (street, city, ZIP)
  4. Tier & Status (dropdowns for CompanyTier, OnboardingStatus)
  5. Feature Flags (4 checkboxes: table reservation, AI assistance, tickets, events)
  6. Store Policy (max stores, can create own stores)
  7. Social Links (Facebook, Instagram, X)
- **Screen:** `DataTable` with horizontal scroll, tier/onboarding badges
- Pagination controls matching Users screen pattern

---

## File Inventory (13 new files)

```
apps/admin/lib/features/
├── shared/
│   ├── stat_card.dart          [NEW]
│   ├── confirm_dialog.dart     [NEW]
│   └── role_badge.dart         [NEW]
├── dashboard/
│   ├── dashboard_provider.dart [NEW]
│   └── dashboard_screen.dart   [MODIFIED — replaced stub]
├── categories/
│   ├── categories_provider.dart [NEW]
│   ├── category_dialog.dart     [NEW]
│   └── categories_screen.dart   [MODIFIED — replaced stub]
├── users/
│   ├── users_provider.dart      [NEW]
│   └── users_screen.dart        [MODIFIED — replaced stub]
└── companies/
    ├── companies_provider.dart  [NEW]
    ├── company_dialog.dart      [NEW]
    └── companies_screen.dart    [MODIFIED — replaced stub]
```

## Architecture Pattern

All screens follow the same Riverpod pattern:

```
Screen (ConsumerWidget)
  └── watches AsyncNotifier/FutureProvider
       └── calls AdminApi (from adminApiProvider)
            └── HTTP → MercuryEngine
```

CRUD operations use `ref.invalidateSelf()` for automatic re-fetch after mutations.
Error handling uses `MercuryApiException` catch → `SnackBar` feedback.

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| Built-in `DataTable` | Sufficient for admin use case; upgrade to `data_table_2` if needed |
| `AsyncNotifier` + `invalidateSelf()` | Simplest CRUD pattern — consistent, no optimistic updates needed |
| `DropdownButtonFormField.initialValue` | Flutter 3.33 deprecated `.value` parameter |
| Slug auto-generation | Name → lowercase → strip special chars → hyphenate → editable override |

## Verification

- ✅ `dart analyze` clean on `apps/admin/` and `packages/mercury_client/`
- ✅ App runs in Chrome (web), login screen renders
- ⏳ Visual review on LineageOS tablet — pending next session

---

*Session 20 — 2026-05-06 01:05–01:50*
