---
title: "PostIT: BankID + Vipps Login"
type: "postit"
status: "resolved"
priority: "v1.0-blocker"
superseded_by: "adr/0010-auth-architecture.md"
date: "2026-05-02"
session: 3
domain: "Auth"
tags:
  - "bankid"
  - "vipps"
  - "auth"
  - "oidc"
---

# 📌 PostIT: BankID + Vipps Login — Auth & Payment Research

## The Discovery

MercuryEngine's auth middleware (`auth.ts`) verifies Firebase ID tokens but has **zero BankID awareness**. CONTEXT.md says "BankID is mandatory for self-service transactions" — but the engine never checks a `bankIdVerified` custom claim. This gap needs to be closed before launch.

## Key Research Finding: Vipps Login = BankID

The research revealed a critical simplification: **Vipps Login IS BankID verification.** You can't create a Vipps account without BankID. Therefore:

> If a user authenticates via Vipps Login → they are BankID-verified by definition.

This means we may not need a separate BankID integration at all. Vipps Login gives us both auth AND identity verification in one flow.

## Vipps Login — Technical Summary

| Aspect | Detail |
|--------|--------|
| **Protocol** | OpenID Connect (OIDC) + OAuth 2.0 |
| **Mobile flow** | App-to-app (`requested_flow=app_to_app_v2`) |
| **Security** | PKCE required for mobile |
| **Redirects** | Universal Links (iOS) / App Links (Android) — not custom URL schemes |
| **User data** | Name, email, phone, address, birth date, NIN (national ID) |
| **Portal** | [portal.vippsmobilepay.com](https://portal.vippsmobilepay.com) |

### Integration Steps (Flutter)

1. **Register on Vipps MobilePay Portal** — create sales unit, activate "Vipps Login"
2. **Get credentials** — `client_id` + `client_secret`
3. **Fetch OIDC config** — from Vipps well-known endpoint (don't hardcode)
4. **Implement OAuth2 flow:**
   - Open Vipps app via deep link with PKCE challenge
   - Handle redirect back to Flutter app
   - Exchange code for tokens
   - Call `/userinfo` endpoint
5. **Bridge to Firebase Auth** — create Firebase custom token from Vipps identity, attach custom claims (`bankIdVerified: true`, `nin`, `vippsId`)

### Flutter Packages to Evaluate

- `flutter_appauth` — mature OIDC/OAuth2 library
- `openid_client` — alternative OIDC client
- Check if Vipps has any official Flutter SDK

## Architecture Proposal

```
Flutter App
     │
     ▼
┌──────────────┐
│ Vipps Login  │  ← App-to-app OIDC flow (PKCE)
│ (in-app)     │
└──────┬───────┘
       │ auth code
       ▼
┌──────────────┐
│ Backend fn   │  ← Cloud Function or MercuryEngine endpoint
│ /auth/vipps  │     Exchange code → Vipps tokens → user info
└──────┬───────┘
       │ create custom token
       ▼
┌──────────────┐
│ Firebase Auth│  ← signInWithCustomToken()
│ Custom Claims│     bankIdVerified: true
│              │     vippsId: "..."
└──────────────┘
```

## Engine Auth Middleware Split (Proposed)

```typescript
// Current: single layer
requireAuth → verifies Firebase token, sets userId

// Proposed: two layers
requireAuth     → verifies Firebase token (read operations)
requireBankId   → requireAuth + checks bankIdVerified claim (write operations)
```

Where to apply:
- `GET /appointments/slots` — `requireAuth` (or public)
- `POST /appointments/holds` — `requireBankId`
- `POST /appointments/bookings` — `requireBankId`
- `POST /appointments/bookings/:id/cancel` — `requireBankId`
- TheOracle search — `requireAuth` (or public)

## Vipps Payment (v1.3)

Separate from login, but same merchant relationship. Vipps ePayment API for:
- Booking deposits
- No-show fees
- Pre-payment

The merchant registration for Vipps Login can be extended to include payment — same portal, same sales unit.

## Open Questions (for dedicated grill session)

1. **Vipps-only or Vipps + email fallback?** Some users (tourists, immigrants) may not have Vipps. Do we support email + phone verification as a lesser-trust tier?
2. **NIN storage:** Vipps returns Norwegian National ID Number. Do we need to store it? GDPR implications.
3. **Backend token exchange:** Cloud Function (stateless, scale-to-zero) or MercuryEngine endpoint?
4. **Existing Firebase users:** What happens when a Vipps-verified user already has a Firebase email account? Account linking strategy.
5. **Test environment:** Does Vipps have a sandbox for development?

## Next Steps

- [ ] Register Merkurial Studio on Vipps MobilePay Portal
- [ ] Get test/sandbox credentials
- [ ] Prototype the OIDC flow in a standalone Flutter test app
- [ ] Design the Firebase custom claims schema
- [ ] Grill session: auth architecture for v1.0

---

*Created: 2026-05-02 — Session 3 Grill*
