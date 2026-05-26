# 🚀 March First Week Sprint (Revised)

**Sprint Window:** Sun March 1 → Thu March 5, 2026  
**Available:** Sun afternoon, Mon–Wed full days (morning → evening)  
**Goal:** Make the platform usable end-to-end _without_ agentic features. Business Portal first, then Public Frontpage.  
**Context:** Week off (ADK focus), fresh start for March — preparing for agents & mobile apps.  
**Revised:** 2026-03-05 12:06 — Day 5: Admin Inbox wired, System Alerts, Frontpage Forms → Admin Inbox.

---

## 📊 Sprint Backlog

### 🔴 P0 — Must Ship

| #   | Item                                                                            | Domain                   | Est  | Status     |
| --- | ------------------------------------------------------------------------------- | ------------------------ | ---- | ---------- |
| 1   | **Fix Login / Registration** — diagnose staged deploy auth issue                | Public Frontpage         | 2–3h | ✅         |
| 2   | **MercuryEngine staged deploy** → `mercury.dittodatto.no` (+ GCP custom domain) | mercury-engine           | 4–6h | ✅         |
| 3   | **RBAC audit** — portal role gate (`hasMinRole("business")`)                    | Admin Panel + Biz Portal | 4–6h | ✅ partial |

### 🟡 P1 — High Priority (Business Portal Focus)

| #     | Item                                                                           | Domain          | Est  | Status     |
| ----- | ------------------------------------------------------------------------------ | --------------- | ---- | ---------- |
| 4     | **Staff Management — detail page + schedule grid + invite**                    | Business Portal | 6–8h | ✅         |
| 5     | **Owner Dashboard** — greeting, store filter, staff toggles, today's timetable | Business Portal | 4–6h | ✅         |
| ~~6~~ | ~~**Gantt Planner component**~~ — dropped (mermaid dep, shift grid sufficient) | Business Portal | —    | 🚫 dropped |
| 7     | **Bookings Overview page** — time-grid calendar, store/staff filters           | Business Portal | 3–4h | ✅         |
| 8     | **Services Management overview** — store tabs, staff assignment, group fix     | Business Portal | 3–4h | ✅         |

### 🟡 P1.5 — Noona Intel (NEW — from API Deep Dive)

| #   | Item                                                                                      | Domain         | Est  | Status |
| --- | ----------------------------------------------------------------------------------------- | -------------- | ---- | ------ |
| N1  | **Booking Policy Controls** — `BookingPolicySchema` on Store                              | shared-types   | 1–2h | ✅     |
| N2  | **MercuryEngine policy enforcement** — `maxBookableFutureDays`, `minBookingNoticeMinutes` | mercury-engine | 2–3h | ✅     |
| N3  | **Resource & ResourceGroup schemas** — design spec only (no wiring)                       | shared-types   | 1–2h | ✅     |
| N4  | **Waitlist + Cancellation Roadmap** — document architecture for March W2–W4               | conductor      | 1h   |        |
| N5  | **Norwegian Holidays** — `getNorwegianHolidays(year)` for MercuryEngine                   | shared-types   | 30m  | ✅     |

### 🟢 P2 — Should Have

| #   | Item                                                                          | Domain                | Est  | Status |
| --- | ----------------------------------------------------------------------------- | --------------------- | ---- | ------ |
| 9   | **Mobile polish — frontpage spotless** (prerequisite for native app planning) | Public Frontpage      | 4–6h |        |
| 10  | **Contact forms polish + wiring**                                             | Public Frontpage      | 2–3h | ✅      |
| 11  | **Table Reservation system** — Spec & E2E Validation complete | mercury-engine        | 2–3h | ✅      |
| 12  | **Search Analytics verification**                                             | predict.dittodatto.no | 1–2h | ✅      |

### 🔵 Backlog Pull-ins (if time)

| Item                                                  | Source           |
| ----------------------------------------------------- | ---------------- |
| Map dark-mode fix + initial zoom on Drammen           | SYSTEM_WIDE_TODO |
| /discover category icon filters                       | SYSTEM_WIDE_TODO |
| SolarTheme day-mode depth + login theme toggle        | SYSTEM_WIDE_TODO |
| `onBookingUpdated` CF (cancel/complete notifications) | ideas backlog    |

