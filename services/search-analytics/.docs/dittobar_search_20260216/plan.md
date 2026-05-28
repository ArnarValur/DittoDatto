# DittoBar Search Experience

**Track ID:** `dittobar_search_20260216`  
**Domain:** `public-marketplace`  
**Created:** 2026-02-16  
**Status:** Phase 1 Complete ✅

---

## Vision

> "Ditto's eyes are your eyes."

The DittoBar is the user's interaction bar with Ditto — the consumer-facing AI agent. It is **not a traditional search input**. It is a curated, intelligent, state-driven search component that will eventually serve as the **pipeline terminus** between the user and DittoDatto's agentic brain.

**Long-term architecture (out of scope, noted for context):**

```
DittoBar (User) ──→ @ (Agent Brain) ←── DattoBar (Business)
```

DattoBar will be a parallel component on the Business Portal with deeper capabilities. Both bars connect through an intermediary agentic layer (`@`). This iteration focuses only on DittoBar.

---

## Three States (from wireframe)

| State          | Left Icon   | Content Area                                                       | Right Icon |
| -------------- | ----------- | ------------------------------------------------------------------ | ---------- |
| **1. Idle**    | 🔍 Search   | Rotating placeholders (last search, nearest store, category hints) | 🎤 Mic     |
| **2. Inquiry** | ❓ Question | User types query → results load (future: A2NUI response)           | 🎤 Mic     |
| **3. Results** | ◀ Prev      | Store name + result card (BOOK · OPEN → Establishment Page)        | ▶ Next     |

---

## Scope Decisions (Captain's Input)

| Question                | Decision                                                                   |
| ----------------------- | -------------------------------------------------------------------------- |
| Placement               | **Replace** current dead search pill on frontpage map hero                 |
| Pages                   | **Frontpage only** this iteration                                          |
| Search backend          | **Client-side Firestore** — pragmatic for MVP                              |
| Autocomplete            | **Yes** — categories + stores type-ahead to guide users                    |
| Mobile                  | **Keep neat** like current pill — responsive, not a bottom sheet           |
| `/discover` integration | **Complement** — DittoBar = quick results, Discover = browse               |
| A2NUI integration       | **Not this iteration** — A2NUI lives in separate repo (`arnarvalur/a2nui`) |
| Showcase tomorrow       | **Visual + working search** — deployed bar, no agent wiring                |

---

## 📌 PostIt: Search Keyword Mining

> **Captain's insight:** Mine ALL user search keywords, especially zero-result queries. This is data gold for future marketing. Need to determine GCP/Firestore storage strategy for analytics. Captain will research options.

**Deferred to separate research spike.** Potential approaches:

- Firestore `searchQueries` collection with timestamp + query + resultCount + userId
- BigQuery streaming for analytics pipeline
- Cloud Functions trigger to log and aggregate

---

## Phases

### Phase 1: DittoBar Component (This Iteration) ✅

The visual component with working Firestore search, replacing the current map overlay pill.

- [x] **DDDittoBar.vue** — New component in `app/components/`
  - 3-state machine: `idle` → `searching` → `results`
  - Glassmorphism styling (matches current `bg-default rounded-full shadow-lg`)
  - Rotating placeholder text with CSS animation
  - Mic icon (visual only — no voice wiring this iteration)
- [x] **useDittoSearch.ts** — New composable in `app/composables/`
  - Queries Firestore `stores` (collectionGroup, `isPublished == true`)
  - Queries `categories` for type-ahead
  - Client-side fuzzy matching on store name, category name, tagline, city
  - Debounced input (300ms)
  - Returns `results[]`, `isSearching`, `query`
- [x] **Autocomplete dropdown** — Below the bar (Teleported to `#__nuxt` for z-index)
  - Category quick-picks (icon + name) — max 5
  - Store matches (name + category badge) — max 5
  - Click navigates to category or store page
- [x] **Results state** (State 3)
  - Compact store result card inside/below the bar
  - ◀ ▶ navigation between results
  - "BOOK" button → navigates to store's booking flow
  - "OPEN" → navigates to establishment page
- [x] **Map bridge** — When result is selected, emit coordinates → map pans + zooms
- [x] **Replace current search overlay** in `index.vue` (lines 129–140)

### Phase 2.1: Search Analytics Data Pipeline ✅

Foundation for search intelligence — dark launch capturing all search events to Firestore.

- [x] **search-event.ts** — Zod schema in `packages/shared-types/src/`
  - `SearchEventSchema` (full document), `LogSearchEventRequestSchema` (client DTO)
  - `SearchEventSourceSchema` — enum: `dittobar`, `discover`, `dattobar`
- [x] **log-search-event.ts** — Cloud Function in `packages/functions/src/analytics/`
  - `onCall`, `europe-west1`, `maxInstances: 5`
  - Validates with Zod, enriches with `serverTimestamp` + `auth.uid`
  - Writes to `searchEvents/{autoId}` collection
- [x] **Firestore rules** — `searchEvents` collection
  - Write-locked (Cloud Functions only)
  - Read: `isSuperAdmin()` only (admin panel dashboard)
- [x] **useDittoSearch.ts** — Analytics emission
  - Fire-and-forget Cloud Function call (never degrades search UX)
  - Emits on debounce settle (query + result count)
  - `logResultSelected()` for click-through tracking
  - Session ID via `useState` for anonymous tracking
  - Duplicate consecutive query suppression
- [x] **DDDittoBar.vue** — Wired click-through tracking
  - `enterResultsState()` → logs store selection
  - `navigateToCategory()` → logs category selection

### Phase 2.2: Admin Panel Dashboard (Next)

- [ ] Search Analytics page in admin panel (`/analytics/search`)
- [ ] Top queries table/chart (last 7/30 days)
- [ ] Zero-result queries list (🔴 flagged — data gold)
- [ ] Conversion funnel: Query → Click → Booking
- [ ] Real-time recent activity feed

### Phase 2.3: Intelligence Features (Future)

- [ ] Recent searches (localStorage)
- [ ] Popular/trending queries shown in DittoBar idle state
- [ ] Location-aware filtering (city/distance)


### Phase 3: A2NUI Integration (Long Track)

- [ ] Import `useA2uiSurface` from A2NUI package
- [ ] State 2 (Inquiry) renders A2NUI surface responses
- [ ] Ditto agent endpoint (`/api/ditto/search`)
- [ ] Voice input (Web Speech API or Whisper)
- [ ] WebSocket transport for real-time agent responses

### Phase 4: DattoBar (Separate Track)

- [ ] Business Portal equivalent with deeper capabilities
- [ ] Shared primitives with DittoBar (design system)
- [ ] Agent brain middleware (`@` layer)

---

## Related Files

| File                                                                  | Purpose                                     |
| --------------------------------------------------------------------- | ------------------------------------------- |
| `apps/web/public-marketplace/app/pages/index.vue`                     | Frontpage — DittoBar replaces lines 129-140 |
| `apps/web/public-marketplace/app/composables/useCategories.ts`        | Existing category composable (reference)    |
| `apps/web/public-marketplace/app/composables/useMarketplaceStores.ts` | Existing store composable (reference)       |
| `packages/shared-types/`                                              | Zod schemas for stores/categories           |
| `../a2nui/`                                                           | A2NUI project (future integration)          |

---

## Notes

- The archived `DattoBar` (deleted 2026-01-04) was a _Store Preview_ concept. DittoBar is fundamentally different — it's the consumer search experience.
- pulse.md flagged "PM Search Bar" as 🔴 priority.
- No existing tests in PM — verification is visual + browser-based.
- WebSocket likely needed when `@` agent brain layer comes online.
