# Search Dashboard MVP — Implementation Plan

**Track ID:** `search_dashboard_mvp_20260219`
**Domain:** `dashboard`
**Created:** 2026-02-19
**Status:** Planned

---

## Phase 1: Foundation — Firebase & Auth

Set up the data layer and access gate.

- [ ] Install Firebase SDK (`npm install firebase`)
- [ ] Create `app/utils/firebase.ts` — Firebase app initialization with DittoDatto project config
- [ ] Create `app/composables/useAuth.ts` — Firebase Auth composable (login, logout, current user, role check)
- [ ] Create `app/pages/login.vue` — Simple email/password login form
- [ ] Create `app/middleware/auth.ts` — Route guard: redirect unauthenticated users to `/login`
- [ ] Verify: can log in as super_admin and access dashboard

## Phase 2: Data Layer — Search Events Composable

Build the composable that reads and aggregates search event data.

- [ ] Create `app/composables/useSearchEvents.ts` — Core data composable
  - Firestore queries with time-window filtering (7d/30d/custom)
  - Real-time listener (`onSnapshot`) for recent activity
  - Computed aggregations: total searches, unique queries, zero-result rate, CTR
- [ ] Create `app/types/search-event.ts` — Local TypeScript interfaces (mirroring DittoDatto's Zod schema)
- [ ] Verify: composable returns correct data from Firestore emulator or staging

## Phase 3: Dashboard UI

Build the visual dashboard using Nuxt UI components.

- [ ] Replace default `app/app.vue` with dashboard shell (UDashboardPage, sidebar, header)
- [ ] Create `app/pages/index.vue` — Main dashboard page
  - KPI cards row (Total Searches, Unique Queries, Zero-Result Rate, CTR)
  - Zero-result queries table (UTable)
  - Top queries table (UTable)
  - Recent activity feed (real-time)
- [ ] Create `app/components/KpiCard.vue` — Reusable KPI summary card
- [ ] Create `app/components/TimeWindowSelector.vue` — 7d/30d/all toggle
- [ ] Wire time window selector to composable's query parameters
- [ ] Apply dark mode default in `app.config.ts`
- [ ] Clean up starter template remnants (AppLogo, TemplateMenu, etc.)

## Phase 4: Polish & Verification

- [ ] Add Firestore composite indexes (if needed for queries)
- [ ] Test with real staging data
- [ ] Verify mobile/tablet responsiveness
- [ ] Captain's manual verification walkthrough
