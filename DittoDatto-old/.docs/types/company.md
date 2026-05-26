---
schema: CompanySchema
domain_term: Company
firestore_path: companies/{companyId}
status: active
version: v1.0
related: [store, user, staff-member, customer, media, event]
noona_equivalent: Company
tags: [core, business-portal, admin-panel]
---

# Company

A registered business entity on the DittoDatto platform. Owns one or more Establishments (stores) and employs staff. The organizational root for all business operations.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `ownerId` | `string` | ✅ | User ID of the company owner |
| `ownerEmail` | `string (email)` | ❌ | Owner's email (denormalized for admin convenience) |
| `name` | `string` | ✅ | Business name (2–255 chars) |
| `description` | `string` | ❌ | About the company |
| `website` | `string (url)` | ❌ | Company website |
| `address` | `string` | ❌ | Registered address |
| `city` | `string` | ❌ | City |
| `zip` | `string` | ❌ | Postal code |
| `country` | `string` | ✅ | ISO country code. Default: `"NO"` |
| `email` | `string (email)` | ❌ | Contact email |
| `phone` | `string` | ❌ | Contact phone |
| `logoUrl` | `string (url)` | ❌ | Company logo |
| `tier` | `enum: free, premium` | ✅ | Subscription tier. Default: `"free"` |
| `slinks` | `object` | ❌ | Social links: `fb`, `ig`, `x` (all optional URLs) |
| `onboardingStatus` | `enum` | ✅ | `not_started`, `ai_suggested`, `verified`, `complete` |
| `aiSuggestedData` | `object` | ❌ | AI-populated data from onboarding (name, website, description, address, phone, suggestedAt) |
| `enabledFeatures` | `object` | ✅ | **⚠️ Transitional (ADR-0005).** SaaS-era feature gates: `tableReservation`, `aiAssistance`, `ticketSystem`, `eventSystem`. Will be replaced by `usagePolicy` + Datto-mediated access in v1.5. |
| `storePolicy` | `object` | ✅ | `maxStores` (default 1), `canCreateOwnStores` (default false). Admin-controlled. |
| `mediaConfig` | `object` | ✅ | `defaultTags`: array of available media tags for this company |
| `managerIds` | `string[]` | ❌ | User IDs with manager access |
| `memberIds` | `string[]` | ❌ | User IDs with member access |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification timestamp |

## Relationships

- A **Company** has one or more **Stores** (Establishments)
- A **Company** is owned by one **User** (via `ownerId`)
- A **Company** employs **Staff Members** (sub-collection)
- A **Company** has **Customers** (sub-collection)
- A **Company** owns **Media Items** (sub-collection)
- A **Company** can create **Events**
- A **User** can belong to multiple **Companies** (via `companyMemberships`)

## Design Notes

- `storePolicy.maxStores` is admin-controlled to prevent free-tier abuse. Premium companies can have multiple locations.
- `enabledFeatures` gates access to vertical-specific features (table reservations, events, ticketing). Admin flips these — businesses can't self-enable.
- `onboardingStatus: "ai_suggested"` means the AI pre-populated fields from a URL scrape; the owner still needs to verify.
- Categories intentionally live at Store level, not Company level. A company might operate a salon and a barbershop — different categories per location.

## Noona Comparison

- Noona's `Company` maps closely. Key difference: Noona has `companytype` as a first-class entity; DittoDatto uses `storeType` on Store instead.
- Noona has enterprise-level grouping above Company; DittoDatto doesn't need this yet (single-owner model).
- Feature flags are a DittoDatto addition — Noona handles this via subscription tiers.