---

## ✅ What's Done (Days 1–2)

### Day 1 — Sun Mar 1

- [x] Conductor protocols loaded
- [x] Sprint plan created
- [x] **P0-1: Login/Auth + Admin Delete** ✅
- [x] **P0-2: MercuryEngine deployed** → `mercury.dittodatto.no` ✅
- [x] **P0-3: RBAC audit** — `hasMinRole('business')` added to portal ✅

### Day 2 — Mon Mar 2 (today, AM + PM)

- [x] **P1-4: Staff detail page** — schedule grid, invite flow ✅
- [x] **P1-8: Services overview** — store tabs, staff assignment, service group fix ✅
- [x] **Bug: Customer name = email** — Firestore profile lookup before Auth fallback ✅
- [x] **Bug: Staff filter broken** — `personId` threaded through Hold → Booking ✅
- [x] **Bug: Availability inheritance** — `useInheritedConfig` derives from `openingSchedule` ✅
- [x] **Schema: `ServiceGroup.showOnBookingPanel`** — toggle + filtering ✅
- [x] **Schema: `Service.assignedStaff[]`** — prepared for multi-staff ✅
- [x] **UI: Grouped services in BookingSlideover** ✅
- [x] **P1-5: Owner Dashboard rebuilt** — greeting, stats, staff bookings table, recent list ✅
- [x] **Noona API docs organized** — 84 endpoints clipped to `.docs/NoonaExtras/` ✅
- [x] **Noona API Deep Dive** — 64 categories mapped, 12 gaps identified, 3 prioritized ✅

### Night 2→3 — Mon→Tue Nightshift (22:30 → 05:30)

- [x] **N2: MercuryEngine policy enforcement** ✅
  - `getSlots`: Date window filtering by `maxBookableFutureDays`
  - `getSlots`: Reject slots within `minBookingNoticeMinutes`
  - `getSlots`: Filter out already-booked slots
  - `createHold`: Validate against policy
  - All 11 MercuryEngine tests pass
- [x] **P1-7: Bookings Overview page** — scaffolded ✅
  - Schedule grid view (staff-column calendar) with store filter
  - List view with status filters/badges
  - Toggle between grid and list views
  - Booking detail slideover with actions (complete, no-show, cancel)
  - Firestore timestamp coercion helpers
  - Firestore rules update for booking status updates
- [x] **Multi-Select Booking Feature** ✅ (NEW)
  - Backend: `multiSelect` field persistence in `createServiceGroup` Cloud Function
  - Business Portal: multi-select toggle in ServiceFormSlideover
  - Storefront: group cards with 2×2 image collage, service count, price range
  - BookingSlideover: accordion groups, checkboxes, sticky footer with totals
  - StandardBookingFlow: `additionalServices` prop, multi-service summary + confirm
  - `[slug].vue`: aggregated hold creation + confirmation with all service IDs
  - i18n: `serviceCount`, `proceed`, `fromPrice` in 4 locales (en, nb, nn, pl)
  - Removed all hardcoded Icelandic strings 😄
- [x] **Booking fixes** ✅
  - Firestore Timestamp coercion (`coerceToISO` + `coerceToDate`)
  - Staff auto-assign for single-staff stores
  - BookingCard UI polish
  - Sticky footer positioning fix (fixed → sticky)

---

## 📅 Remaining Plan (Days 3–5) — Reordered by Dependency

### Morning 3 — Tue Mar 3 (07:33–08:30)

- [x] **Dashboard store-aware filters** ✅
  - Store pill-buttons (auto-hidden for single-store accounts)
  - Staff visibility toggles (clickable avatar pills, dashed when hidden)
  - Both persisted to localStorage
  - Fixed `staffLoading` bug (referenced but never destructured)
- [x] **Bookings page store/staff filters** ✅
  - Same UX pattern, independent localStorage keys
  - `isMultiStore` computed hides store pills for single-store
