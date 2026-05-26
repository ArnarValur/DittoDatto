---
schema: HoldSchema
domain_term: Hold
firestore_path: companies/{companyId}/holds/{holdId}
status: active
version: v1.0
related: [store, service, user, booking, staff-member, resource]
noona_equivalent: N/A (Noona uses direct booking)
tags: [core, booking-spine, mercury-engine]
---

# Hold

A temporary reservation of a time slot during the checkout process. Prevents double-booking by locking the slot for a fixed duration while the customer confirms. Holds expire automatically — expired holds free the slot for others.

> **The Tetris analogy:** Holds are the "falling piece" in the scheduling Tetris. Once confirmed, they become a Booking (locked piece). If they expire, the slot re-opens.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Composite key: `"storeId_YYYY-MM-DD_HH:MM"` |
| `userId` | `string` | ✅ | Who placed the hold |
| `companyId` | `string` | ✅ | Company context |
| `storeId` | `string` | ✅ | Store context |
| `serviceId` | `string` | ❌ | **Legacy.** Single-service hold. |
| `serviceIds` | `string[]` | ✅ | Multi-service support |
| `staffId` | `string` | ❌ | Staff performing the service |
| `resourceId` | `string` | ❌ | Resource locked during hold (table, room) |
| `date` | `string` | ✅ | Date string `"YYYY-MM-DD"` (for efficient querying) |
| `slotTime` | `string` | ✅ | Time string `"HH:MM"` |
| `duration` | `number (int)` | ✅ | Total duration in minutes |
| `expiresAt` | `Date` | ✅ | When this hold auto-expires |
| `createdAt` | `Date` | ✅ | When the hold was created |
| `paymentStatus` | `enum: pending, initiated, failed` | ❌ | Payment flow status (future: Vipps) |
| `vippsOrderId` | `string` | ❌ | Vipps payment reference (future) |

## Lifecycle

```
created → [customer confirms] → Booking created, Hold deleted
created → [timer expires]     → Hold auto-deleted, slot freed
created → [customer cancels]  → Hold deleted, slot freed
```

## Relationships

- A **Hold** locks a slot at one **Store** for one **User**
- A **Hold** references one or more **Services** (via `serviceIds`)
- A **Hold** may lock a **Staff Member** (via `staffId`)
- A **Hold** may lock a **Resource** (via `resourceId`)
- A confirmed **Hold** becomes a **Booking**
- **MercuryEngine** creates holds via `POST /holds` and checks existing holds during slot calculation

## Design Notes

- **Composite key** (`storeId_date_time`) enables efficient conflict detection. No two holds can have the same key for the same staff+service combination.
- **`serviceId` vs `serviceIds`:** Legacy single-service field retained for backward compatibility. `serviceIds` is the canonical field for multi-service holds.
- **Expiry** is enforced by MercuryEngine: expired holds are excluded from slot calculations. A scheduled cleanup function garbage-collects expired hold documents.
- **Payment integration** (`paymentStatus`, `vippsOrderId`) is pre-wired for v1.3 Vipps flow: Hold → Payment initiated → Payment confirmed → Booking created.
