---
schema: TicketSchema, TicketBundleSchema, TicketGroupSchema
domain_term: Ticket / Ticket Bundle / Ticket Group
firestore_path: events/{eventId}/ticketBundles/{bundleId}, events/{eventId}/tickets/{ticketId}
status: active
version: v1.0
related: [event, company]
noona_equivalent: N/A (Noona doesn't have ticketing)
tags: [events, ticketing]
---

# Ticket System

Three-level ticketing hierarchy for events: **Ticket Bundle** (container per event) → **Ticket Group** (pricing tier) → **Ticket** (individual instance). Inspired by the microservices ticketing design from the Noona research video — simplified for DittoDatto's scale.

## Ticket Bundle

Container for all ticket configuration of a single event. One bundle per event.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `eventId` | `string` | ✅ | Parent event |
| `companyId` | `string` | ✅ | Organizing company |
| `totalCapacity` | `number (int)` | ✅ | Sum of all group capacities |
| `bufferCapacity` | `number (int)` | ✅ | Overflow protection seats. Default: `0` |
| `totalSold` | `number (int)` | ✅ | Tickets sold. Default: `0` |
| `totalRevenue` | `number` | ✅ | Revenue in øre. Default: `0` |
| `maxPerPurchase` | `number (int)` | ✅ | Max tickets per transaction. Default: `10` |
| `ageRequirement` | `number (int)` | ❌ | Minimum age (0–99) |
| `salesStart` | `Date` | ❌ | When sales open |
| `salesEnd` | `Date` | ❌ | When sales close |
| `status` | `enum` | ✅ | `draft`, `scheduled`, `active`, `paused`, `soldOut`, `closed` |
| `groups` | `TicketGroup[]` | ✅ | Pricing tiers (min 1) |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |
| `createdBy` | `string` | ✅ | Creator's user ID |

## Ticket Group (embedded in Bundle)

A pricing tier within a bundle — VIP, General Admission, Early Bird, etc.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Group ID |
| `name` | `string` | ✅ | Tier name: "VIP", "General Admission" |
| `description` | `string` | ❌ | What's included |
| `capacity` | `number (int)` | ✅ | Total tickets in this tier |
| `soldCount` | `number (int)` | ✅ | Sold so far. Default: `0` |
| `heldCount` | `number (int)` | ✅ | Currently held. Default: `0` |
| `price` | `number` | ✅ | Ticket price |
| `currency` | `enum: NOK, USD` | ✅ | Default: `"NOK"` |
| `sortOrder` | `number (int)` | ✅ | Display order. Default: `0` |
| `isBuffer` | `boolean` | ✅ | Whether this is an overflow buffer group. Default: `false` |

## Ticket (individual instance)

Created on purchase. One document per ticket sold.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `bundleId` | `string` | ✅ | Parent bundle |
| `eventId` | `string` | ✅ | Parent event |
| `groupId` | `string` | ✅ | Which pricing tier |
| `purchaserId` | `string` | ✅ | Who bought it |
| `holderId` | `string` | ✅ | Current holder (may differ after transfer) |
| `holderName` | `string` | ❌ | Holder's name |
| `holderEmail` | `string (email)` | ❌ | Holder's email |
| `qrCode` | `string` | ❌ | QR code for door scanning |
| `status` | `enum` | ✅ | `available`, `held`, `sold`, `used`, `cancelled`, `transferred` |
| `holdExpiresAt` | `Date` | ❌ | For held tickets |
| `purchasedAt` | `Date` | ❌ | Purchase timestamp |
| `usedAt` | `Date` | ❌ | Check-in timestamp |
| `transferredAt` | `Date` | ❌ | Transfer timestamp |
| `paymentRef` | `string` | ❌ | Payment reference |
| `pricePaid` | `number` | ❌ | Actual price paid |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |

## Ticket Status Lifecycle

```
available → held → sold → used
                      ↘ cancelled
                      ↘ transferred → used
```

## Design Notes

- **Two-phase purchase:** Select → Hold (10 min timer) → Confirm payment → Sold. Same pattern as appointment Holds.
- **`purchaserId` vs `holderId`:** Enables ticket transfers. Buyer stays on record; holder is the current owner.
- **`bufferCapacity`** on Bundle provides overflow protection for high-demand events without increasing visible capacity.
- **QR verification** planned: generate unique QR on purchase, scan at door, mark as `used`. `scannedBy` and `scanLocation` fields planned for multi-entrance venues.
- Payment integration (`paymentProvider`, `merchantId` on Bundle) deferred to v1.3 Vipps integration.
