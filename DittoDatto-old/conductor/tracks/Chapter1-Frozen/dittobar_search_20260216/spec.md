# DittoBar — Formal Specification

**Track:** `dittobar_search_20260216`  
**Author:** Arnar (CEO, Merkurial Studio) + Hermes (AI Navigator)  
**Date:** 2026-02-16  
**Version:** 0.1 (Phase 1 Scope)

---

## 1. Executive Summary

The DittoBar is the primary search and discovery interface on the DittoDatto public marketplace. It replaces the static search pill currently overlaying the map hero on the frontpage.

Unlike a traditional search input, the DittoBar is designed as **Ditto's eye** — the consumer-facing end of an agentic pipeline. In its mature form, it will serve as the interaction point between users and the Ditto AI agent, rendering responses via A2NUI (Agent-to-Nuxt-UI) surfaces.

This specification covers the **Phase 1 MVP** — a working, visually polished search bar with client-side Firestore matching — and documents the long-term vision for context.

---

## 2. Vision

### 2.1 The Pipeline

```
User ──→ DittoBar ──→ @ (Agent Brain) ←── DattoBar ←── Business
```

- **DittoBar** (public marketplace): Consumer search and discovery
- **DattoBar** (business portal): Business intelligence and management search — deeper capabilities
- **@** (Agent Brain): Intermediary agentic layer connecting both endpoints (out of scope, future "Virtual Department Agentspace")

### 2.2 Living User Interface (LUI)

The DittoBar is the first surface where the LUI paradigm meets consumers. Per the LUI methodology:

- The bar is a **hollow component** — a stylistic shell that the agent fills with intent
- The UI is **ephemeral** — results appear because they fulfill user intent, then dissolve
- The **agent is the architect** — Ditto decides what to show based on query context

Phase 1 simulates this with traditional client-side search. Phase 3 replaces it with true agent-driven responses.

---

## 3. User Experience

### 3.1 Three States

Derived from the Captain's wireframe ([DittoSearchbar.jpg](./context/DittoSearchbar.jpg)):

#### State 1 — Idle

```
┌──────────────────────────────────────────────────────┐
│  🔍  # Rotating Placeholder Text...              🎤  │
└──────────────────────────────────────────────────────┘
```

- Left: search icon (animated pulse or glow)
- Center: cycling placeholder text (CSS transition, ~3s per rotation)
  - _"Søk etter tjenester..."_ (Search for services)
  - _"Frisør i nærheten?"_ (Hairdresser nearby?)
  - _"Hva trenger du i dag?"_ (What do you need today?)
- Right: microphone icon (visual indicator, no functionality in Phase 1)
- Tap/click/focus → transitions to **State 2**

#### State 2 — Searching

```
┌──────────────────────────────────────────────────────┐
│  🔍  Frisø|                                       🎤  │
└──────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────┐
│  Kategorier                                          │
│  ✂️  Frisør                                          │
│  💅  Frisør & Skjønnhet                              │
│──────────────────────────────────────────────────────│
│  Steder                                              │
│  🏪  Viking Barbers · Frisør · Drammen               │
│  🏪  Salon Nord · Frisør · Drammen                   │
└──────────────────────────────────────────────────────┘
```

- Input is active, placeholder stops rotating
- After ≥2 characters + 300ms debounce → autocomplete dropdown appears
- **Categories section:** icon + name (max 5), click → `/discover?category=slug`
- **Stores section:** name + category badge + city (max 5), click → store page
- ESC or clear → **State 1**
- Select store result → **State 3**

#### State 3 — Results

```
┌──────────────────────────────────────────────────────┐
│  ◀   House of the North                          ▶   │
└──────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────┐
│  [Store Image]                                       │
│  Frisør · Drammen · ⭐ Åpen                         │
│                                                      │
│  [ BOOK ]                    [ OPEN → ]              │
└──────────────────────────────────────────────────────┘
```

- Bar transforms: left/right become ◀/▶ navigation arrows
- Center shows store name
- Below: compact store result card
  - Store cover image
  - Category + city + open status
  - **BOOK** → navigates to store booking flow
  - **OPEN** → navigates to establishment page (`/{categorySlug}/{storeSlug}`)
- Selecting a result pans the map to store coordinates
- ◀/▶ cycles through search results
- Back/clear → **State 1**

### 3.2 Responsive Behavior

- Desktop: max-width ~448px (current pill width), centered on map
- Tablet: same pill form factor, dropdown wider
- Mobile: full-width with horizontal padding, maintaining the rounded-pill aesthetic

---

## 4. Technical Architecture

### 4.1 Component Structure

```
index.vue (frontpage)
  └── DDDittoBar.vue
        ├── State machine (idle | searching | results)
        ├── useDittoSearch composable
        ├── Autocomplete dropdown (sub-component or inline)
        └── Result card (sub-component or inline)
```

### 4.2 Composable: `useDittoSearch`

