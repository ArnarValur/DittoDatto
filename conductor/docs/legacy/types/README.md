# DittoDatto — Type Reference Library

One note per domain type. Designed for GraphRAG ingestion — each note is a self-contained knowledge unit with YAML frontmatter for structured metadata and entity relationships.

## Source of Truth

All Zod schemas live in `packages/shared-types/src/`. These docs are the **human-readable reference** — the code is always canonical.

## Schema Index

### Core Entities

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [company](company.md) | `CompanySchema` | Company | `companies/{companyId}` | Active |
| [store](store.md) | `StoreSchema` | Establishment | `companies/{companyId}/stores/{storeId}` | Active |
| [user](user.md) | `UserSchema` | User | `users/{userId}` | Active |
| [customer](customer.md) | `CustomerSchema` | Customer | `companies/{companyId}/customers/{customerId}` | Active |
| [staff-member](staff-member.md) | `StaffMemberSchema` | Staff Member | `companies/{companyId}/staff/{staffId}` | Active |

### Booking Spine

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [service](service.md) | `ServiceSchema` | Service | `companies/{companyId}/stores/{storeId}/services/{serviceId}` | Active |
| [service-group](service-group.md) | `ServiceGroupSchema` | Service Group | `companies/{companyId}/stores/{storeId}/serviceGroups/{groupId}` | Active |
| [booking](booking.md) | `BookingSchema` | Booking | `companies/{companyId}/bookings/{bookingId}` | Active |
| [hold](hold.md) | `HoldSchema` | Hold | `companies/{companyId}/holds/{holdId}` | Active |
| [booking-policy](booking-policy.md) | `BookingPolicySchema` | Booking Policy | Embedded in Store | Active |

### Reservations & Events

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [reservation](reservation.md) | `ReservationSchema` | Reservation | `companies/{companyId}/stores/{storeId}/reservations/{id}` | Active |
| [experience](experience.md) | `ExperienceSchema` | Experience | `companies/{companyId}/stores/{storeId}/experiences/{id}` | Active |
| [event](event.md) | `EventSchema` | Event | `companies/{companyId}/events/{eventId}` | Active |
| [ticket](ticket.md) | `TicketSchema` + `TicketBundleSchema` | Ticket / Ticket Bundle | `events/{eventId}/tickets/{ticketId}` | Active |

### Resources & Scheduling

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [resource](resource.md) | `ResourceSchema` + `ResourceGroupSchema` | Resource / Resource Group | `companies/{companyId}/stores/{storeId}/resources/{id}` | Active |
| [schedule](schedule.md) | `OpeningScheduleSchema` | Opening Schedule | Embedded in Store | Active |
| [shift](shift.md) | `WeeklyShiftSchema` + `DateOverrideSchema` | Shift / Date Override | Embedded in StaffMember | Active |

### Communications & Activity

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [activity](activity.md) | `ActivitySchema` + `ThreadSchema` + `MessageSchema` + `BroadcastSchema` | Activity / Thread / Message / Broadcast | `activities/{id}`, `threads/{id}` | Active |
| [feedback](feedback.md) | `FeedbackSchema` | Feedback | `feedback/{feedbackId}` | Active |

### Search & Intelligence

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [search-event](search-event.md) | `SearchEventSchema` | Search Event | `searchEvents/{id}` | Active |

### Platform & Access Control

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [auth](auth.md) | `FirebaseTokenClaimsSchema` + `FirebaseUserSchema` | Auth Claims | N/A (Firebase Auth) | Active |
| [rbac](rbac.md) | `RoleSchema` + utility functions | RBAC | N/A (runtime) | Active |
| [category](category.md) | `CategorySchema` | Category | `categories/{categoryId}` | Active |
| [media](media.md) | `MediaItemSchema` | Media Item | `companies/{companyId}/media/{mediaId}` | Active |
| [favorite](favorite.md) | `UserFavoriteSchema` | User Favorite | `users/{userId}/favorites/{id}` | Active |

### System & Config

| Note | Schema | Domain Term | Firestore Path | Status |
|------|--------|-------------|----------------|--------|
| [app-settings](app-settings.md) | `AppSettingsSchema` | App Settings | `settings/app` | Active |
| [system-alert](system-alert.md) | `SystemAlertSchema` | System Alert | `systemAlerts/{alertId}` | Active |
| [icon-collection](icon-collection.md) | `IconCollectionSchema` | Icon Collection | `iconCollections/{id}` | Active |
| [holidays](holidays.md) | N/A (utility functions) | Norwegian Holidays | N/A (computed) | Active |

### Deprecated

| Note | Schema | Domain Term | Status |
|------|--------|-------------|--------|
| [person](_deprecated/person.md) | `PersonSchema` | Person | ⚠️ Deprecated → use StaffMember |

## Conventions

- **One note per domain concept** — optimized for GraphRAG chunking
- **YAML frontmatter** — structured metadata for entity extraction
- **`related:` field** — explicit edges for knowledge graph construction
- **Obsidian-compatible** — standard markdown, no exotic syntax
- **Fields tables** — complete field inventory with types and descriptions
- **Design notes** — edge cases, rationale, Noona comparisons where relevant

---

*Created: 2026-05-02 — Chapter 2 Grill Session 2*
