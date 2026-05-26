# CRM & Customers

**Track ID:** `crm_system_20260308`  
**Domain:** `business-portal`  
**Created:** 2026-03-08  
**Status:** Not Started

---

## Overview

Design and implement base CRM system to track companies and their customers, linking bookings to customer profiles.

---

## Phases

### Phase 1: Requirements Gathering & Schema Design
- [ ] Define Customer/Client schema (`CustomerSchema` or similar)
- [ ] Define required data points (name, email, phone, notes, loyalty/visits count, tags/flags)
- [ ] Update `Booking` and `Reservation` models to link consistently to a global `customerId`

### Phase 2: CRM Core UI & Components
- [ ] Create `/customers` overview page with table/list view
- [ ] Implement search/filtering logic
- [ ] Create `CustomerDetailSlideover.vue` or dedicated detail page
- [ ] Wire up Vuefire composables for CRM (`useCustomers.ts`)

### Phase 3: Booking Integration
- [ ] Update Booking flow to look up existing customers or create new ones
- [ ] Display customer's past/upcoming visits on their CRM profile
- [ ] Add "Loyalty/Tags" logic if needed

---

## Related Files

| File | Purpose |
|------|---------|
| `packages/shared-types/src/crm.ts` | (To be created) Schema definition |
| `apps/web/business-portal/app/pages/customers/` | CRM UI |

---

## Notes

- CRM should act as the central source of truth. Previously, bookings stored duplicate snapshot data of customers. Now, they must link to a central customer ID while retaining historic snapshots.
