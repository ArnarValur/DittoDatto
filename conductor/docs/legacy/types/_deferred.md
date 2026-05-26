---
session: 2
date: 2026-05-02
status: deferred
---

# Deferred Grill Items — Session 2

Items identified during the Type Schema grill that are out of v1.0 scope. Each should be revisited in the relevant future session.

## v1.1 — Favorites & Discovery

- [ ] **Staff favoriting UX** — `UserFavoriteSchema` supports `type: "person"` but should we surface it in Flutter? Use case: "I want *that* stylist." Revisit during v1.1 Favorites track.

## v1.2 — Restaurant Vertical

- [ ] **Customer resource selection** — Noona supports `customer_selects: "resource"` (customer picks a specific table/room). Currently engine always auto-assigns. Revisit when building reservation UX.
- [ ] **`reservationConfig` migration** — Removed from Store (ADR-0004). Needs a new home (Service or Resource level). Design in MercuryEngine Session 3.
- [ ] **Check-in tracking** — Add `checkInAt`, `checkInBy` to Reservation schema (Noona insight). Needed for restaurant host flow.
- [ ] **Booking questions** — Noona has per-service custom intake questions. DittoDatto has `Booking.notes` (free-text). Consider structured questions for restaurants ("allergies?", "occasion?").

## v1.3 — Payments

- [ ] **No-show fee enforcement** — `BookingPolicy.noShowFeePercent` exists but is dormant until Vipps integration.
- [ ] **Payment fields on Hold/Booking** — `paymentStatus`, `vippsOrderId`, `paymentId` are pre-wired but unused.

## v1.5 — Datto (AaaS)

- [ ] **`enabledFeatures` → `usagePolicy` migration** — Replace boolean gates with usage limits + Datto-mediated activation (ADR-0005).
- [ ] **Intelligent staff assignment** — Datto scoring layer on top of `staffAssignmentMode: "any_available"` (ADR-0006).
- [ ] **Admin Panel sunset path** — Panel transitions from gatekeeper to read-only monitor.

## CRM Track (Portal, timing TBD)

- [ ] **Customer auto-creation** — MercuryEngine should auto-create/update Customer on booking completion. Verify wiring.
- [ ] **Walk-in user flow** — Staff creates minimal User for phone/walk-in bookings (no BankID required). Design the Portal UX.
- [ ] **Customer segments/tags** — Beyond `status: new/active/inactive`, businesses may want custom tags ("VIP", "difficult").
- [ ] **Waitlist system** — Noona's `WaitlistEntry` with `preferred_times` and `booking_offer` with `expires_at`. Powerful for high-demand slots.

## Code Cleanup

- [ ] **Remove `storeId`/`companyId` from `BookingItemSchema`** — Redundant (always same as top-level). Same-store only.
- [x] **`DateTimeSchema` unification** — ADR-0003 (executed by parallel agent).
- [ ] **`storeType` enum: `"store"` → `"service"`** — ADR-0004. Mechanical rename.
- [ ] **Remove `Store.bookingFormType`** — ADR-0004.
- [ ] **Add `staffAssignmentMode` to Service** — ADR-0006.
- [x] **`CurrencySchema` audit** — USD removed. NOK only. Add `SEK`/`DKK`/`EUR` when Scandinavia expansion begins.
- [ ] **Add `bankIdVerified` to Firebase custom claims** — Pending Session 3 BankID integration design.
