---
schema: BookingPolicySchema
domain_term: Booking Policy
firestore_path: Embedded in Store (bookingPolicy field)
status: active
version: v1.0
related: [store]
noona_equivalent: Company.profile (booking settings)
tags: [core, business-portal, booking-spine]
---

# Booking Policy

Per-store rules governing how customers can book, cancel, and reschedule. Embedded directly in the Store document — not a standalone collection. Enforced by MercuryEngine (slot generation, hold creation) and client-side cancel/reschedule flows.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `maxBookableFutureDays` | `number (int)` | ✅ | How far ahead customers can book (days). Default: `60` (~2 months) |
| `minBookingNoticeMinutes` | `number (int)` | ✅ | Minimum advance notice to book (minutes). Default: `60` (1 hour) |
| `slotInterval` | `number (int)` | ✅ | Slot generation step (minutes): 15 = :00/:15/:30/:45. Default: `15` |
| `clientCancelEnabled` | `boolean` | ✅ | Whether customers can self-cancel. Default: `true` |
| `minCancelNoticeHours` | `number (int)` | ✅ | Minimum notice for free cancellation (hours). Default: `24` |
| `clientRescheduleEnabled` | `boolean` | ✅ | Whether customers can self-reschedule. Default: `true` |
| `minRescheduleNoticeHours` | `number (int)` | ✅ | Minimum notice for rescheduling (hours). Default: `24` |
| `bookingConfirmationMessage` | `string` | ❌ | Custom message after successful booking (max 500 chars) |
| `noShowFeePercent` | `number (int)` | ✅ | % of service price charged on no-show. Default: `0`. Only enforced when payment is live. |

## Enforcement Points

| Rule | Enforced By | How |
|------|-------------|-----|
| `maxBookableFutureDays` | MercuryEngine `getSlots` | Filters out dates beyond the window |
| `minBookingNoticeMinutes` | MercuryEngine `getSlots` | Filters out slots too close to now |
| `slotInterval` | MercuryEngine `getSlots` | Steps slot generation by this interval |
| `clientCancelEnabled` | Client cancel flow | Hides cancel button if `false` |
| `minCancelNoticeHours` | Client cancel modal | Shows deadline warning; blocks late cancels |
| `noShowFeePercent` | Future: Payments | Charges fee on no-show via Vipps |

## Relationships

- A **Booking Policy** is embedded in exactly one **Store**
- **MercuryEngine** reads the policy during slot calculation and hold creation
- The **Business Portal** provides UI for editing the policy (BookingPolicyCard under Hours tab)

## Design Notes

- Policy is per-store, not per-company. A company with a salon and a spa can have different cancellation windows.
- `noShowFeePercent` is pre-wired but dormant until Vipps integration (v1.3). Setting it to >0 today has no effect.
- Inspired by Noona HQ's `company.profile` booking settings, but adapted for DittoDatto's multi-store model.
