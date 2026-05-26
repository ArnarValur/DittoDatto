# 📊 Project Audit Report — 2026-01-11

## Executive Summary

This audit assesses the readiness of DittoDatto.no to implement the **Public Marketplace Booking UI** and connect it to **MercuryEngine**. The backend is surprisingly complete; the gap is primarily in the **frontend integration**.

---

## 🔍 Chunk 1: Shared Core (Foundation)

### `packages/shared-types` — ✅ **READY**

| Schema | Status | Notes |
|--------|--------|-------|
| `store.ts` | ✅ Ready | Full schema with reservation config, images, opening schedule |
| `service.ts` | ✅ Ready | BookingMode, duration, price, availability window |
| `booking.ts` | ✅ Ready | Complete with fiscal snapshot (GDPR compliant), items array |
| `hold.ts` | ✅ Ready | Composite key pattern, duration, expiry |

**📝 Notes:**
- Schemas are well-documented with Zod validation
- `Booking` has `items[]` array for multi-service support
- `Hold` uses composite key pattern (`storeId_date_slotTime`) for idempotency

---

### `packages/functions/MercuryEngine` — ✅ **READY**

| Function | Status | Notes |
|----------|--------|-------|
| `mercury_getSlots` | ✅ Working | Time Tetris algorithm implemented |
| `mercury_createHold` | ✅ Working | Atomic transaction with 10-min TTL |
| `mercury_createBooking` | ✅ Working | Converts hold → booking with snapshot pattern |
| `mercury_getReservationAvailability` | ✅ Working | Table reservation support |
| `mercury_createReservation` | ✅ Working | Restaurant/table flow |
| Ticketing system | ✅ Working | Full ticket lifecycle implemented |

**⚠️ TODOs in Code:**
- Line 119: `// TODO: Add scheduler for cleaning expired holds`
- Line 121-123: Vipps payment integration stubs present but not implemented
- Line 77-78 (booking.ts): User data is mocked (`userName: "Arnar Valur"`)

**📝 Notes:**
- `setGlobalOptions({ region: "europe-west1" })` is correctly set in index.ts
- MercuryEngine is fully functional for the core booking flow
- Calculator properly handles opening hours, existing bookings, and holds

---

## 🔍 Chunk 2: Admin & Business Portal

### Admin Panel — ✅ **READY**

| Feature | Status | Notes |
|---------|--------|-------|
| Mercury Playground | ✅ Exists | `pages/bookings/mercury-engine.vue` |
| Company CRUD | ✅ Working | `admin_createCompany` function exported |
| User Management | ✅ Exists | Full RBAC in `pages/users` |

**⚠️ Issue Found:**
- **Mercury Playground uses `us-central1`** (line 15) instead of `europe-west1`
- This will fail when calling production functions deployed to `europe-west1`

### Business Portal — ✅ **READY**

| Feature | Status | Notes |
|---------|--------|-------|
| Establishment CRUD | ✅ Working | `pages/establishments/` |
| Service CRUD | ✅ Working | `pages/services/index.vue` (10KB file) |
| Staff CRUD | ⚠️ Basic | `pages/staff/index.vue` (1KB - likely placeholder) |
| Preview Mode | ✅ Working | `pages/preview/` directory |

**📝 Notes:**
- Staff management appears minimal but sufficient for testing
- Test data can be created via Business Portal

---

## 🔍 Chunk 3: Public Marketplace (Critical Path)

### URL Structure — ✅ **CORRECT**

```
/{category}/{slug}  →  [category]/[slug].vue
Examples:
- /barber/nordic-cuts
- /restaurant/fjord-bistro
```

### Establishment Page — ⚠️ **NEEDS WORK**

| Component | Status | Gap |
|-----------|--------|-----|
| `[category]/[slug].vue` | ✅ Exists | Data fetching works |
| Store data | ✅ Working | Uses `collectionGroup` for nested stores |
| Services list | ✅ Working | Fetches from `companies/{}/stores/{}/services` |
| Events list | ✅ Working | Fetches from `events` collection |
| Favorites | ✅ Working | Firestore-based with triggers |
| **Booking Flow** | ❌ **NOT CONNECTED** | Emits events but no MercuryEngine calls |

