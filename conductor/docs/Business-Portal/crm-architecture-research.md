# CRM Architecture Research — Flutter + SurrealDB

> Research conducted June 2026.
> Purpose: Inform DittoDatto's CRM track architecture for the Business Portal.

---

## 1. Executive Summary

The CRM domain for DittoDatto's Business Portal extends the existing `customer` table (already in `company-blueprint.surql`) with graph relationships, segmentation, notes history, reviews, recurring bookings, and a notification pipeline. The architecture leverages SurrealDB's native graph traversal for staff↔customer↔booking relationships and keeps the CRM as a BP-internal feature module (not a shared package).

**Key architectural decisions:**
- CRM stays in `apps/business-portal/lib/features/customers/` — not extracted to a shared package
- SurrealDB graph edges (`booked_by`, `prefers`, `member_of`) replace REST-style denormalized arrays
- BM25 full-text search on customer names via SurrealDB indexes
- Provider patterns match existing `EstablishmentsNotifier` for consistency
- Phased delivery: Customer Core → Relationships → Groups → Reviews → Recurring → Notifications

---

## 2. SurrealDB Schema Proposal

### Existing Foundation

The `customer` table in `schemas/company-blueprint.surql` (lines 289-326) already has:
- `name`, `first_name`, `last_name`, `email`, `phone`, `phone_country_code`
- CRM fields: `notes`, `status` (new/active/inactive), `staff_ids`, `channel` (app/web/portal/import)
- Metrics: `total_visits`, `total_spent`, `first_visit_at`, `last_visit_at`
- `last_booking` record link, `store_ids` array, `user_id` cross-DB string ref

The `message_thread` and `message` tables (lines 529-544) exist in v1.4 scope.

### New Tables

```sql
-- Customer groups/segments (tag-based)
DEFINE TABLE customer_group SCHEMAFULL;
DEFINE FIELD name              ON customer_group TYPE string;
DEFINE FIELD description       ON customer_group TYPE option<string>;
DEFINE FIELD color             ON customer_group TYPE option<string>;  -- hex for UI chips
DEFINE FIELD icon              ON customer_group TYPE option<string>;
DEFINE FIELD is_smart          ON customer_group TYPE bool DEFAULT false;  -- auto-segment
DEFINE FIELD smart_filter      ON customer_group TYPE option<object> FLEXIBLE;  -- filter criteria
DEFINE FIELD created_at        ON customer_group TYPE datetime VALUE time::now() READONLY;

-- Customer notes (separate table for timeline history)
DEFINE TABLE customer_note SCHEMAFULL;
DEFINE FIELD customer          ON customer_note TYPE record<customer> REFERENCE;
DEFINE FIELD staff             ON customer_note TYPE option<record<staff>>;
DEFINE FIELD body              ON customer_note TYPE string;
DEFINE FIELD pinned            ON customer_note TYPE bool DEFAULT false;
DEFINE FIELD created_at        ON customer_note TYPE datetime VALUE time::now() READONLY;

-- Recurring booking template (parent-instance pattern)
DEFINE TABLE recurring_booking SCHEMAFULL;
DEFINE FIELD customer          ON recurring_booking TYPE record<customer> REFERENCE;
DEFINE FIELD service           ON recurring_booking TYPE record<service> REFERENCE;
DEFINE FIELD staff             ON recurring_booking TYPE option<record<staff>>;
DEFINE FIELD establishment     ON recurring_booking TYPE record<establishment> REFERENCE;
DEFINE FIELD rrule             ON recurring_booking TYPE string;  -- RFC 5545 RRULE
DEFINE FIELD start_time        ON recurring_booking TYPE string;  -- HH:MM
DEFINE FIELD day_of_week       ON recurring_booking TYPE option<int>;
DEFINE FIELD interval_weeks    ON recurring_booking TYPE int DEFAULT 1;
DEFINE FIELD horizon_months    ON recurring_booking TYPE int DEFAULT 3;
DEFINE FIELD next_occurrence   ON recurring_booking TYPE option<datetime>;
DEFINE FIELD status            ON recurring_booking TYPE string DEFAULT 'active'
  ASSERT $value IN ['active', 'paused', 'cancelled'];
DEFINE FIELD created_at        ON recurring_booking TYPE datetime VALUE time::now() READONLY;

-- Review (customer feedback on services/staff)
DEFINE TABLE review SCHEMAFULL;
DEFINE FIELD customer          ON review TYPE record<customer> REFERENCE;
DEFINE FIELD booking           ON review TYPE option<record<booking>>;
DEFINE FIELD establishment     ON review TYPE record<establishment> REFERENCE;
DEFINE FIELD staff             ON review TYPE option<record<staff>>;
DEFINE FIELD rating            ON review TYPE int ASSERT $value >= 1 AND $value <= 5;
DEFINE FIELD comment           ON review TYPE option<string>;
DEFINE FIELD reply             ON review TYPE option<string>;  -- business reply
DEFINE FIELD replied_at        ON review TYPE option<datetime>;
DEFINE FIELD is_visible        ON review TYPE bool DEFAULT true;
DEFINE FIELD created_at        ON review TYPE datetime VALUE time::now() READONLY;
```

