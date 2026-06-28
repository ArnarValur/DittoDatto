# Plan: Ticketing & Events — Event System + Ticket Booking Mode

> **Track:** `ticketing_events_20260628`
> **Workflow:** strict (TDD)
> **Depends on:** `services_section_20260628` Phase 1–2 (Service + ServiceGroup models + BP CRUD patterns)

---

## Phase 1: Schema + Data Layer

- [ ] Task: Schema Gate — review `service_group` and `service` tables in `company-blueprint.surql`
    - [ ] Confirm existing fields align with Dart models from services track
    - [ ] Document which event fields need adding
- [ ] Task: Add event metadata fields to `service_group` in `company-blueprint.surql`
    - [ ] `is_event` (bool, DEFAULT false)
    - [ ] `event_type` (option<string>, ASSERT IN ['public', 'private'])
    - [ ] `event_date` (option<datetime>)
    - [ ] `event_end_date` (option<datetime>)
    - [ ] `event_logo` (option<string>)
    - [ ] `event_gallery` (option<array<string>>)
    - [ ] `event_description` (option<string>)
    - [ ] `rrule` (option<string>)
    - [ ] `parent_event` (option<record<service_group>>)
- [ ] Task: Add capacity field to `service` in `company-blueprint.surql`
    - [ ] `capacity` (option<int>) — null for standard services, set for ticket tiers
- [ ] Task: Apply schema to Hub
    - [ ] Run blueprint against `company_dittodatto-as` on Saturn
    - [ ] Verify no data loss on existing records
- [ ] Task: Extend ServiceGroup model in `packages/establishment_ui/`
    - [ ] Write serialization tests for event metadata fields (round-trip)
    - [ ] Add event fields to ServiceGroup model (is_event, event_type, event_date, event_end_date, event_logo, event_gallery, event_description, rrule, parent_event)
- [ ] Task: Extend Service model with capacity field
    - [ ] Write serialization tests for capacity field
    - [ ] Add `capacity` (int?) to Service model
- [ ] Task: Create EventData helper model
    - [ ] Aggregate model: event ServiceGroup + its child ticket Services + capacity summary
    - [ ] `totalCapacity` (sum of child Service capacities)
    - [ ] `remainingCapacity` (totalCapacity - booked count)
    - [ ] `isSoldOut` computed bool
    - [ ] Write unit tests

---

## Phase 2: BP Event CRUD

- [ ] Task: Add Events filter/view to BP services page
    - [ ] Filter ServiceGroups where `is_event=true` — display as events list
    - [ ] Show event date, type badge (public/private), capacity summary
    - [ ] Sort by event_date descending (upcoming first)
- [ ] Task: Build Event creation dialog
    - [ ] Write integration tests for create/read/update event ServiceGroup
    - [ ] Form fields: name, event_type (public/private), event_date, event_end_date, event_description, event_logo (media picker), event_gallery (media picker)
    - [ ] Set `is_event=true` automatically
    - [ ] Reuse existing ServiceGroup CRUD patterns from services track
- [ ] Task: Build Ticket Tier CRUD within event
    - [ ] Write integration tests for create/read/update/delete ticket tier (Service with ticketSystem mode)
    - [ ] Sub-list of Services within event detail, each with: name, price, capacity, description
    - [ ] Create tier dialog: name, price, capacity, description, `booking_mode` auto-set to `ticketSystem`
    - [ ] Capacity summary display on event (total = Σ tier capacities)
- [ ] Task: Feature flag enforcement in BP
    - [ ] Events tab/section only visible when `event_system: true`
    - [ ] Ticket tier creation only available when `ticket_system: true`
    - [ ] Write widget tests for flag-gated visibility
- [ ] Task: Seed test data via BP
    - [ ] Create a public event on House of the North (e.g., "Jazzklubb Drammen") with 2 ticket tiers
    - [ ] Create a private staff event (no tiers)
    - [ ] Create a display-only public event (event_system only, no tiers)

---

## Phase 3: Marketplace Event Display

- [ ] Task: Build EventCard widget
    - [ ] Write widget tests for event card (date formatting, type badge, capacity)
    - [ ] Implement event card: date, name, description, logo, capacity summary
    - [ ] Sold-out badge ("Utsolgt") when `isSoldOut`
- [ ] Task: Build EventSection widget
    - [ ] Write widget tests for section (upcoming vs past, empty state, private filtering)
    - [ ] Show upcoming public events sorted by date
    - [ ] Past events in collapsed "Tidligere arrangementer" section
    - [ ] Hide section when no events
    - [ ] Filter out private events
- [ ] Task: Build ticket tier display within event
    - [ ] Write widget tests for tier list, single-tier simplification
    - [ ] Show tiers with name, price, remaining capacity
    - [ ] Single-tier event → simplified "Kjøp billett" button (no tier picker)
    - [ ] Multi-tier event → tier selector with prices and availability
- [ ] Task: Replace placeholder EstablishmentEventsSection
    - [ ] Remove "Arrangementer kommer snart" stub
    - [ ] Wire real EventSection using `showEvents` flag + `event_system` feature flag
    - [ ] Extend EstablishmentDebugService to fetch events + tiers
- [ ] Task: Basic ticket purchase flow
    - [ ] Attendee count selector (default 1)
    - [ ] Validate attendee_count ≤ remaining_capacity
    - [ ] Create Hold → confirm → Booking (reuse existing MercuryEngine pattern)
    - [ ] Success / failure feedback

---

## Phase 4: Recurring Events (MVP)

- [ ] Task: Add rrule input to BP event creation
    - [ ] Recurrence picker: none / weekly / biweekly / monthly / custom rrule
    - [ ] Preview next 3 occurrence dates from rrule
- [ ] Task: Build auto-creation logic
    - [ ] SurrealQL query: find event ServiceGroups with `rrule` where next occurrence is within 30 days and no child instance exists
    - [ ] Create next instance: copy event metadata, copy tier Services (with reset capacity), set `parent_event` link
    - [ ] BP dashboard banner: "Ny forekomst av {event} er opprettet — bekreft detaljer"
- [ ] Task: Recurring event lineage view
    - [ ] In BP event detail: show parent/child chain of recurring instances
    - [ ] Navigate between instances

---

## Phase 5: Verification + Deploy

- [ ] Task: Run full test suite
    - [ ] Package tests (establishment_ui — event models + widgets)
    - [ ] BP integration tests (event CRUD + tier CRUD + feature flag enforcement)
    - [ ] BP widget tests
- [ ] Task: Deploy BP to Saturn :8003
    - [ ] Run deploy gate (tests → build → deploy → smoke test)
    - [ ] Verify event CRUD works on Saturn
- [ ] Task: Deploy Marketplace to phone
    - [ ] `flutter run --release -d R5CR61FGVPN`
    - [ ] Verify events display on EstablishmentPage with real data
- [ ] Task: E2E verification
    - [ ] Create event + tiers in BP on Saturn → verify on phone's EstablishmentPage
    - [ ] Verify private event NOT visible on phone
    - [ ] Verify display-only event (no tiers) shows without purchase button
    - [ ] Verify sold-out state when all tiers at capacity
    - [ ] Verify recurring event auto-creation produces new instance
