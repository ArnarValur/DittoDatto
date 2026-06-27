# Specification — Marketplace Foundation

> **Track:** `marketplace_foundation_20260624`
> **Domain:** Public Marketplace (native)
> **Type:** feature

---

## Scope

Bootstrap the Public Marketplace Flutter web app with navigation shell, consumer authentication, and profile screen.

## Key Decisions

| ADR | Decision |
|-----|----------|
| ADR-0020 | Anonymous browsing by default. Home and Bookings tabs are public; only Profile is auth-guarded. |
| ADR-0019 | SurrealDB-native auth via `ditto_auth` shared package + `consumer_auth` RECORD ACCESS. No separate auth backend. |
| ADR-0006 | Direct-to-SurrealDB architecture. |

## Acceptance Criteria

### Phase 1 — Project Scaffold + Nav Shell

- Flutter web project created at `apps/marketplace/`
- GoRouter with `StatefulShellRoute.indexedStack` — 3 branches (Home, Bookings, Profile)
- Bottom NavigationBar: Utforsk / Bestillinger / Profil
- DittoTheme (light/dark) from `ditto_design`
- Norwegian locale (nb_NO)

### Phase 2 — Consumer Auth

- AuthNotifier (Riverpod AsyncNotifier) — signup, login, logout, session restore
- Integration with `ditto_auth.consumerSignup/consumerSignin/tryRestoreConsumer/signOut`
- Login screen with email + password form, validation, error feedback
- Signup screen with name + email + password + confirm, validation
- Router redirect: unauthenticated on /profile → /profile/login; authenticated on auth routes → /profile

### Phase 3 — Profile Page

- Avatar with initials
- Greeting: 'Hei, {firstName} 👋'
- Current date in nb_NO locale
- Email display
- Dark mode toggle
- Logout button

### Phase 4 — Integration Testing + Saturn Deploy

- Integration tests for AuthNotifier against real SurrealDB
- Widget tests for form validation, router redirects, profile display
- Saturn deploy verified (port 8004)

## Out of Scope (Deferred)

- Discovery/search (Home screen is placeholder)
- Booking history (Bookings screen is placeholder)
- Discovery DB connection auth for anonymous clients (ADR-0020 deferral)
- Vipps OIDC (ADR-0019 escape hatch)
