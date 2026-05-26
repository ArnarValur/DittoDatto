# Plan: TableReservation Booking System

**Track ID:** `table_reservation_20251229`  
**Status:** In Progress  
**Created:** 2025-12-29  
**Last Updated:** 2025-12-30

---

## Phase 1: Schema Updates ✅ COMPLETE
- [x] Add `enabledFeatures` to `CompanySchema` (tableReservation, aiAssistance, ticketSystem)
- [x] Update `StoreSchema` with `bookingFormType` and `reservationConfig`
- [x] Create `reservation.ts` with `ReservationConfigSchema`, `ExperienceSchema`, `ReservationSchema`
- [x] Export all from `packages/shared-types/index.ts`
- [ ] Add `serviceType` enum to `ServiceSchema` (deferred)
- [ ] Create `TableSchema` (deferred - using capacity pools first)

---

## Phase 2: MercuryEngine Reservations Module ✅ COMPLETE
- [x] Create `packages/functions/src/MercuryEngine/reservations/`
- [x] Implement `calculator.ts` (time slots, capacity checking)
- [x] Implement `availability.ts` (`mercury_getReservationAvailability`)
- [x] Implement `booking.ts` (`mercury_createReservation`)
- [x] Export from `MercuryEngine/index.ts`
- [ ] 📌 PostIt: Refactor shared logic to `MercuryEngine/shared/`

---

## Phase 3: Admin Panel ✅ COMPLETE
- [x] Feature toggles in `CompanyFormSlideover` (tableReservation, ticketSystem, AI)
- [x] Verified persistence in Firestore

---

## Phase 4: Business Portal ✅ COMPLETE
- [x] Multi-company switching (`useCompany`, `TeamsMenu`)
- [x] Sidebar: "Restaurants" link (conditional on `enabledFeatures`)
- [x] Add Store flow with `StoreFormSlideover`
- [x] Restaurants page with filtered store list
- [ ] Table/Capacity configuration UI (next session)
- [ ] Experience creation UI (Lunch/Dinner services)

---

## Phase 5: Public Marketplace 🔜 NOT STARTED
- [ ] Detect `bookingFormType === "tableReservation"`
- [ ] Guest count selection UI
- [ ] Experience picker
- [ ] Date + time slot selection
- [ ] Hold + confirmation flow

---

## Session Progress (2025-12-30)

**Completed this session:**
1. Schemas: `reservation.ts`, Company `enabledFeatures`, Store `reservationConfig`
2. Admin: Feature toggle UI
3. Backend: MercuryEngine `reservations/` module
4. Portal: Sidebar, Add Store, Restaurants page, Multi-company switching

**Next session priorities:**
1. ServiceSchema: Add `serviceType` enum
2. Business Portal: Experience creation (Lunch/Dinner)
3. Public booking widget

---

## Notes

- Using capacity pools (not physical tables) for MVP
- Experiences implemented as Services with `serviceType: "experience"`
- New `reservations` collection (separate from `bookings`)
