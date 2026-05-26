# UI API Calls & Fetch Mapping

This document maps all API endpoints, `fetch` calls, and API wrappers used within the `public-marketplace`, `business-portal`, and shared `ui` package.

## 1. Public Marketplace (`apps/web/public-marketplace`)

### Mercury Engine API Calls
* **Wrapper Implementation:** `app/composables/useMercuryREST.ts`
  * Core composable containing the `fetchFromMercury` wrapper utilizing Nuxt's native `$fetch` for all external communication to the Mercury Engine.
* **Endpoints:**
  * `POST /appointments/bookings/${bookingId}/cancel`
    * **Location:** `app/composables/useUserBookings.ts`

*(Note: No other direct `$fetch`, `useFetch`, `useAsyncData`, or local `server/api` endpoints exist in the public marketplace).*

---

## 2. Business Portal (`apps/web/business-portal`)

### Mercury Engine API Calls
* **Wrapper Implementation:** `app/composables/useMercuryREST.ts`
  * Core composable containing the `fetchFromMercury` wrapper utilizing Nuxt's native `$fetch`.
* **Endpoints:**
  * `POST /appointments/bookings/${bookingId}/cancel`
    * **Location:** `app/composables/useBookings.ts`

### Local Server API Endpoints (`server/api/*`)
The business portal defines the following local Nuxt server routes:
* `GET /api/auth-diagnostic` (`auth-diagnostic.get.ts`)
* `/api/customers` (`customers.ts`)
* `GET /api/debug-admin` (`debug-admin.get.ts`)
* `/api/mails` (`mails.ts`)
* `/api/members` (`members.ts`)

---

## 3. Shared UI Package (`packages/ui`)

### Component API Calls
* **Icon Picker:** `components/DDIconPicker.vue`
  * **Method:** Direct `$fetch`
  * **Endpoint:** `GET /api/icon-collections`
  * **Purpose:** Fetches icon categories dynamically when the popover opens.

*(Note: Other external communications, like loading User Favorites inside `useFavorites.ts`, utilize Firebase `httpsCallable` functions rather than standard HTTP fetches).*