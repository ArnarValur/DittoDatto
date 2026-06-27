# Noona.is CRM Domain Research

> Research conducted June 2026 from pre-downloaded Noona API documentation.
> Purpose: Inform DittoDatto's CRM track design for the Business Portal.

---

## 1. Executive Summary

Noona.is is an Icelandic service-booking platform (7M+ appointments booked, 3500+ active users) that provides an all-in-one system for service businesses: appointment scheduling, online bookings, POS, payments, CRM, and customer communications.

**Noona's CRM is not a standalone module** — it's the connective tissue between booking, payments, and communication. The "CRM" emerges from:

- **Customer profiles** with contact info, notes, tags, custom properties, file attachments, and notices
- **Event (booking) history** linked to customers and employees
- **Customer groups** for segmentation
- **Activity logs** tracking all changes per customer/event
- **Memos** for daily business notes
- **Multi-channel communication**: SMS reminders, email confirmations, push notifications, marketing campaigns
- **Waitlists** with booking offers
- **Recurring bookings** via RRULE
- **Duplicate detection and merging**
- **Custom properties** for extensibility (scoped to customers or events)

Noona separates concerns into two APIs:
- **HQ API** (business-facing): Full CRUD on all entities, staff management, notifications config
- **Marketplace API** (consumer-facing): Discovery, booking, limited customer view

---

## 2. Data Model Map

### Core Entities & Relationships

```
┌──────────────────────────────────────────────────────────┐
│                        COMPANY                           │
│  (top-level tenant — all entities scoped to company_id)  │
└────────┬─────────┬──────────┬────────┬──────────┬────────┘
         │         │          │        │          │
    ┌────▼───┐ ┌───▼────┐ ┌──▼───┐ ┌──▼───┐ ┌───▼────────┐
    │Employee│ │Customer│ │Event │ │Memo  │ │CustomerGroup│
    │        │ │        │ │Type  │ │      │ │             │
    └───┬────┘ └───┬────┘ └──┬───┘ └──────┘ └─────────────┘
        │          │         │
        │     ┌────▼─────────▼────┐
        ├────►│      EVENT        │◄── (booking/appointment)
        │     │ (the hub entity)  │
        │     └────┬──────────────┘
        │          │
        │     ┌────▼────┐
        │     │Activity │  (audit log per entity)
        │     └─────────┘
        │
   ┌────▼─────────┐
   │  Reminder     │  (automated SMS/email before events)
   └──────────────┘

Cross-cutting:
  • Custom Properties → scoped to "customers" or "events"
  • Tags → key:boolean map on Customer and Event
  • Attachments → files on Customer and Event
  • Notices → dismissable alerts on Customer
  • Waitlist Entry → customer + preferred times + booking offers
  • Scheduled Event → capacity-based events with tiers (concerts, classes)
```

### Key Relationships

| Relationship | How Noona Models It |
|---|---|
| Customer ↔ Company | `company_id` on customer. Customer belongs to ONE company. |
| Customer ↔ Employee | `employee_ids[]` array on customer. Tracks which employees have served this customer. |
| Customer ↔ Event | `customer` field on event (expandable). `event_count`, `previous_event`, `next_event` on customer. |
| Employee ↔ Event | `employee` field on event (expandable). One employee per event. |
| Customer ↔ Group | `groups[]` array of group IDs on customer. Many-to-many. |
| Event ↔ Event Type | `event_types[]` array on event. Multiple service types per booking. |
| Event ↔ Recurring | `recurring_event` self-referential link + `rrule` string (RFC 5545). |
| Event ↔ Scheduled Event | `scheduled_event` field linking to capacity-based event. |
| Customer ↔ Marketplace User | `marketplace_user` and `parent_marketplace_user` fields on customer. Bridges HQ ↔ Marketplace. |
| Customer ↔ Duplicates | `duplicates` field + `duplicateStatus` ("possible" / "approved"). |

---

## 3. Deep-Dive per Domain

### 3.1 Customers

**Data model (full customer profile):**