### Shared Components (`packages/ui`) — ⚠️ **UI EXISTS, LOGIC MISSING**

| Component | Status | Gap |
|-----------|--------|-----|
| `EstablishmentPage.vue` | ✅ Polished | Uses `DDBookingModal` |
| `BookingModal.vue` | ⚠️ UI Only | **Generates fake time slots locally** |
| `TimeSlotPicker.vue` | ✅ UI Ready | Generic picker component |
| `ServiceSelector.vue` | ✅ UI Ready | Selection component |

**🔴 CRITICAL FINDING:**
The `BookingModal.vue` (line 84-106) generates time slots **locally** based on service availability window, NOT from MercuryEngine!

```typescript
// Current code (BookingModal.vue:84-106):
const timeSlots = computed(() => {
  const start = selectedService.value.availabilityStart || '09:00'
  const end = selectedService.value.availabilityEnd || '17:00'
  // ...generates slots without checking actual availability
})
```

This means:
- ❌ Does NOT check for existing bookings
- ❌ Does NOT check for active holds
- ❌ Does NOT use MercuryEngine
- ❌ Ignores opening schedule for specific days

### Composables — ❌ **MISSING**

| Composable | Status | Notes |
|------------|--------|-------|
| `useAvailability` | ❌ Missing | Needs to call `mercury_getSlots` |
| `useBooking` | ❌ Missing | Needs to call `mercury_createHold` + `mercury_createBooking` |
| `useCallableFunctions.ts` | ✅ Exists | Basic setup for callable functions |

---

## 🔴 Synthesis: What's Missing for Booking UI

### Gap Summary

| Layer | Component | Status |
|-------|-----------|--------|
| Backend | MercuryEngine | ✅ READY |
| Types | Booking/Hold Schemas | ✅ READY |
| UI | BookingModal | ⚠️ UI Only |
| Integration | useAvailability composable | ❌ MISSING |
| Integration | Mercury → BookingModal wiring | ❌ MISSING |

### Definition of Done for "MercuryEngine Connection"

1. ✅ MercuryEngine functions are deployed and callable
2. ❌ Public marketplace has composable to call `mercury_getSlots`
3. ❌ `BookingModal` uses real availability data instead of local generation
4. ❌ "Book Now" click calls `mercury_createHold`
5. ❌ Payment/confirmation calls `mercury_createBooking`
6. ❌ User sees confirmation with booking ID

---

## 📋 Recommended Next Steps (Priority Order)

### Phase 1: Create Integration Layer
- [ ] **Task 1.1**: Create `useAvailability.ts` composable in public-marketplace
  - Calls `mercury_getSlots` with companyId, storeId, date, serviceIds
  - Returns reactive `availableSlots` array
  
- [ ] **Task 1.2**: Create `useBooking.ts` composable
  - `createHold()` → calls `mercury_createHold`
  - `confirmBooking(holdId)` → calls `mercury_createBooking`
  - Handles errors and loading states

### Phase 2: Wire BookingModal to Mercury
- [ ] **Task 2.1**: Modify `BookingModal.vue` to accept slots prop
  - Replace local `timeSlots` computed with prop-based slots
  - Add loading state for slot fetching
  
- [ ] **Task 2.2**: Pass Mercury data through `EstablishmentPage.vue`
  - Use `useAvailability` when date/service selection changes
  - Pass slots to `BookingModal`

### Phase 3: Complete the Flow
- [ ] **Task 3.1**: Implement hold creation on "Book Now" click
- [ ] **Task 3.2**: Add booking confirmation step (payment placeholder)
- [ ] **Task 3.3**: Show success state with booking ID

### Phase 4: Polish
- [ ] Fix Mercury Playground region (`us-central1` → `europe-west1`)
- [ ] Add user data fetching in `booking.ts` (replace mocks)
- [ ] Add expired hold cleanup scheduler

---

## Quick Wins Available Now

1. **Fix Mercury Playground Region** (5 min)
   - `admin-panel/pages/bookings/mercury-engine.vue` line 15
   - Change `us-central1` to `europe-west1`

2. **Test MercuryEngine via Mercury Playground**
   - Verify slots appear correctly
   - Test hold creation and booking flow

---

*Audit completed by Lt. Cmdr. Data (Opus) — Stardate 2026.011*
