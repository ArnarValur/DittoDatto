---
schema: FirebaseTokenClaimsSchema, FirebaseUserSchema
domain_term: Auth Claims / Firebase User
firestore_path: N/A (Firebase Auth, not Firestore)
status: active
version: v1.0
related: [user, rbac]
noona_equivalent: N/A
tags: [core, auth]
---

# Auth

Firebase Authentication schemas for token claims and user records. These are not Firestore documents — they live in Firebase Auth's internal storage and are accessed via the Admin SDK or client SDK.

## Firebase Token Claims

Custom claims set on the Firebase Auth token. Read by Firestore security rules and client-side auth guards.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `role` | `enum: customer, business, admin, super_admin` | ✅ | Platform role |
| `companyMembershipIds` | `string[]` | ❌ | Company IDs this user belongs to |
| `bankIdVerified` | `boolean` | ❌ | **Pending (Session 3).** Whether the user has completed BankID verification. Required for online transactions. Staff-created users start as `false`. |

## Firebase User

Server-side user record from Firebase Admin SDK.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `uid` | `string` | ✅ | Firebase Auth UID |
| `displayName` | `string` | ✅ | Display name |
| `email` | `string (email)` | ✅ | Primary email |
| `photoURL` | `string` | ❌ | Photo URL |
| `role` | `UserRole` | ✅ | Platform role |
| `customClaims` | `Record<string, any>` | ✅ | All custom claims |
| `metadata` | `any` | ✅ | Firebase metadata (creation time, last sign-in) |

## Design Notes

- Custom claims are set via Cloud Functions (`setCustomUserClaims`) when a user's role changes.
- `companyMembershipIds` in claims is the same flat array as `User.companyMembershipIds` — kept in sync by Firestore triggers.
- Firestore security rules read `request.auth.token.role` and `request.auth.token.companyMembershipIds` for access control.
- BankID verification will be added as a claim (`bankIdVerified: boolean`) in Session 3 design.
