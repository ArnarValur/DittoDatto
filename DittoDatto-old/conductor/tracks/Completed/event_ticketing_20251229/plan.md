# Plan: Event & Ticketing System

**Track ID:** `event_ticketing_20251229`  
**Status:** Planned  
**Created:** 2025-12-29

---

## Phase 1: Schema & Types

- [ ] Create `EventSchema` in `packages/shared-types/src/event.ts`
- [ ] Create `TicketBundleSchema` with embedded `TicketGroupSchema`
- [ ] Create `TicketSchema` in `packages/shared-types/src/ticket.ts`
- [ ] Add `"ticketSystem"` to `bookingFormTypes` enum
- [ ] Export all from `packages/shared-types/src/index.ts`

---

## Phase 2: Event System (Firestore)

- [ ] Create `events` collection rules in Firestore
- [ ] Implement Event CRUD Cloud Functions:
  - [ ] `events.create`
  - [ ] `events.update`
  - [ ] `events.delete`
  - [ ] `events.get` / `events.list`
- [ ] Add company/store level event ownership validation

---

## Phase 3: MercuryEngine Ticketing Module

- [ ] Create `MercuryEngine/ticketing/` folder structure
- [ ] Implement `createHold()` with capacity transaction
- [ ] Implement `confirmPurchase()` with QR generation
- [ ] Implement `verifyTicket()` for venue scanning
- [ ] Implement `transferTicket()` for post-purchase transfer
- [ ] Add hold expiration cleanup to scheduler

---

## Phase 4: Business Portal - Events

- [ ] Create `/events` page with list view
- [ ] Create Event form (title, date, location, images)
- [ ] Add "Requires Tickets?" toggle
- [ ] Create Ticket Bundle configuration UI:
  - [ ] Add Groups (VIP, Normal, Buffer)
  - [ ] Set capacity, price, age requirement
- [ ] Event publish/draft workflow

---

## Phase 5: Business Portal - Ticket Management

- [ ] Ticket sales dashboard (sold/remaining)
- [ ] QR scanner integration for Business app
- [ ] Entry log view (who used tickets)

---

## Phase 6: Public Marketplace - Event Discovery

- [ ] Event listing page
- [ ] Event detail page with ticket purchase
- [ ] Group selection UI
- [ ] Quantity picker (1-4)
- [ ] Hold → Payment → Confirmation flow

---

## Phase 7: User Profile - Tickets

- [ ] "My Tickets" page
- [ ] QR display for each ticket
- [ ] Transfer ticket flow
- [ ] Smart Ditto: location-aware ticket surfacing

---

## Notes

- Full spec: `.docs/Event-Ticketing-Spec-Draft.md`
- Vipps integration is separate track
- Push notifications handled by Smart Activity Hub
- Seat maps deferred to Phase 2 track