| Field | Type | Notes |
|---|---|---|
| `id` | string | Unique identifier |
| `name` | string | **Required** on create |
| `kennitala` | string | Icelandic national ID (SSN equivalent) |
| `phone_number` | string/number | |
| `phone_country_code` | string | e.g. "354" |
| `email` | string | |
| `license_plate` | string | For car-service businesses |
| `license_plates` | string[] | All plates customer has used |
| `company_id` / `company` | string | Owning company |
| `event_count` | integer | Total bookings (computed) |
| `groups` | string[] | Customer group IDs |
| `employee_ids` | string[] | Employees who've served this customer |
| `previous_event` | expandable | Last completed event |
| `next_event` | expandable | Next upcoming event |
| `duplicates` | object | Linked duplicate customer records |
| `duplicateStatus` | enum | "possible" or "approved" |
| `notes` | string | Free-text notes |
| `update_origin` | string | "hq", "online", etc. |
| `updated_by` | string | Who last updated |
| `last_employee` | string | Name of last serving employee |
| `last_event` | datetime | When last event occurred |
| `custom_properties` | array | Custom field values `[{id, values[], valueIsId}]` |
| `attachments` | array | Files `[{id, filename, type, secure_url, ...}]` |
| `notices` | array | Alert banners `[{id, message, variant, dismissable, expires_at}]` |
| `tags` | object | Key:boolean map (e.g. `vip: true`, `wheelchair: true`, dietary flags) |
| `marketplace_user` | string | Link to consumer-side user |
| `parent_marketplace_user` | string | For child/dependent accounts |
| `created_at` / `updated_at` | datetime | |

**CRUD Operations:**

| Endpoint | Method | Description |
|---|---|---|
| `/v1/hq/customers` | POST | Create customer (name required) |
| `/v1/hq/companies/{id}/customers` | GET | List all customers at company |
| `/v1/hq/customers/{id}` | GET | Retrieve single customer |
| `/v1/hq/customers/{id}` | POST | Update customer |
| `/v1/hq/customers/{id}` | DELETE | Delete customer |
| `/v1/hq/customers/{id}/merge` | POST | Merge customers (irreversible) |
| `/v1/hq/customers/{id}/send` | POST | Email customer their data (GDPR) |
| `/v1/hq/customers/{id}/files/{file_id}` | GET | Get attachment with signed URL |
| `/v1/hq/customers/{id}/files/{file_id}` | DELETE | Delete attachment |

**Notable patterns:**
- **Duplicate detection & merging**: Customers have `duplicates` and `duplicateStatus` fields. Merge operation is irreversible — target customer absorbs all data from source customers.
- **GDPR "send data"**: Dedicated endpoint to email customer an overview of all stored data.
- **Computed fields**: `event_count`, `last_employee`, `last_event` are server-computed from booking history.
- **Tags are predefined keys**: Not arbitrary — includes `vip`, `wheelchair`, dietary preferences (gluten_free, vegan, etc.). Business-specific booleans.
- **Notices**: Staff-facing alert banners on customer profiles (e.g. "Important information!") with variants (info), dismissable flag, and expiry.

### 3.2 Customer Groups (Segmentation)

Simple label-based grouping:

| Field | Type |
|---|---|
| `id` | string |
| `company` | string |
| `title` | string (e.g. "Regulars") |
| `description` | string |
| `created_at` / `updated_at` | datetime |

**CRUD:** Full create/read/update/delete at `/v1/hq/customer_groups`. Groups are referenced by ID in the customer's `groups[]` array.

**Limitations:** No auto-assignment rules, no smart segments (e.g. "customers who haven't visited in 90 days"). Purely manual assignment. Marketing campaigns target groups.

### 3.3 Events (Bookings/Appointments)

The **central entity** of the entire system. Key CRM-relevant fields:

| Field | Notes |
|---|---|
| `customer` / `customer_name` | Expandable link to customer |
| `employee` / `employee_name` | Expandable link to assigned staff |
| `new_customer` | boolean — was this their first visit? |
| `event_types[]` | Services being performed |
| `variation_selections[]` | Service variations selected |
| `starts_at` / `ends_at` | ISO 8601 timestamps |
| `duration` | Minutes |
| `status` | See Event Statuses below |
| `origin` | enum: "online", "hq", etc. |
| `booking_source` | `{group, channel, funnel}` — tracks attribution |
| `comment` | Staff note |
| `customer_comment` | Customer's booking note |
| `unconfirmed` | Requires employee confirmation |
| `special` | User-set flag (no system behavior) |
| `pinned` | User-set flag |
| `tags` | `{birthday: true}` etc. |
| `check_in_at` | Timestamp when customer arrived |
| `check_in_origin` | How they checked in |
| `price` | `{currency, amount, amount_upper_limit}` |
| `invoice_status` | "paid" etc. |
| `cancel_reason` | Free text |
| `outstanding_no_show_fee` | Amount owed for no-show |
| `notification_preferences` | `{sms, email, push}` per event |
| `custom_properties` | Custom field values |
| `attachments` | Files |
| `rrule` | RFC 5545 recurrence rule |
| `recurring_event` | Link to parent recurring event |
| `scheduled_event` | Link to scheduled (capacity) event |
| `waitlist_entry` | Link to originating waitlist entry |
| `booking_offer` | Link to booking offer |
| `ticket_id` | e.g. "A3B7C2K9" for ticketed events |
| `version` | Optimistic concurrency |
| `created_by` / `updated_by` | Audit |
| `accepted_at` / `declined_at` | For confirmation workflow |

**Event Statuses** (customizable per company):
- Default: `showup`, `noshow`, plus custom statuses
- Each status has: `name`, `label`, `color`, `order`, `default` flag
- Full CRUD at `/v1/hq/event_statuses`

**Event Lifecycle:**
1. Created (online or HQ) → optionally `unconfirmed`
2. `accepted_at` set when employee confirms
3. `check_in_at` set via check-in endpoint (can trigger terminal payment)
4. Checkout endpoint creates Sale, Transaction, Line Items
5. Status set to `showup` / `noshow` / custom

**CRUD + Special ops:**
- Standard CRUD at `/v1/hq/events`
- `POST .../events/{id}/checkin` — check-in with optional terminal/voucher payment
- `POST /v1/hq/events/{id}/checkout` — scaffolds sale resources
- `GET .../events/count` — count events by date
- `GET .../events/stream` — real-time event stream (SSE/WebSocket)

### 3.4 Employees (Staff)

| Field | Notes |
|---|---|
| `name`, `email`, `phone_*` | Contact info |
| `description` + translations | Bio |
| `image` | Profile photo (Cloudinary) |
| `role` | Role ID |
| `available_for_bookings` | Calendar visibility |
| `marketplace` | Online booking settings: `{enabled, booking_interval, prioritized, exclude_new_customers, ...}` |
| `notifications` | Granular per-channel settings for own/other/staff bookings, payments, waitlist, booking offers |
| `sms` | Custom SMS sender name and text |
| `event_type_preferences` | Per-service custom durations and skip flags |
| `commissions` | POS and calendar commission rates |
| `settlement_account` | For payments |
| `adyen` / `teya` | Payment provider integration status |

**Staff-Client relationship**: Modeled via `employee_ids[]` on customer (populated automatically as employees serve that customer). The `last_employee` field on customer shows the most recent. Employee's `exclude_new_customers` flag on marketplace settings can restrict new customers from booking with specific staff.

### 3.5 Recurring Bookings

**Two distinct models:**

