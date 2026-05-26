# Mercury Engine API Mapping Report

This document outlines the usage of `useFetch`, `$fetch`, and specific API composables across the DittoDatto client applications, mapping them against the defined contracts in the `mercury-engine` microservice.

## 1. Mercury Engine Contracts vs. Client Implementations

The `mercury-engine` defines the core booking logic and is consumed by the client apps via a dedicated composable: `useMercuryREST()` and its wrapper `useBooking()` / `useUserBookings()`.

### A. Appointments (`/appointments/*`)

**1. Fetch Slots**
*   **Engine Contract:** `GET /appointments/slots`
    *   *Requires Query:* `companyId`, `storeId`, `date`, `serviceIds` (comma-separated).
    *   *Optional Query:* `staffId`.
*   **Client Implementation:** `fetchSlots` in `useBooking.ts`
    *   *Usage:* Passes `{ companyId, storeId, date, serviceIds, staffId }`.
    *   *Status:* ✅ **Match.** Note: The client uses Nuxt's `ofetch` which serializes the array `serviceIds`. The engine expects it to be either properly structured in the query or handles the stringification.

**2. Create Hold**
*   **Engine Contract:** `POST /appointments/holds`
    *   *Requires Body:* `companyId`, `storeId`, `date`, `slotTime`, `serviceIds`.
    *   *Optional Body:* `personId`. Requires Auth token.
*   **Client Implementation:** `createHold` in `useBooking.ts`
    *   *Usage:* Passes `{ companyId, storeId, serviceIds, date, slotTime, personId }`.
    *   *Status:* ✅ **Match.**

**3. Confirm Booking**
*   **Engine Contract:** `POST /appointments/bookings`
    *   *Requires Body:* `holdId`, `paymentId`. User details are extracted from the Auth token.
*   **Client Implementation:** `confirmBooking` in `useBooking.ts`
    *   *Usage:* Passes `{ companyId, storeId, holdId, customerDetails, notes, paymentId }`.
    *   *Status:* ⚠️ **Minor Discrepancy (Safe).** The client is over-fetching by sending `companyId`, `storeId`, `customerDetails`, and `notes`. The engine ignores these as it uses the data already stored in the `hold` document and the Auth token. 

**4. Cancel Booking**
*   **Engine Contract:** `POST /appointments/bookings/:bookingId/cancel`
    *   *Requires Path:* `bookingId`. Requires Auth token.
    *   *Optional Body:* `reason`.
*   **Client Implementation:** `cancelBooking` in `useBookings.ts` (business-portal) & `useUserBookings.ts` (public-marketplace)
    *   *Usage:* Path param passed correctly. No body payload sent.
    *   *Status:* ✅ **Match.**

### B. Reservations (`/reservations/*`)

**1. Fetch Availability**
*   **Engine Contract:** `GET /reservations/availability`
    *   *Requires Query:* `companyId`, `storeId`, `date`, `partySize`.
*   **Client Implementation:** `fetchReservationSlots` in `useBooking.ts`
    *   *Usage:* Passes `{ companyId, storeId, date, partySize }`.
    *   *Status:* ✅ **Match.**

**2. Create Reservation**
*   **Engine Contract:** `POST /reservations/`
    *   *Requires Body:* `companyId`, `storeId`, `date`, `time`, `partySize`, `customerName`.
    *   *Optional Body:* `customerPhone`, `notes`. User email/ID picked from Auth token.
*   **Client Implementation:** `createReservation` in `useBooking.ts`
    *   *Usage:* Passes `{ companyId, storeId, date, time, partySize, customerName, customerPhone, customerEmail, notes }`.
    *   *Status:* ✅ **Match.**

### C. Ticketing (`/tickets/*`)

*   **Engine Contracts:** 
    *   `GET /tickets/availability`
    *   `POST /tickets/holds`
    *   `POST /tickets/purchase`
    *   `POST /tickets/verify`
    *   `POST /tickets/transfer`
*   **Client Implementation:** ❌ **Not Implemented Yet.** There are UI components (`TicketBookingFlow.vue`, `DDEventCard.vue`) prepared for ticketing, but no `$fetch` or `fetchFromMercury` calls map to these engine endpoints yet.

### D. Cleanup (`/cleanup/*`)

*   **Engine Contracts:** `DELETE /cleanup/holds/expired`, `GET /cleanup/stats`
*   **Client Implementation:** ℹ️ **Internal Only.** These are not called via client-side `$fetch` as they are meant for cron jobs or internal admin triggers.

---

## 2. Nuxt Internal Server Routes (BFF)

There are 48 occurrences of `useFetch` and `$fetch` in the `admin-panel`, `public-marketplace`, and `business-portal` apps that do **not** hit the `mercury-engine`. Instead, these hit Nuxt's internal `/api/...` server routes, acting as a BFF (Backend-For-Frontend) to wrap Firebase Admin operations.

**Common Endpoints Used:**
*   `/api/companies` & `/api/companies/companies`
*   `/api/stores/stores`
*   `/api/services/services`
*   `/api/users/*` (search, list, read)
*   `/api/settings/*` (categories, general, members)
*   `/api/icon-collections/*`
*   `/api/notifications`

*These calls are standard CRUD operations and are decoupled from the high-complexity Mercury Engine logic.*

---

## 3. Summary & Action Items

*   **Engine Consistency:** The core booking composables (`useBooking.ts`) are well-aligned with the `mercury-engine` contracts.
*   **Payload Optimization:** `confirmBooking` sends redundant data (like `customerDetails` and `notes`) that the engine doesn't need (it relies on the hold document). This is harmless but can be cleaned up to save bandwidth.
*   **Ticketing Integration:** The next major step will be to connect the ticketing components to the `mercury-engine` endpoints, as they currently lack implementation.
*   **Type Safety:** The client requests are typed internally, but sharing `zod` schemas or full TypeScript interface imports between `mercury-engine/src/routes` and `packages/shared-types` could provide stricter end-to-end type safety for network payloads.