- [x] **BookingOverview time-grid rewrite** ✅
  - Card layout → professional time-grid calendar
  - Time gutter (08:00–20:00, configurable `dayStartHour`/`dayEndHour`)
  - Booking blocks positioned by time, height ∝ duration
  - Grid lines at 30-min intervals (hour lines more prominent)
  - Current-time indicator (green dot + line, auto-updates every minute)
  - Auto-scroll to current time on page load
  - Staff-colored booking blocks (left border + tinted background)
  - Sticky column headers during vertical scroll
  - Full viewport fill — no outer page scroll
- [x] **Multi-service booking backend** ✅ (from night session)
  - `serviceIds[]` in HoldSchema, aggregated items/totals in bookings
  - 12 tests pass, deployed to europe-west1
- [x] **Timezone fix** ✅ — times stored as timezone-naive local strings
- [x] **Booking seeder script** ✅ — `seed-bookings.ts` for test data

**Still needs verification:**

- Staff assignment in grid: seeded staff IDs don't match real staff → "Ikke tildelt" stays after assign (expected with mock data, verify with real flow)
- End-to-end multi-select booking: select 2+ services → confirm → verify record
- Thai massage shop: test 6-service group flow with real staff

### Afternoon 3 — Tue Mar 3 (13:30–15:55)

- [x] **Services Overview UX Overhaul** ✅
  - Mandatory store selector (Bookings pattern, `UButton` pills, localStorage)
  - Reactive `refresh()` in `useServices` composable (no more page reload)
  - Ghost field removal: `capacity`, `availabilityStart/End` from service list
  - Service sorting by `sortOrder` then `title`
- [x] **Service Form Cleanup** ✅
  - Removed `capacity`, `availabilityStart/End`, `useInheritedConfig`
  - Grouped staff dropdown: active store first, divider, other locations
- [x] **Booking Slot Time Fix** ✅ (CRITICAL)
  - Root cause: `StandardBookingFlow.vue` + `ReservationBookingFlow.vue` fallback used deprecated `service.availabilityStart || '09:00'`
  - Fix: both now read `openingSchedule[selectedDay]` from store
  - Verified: Fjell og Flamme Saturday slots now 14:00–22:30 ✅
- [x] **Stale Firestore cleanup** — Arnar manually removed `defaultServiceConfig` from store doc

**Known bugs:**

- 🟡 Double-click hold race condition: 409 Conflict on rapid click, both error + success toasts. Low priority — booking still succeeds.

### Evening 3 — Tue Mar 3 (17:00–18:00)

- [x] **Price display fix** ✅ — `0,00 kr` → "Gratis" (green) on ServiceGrid + i18n in all 4 locales
- [x] **Resource description limit** ✅ — 500 → 1000 chars (schema + `resources_create` + `resources_update` redeployed)
- [x] **`showOnStorefront` flag** ✅ — on ResourceGroupSchema + toggle in ResourceGroupFormSlideover
- [x] **Removed deprecated fields** — `availabilityStart/End` from `ServiceGrid` interface + template
- [x] **Design decision: Operational vs Showcasable resources** — tables = engine assigns (invisible), halls = customer picks (visible on storefront)
- [x] **Design decision: Service → ResourceGroup linking** — specific resource selected at booking time, not service definition

### Day 4–5 — Wed Mar 4 + Thu Mar 5: Comms & Notifications

**Theme: "Inbox & Alerts"**

- [x] **Admin Inbox Wiring** — real-time Firestore notifications, unread badge, mobile slideover fix
- [x] **System Alerts** — `SystemAlertSchema`, admin compose page (`/inbox/alerts`), portal popover indicator
- [x] **Firestore Rules** — `systemAlerts` collection: signed-in read, super_admin write
- [x] **Business Form → Admin Inbox** — `for-business.vue` wired to `feedback_submit` CF with `source: 'business_inquiry'`
- [x] **Contact Form polish** — hero icon, card wrapper, 2-col layout, subject field, char counter, send icon
- [x] **Business Form polish** — required markers, char counter, disabled state, send icon
- [x] **Input Sanitization** — `sanitize()` in CF strips HTML tags + control chars from all text inputs
- [x] **P2-10: Contact forms polish** ✅
- [ ] **P2-9: Frontpage mobile polish** — audit breakpoints 375/390/428px
- [ ] **P0-3: RBAC final implementation** — deferred
- [ ] **Pulse update + sprint retro notes** ✅