**A. RRULE-based recurring events (on Event entity):**
- `rrule` field: Standard RFC 5545 recurrence rule string
- Example: `"FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR"`
- `recurring_event` field: self-referential link to parent event
- Max 2 years into future
- `dtstart` is ignored (uses event's `starts_at`)
- Individual occurrences are full Event objects linked to parent

**B. Scheduled Events (capacity-based):**
- For concerts, classes, workshops — NOT repeating appointments
- Has `tiers[]` with capacity, pricing, variations, booking questions
- Tier creates managed Event Types and Resources behind the scenes
- Fields: `total_capacity`, `remaining_capacity`, `is_full`
- Cancellation policy: `allow_cancellation`, `min_cancel_notice_minutes`
- Location with Google Place ID, address, lat/lng, timezone
- Payment settings per tier (pre-payment, flat fee, ratio)

### 3.6 Communication Funnel

**Layer 1: Automated Reminders** (`/v1/hq/reminders`)
- Configured per company with `minutes_before` (e.g. 1440 = 24hr)
- Channels: SMS, email, push, in-HQ notification
- Scoped to specific employees and/or event types, or company-wide
- SMS content supports template variables: `{{customer_name}}`, `{{employee_name}}`, `{{event_time}}`, `{{company_name}}`
- Multi-language translations via `sms_content_translations`
- Active/inactive toggle
- Validation: only one global reminder per time period

**Layer 2: Automated Emails** (`/v1/hq/companies/{id}/emails`)
- Types include: `event_confirmation_customer`
- Tracked with delivery status events (`processed`, timestamps)
- Calendar invite attached to confirmation emails

**Layer 3: SMS Messages** (`/v1/hq/companies/{id}/sms_messages`)
- Full message log per company
- Each SMS linked to company, employee, event
- Includes event details in response (full event expansion)

**Layer 4: Notifications** (`/v1/hq/notifications`)
- In-app notifications for HQ users (employees)
- Title + message + company + employee scoping
- CRUD + stream endpoint for real-time delivery
- Notification settings: dynamic categories/subcategories/channels structure
  - Categories: "online_bookings", with subcategories "new_bookings", "reschedules", "cancellations"
  - Channels: "hq", "email", "push" — each can be locked

**Layer 5: Push Notifications**
- Mobile app notifications for the Noona consumer app
- Free for businesses — additional reminder 1 hour before

**Layer 6: Marketing Campaigns** (from features docs)
- SMS campaigns to customer groups
- "Target the usual suspects" — extra reminders for no-show-prone customers
- Bulk messaging: all customers "coming today/tomorrow/this week"

**Employee notification preferences** are deeply granular:
- Own online bookings (new/reschedule/cancel) × (hq/email/push)
- Staff booking updates × channels
- Other online bookings × channels
- Payments (successful/failed payouts) × channels
- Waitlist (new requests) × channels
- Booking offers (approved/declined) × channels

### 3.7 Memos

Business notes — NOT customer notes (those are the `notes` field on customer):

| Field | Type |
|---|---|
| `company` | string (expandable) |
| `employee` | string (expandable) |
| `title` | string (required) |
| `content` | string |
| `date` | string |

CRUD at `/v1/hq/memos`. Listed per company. Used for daily operational reminders (e.g. "Order supplies", "Meeting at 2pm").

### 3.8 Activity History

Comprehensive audit log per entity:

| Field | Notes |
|---|---|
| `type` | "customer", "event", "blocked_time", "event_type", "payment" |
| `action` | "created", "updated", "deleted" etc. |
| `field` | Specific field changed (e.g. "status") |
| `old_value` | Previous value |
| `new_value` | New value |
| `customer` | Full embedded customer object |
| `event` | Full embedded event object |

**Endpoints:**
- `/v1/hq/activities/customers/{id}` — per customer
- `/v1/hq/activities/events/{id}` — per event
- `/v1/hq/activities/blocked_times/{id}` — per blocked time
- `/v1/hq/activities/event_types/{id}` — per service type
- `/v1/hq/activities/payments/{id}` — per payment
- `/v1/hq/companies/{id}/activities` — all company activities (last 100)

Activities are sorted descending by occurrence. Full entity objects embedded in each activity entry (denormalized for easy rendering).

### 3.9 Custom Properties

Extensible custom fields scoped to entity types:

| Field | Type | Notes |
|---|---|---|
| `company` | string | |
| `name` | string | Display name (e.g. "Age", "Hair Type") |
| `scope` | enum | "customers" or (presumably) "events" |
| `type` | enum | "input" (free text), possibly "select" |
| `options` | array | `[{id, name}]` for select-type properties |
| `order` | integer | Display order |

**On entities**, custom properties are stored as:
```json
"custom_properties": [
  { "id": "property_id", "values": ["value1"], "valueIsId": true }
]
```
`valueIsId: true` means the value references an option ID rather than being a raw value.

CRUD at `/v1/hq/properties`, listed per company at `/v1/hq/companies/{id}/properties`.

### 3.10 Waitlists

Bridge between demand and supply:

| Field | Notes |
|---|---|
| `company` | Expandable |
| `customer` | Full customer object embedded |
| `employee` | Optional preferred employee |
| `resource` | Optional preferred resource (table, room, etc.) |
| `event_types` | Requested services |
| `number_of_guests` | |
| `notes` | Customer notes |
| `preferred_times` | Array of `{date, times[]}` |
| `booking_offers` | Array of offers sent to customer, each with `{message, starts_at, declined_at, expires_at, event}` |
| `expires_at` | Deprecated |

**Flow:** Customer goes on waitlist → staff sends booking offers → customer accepts/declines → accepted offer creates an event, waitlist entry auto-deleted.

### 3.11 Reviews / Feedback

**No explicit review/rating system found in the API.** The Marketplace API and HQ API have no review endpoints. The Features docs mention "Favorites" (customers can favorite businesses) but no rating/review mechanism.

### 3.12 Marketplace (Consumer-Side)

The Marketplace API provides a slimmed-down consumer view:
- **Marketplace Customer**: `{id, name, ssn, email, license_plate, default}` — much simpler than HQ customer
- **"A customer is the HQ view of a marketplace user"** — the HQ Customer entity is the business's enriched version of the marketplace user
- Events are the same core entity, exposed with consumer-relevant fields
- Consumer can send notifications for events

---

## 4. Patterns Worth Adopting for DittoDatto

### 4.1 ✅ Customer Profile as Composite View
Noona's customer isn't just contact info — it's a computed view with `event_count`, `last_employee`, `last_event`, `previous_event`, `next_event`. **Adopt this**: In SurrealDB, these can be live-computed graph traversals rather than denormalized fields.

### 4.2 ✅ Employee-Customer Relationship via Event History
Rather than explicit "preferred staff" records, Noona derives staff-client relationships from booking history (`employee_ids[]` on customer). **Adopt this**: Use graph edges `customer->booked_with->employee` derived from events.

### 4.3 ✅ Tags as Structured Booleans
Tags like `vip`, `wheelchair`, dietary flags — not arbitrary strings. Provides consistent UI and queryability. **Adopt this**: Define a fixed set of business-relevant tags per industry vertical.

### 4.4 ✅ Customer Notices
Alert banners on customer profiles with variant (info/warning), dismissable flag, and expiry. Great UX for staff: "This customer has an outstanding balance" or "Allergic to X product." **Adopt this**.

### 4.5 ✅ Reminder System with Template Variables
SMS/email reminders with `{{customer_name}}`, `{{employee_name}}`, `{{event_time}}` etc. Scoped to specific employees or service types. **Adopt this** for Norwegian SMS.

### 4.6 ✅ Activity Log per Entity
Field-level change tracking with old/new values. Scoped to customer, event, payment, etc. **Adopt this**: SurrealDB's `DEFINE EVENT` can automate this as graph edges.

### 4.7 ✅ Duplicate Detection & Merging
Proactive duplicate detection with `duplicateStatus` and a merge endpoint. Critical for businesses where walk-ins create duplicate profiles. **Adopt this**.

### 4.8 ✅ Custom Properties with Scope
Generic extensibility: businesses define custom fields scoped to "customers" or "events" with input types and option lists. **Adopt this**: SurrealDB's schemaless nature makes this even easier — just validate at the application layer.

### 4.9 ✅ GDPR "Send Customer Data"
One-click endpoint to email a customer all their stored data. **Adopt this** — mandatory under GDPR/Norwegian Datatilsynet rules.

### 4.10 ✅ Waitlist → Booking Offer → Event Pipeline
Elegant flow: waitlist captures demand, booking offers are sent to customers, accepted offers auto-create events. **Adopt this**.

### 4.11 ✅ Event Statuses as Customizable Entities
Default statuses + custom statuses with label, color, order. **Adopt this**: Let each business define their workflow states.

### 4.12 ✅ Booking Source Attribution
`booking_source: {group, channel, funnel}` on events. Tracks where bookings originate (HQ calendar, online, ads). **Adopt this** for analytics.

---

## 5. Patterns to Skip or Adapt

### 5.1 ⚠️ REST-centric Expandable Attributes → SurrealDB Graph Traversal
Noona uses `?expand=customer,employee` query params to inline related objects. In SurrealDB, use `FETCH` clauses or graph traversals instead. No need for the "expandable" pattern.

### 5.2 ⚠️ Flat company_id Scoping → DB-per-Company Isolation
Noona scopes everything via `company_id` in a shared database. DittoDatto uses DB-per-company multi-tenancy in SurrealDB. All customer/event/etc. queries are inherently scoped. No need for company_id filtering.

### 5.3 ⚠️ Kennitala (Icelandic SSN) → Norwegian Fødselsnummer
Replace `kennitala` with Norwegian `fødselsnummer` or `organisasjonsnummer` for B2B customers. Different validation rules.

### 5.4 ⚠️ License Plate Fields → Skip (for now)
Car-service-specific (car washes, auto repair). Not relevant for beauty/wellness/health verticals DittoDatto targets initially. Add later via custom properties if needed.

### 5.5 ❌ Deeply Nested Recursive Event Expansion
Noona's API responses have `recurring_event` nested 14+ levels deep (visible in the response samples). This is a REST API artifact. In SurrealDB, use `->recurring_event->` graph queries with depth limits.

### 5.6 ⚠️ SMS as Primary Channel → Multi-channel (SMS + Email + Push)
Norway's SMS costs and customer expectations differ from Iceland. Plan for email as the primary automated channel with SMS as a paid add-on.

### 5.7 ❌ Monolithic Notification Settings Structure
Noona's employee notification preferences are a deeply nested JSON structure. For DittoDatto, model as a `notification_preference` table with `(employee, category, subcategory, channel, enabled)` rows for easier querying and updating.

### 5.8 ⚠️ Customer Groups → Consider Smart Segments
Noona's groups are purely manual (assign customers by hand). For DittoDatto, consider adding rule-based auto-segments: "Customers with 0 bookings in 90 days", "VIP (10+ bookings)", etc. SurrealDB's live queries can power this.

### 5.9 ❌ No Review System → Add One
Noona has NO customer review/rating system. This is a gap worth filling for DittoDatto's marketplace. Consider post-appointment review prompts.

### 5.10 ⚠️ Memos as Company-Level → Link to Entities
Noona memos are free-floating company + employee + date + title. For DittoDatto, consider also linking memos to specific customers or events for richer CRM context.

---

## 6. Summary Table: Noona CRM Entity Inventory

| Entity | HQ CRUD | Marketplace | Key CRM Role |
|---|---|---|---|
| Customer | Full | List only | Central profile with history, tags, notes |
| Customer Group | Full | No | Manual segmentation |
| Event | Full + check-in/checkout | Full | Booking history, staff assignment |
| Event Status | Full | No | Customizable workflow states |
| Event Type | Full | Read | Service catalog |
| Employee | Full | Read | Staff profiles, notification prefs |
| Reminder | Full | No | Automated pre-event messages |
| Memo | Full | No | Daily business notes |
| Activity | Read (list) | No | Audit log per entity |
| Custom Property | Full | No | Extensible fields |
| Notification | Full + stream | Send | In-app alerts for staff |
| Notification Settings | Read | No | Channel/category config |
| SMS Message | Read (list) | No | Message history |
| Email | Read (list) | No | Email history |
| Waitlist Entry | Full | Full | Demand capture → booking pipeline |
| Scheduled Event | Full | Read | Capacity-based events |
| Booking Offer | via Waitlist | via Waitlist | Waitlist → booking conversion |
