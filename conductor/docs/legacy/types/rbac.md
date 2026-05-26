---
schema: RoleSchema, ROLE_HIERARCHY, APP_ACCESS_RULES
domain_term: RBAC
firestore_path: N/A (runtime utility)
status: active
version: v1.0
related: [user, auth]
noona_equivalent: Roles + Permission groups
tags: [core, security]
---

# RBAC (Role-Based Access Control)

Runtime utilities for role hierarchy and app access rules. Not a Firestore schema — these are pure functions and constants shared across the codebase.

## Role Hierarchy

```
customer < business < admin < super_admin
```

Higher index = more permissions. `hasMinRole("business", "customer")` returns `true`.

## App Access Rules

| App | Allowed Roles | Unauthenticated |
|-----|---------------|-----------------|
| `public-marketplace` | All roles | ✅ Yes |
| `business-portal` | business, admin, super_admin | ❌ No |
| `admin-panel` | super_admin only | ❌ No |

## Utility Functions

| Function | Description |
|----------|-------------|
| `hasMinRole(userRole, minRole)` | Does user have at least the minimum role? |
| `hasExactRole(userRole, role)` | Is the role exactly this? |
| `hasAnyRole(userRole, roles)` | Is the role in the allowed list? |
| `canAccessApp(userRole, appName)` | Can this role access this app? |
| `getRoleFromClaims(claims)` | Extract and validate role from Firebase claims |

## Design Notes

- RBAC is deliberately simple: 4 roles, hierarchical. The Staff capability system (on StaffMember) handles per-store granularity.
- `hasMinRole` is the primary check used throughout the codebase. Prefer it over `hasExactRole`.
- `getRoleFromClaims` validates the role string — returns `null` if claims are missing or invalid.
