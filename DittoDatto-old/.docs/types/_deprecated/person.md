---
schema: PersonSchema
domain_term: Person
firestore_path: companies/{companyId}/stores/{storeId}/persons/{personId}
status: deprecated
version: v0.1
superseded_by: staff-member
related: [store, service, booking]
noona_equivalent: Employee (legacy)
tags: [deprecated]
---

# Person (⚠️ Deprecated)

**Superseded by [Staff Member](../staff-member.md).** Retained for backward compatibility with existing booking data.

The original staff representation — a simple per-store record with name, role, and schedule. Lacks multi-store assignment, capabilities, lifecycle management, and proper auth linking.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Parent store |
| `userId` | `string` | ❌ | Linked user (optional) |
| `name` | `string` | ✅ | Display name |
| `role` | `string` | ❌ | Free-text role |
| `groups` | `string[]` | ❌ | Service group names |
| `imageUrl` | `string (url)` | ❌ | Photo |
| `isBookable` | `boolean` | ✅ | Default: `true` |
| `schedule` | `OpeningSchedule` | ❌ | Per-person schedule override |

## Migration Path

- ✅ `personId` fields on Booking, Service, and Hold renamed to `staffId` (Session 3, 2026-05-02)
- Person documents will be migrated to StaffMember documents
- Phase 4 of the Staff Management track handles this migration
- Until migration: both schemas coexist, new code uses StaffMember

## Why Deprecated

- **Per-store only:** A person could only belong to one store. StaffMember supports multi-store via `storeIds[]`.
- **No capabilities:** Person had a free-text `role` field. StaffMember has granular `StaffCapability` enums.
- **No lifecycle:** No invite/accept/suspend flow. StaffMember has full status lifecycle.
- **No auth linking:** `userId` was optional and unmanaged. StaffMember auto-links via Firebase trigger.
