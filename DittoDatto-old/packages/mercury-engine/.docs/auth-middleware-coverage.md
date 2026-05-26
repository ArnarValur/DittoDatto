# Authentication & Middleware Coverage Map

This document outlines the authentication requirements (Public vs. Protected) and middleware coverage for both the `public-marketplace` and `business-portal` domains.

## 1. Public Marketplace (`apps/web/public-marketplace`)

### Architecture
The public marketplace uses a **Named Middleware** approach (`app/middleware/auth.ts`). By default, all pages are **public**. Authentication is strictly opt-in and is applied only to specific routes via `definePageMeta({ middleware: 'auth' })`.

### 🔒 Requires Login (Protected)
These pages implement the `auth` middleware and require a valid user session.
* `/profile` (and all nested profile routes like Settings, Bookings, Messages, Favorites)
* *Note: Legacy root-level routes (`/settings`, `/bookings`, `/messages`, `/favorites`) automatically redirect to their `/profile/*` equivalents.*

### 🌍 Public Pages (No Login Required)
Users can browse these freely without an account.
* `/` (Frontpage)
* `/discover` (Search & Discovery)
* `/[category]` (Category listings)
* `/[category]/[slug]` (Store/Establishment details)
* `/login` & `/signup`
* `/contact`
* `/for-business`
* `/about`, `/terms`, `/privacy`, `/cookies`

---

## 2. Business Portal (`apps/web/business-portal`)

### Architecture
The business portal uses a **Global Middleware** approach (`app/middleware/auth.global.ts`). By default, **ALL** pages are protected and require a strict set of conditions to access.

**Access Requirements:**
1. Valid user authentication.
2. The user's token must contain a valid `companyId` claim.
3. The user's role must be `business` (or higher).

### 🌍 Public Pages
The global middleware explicitly whitelists only one route:
* `/` (The Login / Welcome page)

*(If an authenticated user visits `/` and meets the role requirements, they are automatically redirected to `/dashboard`)*

### 🔒 Requires Login (Protected)
Because the middleware is global, **every other page in the application** is strictly protected. Examples include:
* `/dashboard`
* `/bookings` & `/reservations`
* `/customers`
* `/establishments`
* `/events`
* `/inbox`
* `/media`
* `/resources`
* `/services`
* `/settings`
* `/staff`
* `/sandbox/*`
* `/preview/*`

Any unauthorized access attempt to these routes will intercept and redirect the user back to `/` with an appropriate error query parameter (e.g., `?denied=role` or `?denied=no-company`).