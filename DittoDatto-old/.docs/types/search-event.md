---
schema: SearchEventSchema, LogSearchEventRequestSchema
domain_term: Search Event / Zero-Result Signal
firestore_path: searchEvents/{searchEventId}
status: active
version: v1.0
related: [store, user]
noona_equivalent: N/A (DittoDatto original — demand intelligence)
tags: [core, public-marketplace, intelligence, dittobar]
---

# Search Event

A logged record of a DittoBar query. Every search — successful or not — is captured for demand intelligence. Zero-result queries are the crown jewel: they represent unmet market demand and drive B2B sales targeting.

> **DittoBar is not a search bar — it's a demand intelligence harvester.**

## Fields (SearchEvent)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `query` | `string` | ✅ | Normalized query string (1–500 chars) |
| `rawQuery` | `string` | ✅ | Original user input before normalization |
| `resultCount` | `number (int)` | ✅ | Number of results returned |
| `selectedResult` | `object` | ❌ | What the user clicked: `{ type: "store"|"category", id, name }` |
| `userId` | `string` | ❌ | Logged-in user ID (null if anonymous) |
| `sessionId` | `string` | ✅ | Anonymous session UUID |
| `source` | `enum: dittobar, discover, dattobar` | ✅ | Which search interface |
| `createdAt` | `Timestamp` | ✅ | When the search happened |

## Fields (LogSearchEventRequest — client DTO)

Same as SearchEvent minus `id`, `userId` (server-enriched from auth), and `createdAt` (server timestamp). Includes `rawQuery` which the server normalizes into `query`.

## Search Sources

| Source | Description |
|--------|-------------|
| `dittobar` | Consumer-facing DittoBar in Public Marketplace |
| `discover` | Browse/filter on discovery page |
| `dattobar` | Business portal search (future) |

## Relationships

- A **Search Event** may reference a **User** (if logged in)
- A **Search Event** may reference a selected **Store** or **Category** (via `selectedResult`)
- **Zero-Result Signals** feed the B2B sales analytics dashboard
- The **DittoBar** component creates Search Events on every query

## Design Notes

- **Zero-Result Signal** = `resultCount === 0`. This is the most valuable data point: "people searched for X but we don't have it." The sales team uses these to target businesses: "50 people searched for 'Thai massage in Drammen' last month — you should be on DittoDatto."
- **`rawQuery` vs `query`:** The raw input preserves typos and exact user phrasing. `query` is normalized (lowercased, trimmed) for aggregation.
- **`selectedResult`** tracks conversion: user searched → user clicked. No selected result = bounce (they left without selecting).
- **`sessionId`** enables anonymous search tracking. Even without login, we can count unique searchers and repeat queries.
- **No Noona equivalent.** Search analytics is a DittoDatto original — this is the demand intelligence moat. Noona doesn't capture search intent at this granularity.
