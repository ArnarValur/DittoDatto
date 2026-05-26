---
schema: UserSchema
domain_term: User
firestore_path: users/{userId}
status: active
version: v1.0
related: [company, auth, rbac, favorite, booking, customer]
noona_equivalent: User
tags: [core, public-marketplace, business-portal, admin-panel]
---

# User

A registered person on the DittoDatto platform. May be a consumer (customer role), a business owner/employee (business role), or a platform administrator. Every User authenticates via Firebase Auth; account creation requires BankID verification.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firebase Auth UID |
| `name` | `string` | ✅ | Display name (1–255 chars) |
| `email` | `string (email)` | ✅ | Primary email |
| `username` | `string` | ❌ | Optional username (1–30 chars) |
| `bio` | `string` | ❌ | Profile bio (max 500 chars) |
| `phone` | `string` | ❌ | Phone number |
| `photoUrl` | `string (url)` | ❌ | Profile photo URL |
| `role` | `enum: customer, business, admin, super_admin` | ✅ | Platform role. Default: `"customer"` |
| `isOnboarded` | `boolean` | ✅ | Whether onboarding flow is complete. Default: `false` |
| `companyMemberships` | `UserCompanyMembership[]` | ✅ | Array of `{ companyId, role, assignedAt }`. For "Switch Company" UI. Default: `[]` |
| `companyMembershipIds` | `string[]` | ✅ | Flat array of company IDs. Optimized for Firestore security rules. Default: `[]` |
| `language` | `enum: nb, en` | ✅ | UI language preference. Default: `"en"` |
| `createdAt` | `Date` | ✅ | Account creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification timestamp |

## Sub-Schemas

### UserCompanyMembership

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `companyId` | `string` | ✅ | Which company |
| `role` | `enum: owner, admin, employee` | ✅ | Role within that company |
| `assignedAt` | `Date` | ✅ | When membership was granted |

### CompanyRole vs UserRole

- `UserRole` (`customer`, `business`, `admin`, `super_admin`) — platform-wide access level
- `CompanyRole` (`owner`, `admin`, `employee`) — role within a specific company

A user with `role: "business"` may be an `owner` at one company and an `employee` at another.

## Relationships

- A **User** may own one or more **Companies** (via `companyMemberships`)
- A **User** can have many **Bookings** (as a consumer)
- A **User** can have **Favorites** (sub-collection of favorited establishments/staff)
- A **User** may be linked to a **Customer** record in a Company's CRM (via `Customer.userId`)
- A **User** may be linked to a **Staff Member** (via `StaffMember.userId`)
- Platform access is governed by **RBAC** rules based on `role`

## Design Notes

- `companyMembershipIds` is a denormalized flat array purely for Firestore security rules: `resource.data.companyMembershipIds.hasAny([request.auth.uid])`. Keeps rules fast.
- `companyMemberships` is the rich version with role info — used for the "Switch Company" dropdown in Business Portal.
- BankID verification is mandatory for account creation but is not tracked in this schema — it's an auth-flow concern, not a user-profile concern. BankID integration detail deferred to Session 3.
- `role: "customer"` is the default. Elevation to `"business"` happens when a company is created and assigned to the user. Elevation to `"admin"` or `"super_admin"` is manual (admin panel only).
- `language: "nb"` = Norwegian bokmål. Platform supports NO + EN from day 1.
