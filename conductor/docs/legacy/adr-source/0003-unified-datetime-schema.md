---
title: "ADR-0003: Unified DateTimeSchema"
type: "adr"
status: "implemented"
date: "2026-05-02"
session: 2
domain: "Shared Types"
tags:
  - "datetime"
  - "schema"
  - "zod"
---

# ADR-0003: Unified DateTimeSchema for All Timestamps

## Problem

Two timestamp schemas exist in `packages/shared-types/src/common.ts`:

```typescript
export const IsoDateSchema = z.date();
export const TimestampSchema = z.union([
  z.date(),
  z.object({ seconds: z.number(), nanoseconds: z.number() }),
]);
```

They are used inconsistently across 23 schemas:

- **`IsoDateSchema`** (~15 files): Store, Company, Booking, Service, Hold, Reservation, Event, Ticket, Category, ServiceGroup, BookingPolicy, Resource, ResourceGroup, Experience, Common (Range)
- **`TimestampSchema`** (~8 files): StaffMember, Activity, Thread, Message, Broadcast, Feedback, SearchEvent, MediaItem

This creates three problems:
1. **Firestore reads fail `IsoDateSchema` validation** — Firestore returns `{ seconds, nanoseconds }` Timestamp objects, not JS `Date`.
2. **MercuryEngine REST input fails `TimestampSchema` validation** — REST sends ISO strings like `"2026-05-02T14:00:00Z"`, not `Date` or `Timestamp`.
3. **`z.infer` types differ** — `IsoDateSchema` infers to `Date`, `TimestampSchema` infers to `Date | { seconds: number; nanoseconds: number }` — an ugly union type that leaks Firestore internals into domain code.

## Decision

Replace both with a single `DateTimeSchema` that accepts all three input formats and always normalizes to `Date`:

```typescript
/**
 * Universal DateTime schema.
 * Accepts: JS Date, Firestore Timestamp, ISO string.
 * Always outputs: JS Date.
 *
 * Use this for ALL timestamp fields across ALL schemas.
 */
export const DateTimeSchema = z.union([
  z.date(),
  z.object({ seconds: z.number(), nanoseconds: z.number() })
    .transform(t => new Date(t.seconds * 1000 + t.nanoseconds / 1_000_000)),
  z.string().transform(s => new Date(s)),
]).pipe(z.date());
```

### Migration Steps

1. **Add `DateTimeSchema` to `common.ts`**
2. **Find-and-replace across all schema files:**
   - `IsoDateSchema` → `DateTimeSchema` (all imports and usages)
   - `TimestampSchema` → `DateTimeSchema` (all imports and usages)
3. **Remove old schemas from `common.ts`** — clean-cut, no deprecated aliases. Fresh DB means no backward compatibility burden.
4. **Update `index.ts`** — export `DateTimeSchema`, remove old exports
5. **Run existing tests** — verify 156+ MercuryEngine tests still pass
6. **Update type reference docs** — `.docs/types/*.md` field tables should reference `DateTime` not `Date` or `Timestamp`

### Files to modify

| File | Change |
|------|--------|
| `packages/shared-types/src/common.ts` | Add `DateTimeSchema`, remove `IsoDateSchema` and `TimestampSchema` |
| `packages/shared-types/index.ts` | Update exports |
| `packages/shared-types/src/store.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/company.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/booking.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/service.ts` | No timestamp fields (uses `IdSchema`, `PriceSchema` only) |
| `packages/shared-types/src/service-group.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/hold.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/booking-policy.ts` | No timestamp fields |
| `packages/shared-types/src/reservation.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/event.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/ticket.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/resource.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/schedule.ts` | No timestamp fields |
| `packages/shared-types/src/person.ts` | No timestamp fields |
| `packages/shared-types/src/user.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/customer.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/staff.ts` | `TimestampSchema` → `DateTimeSchema` |
| `packages/shared-types/src/shift.ts` | No timestamp fields |
| `packages/shared-types/src/activity.ts` | `TimestampSchema` → `DateTimeSchema` |
| `packages/shared-types/src/search-event.ts` | `TimestampSchema` → `DateTimeSchema` |
| `packages/shared-types/src/feedback.ts` | `TimestampSchema` → `DateTimeSchema` |
| `packages/shared-types/src/media.ts` | `TimestampSchema` → `DateTimeSchema` |
| `packages/shared-types/src/metadata.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/favorite.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/settings.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `packages/shared-types/src/system-alert.ts` | Uses `z.any()` for timestamps — migrate to `DateTimeSchema` |
| `packages/shared-types/src/icon-collection.ts` | Uses `z.string().datetime()` — migrate to `DateTimeSchema` |
| `packages/shared-types/src/admin/company-schemas.ts` | Inherits from CompanySchema, no direct timestamp usage |
| `packages/shared-types/src/admin/user-registry-schemas.ts` | Inherits from UserSchema, no direct timestamp usage |

### Also fix: `system-alert.ts` uses `z.any()` for timestamps

```typescript
// BEFORE (sloppy):
startsAt: z.any().optional(),
expiresAt: z.any().optional(),
createdAt: z.any(),

