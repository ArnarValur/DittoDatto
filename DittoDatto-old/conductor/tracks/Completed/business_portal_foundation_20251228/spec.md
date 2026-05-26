# Specification: Business Portal Foundation

## 1. Goal
To establish a functional "Business Portal" (`portal.dittodatto.no`) that allows business owners to authenticate, view their company dashboard, and manage their core inventory (Stores, Services, and Staff). This serves as the foundation for the SaaS offering.

## 2. Core Features

### 2.1 Authentication & Tenancy
*   **Login Page:** A secure login screen mirroring the Admin Panel's design.
*   **Claims-Based Routing:** Upon login, the system MUST inspect the user's ID Token for a `companyId` custom claim.
    *   If present: Redirect to `/dashboard`.
    *   If missing: Redirect to a `/no-company` or onboarding flow (out of scope for now, just show error).
*   **Composables:** `useCompany()` to fetch and store the active company context.

### 2.2 Dashboard Architecture
*   **Layout:** A standard `dashboard.vue` layout with a sidebar navigation.
*   **Navigation:**
    *   Dashboard (Overview)
    *   Stores
    *   Services
    *   Staff
    *   Bookings

### 2.3 Inventory Management (CRUD)
*   **Stores:** List all stores belonging to the company.
*   **Services:** List all services (Menu).
*   **Staff:** List all staff members.
*   **Constraint:** For this Sprint, we focus on *Listing* and *Creating* (Read/Write), with "Update" as a secondary priority.

### 2.4 Staff Access Control (RBAC)
*   **Middleware:** Implement `portal-auth` middleware to enforce role boundaries.
*   **Rules:**
    *   **Owner:** Full access.
    *   **Staff:** Restricted view (can only see their own schedule/profile).

## 3. Technical Implementation

### 3.1 File Structure
Adhere to the proposed structure in `business-portal-sprint.md`:
```
apps/web/business-portal/
├── app/
│   ├── pages/
│   │   ├── index.vue          # Login
│   │   ├── dashboard.vue      # Company overview
│   │   ├── stores/            # Store management
│   │   ├── services/          # Service menu editor
│   │   ├── bookings/          # Booking calendar
│   │   └── staff/             # Staff management
│   ├── composables/
│   │   ├── useCompany.ts
│   │   ├── useStores.ts
│   ├── middleware/
│   │   └── portal-auth.ts
│   └── layouts/
│       └── dashboard.vue
```

### 3.2 Data Flow
*   **Auth:** VueFire `useCurrentUser()`.
*   **Context:** `useCompany` initializes on app load, fetching `companies/{companyId}` from Firestore.

## 4. Acceptance Criteria
1.  **Login:** A user can log in with `owner@dittodatto.no` (Demo User).
2.  **Redirect:** They are automatically redirected to `/dashboard`.
3.  **Data:** The dashboard displays "DittoDatto AS" (Company Name).
4.  **Navigation:** Clicking "Stores" shows "DittoDatto Offices".
5.  **Role Check:** Logging in as a "Staff" user restricts access to the "Company Settings" pages.
