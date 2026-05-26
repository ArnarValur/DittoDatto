---
schema: EventSchema
domain_term: Event
firestore_path: companies/{companyId}/events/{eventId}
status: active
version: v1.0
related: [company, store, ticket]
noona_equivalent: N/A (Noona's "Event" = our "Booking")
tags: [events, business-portal]
---

# Event

A one-off or recurring happening organized by a Company — concerts, workshops, classes, meetups. Optionally linked to a Store (location-based) or company-level (virtual/multi-venue). Events can be ticketed via a linked Ticket Bundle.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `companyId` | `string` | ✅ | Organizing company |
| `storeId` | `string` | ❌ | Host store (null = company-level event) |
| `title` | `string` | ✅ | Event title (1–255 chars) |
| `description` | `string` | ❌ | Event description |
| `startDateTime` | `Date` | ✅ | Event start |
| `endDateTime` | `Date` | ❌ | Event end (optional for open-ended events) |
| `timezone` | `string` | ✅ | IANA timezone. Default: `"Europe/Oslo"` |
| `location` | `EventLocation` | ✅ | Venue details (name, address, city, country, coordinates) |
| `coverImageUrl` | `string (url)` | ❌ | Event cover image |
| `status` | `enum: draft, published, cancelled, completed` | ✅ | Lifecycle. Default: `"draft"` |
| `visibility` | `enum: public, private` | ✅ | Who can see it. Default: `"public"` |
| `ticketBundleId` | `string` | ❌ | Linked Ticket Bundle (if ticketed) |
| `hasTickets` | `boolean` | ✅ | Quick UI flag. Default: `false` |
| `ticketingEnabled` | `boolean` | ✅ | Whether ticketing is configured. Default: `false` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |
| `createdBy` | `string` | ✅ | Creator's user ID |

## Planned: Recurring Events

```
recurrence: { frequency, interval, daysOfWeek, endDate }
parentEventId: IdSchema.optional()
isRecurring: z.boolean().default(false)
```

For "Dream On the Full Moon" style monthly events. Not yet implemented — use RRULE standard when ready (see Noona insights).

## Relationships

- An **Event** belongs to one **Company**
- An **Event** may be hosted at a **Store** (via `storeId`)
- An **Event** may have a **Ticket Bundle** for ticketed events
- **Activity** cards can reference events (via `context.eventId`)

## Design Notes

- Naming clarity: In DittoDatto, an **Event** is a concert/workshop/meetup. A **Booking** is an appointment. Noona confusingly calls appointments "Events" — we don't.
- `hasTickets` and `ticketingEnabled` are denormalized booleans for quick UI rendering without querying the Ticket Bundle sub-collection.
- `EventLocation` is a standalone object (not a reference to Store) because events can happen at external venues.
- Recurring events are deferred. When implemented, store one document with an RRULE string rather than N individual documents. Let MercuryEngine expand instances dynamically.