### New Graph Edges

```sql
-- customer ↔ booking (booking history)
DEFINE TABLE booked_by SCHEMAFULL TYPE RELATION FROM booking TO customer;
DEFINE FIELD created_at ON booked_by TYPE datetime VALUE time::now() READONLY;

-- customer ↔ staff (preferred staff)
DEFINE TABLE prefers SCHEMAFULL TYPE RELATION FROM customer TO staff;
DEFINE FIELD since     ON prefers TYPE datetime VALUE time::now();
DEFINE FIELD notes     ON prefers TYPE option<string>;  -- "likes short layers"

-- customer ↔ customer_group (membership)
DEFINE TABLE member_of SCHEMAFULL TYPE RELATION FROM customer TO customer_group;
DEFINE FIELD added_at  ON member_of TYPE datetime VALUE time::now() READONLY;
DEFINE FIELD added_by  ON member_of TYPE option<record<staff>>;

-- customer ↔ review
DEFINE TABLE reviewed_by SCHEMAFULL TYPE RELATION FROM review TO customer;
DEFINE FIELD created_at ON reviewed_by TYPE datetime VALUE time::now() READONLY;
```

### Indexes for CRM

```sql
-- Full-text search on customer name + notes
DEFINE INDEX idx_customer_search ON customer FIELDS name SEARCH ANALYZER snowball_no BM25;
DEFINE INDEX idx_customer_status ON customer FIELDS status;
DEFINE INDEX idx_customer_group_name ON customer_group FIELDS name;
DEFINE INDEX idx_review_establishment ON review FIELDS establishment;
DEFINE INDEX idx_review_rating ON review FIELDS rating;
DEFINE INDEX idx_recurring_next ON recurring_booking FIELDS next_occurrence;
```

### Design Rationale

- `booked_by` edge → `SELECT <-booked_by<-booking FROM customer:xyz` gives full booking history via graph traversal
- `prefers` edge carries metadata (notes about preferences) — Fresha-style "preferred staff"
- `member_of` edge → `SELECT ->member_of->customer_group FROM customer:xyz` and reverse `SELECT <-member_of<-customer FROM customer_group:vip`
- `customer_note` as separate table (not just a field) enables timeline history, staff attribution, pinning
- `recurring_booking` uses RFC 5545 RRULE strings + parent-instance pattern — app layer expands into booking instances within a horizon
- `review` with optional `booking` and `staff` links supports both service-level and staff-level reviews

---

## 3. Flutter Module Architecture

### Keep CRM as BP-Internal

**Rationale:**
- CRM is deeply tied to BP's tenant connection and operational context
- Marketplace needs *consumer-side* profile (different view of same data — via `users/users` namespace)
- Admin Panel may need read-only analytics later — can consume via SurrealQL on `companies/registry` aggregation
- Extracting to `packages/crm/` is premature — do it only if Admin+Marketplace truly need the same Dart models

**DO NOT create `packages/crm/`** yet. The Marketplace consumer profile is a fundamentally different view (read-only, own-data-only, `users/users` namespace). Sharing models would force awkward abstractions.

### Proposed Folder Structure

```
features/
  customers/                        # CRM domain
    data/
      customer_model.dart           # Customer, CustomerGroup, CustomerNote models
      customer_queries.dart         # SurrealQL constants/helpers
    providers/
      customers_provider.dart       # AsyncNotifierProvider<..., List<Customer>>
      customer_detail_provider.dart # Single customer + related data
      customer_groups_provider.dart # Groups/segments
      customer_search_provider.dart # BM25 search + filters
    screens/
      customers_screen.dart         # List view with search + filter sidebar
      customer_detail_screen.dart   # Profile + timeline + notes
    widgets/
      customer_card.dart
      customer_filter_panel.dart
      customer_timeline.dart        # Booking history timeline
      customer_notes_list.dart
      customer_group_chip.dart
      customer_stats_row.dart       # visits, spend, last visit
  reviews/                          # Separate feature for review management
    data/
    providers/
    screens/
    widgets/
  recurring_bookings/               # Recurring booking templates
    data/
    providers/
    screens/
    widgets/
```

### Provider Patterns

```dart
// List with pagination
final customersProvider = AsyncNotifierProvider<CustomersNotifier, CustomerListState>(...)

class CustomerListState {
  final List<Customer> customers;
  final int totalCount;
  final int page;
  final CustomerFilter? activeFilter;
}

// Detail with related data (graph traversal)
final customerDetailProvider =
    AsyncNotifierProvider.family<CustomerDetailNotifier, CustomerDetail, String>(...)

class CustomerDetail {
  final Customer customer;
  final List<Booking> recentBookings;   // SELECT <-booked_by<-booking
  final List<Staff> preferredStaff;     // SELECT ->prefers->staff
  final List<CustomerGroup> groups;     // SELECT ->member_of->customer_group
  final List<CustomerNote> notes;
  final List<Review> reviews;
}

// Search with debounce
final customerSearchProvider = StateProvider<String>((ref) => '');
final customerSearchResultsProvider = FutureProvider<List<Customer>>((ref) {
  final query = ref.watch(customerSearchProvider);
  // Debounce + BM25 query: SELECT * FROM customer WHERE name @@ $query
});
```

