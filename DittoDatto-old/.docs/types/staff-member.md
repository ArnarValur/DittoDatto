---
schema: StaffMemberSchema
domain_term: Staff Member
firestore_path: companies/{companyId}/staff/{staffId}
status: active
version: v1.0
related: [company, store, service, booking, shift, customer]
noona_equivalent: Employee
tags: [core, business-portal]
---

# Staff Member

An employee or contractor associated with a Company. Can be assigned to multiple Stores, have per-store capabilities, and maintain their own weekly shift schedule. Replaces the deprecated `Person` schema.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `companyId` | `string` | ✅ | Parent company |
| `userId` | `string` | ❌ | Linked platform User (set when invited user signs in) |
| `email` | `string (email)` | ✅ | Invite email |
| `displayName` | `string` | ✅ | Display name |
| `avatarUrl` | `string (url)` | ❌ | Profile photo |
| `storeIds` | `string[]` | ✅ | Assigned stores. Default: `[]` |
| `position` | `string` | ❌ | Free-text position: "Barista", "Senior Stylist", "Manager" |
| `defaultCapabilities` | `StaffCapability[]` | ✅ | Global capabilities. Default: `[]` |
| `storeCapabilities` | `Record<storeId, StaffCapability[]>` | ✅ | Per-store capability overrides. Default: `{}` |
| `isBookable` | `boolean` | ✅ | Whether customers can book with this staff member. Default: `false` |
| `showOnStorefront` | `boolean` | ✅ | Whether visible on the EstablishmentPage. Default: `false` |
| `weeklyShifts` | `WeeklyShift` | ❌ | Recurring weekly availability |
| `dateOverrides` | `DateOverride[]` | ✅ | Date-specific schedule overrides (vacation, sick). Default: `[]` |
| `status` | `enum: invited, active, suspended, removed` | ✅ | Lifecycle status. Default: `"invited"` |
| `invitedAt` | `Timestamp` | ❌ | When the invite was sent |
| `joinedAt` | `Timestamp` | ❌ | When the user accepted and linked |
| `createdAt` | `Timestamp` | ✅ | Record creation |
| `updatedAt` | `Timestamp` | ✅ | Last modification |

## Staff Capabilities

```
can_manage_bookings    can_view_all_bookings   can_manage_schedule
can_manage_services    can_manage_staff        can_view_financials
can_manage_media       can_manage_events       can_manage_settings
```

Capabilities can be set globally (`defaultCapabilities`) or per-store (`storeCapabilities`). Per-store overrides take precedence.

## Lifecycle

```
invited → active → suspended → removed
```

- **invited:** Email invite sent, no `userId` linked yet
- **active:** User signed in and auto-linked via Firebase trigger
- **suspended:** Temporarily disabled (can be re-activated)
- **removed:** Soft-deleted (retained for booking history audit trail)

## Relationships

- A **Staff Member** belongs to exactly one **Company**
- A **Staff Member** is assigned to one or more **Stores** (via `storeIds`)
- A **Staff Member** can perform **Services** (via `Service.assignedStaff[]`)
- A **Staff Member** may be linked to a **User** (via `userId`)
- A **Staff Member** has served **Customers** (tracked in `Customer.staffIds`)
- **Bookings** reference staff via `staffId`

## Design Notes

- **`personId` → `staffId` migration:** ✅ Completed (Session 3, 2026-05-02). All schemas and MercuryEngine now use `staffId`. Legacy `Person` schema retained for backward compat only.
- **Capability-based RBAC** is more granular than role-based. A "Senior Stylist" might manage bookings and schedule but not financials. Phase 3 (RBAC Enforcement) will wire capabilities into Firestore rules and composables.
- **`dateOverrides`** are stored as an array on the StaffMember document for simplicity. If this grows large (years of history), migrate to sub-collection.
- **`showOnStorefront`** controls whether the staff member appears on the public EstablishmentPage. Some staff are bookable but not displayed (e.g., substitute staff).

## Noona Comparison

- Noona's `Employee` is equivalent. Key difference: Noona uses role-based permissions; DittoDatto uses capability-based permissions for finer granularity.
- Noona tracks `commission_rate` on employees; DittoDatto defers financial tracking to a future Payments vertical.
- Both support multi-store assignment.
