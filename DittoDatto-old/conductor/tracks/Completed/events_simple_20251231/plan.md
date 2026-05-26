# Plan: Simple Event System

**Track ID:** `events_simple_20251231`  
**Status:** In Progress  
**Created:** 2025-12-31  
**Updated:** 2025-12-31

---

## Phase 1: Schema & Types ✅

- [x] Create `EventSchema` in `packages/shared-types/src/event.ts`
- [x] Create `CreateEventSchema` (omit id, timestamps)
- [x] Create `UpdateEventSchema` (partial)
- [x] Add `eventSystem` feature flag to `CompanySchema.enabledFeatures`
- [x] Export from `packages/shared-types/index.ts`

---

## Phase 2: Firebase Functions (CRUD) ✅

- [x] Create `events.create` callable function
- [x] Create `events.update` callable function
- [x] Create `events.delete` callable function
- [x] Create `events.get` callable function
- [x] Create `events.list` callable function (with companyId/storeId filter)
- [ ] Add Firestore security rules for events collection

---

## Phase 3: Admin Panel - Event Management ✅

- [x] Add "Events" feature flag toggle in Company edit form
- [x] Display eventSystem status in Company detail view

---

## Phase 4: Business Portal - Events UI ✅

- [x] Add "Events" sidebar link (conditional on feature flag)
- [x] Create `/events` list page
- [x] Create Event form slideover:
  - [x] Title & description fields
  - [x] Date/time picker (start & optional end)
  - [x] Location fields (name, address, city)
  - [x] Cover image picker (from Media Gallery)
  - [x] Store selector (optional, or company-level)
  - [x] Status toggle (draft/published)
- [x] Add event delete confirmation

---

## Phase 5: Public Marketplace - Event Display ⏸️

> [!NOTE]
> **BLOCKED:** Public Marketplace app (`apps/web/public-marketplace`) is empty/not yet built.
> This phase will be implemented when the marketplace is created.

- [ ] Event listing on company page
- [ ] Event listing on store page (if linked)
- [ ] Event detail page:
  - [ ] Cover image
  - [ ] Title, description
  - [ ] Date/time display
  - [ ] Location with map embed
  - [ ] Link to store (if applicable)

---

## TODO-PostIt: Ticketing Integration

> [!CAUTION]
> **🎫 TICKETING SYSTEM - DEFERRED**
> 
> The following features are **NOT** part of this track:
> 
> - [ ] `ticketBundleId` field on Event
> - [ ] Ticket Bundle configuration UI
> - [ ] Ticket purchase flow
> - [ ] QR code generation
> - [ ] Entry verification
> - [ ] Capacity management
> 
> **See:** [event_ticketing_20251229/](../event_ticketing_20251229/) for full Ticketing spec.
> 
> **Integration Point:** When Ticketing is implemented, add a "Requires Tickets?" toggle to the Event create/edit form that creates a linked TicketBundle.

---

## Notes

- Cover images use existing Media Gallery system
- Map coordinates support Google Maps embed on public pages
- Events with `status: draft` are only visible to company members
- Feature flag prevents unauthorized access to Events functionality