| Export            | Type                      | Description                        |
| ----------------- | ------------------------- | ---------------------------------- |
| `query`           | `Ref<string>`             | User's search text                 |
| `debouncedQuery`  | `Ref<string>`             | Debounced (300ms) query            |
| `categoryMatches` | `ComputedRef<Category[]>` | Categories matching query (max 5)  |
| `storeMatches`    | `ComputedRef<Store[]>`    | Stores matching query (max 5)      |
| `hasResults`      | `ComputedRef<boolean>`    | Any matches found                  |
| `isSearching`     | `Ref<boolean>`            | True while debounce pending        |
| `selectedIndex`   | `Ref<number>`             | Currently focused result (for ◀/▶) |
| `selectNext()`    | `Function`                | Move to next result                |
| `selectPrev()`    | `Function`                | Move to previous result            |
| `clearSearch()`   | `Function`                | Reset to idle state                |

**Matching logic:** Case-insensitive substring match on:

- `store.name`
- `store.tagline`
- `store.city`
- Category name (looked up from category ID)

**Data sources:** Accepts `stores` and `categories` refs as arguments — reuses the Firestore queries already active on `index.vue`. No duplicate reads.

### 4.3 Events / Map Bridge

| Event         | Payload                        | Trigger                     |
| ------------- | ------------------------------ | --------------------------- |
| `focus-store` | `{ lat: number, lng: number }` | User selects a store result |

The parent (`index.vue`) receives this event and calls `mapExplorer.value.panTo(lat, lng)` or equivalent to move the map view.

### 4.4 Files Affected

| File                                | Action     | Description                               |
| ----------------------------------- | ---------- | ----------------------------------------- |
| `app/components/DDDittoBar.vue`     | **NEW**    | 3-state search bar component              |
| `app/composables/useDittoSearch.ts` | **NEW**    | Search logic composable                   |
| `app/pages/index.vue`               | **MODIFY** | Replace lines 129-140 with `<DDDittoBar>` |

---

## 5. Design System

### 5.1 Styling

- **Glass morphism:** `bg-default/80 backdrop-blur-md` (matches existing card aesthetic)
- **Border:** `border border-default` (subtle)
- **Shadow:** `shadow-lg` (elevation above map)
- **Radius:** `rounded-full` (pill shape for bar), `rounded-2xl` (dropdown/card)
- **Typography:** System font stack via Nuxt UI defaults
- **Icons:** Lucide icon set (consistent with rest of PM)

### 5.2 Animations

| Animation                | Duration                    | Easing      |
| ------------------------ | --------------------------- | ----------- |
| Placeholder rotation     | 3s per text, 0.3s crossfade | ease-in-out |
| Dropdown appear          | 200ms                       | ease-out    |
| State transitions        | 200ms                       | ease-in-out |
| Search icon pulse (idle) | 2s loop                     | ease-in-out |

---

## 6. Phased Roadmap

| Phase | Scope                                                                          | Timeline                 |
| ----- | ------------------------------------------------------------------------------ | ------------------------ |
| **1** | Visual component + Firestore search + autocomplete + result cards + map bridge | **This iteration**       |
| **2** | Search keyword mining, recent searches, location-aware filtering               | After analytics research |
| **3** | A2NUI integration — agent-driven responses, voice input, WebSocket             | Long track               |
| **4** | DattoBar (Business Portal) + Agent Brain middleware (`@` layer)                | Separate track           |

---

## 7. Open Items

| Item                                                   | Owner   | Status                                |
| ------------------------------------------------------ | ------- | ------------------------------------- |
| Search keyword mining strategy (Firestore vs BigQuery) | Captain | 📌 PostIt — researching GCP options   |
| Voice input approach (Web Speech API vs Whisper)       | Hermes  | Deferred to Phase 3                   |
| A2NUI package integration into monorepo                | Joint   | Deferred — currently separate repo    |
| DattoBar track creation                                | Captain | Future — after DittoBar Phase 1 ships |

---

## 8. Appendix

### A. Wireframe Reference

See [DittoSearchbar.jpg](./context/DittoSearchbar.jpg) — hand-drawn 3-state wireframe by the Captain.

### B. A2NUI Context

The A2NUI architecture docs in [context/](./context/) describe the rendering pipeline that will power the DittoBar's agent-driven mode in Phase 3. Key documents:

- [architecture.md](./context/architecture.md) — Three-layer system (processor → composable → renderer)
- [LUI Methodology.md](./context/LUI%20Methodology.md) — Hollow component philosophy
- [ai-dashboard-vision.md](./context/ai-dashboard-vision.md) — Surface zones pattern (applicable to DittoBar result rendering)

### C. Related Tracks

- `frontpage_master_track_20260104` — Frontpage lifecycle (DittoBar is part of this)
- `messaging_service_20251229` — Messaging (future: Ditto conversation could route through DittoBar)