// AFTER (porcelain):
startsAt: DateTimeSchema.optional(),
expiresAt: DateTimeSchema.optional(),
createdAt: DateTimeSchema,
```

### Also fix: `icon-collection.ts` uses `z.string().datetime()`

```typescript
// BEFORE (inconsistent):
createdAt: z.string().datetime(),
updatedAt: z.string().datetime()

// AFTER (unified):
createdAt: DateTimeSchema,
updatedAt: DateTimeSchema,
```

## Consequences

- **All schemas accept Firestore Timestamps, JS Dates, and ISO strings** — no more validation failures on Firestore reads
- **`z.infer` always gives `Date`** — clean TypeScript types, no union leakage
- **Single import** — `DateTimeSchema` replaces two confusingly named alternatives
- **MercuryEngine tests should pass unchanged** — the transform handles what the code was already doing manually
- **Flutter models are unaffected** — Dart handles `Timestamp → DateTime` natively; Zod schemas are TypeScript-only

## Alternatives Considered

- **Keep both and document the convention** — rejected: documentation doesn't prevent misuse, and the split will propagate into new schemas
- **Use ISO strings everywhere (`z.string().datetime()`)** — rejected: loses Firestore native timestamp ordering and range queries
- **Deprecated aliases** — rejected: clean DB, fresh start, no tvíverknað

## Verification

1. `cd packages/shared-types && npx tsc --noEmit` — type-check passes
2. `cd packages/mercury-engine && npm test` — 156+ tests pass
3. Grep for any remaining `IsoDateSchema` or `TimestampSchema` usage — should be zero

---

## Implementation Walkthrough (2026-05-02)

Executed by Commander Hermes (Antigravity / Claude Opus 4.6).

### The New Schema

```typescript
export const DateTimeSchema = z.union([
  z.date(),
  z.object({ seconds: z.number(), nanoseconds: z.number() })
    .transform(t => new Date(t.seconds * 1000 + t.nanoseconds / 1_000_000)),
  z.string().transform(s => new Date(s)),
]).pipe(z.date());
```

### Files Modified (21 total)

| File | Change |
|------|--------|
| `common.ts` | Added `DateTimeSchema`, removed `IsoDateSchema` + `TimestampSchema`, updated `RangeSchema` |
| `store.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `company.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `booking.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `service-group.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `hold.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `reservation.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `event.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `ticket.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `resource.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `user.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `customer.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `metadata.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `favorite.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `settings.ts` | `IsoDateSchema` → `DateTimeSchema` |
| `staff.ts` | `TimestampSchema` → `DateTimeSchema` |
| `activity.ts` | `TimestampSchema` → `DateTimeSchema` |
| `search-event.ts` | `TimestampSchema` → `DateTimeSchema` |
| `media.ts` | `TimestampSchema` → `DateTimeSchema` |
| `feedback.ts` | `TimestampSchema` → `DateTimeSchema` |
| `system-alert.ts` | `z.any()` → `DateTimeSchema` (porcelain fix) |
| `icon-collection.ts` | `z.string().datetime()` → `DateTimeSchema` (consistency fix) |

### Special Case Fixes

1. **`system-alert.ts`** — Had sloppy `z.any()` for 4 timestamp fields. Now properly typed with `DateTimeSchema`.
2. **`icon-collection.ts`** — Had `z.string().datetime()` which only accepted ISO strings and didn't handle Firestore Timestamps. Now unified.

### Verification Results

| Check | Result |
|-------|--------|
| `npx tsc --noEmit` (MercuryEngine) | ✅ Zero errors |
| `npm test` (MercuryEngine) | ✅ **156 tests pass**, 10 files |
| `grep IsoDateSchema` | ✅ Zero hits |
| `grep TimestampSchema` | ✅ Zero hits |