### Weekend — Mar 7-8: Milestone Finalization

- [ ] Showcasable Resources (Phase 1: storefront cards + booking flow picker)
- [ ] Table Reservation View (Noona-style resource calendar)
- [ ] Final bug fixes from Thursday showcase feedback
- [ ] Full testing preparation for next week
- [ ] Plan last 2 weeks of March

---

## 🔗 Track Alignment

| Sprint Item             | Existing Track                    | Action                     |
| ----------------------- | --------------------------------- | -------------------------- |
| MercuryEngine deploy    | `Standalone Microservice`         | ✅ Complete                |
| RBAC + Staff Mgmt       | `staff_management_20260211`       | ✅ UX Done, RBAC remaining |
| Login/Auth fix          | `Firebase Config Sync` (Feb 21)   | ✅ Complete                |
| Services Management     | Business Portal                   | ✅ Complete                |
| Booking Policy Controls | **NEW** — Noona Intel integration | Create with implementation |
| Resource Schemas        | **NEW** — Table Reservation prep  | Design spec only           |
| Bookings Overview       | Business Portal                   | Day 3                      |
| Mobile polish           | `frontpage_master_track_20260104` | Day 4                      |
| Search Analytics        | `dittobar_search_20260216`        | Day 5 verify               |

---

## 📈 Noona Intel Roadmap (Beyond This Sprint)

| Phase   | What                                 | Target      | Dependencies              |
| ------- | ------------------------------------ | ----------- | ------------------------- |
| Phase A | ✅ Booking Policy schema + engine    | This sprint | None                      |
| Phase B | ✅ Resource schemas (design only)    | This sprint | None                      |
| Phase C | Cancellation Policy Engine           | March W2–W3 | Phase A (booking policy)  |
| Phase D | Waitlist + Booking Offers + Datto AI | March W3–W4 | Phase C (cancellation)    |
| Phase E | ✅ Resource → MercuryEngine wiring   | Done        | 4th gate in calculator.ts |

---

## ⚠️ Risks

| Risk                                       | Mitigation                                                   |
| ------------------------------------------ | ------------------------------------------------------------ |
| Booking policy enforcement in Engine = 🔴  | Keep changes minimal: date window filter + notice check only |
| Resource schema over-engineering           | Design spec only, no wiring — validate shape with table res. |
| Full BP Bookings page in half a day        | Focus on functional list, defer analytics/charts             |
| Timeslot bug (booked slots still showing!) | Critical — address in Engine enforcement session (Day 3 N2)  |

---

## 🚫 Out of Scope

- Cancellation & Rebooking engine (Phase C — March W2–W3)
- Waitlist / Booking Offers (Phase D — March W3–W4)
- Ditto AI Agent (Phase 6) — explicitly excluded per "usable without agentic"
- Flutter/Capacitor native compilation — research for _next weekend_
- BigQuery pipeline, Vector Search
- Products / POS system (Noona has this, we don't need it)

---

_Sprint planned: 2026-03-01 by Commander Hermes_  
_Revised: 2026-03-02 19:00 — Noona API Intel integrated_  
_Revised: 2026-03-03 05:25 — Night 2→3 results: Multi-Select Booking, Bookings Overview, Engine Policy_  
_Revised: 2026-03-03 08:30 — Morning 3: Store filters, staff toggles, time-grid calendar, single-store compat_  
_Revised: 2026-03-03 15:55 — Afternoon 3: Services Overview UX, Service Form cleanup, booking slot fix_  
_Revised: 2026-03-03 18:00 — Evening 3: Resources quick wins, showcasable resources design, sprint close-out plan_  
_Revised: 2026-03-05 12:06 — Day 5: Admin Inbox, System Alerts, Frontpage Forms wiring + sanitization_
