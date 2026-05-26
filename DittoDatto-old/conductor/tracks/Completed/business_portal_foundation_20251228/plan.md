# Plan: Business Portal Foundation

## Phase 1: Authentication & Layout
*Goal: Secure the portal and establish the visual shell.*

- [x] Task: Create `apps/web/business-portal/app/pages/index.vue` with a login form (mirroring `admin-panel` pattern).
- [x] Task: Implement `apps/web/business-portal/app/layouts/dashboard.vue` with the sidebar navigation structure.
- [x] Task: Implement `apps/web/business-portal/app/middleware/portal-auth.ts` to handle `companyId` claim checks and redirection.
- [x] Task: Conductor - User Manual Verification 'Authentication & Layout' (Protocol in workflow.md)

## Phase 2: Core Composables & Context
*Goal: Enable the app to "know" which company is active.*

- [x] Task: Create `useCompany` composable to fetch and store company data based on the authenticated user's claim.
- [x] Task: Create `useStores` composable to fetch the list of stores for the active company.
- [x] Task: Implement the "Dashboard" overview page (`pages/dashboard.vue`) displaying the fetched Company Name and basic stats.
- [x] Task: Conductor - User Manual Verification 'Core Composables & Context' (Protocol in workflow.md)

## Phase 2.5: Company Selector Component
*Goal: Remodel TeamsMenu into Company Selector for multi-company support.*

- [x] Task: Remodel `TeamsMenu.vue` to show active Company name and support multi-company selection.
- [x] Task: Add "Add Company" item leading to business application page (TODO placeholder).
- [x] Task: Replace "Create team" with "Feedback" (TODO: Feedback modal via Messaging Service).
- [x] Task: Replace "Manage teams" with "Support".
- [x] Task: Conductor - User Manual Verification 'Company Selector' (Protocol in workflow.md)

## Phase 3: Inventory UI (Stores & Services)
*Goal: Display the business data.*

- [x] Task: Create `pages/stores/index.vue` to list the company's stores using `useStores`.
- [x] Task: Create `pages/services/index.vue` to list the company's services.
- [x] Task: Conductor - User Manual Verification 'Inventory UI' (Protocol in workflow.md)

## Phase 3.5: Bookings Overview
*Goal: Display bookings and connect stats to dashboard.*

- [x] Task: Create `useBookings` composable to fetch bookings from `bookings` collection (NOTE: schema subject to change).
- [x] Task: Create `pages/bookings/index.vue` to list and overview bookings.
- [x] Task: Connect booking count to dashboard stats grid.
- [x] Task: Conductor - User Manual Verification 'Bookings Overview' (Protocol in workflow.md)

## Phase 4: Final Verification
*Goal: Prove it works with "DittoDatto AS".*

- [x] Task: Perform a full end-to-end verification: Login -> Dashboard -> View Stores -> View Bookings.
- [x] Task: Conductor - User Manual Verification 'Final Verification' (Protocol in workflow.md)

