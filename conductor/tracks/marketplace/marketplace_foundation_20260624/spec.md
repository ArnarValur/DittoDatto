# Specification — Marketplace Foundation

> **Track:** `marketplace_foundation_20260624`
> **Domain:** Public Marketplace (native)
> **Type:** feature

---

## Overview

Scaffold the Public Marketplace Flutter app (`apps/marketplace/`) and wire consumer authentication via the `ditto_auth` shared package. This is the consumer-facing native app for Android/iOS — the canonical consumer surface (ADR-0004). The foundation pass delivers: project scaffold, three-tab navigation shell, signup/login screens, and a profile page with edit capability.

Anonymous Browsing (ADR-0020) means the app opens to the Home tab, not auth screens. Auth is required only for booking, favorites, and profile.

---

## Functional Requirements

### F1: Flutter Project Scaffold
- Create `apps/marketplace/` as a Flutter project targeting Android + iOS (+ web for Saturn staging).
- Depend on `packages/ditto_design/` for Material 3 tokens, responsive shell, breakpoints.
- Depend on `packages/ditto_auth/` for consumer authentication.
- Light theme default with dark mode toggle. Moody Blue (`#6F71CC`) seed color.

### F2: Navigation Shell
- Three-tab bottom navigation: **Home** / **Bookings** / **Profile**.
- Home and Bookings tabs are placeholder shells (empty screens with title text).
- Profile tab is functional (see F5).
- Unauthenticated users see Home tab by default. Profile tab prompts login.

### F3: Consumer Signup
- Signup screen with fields: name, email, password, confirm password.
- Calls `DittoAuth.consumerSignup(name:, email:, password:)`.
- `consumer_auth` RECORD ACCESS handles argon2 hashing and `role = 'customer'` server-side.
- On success: store tokens, navigate to Profile tab.
- On failure: display error message (invalid email, password too short, email already taken).

### F4: Consumer Login
- Login screen with fields: email, password.
- Calls `DittoAuth.consumerSignin(email:, password:)`.
- On success: store tokens, navigate to Profile tab.
- On failure: generic "Invalid credentials" (no information leakage).
- Session restore: `DittoAuth.tryRestoreConsumer()` on app launch.

### F5: Profile Page
- Read-only display: name, email, photo placeholder, phone (if set), bio (if set).
- Edit button opens inline form: name (editable), phone (editable), bio (editable). Email is read-only.
- Save updates user record via `UPDATE user SET name = $name, phone = $phone, bio = $bio WHERE id = $auth.id`.
- Sign out button → `DittoAuth.signOut()` → navigate to Home tab.

---

## Non-Functional Requirements

- **Performance:** Auth operations < 500ms on local WiFi to Saturn.
- **Security:** Tokens stored via `FlutterSecureStorage` (native) / `WebStorage` (web, ADR-0009). No PII logged.
- **Accessibility:** WCAG 2.1 AA — high contrast, semantic labels, focus traversal on all form fields.
- **Localization:** Bokmål primary, English co-equal. All user-facing strings externalized from day one.

---

## Acceptance Criteria

1. `flutter create` project compiles for Android, iOS, and web.
2. Three-tab bottom nav renders. Home and Bookings show placeholder content.
3. Consumer can sign up with name/email/password → sees profile page with their info.
4. Consumer can log out and log back in with the same credentials.
5. Session restore works: kill app, reopen → still logged in.
6. Profile edit: change name/phone/bio → changes persist across sessions.
7. Integration tests pass against real SurrealDB (signup, login, session restore, profile edit, signout).
8. Deployed to Saturn at `:8004` and accessible via browser.

---

## Edge Cases & Constraints

- **Duplicate email:** `consumer_auth` SIGNUP must reject duplicate emails. Surface user-friendly error.
- **Password validation:** Minimum length enforced client-side (8 chars) and server-side.
- **Token expiry:** 15m access token + refresh (via `WITH REFRESH`). `ditto_auth` handles silent refresh.
- **Offline:** Not in scope — no offline-first for v1.
- **`consumer_auth` not yet defined:** The Auth Service track must define `consumer_auth` on `users/users` schema and implement `consumerSignin`/`consumerSignup` in `ditto_auth` before the auth wiring phase of this track can proceed. Scaffold + shell can start in parallel.

---

## Dependencies

| Dependency | Track/Package | Status |
|---|---|---|
| `ditto_auth` package (consumer methods implemented) | Auth Service Phase 4 | Stubbed — `consumerSignin`/`consumerSignup` throw `UnimplementedError` |
| `consumer_auth` RECORD ACCESS on `users/users` | Auth Service Phase 2 | Not yet defined in schema |
| `ditto_design` package | Shared | ✅ Available |
| Saturn Caddy config for `:8004` | Infrastructure | Needs setup |

---

## Out of Scope

- DittoBar / search / discovery browsing (future track)
- Establishment detail pages (requires discovery DB connection)
- Booking flow (requires MercuryEngine integration)
- Favorites (requires auth + discovery cross-DB)
- Vipps / BankID auth (no merchant registration, no API access)
- Photo upload (profile photo is placeholder only)
- Push notifications
- Analytics / SearchEvent logging