---

## 4. UI/UX Recommendations

### Customer List View (à la Fresha/Vagaro)

- **Left sidebar:** Filter panel with segments, status chips, date range
- **Main area:** Scrollable customer cards/rows with avatar, name, last visit, total visits, spend
- **Top:** Search bar (BM25 on name + notes + email)
- **Inline actions:** Message, book, edit
- **Pagination:** Cursor-based (`WHERE created_at < $cursor LIMIT 50`)

### Customer Detail View (à la Fresha)

- **Header:** Avatar, name, contact info, group chips, status badge
- **Stats bar:** Total visits, total spent, last visit, favorite staff
- **Tabs or scrollable sections:**
  1. **Timeline** — chronological: bookings, notes, reviews, messages (all merged)
  2. **Upcoming** — next bookings + recurring schedules
  3. **Notes** — staff notes with pin + attribution
  4. **Reviews** — ratings + comments + business replies
  5. **Preferences** — preferred staff, preferred services, custom fields

### Responsive Layout

- **Compact:** List → detail navigation (push)
- **Expanded:** Master-detail split (list on left, detail on right) — same pattern as Establishments

### Industry References

| Platform | Key CRM Pattern |
|---|---|
| **Fresha** | Customer profile with timeline, preferred staff, spending stats |
| **Square Appointments** | Simple customer list with booking history |
| **Vagaro** | Rich CRM with groups, notes, marketing campaigns |
| **Mindbody** | Client profiles with visit tracking and retention metrics |
| **Noona** | Tags, notices, computed metrics, multi-channel comms |

---

## 5. Notification/Messaging Architecture

### Phase 1 (v1.0 CRM): In-app Messaging Only

- Already has `message_thread` + `message` tables in blueprint
- SurrealDB LIVE SELECT on `message_thread` for real-time
- BP staff sees customer threads in Inbox (already in shell routes)

### Phase 2: SMS Reminders

- **Norwegian providers:** **Sveve** (best for Norway-first, servers in Norway, GDPR) or **GatewayAPI** (Danish, broader EU)
- Integration via MercuryEngine as a notification service (FastAPI async tasks)
- SurrealDB `DEFINE EVENT` on booking creation → trigger reminder scheduling
- Reminder table in company DB: `notification_schedule` with `send_at`, `channel`, `status`

### Phase 3: Email

- **Transactional:** Postmark or Mailgun (European data centers)
- **Marketing:** Defer to Phase 3+ (customer group → campaign)

---

## 6. Package Boundary Recommendations

| Component | Location | Rationale |
|-----------|----------|-----------|
| CRM screens/providers | `apps/business-portal/lib/features/customers/` | BP-specific operational context |
| Customer Dart model | `apps/business-portal/lib/features/customers/data/` | BP-internal for now |
| Review widgets | `apps/business-portal/lib/features/reviews/` | BP manages reviews; Marketplace shows them differently |
| SurrealDB schema | `schemas/company-blueprint.surql` | New tables added to existing blueprint |
| Notification service | `services/mercury-engine/` (future) | Cross-surface concern, not Flutter-layer |
| Consumer profile view | `apps/marketplace/` (future) | Consumer sees own profile + booking history via `users/users` |

---

## 7. Recommended Phasing

### Phase 1 — Customer Core (2-3 weeks)
- Add `customer_note`, `customer_group`, graph edges to blueprint
- BM25 search index on customer name
- `features/customers/` with list + detail screens
- Provider pattern matching existing `EstablishmentsNotifier`
- Add `/customers` route to GoRouter shell

### Phase 2 — Relationships & History (2 weeks)
- `booked_by` edge + booking history on detail view
- `prefers` edge + preferred staff UI
- Customer timeline widget (merged chronological view)
- Customer stats (computed or aggregated)

### Phase 3 — Groups & Segmentation (1-2 weeks)
- `customer_group` + `member_of` edge
- Smart segments (filter-based auto-groups)
- Group management screen
- Filter panel in customer list

### Phase 4 — Reviews (1-2 weeks)
- `review` table + `reviewed_by` edge
- Review management screen (reply, hide)
- Aggregate rating update on establishment

### Phase 5 — Recurring Bookings (2 weeks)
- `recurring_booking` template table
- RRULE parsing in Dart (use `rrule` package)
- UI for creating repeat schedules
- Instance generation logic (app-layer, not DB)

### Phase 6 — Notifications (deferred)
- SMS gateway integration (Sveve)
- Reminder scheduling
- Campaign messaging to groups

> This phasing matches the BP PRD v1.0 scope — Phases 1-3 are the CRM essentials that complete the merchant dashboard. Reviews and recurring bookings are natural follow-ons. Notifications are a separate track.
