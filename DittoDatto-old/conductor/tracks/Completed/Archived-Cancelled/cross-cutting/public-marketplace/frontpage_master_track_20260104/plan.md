# Public Marketplace Frontpage — Master Track

**Track ID:** `frontpage_master_track_20260104`  
**Domain:** `public-marketplace`  
**Created:** 2026-01-04  
**Status:** 🗣️ Planning Discussion  
**Type:** Master Track (Flutter-compatible blueprint)

---

## Vision Statement

Build a cohesive, premium Public Marketplace experience that serves as:
1. **Web PWA** — Nuxt 4 app (current implementation path)
2. **Flutter Native Apps** — iOS & Android (future, using same design language)

> [!IMPORTANT]
> This Master Track defines the **complete frontpage lifecycle** with platform-agnostic descriptions. Component specs should be detailed enough to implement identically in Flutter.

---

## 🎨 Visual Design Analysis (User Mockups)

> [!NOTE]
> User has a **special cross-platform theme** to be shared. PostIt: Request theme details.

### Desktop Design (Mockup 1)

![Desktop Frontpage](uploaded_image_0_1767491911967.png)

**Key Elements:**
- **Map Hero** — Full-width map with search overlay, establishment pins
- **Popular Nearby** — Horizontal card scroll with ratings (Nordic Tastes ★4.8, Oslo Cuts ★4.4, etc.)
- **Browse Categories** — 6x4 icon grid (Restaurants, Hair Services, Cleaning, Moving, etc.)
- **Latest News** — Blog/article cards with thumbnails
- **"Grow your business with DittoDatto"** — CTA section with registration form
- **Footer** — Discover, For Business, Company links

### Mobile Designs (Mockups 2, 4, 5)

````carousel
![Mobile Home - Map Focus](uploaded_image_1_1767491911967.png)
<!-- slide -->
![Mobile Home - Trending](uploaded_image_3_1767491911967.png)
<!-- slide -->
![Mobile Home - Full Map](uploaded_image_4_1767491911967.png)
````

**Key Elements:**
- **Map at top** — ~40-50% of viewport, with category pins
- **Search bar** — Floating or below map
- **"My Account" + "AI Concierge"** — Two primary action buttons
- **Browse Categories** — 2x4 icon grid (smaller subset)
- **Popular Nearby** — Horizontal card scroll
- **Recently Added** — List view with type badges
- **Bottom Navigation** — Home, Discover/Explore, (+), Messages, Profile

### User Dashboard (Mockup 3) — Logged-in State

![User Dashboard](uploaded_image_2_1767491911967.png)

**Key Elements:**
- **Welcome, {Name}** — Personalized greeting with date
- **Upcoming** — Next appointments timeline (TODAY 14:00, OCT 26 09:30)
- **Your Shortcuts** — Frequently visited businesses (2x2 grid)
- **Account & Activity** — Profile Overview, Booking History, Favorites, My Reviews
- **Voice Search Button** — Bottom floating FAB for AI interaction

### Design System Observations

| Token | Value | Notes |
|-------|-------|-------|
| Primary color | `#DC2626` / red | DittoDatto brand |
| Accent | `#2563EB` / blue | Links, interactive |
| Cards | Rounded corners (`rounded-xl`) | ~12-16px |
| Shadows | Subtle, elevated | Cards float slightly |
| Typography | Clean sans-serif | Likely Inter or similar |
| Icons | Lucide/Simple Icons | Outline style |

---

## ☀️🌙 Solar Theme — The Crown Jewel

> [!IMPORTANT]
> This is a **unique differentiator** — automatic light/dark mode based on ACTUAL sun position!

### Theme Screenshots

````carousel
![Solar Theme - Night Mode](uploaded_image_0_1767492684195.png)
<!-- slide -->
![Solar Theme - Golden Hour](uploaded_image_1_1767492684195.png)
````

### How It Works

**Location-aware astronomical theming:**
- Uses Drammen coordinates: `(59.74, 10.20)`
- Calculates real sun altitude and position
- Automatically transitions between light ↔ dark

| Time | Sun Altitude | Lightness | Mode |
|------|--------------|-----------|------|
| 03:08 (Night) | -43.3° | 5% | 🌙 Dark + Stars |
| 10:11 (Morning) | 3.1° | 31% | 🌅 Golden Hour |
| 12:00 (Noon) | ~15-20° | 80%+ | ☀️ Light |

### Theme Palettes

Four palette options observed:

| Palette | Use Case |
|---------|----------|
| **Slate** | Default neutral |
| **Sand** | Warm, earthy |
| **Minimal** | Clean, reduced |
| **Forest** | Nature-inspired greens |

### ✨ Easter Egg: Constellation Hunting

> *"If you can spot any constellations, you get a point"*

- Stars twinkle in dark mode
- Uses **Sidereal Calculation** for real star positions
- Actual constellations visible based on Drammen's night sky!

### Technical Notes

- **Source:** `.docs/Misc/SolarThemeNuxt/` (moved to project)
- **Status:** ✅ Analyzed, ready to migrate
- **Dependencies:** `suncalc` (sun position), `@types/suncalc`
- **Migration Analysis:** See `solar_theme_migration.md` artifact
- **TODO:** Replace yellow tones with proper Nuxt UI light mode colors
- **Color palette:** Needs design help

> [!NOTE]
> **📌 PostIt:** Solar Theme migration deferred. Code analyzed (2026-01-04 04:05).
> Composables: `useSolarEngine.ts`, `useStarMap.ts` (30 stars, 3 constellations).
> Resume when ready for visual polish phase.

### Integration Plan (When Ready)

1. Add `suncalc` to public-marketplace dependencies
2. Copy composables → rename to `useSolarTheme.ts`
3. Merge CSS variables into `main.css`
4. Update `app.vue` with theme + star layers
5. Add user toggle in settings

---

## 🎵 AI Agents: Ditto & Datto

> **Ditto** = Public-facing AI (customer side)  
> **Datto** = Business-facing AI (merchant side)  
> *Twins powered by Gemini via VertexAI* 🤖

**Frontpage Section Idea:**
- "Meet Ditto" section before footer
- Voice-first interaction on mobile
- "AI Concierge" button prominent on mobile

---

## 📦 Existing Component Inventory

### packages/ui/components/establishment/
| Component | Purpose | Reusable? |
|-----------|---------|-----------|
| `EstablishmentImageGallery.vue` | Hero carousel/bento | ✅ Ready |
| `EstablishmentInfoBar.vue` | Name, logo, address, hours, Book CTA | ✅ Ready |
| `AboutSection.vue` | Description + map embed | ✅ Ready |
| `ExperienceCard.vue` | Service/experience item | ✅ Ready |

### packages/ui/components/booking/
| Component | Purpose | Reusable? |
|-----------|---------|-----------|
| `BookingModal.vue` | Unified booking slideover | ✅ Ready (15KB) |
| `BookingSlideover.vue` | Alternative layout | ✅ Ready |
| `DateSelector.vue` | Calendar picker | ✅ Ready |
| `GuestCountSelector.vue` | +/- guest count | ✅ Ready |
| `ServiceSelector.vue` | Service picker | ✅ Ready |
| `TimeSlotPicker.vue` | Available slots | ✅ Ready |

### packages/ui/components/
| Component | Purpose | Reusable? |
|-----------|---------|-----------|
| `DDDattoBar.vue` | Top toolbar for previews | ✅ Ready |
| `ServiceGrid.vue` | Grid of service cards | ✅ Ready |
| `DDIconPicker.vue` | Icon selection | ✅ Ready |

### 🎯 Source of Truth: Business Portal Preview

[preview.vue](file:///x:/DittoDatto.no/apps/web/business-portal/app/pages/establishments/[slug]/preview.vue) is the **template** for the Establishment Page:
- Hero gallery integration
- Info bar with Book CTA
- Tabs: Menu/Services, Events, About Us
- Service grid with booking
- Event grid with tickets
- BookingModal integration

> [!IMPORTANT]
> **Architecture Decision (2026-01-04):**
> - `packages/ui` components = **Current direction** ✅
> - Business Portal `preview.vue` = **Template for Establishment Page** ✅
> - Old pages in `public-marketplace/app/pages/` = **Legacy, to be replaced** ⚠️

### ⚠️ Legacy Code (To Be Replaced)

These files in `public-marketplace` are from old codebase and **not relevant**:
- `/s/[slug].vue` — Old accordion-based store page
- Other migrated pages — May need complete rebuild

**Strategy:** Build fresh using `packages/ui` components, not refactoring legacy.

---

## Current State Analysis

### ✅ What's Already Migrated

| Asset | Type | Notes |
|-------|------|-------|
| `useMarketplaceStores.ts` | Composable | Filtering, pagination, sorting (stubbed) |
| `useCategories.ts` | Composable | Category listing (stubbed) |
| `useFavorites.ts` | Composable | Full CRUD with offline fallback ✅ |
| `useSiteSettings.ts` | Composable | Maintenance mode via Firestore |
| `maintenance.global.ts` | Middleware | Redirect to /maintenance when enabled |
| `ColorModeToggle.vue` | Component | Dark/light mode switch |
| `FavoritesList.vue` | Component | Favorites panel UI |
| `MessagesPanel.vue` | Component | Messages UI shell |

### 🔴 What's Missing (Placeholder)

- `index.vue` — Currently Nuxt UI starter template (needs complete rebuild)
- Store detail pages (`/store/[slug]`)
- Category browsing (`/category/[slug]`)
- Search functionality
- Booking/reservation integration
- User authentication flow
- Mobile-first responsive layouts
- i18n (Norwegian primary, English secondary)

---

## 🎯 Frontpage Sections

The frontpage should be composed of the following **platform-agnostic sections**:

### 1. Hero Section
**Purpose:** First impression, primary search/discovery entry point

| Element | Web | Flutter | Notes |
|---------|-----|---------|-------|
| Search bar | `<input>` with typeahead | TextField + overlay | Location-aware suggestions |
| Location picker | Dropdown/modal | Bottom sheet | City/region selection |
| Hero image/carousel | CSS background / carousel | PageView | Seasonal/promotional |
| Quick category pills | Horizontal scroll | ListView.horizontal | Top 6 categories |

**User Story:** *"As a visitor, I want to quickly search for services near me or browse popular categories."*

---

### 2. Popular Categories Grid
**Purpose:** Visual discovery of service types

| Element | Web | Flutter | Notes |
|---------|-----|---------|-------|
| Category cards | Grid (3 cols desktop, 2 mobile) | GridView | Icon + name + count |
| See all link | Router link | Navigator.push | → /categories |

**Data:** From `useCategories.ts` → `popularCategories` (top 6)

---

### 3. Featured Stores Carousel
**Purpose:** Highlight premium/promoted businesses

| Element | Web | Flutter | Notes |
|---------|-----|---------|-------|
| Store cards | Horizontal scroll | ListView.horizontal | Image, name, rating, distance |
| "Featured" badge | Overlay | Stack | Visual indicator |
| Favorite button | Heart toggle | IconButton | Uses `useFavorites` |

**Data:** From `useMarketplaceStores.ts` → `sortBy: 'featured'`

---

### 4. Nearby Stores Section
**Purpose:** Location-aware discovery

| Element | Web | Flutter | Notes |
|---------|-----|---------|-------|
| Store list/grid | Responsive grid | ListView / GridView | Based on user geolocation |
| Distance badge | Calculated | Calculated | "1.2 km" format |
| Rating stars | Star icons | RatingBar | 0-5 scale |
| "Show more" | Button/link | ElevatedButton | Pagination |

**Data:** From `useMarketplaceStores.ts` → filtered by `city` + `sortBy: 'distance'`

---

### 5. Quick Actions / App Promo
**Purpose:** Cross-platform upsell (when on web)

| Element | Web | Flutter | Notes |
|---------|-----|---------|-------|
| App store badges | Image links | N/A (native app) | iOS/Android |
| QR code | Canvas/SVG | N/A | Deep link to app |

---

### 6. Footer / Navigation
**Purpose:** Secondary navigation, legal, social

| Element | Web | Flutter | Notes |
|---------|-----|---------|-------|
| Bottom nav | None (footer) | BottomNavigationBar | Home, Search, Favorites, Profile |
| Footer links | Standard footer | N/A | About, Terms, Privacy |
| Social links | Icons | N/A | Instagram, Facebook |

---

## 🛠️ Implementation Phases

### Phase 1: Foundation ✅ COMPLETED
- [x] Design system tokens → Using Nuxt UI native (no custom tokens)
- [x] Responsive grid/layout → Nuxt UI built-in responsive utilities
- [x] Component inventory → 25+ components in packages/ui
- [x] i18n setup (Norwegian primary, English secondary)
  - `nb.json` — Full Norwegian Bokmål translations
  - `en.json` — Full English translations
  - `nn.json` — Nynorsk stub
- [x] nuxt.config.ts updated with modules, vuefire, i18n
- [x] Extends @dittodatto/ui for shared components

### Phase 1.5: Publishing & Visibility ✅ COMPLETED (2026-01-06)
- [x] **Category store counting** — Firestore trigger updates `category.count` on store changes
  - `packages/functions/src/categories/index.ts` — `onStoreWritten` trigger
  - `categories_recount` callable for backfill
- [x] **Frontpage filters by `isPublished`** — Only published stores appear in "Popular Nearby"
- [x] **Category filtering** — Only categories with `count > 0` shown in "Browse Categories"
- [x] **Direct URL protection** — Unpublished stores redirect to frontpage (not 404)
- [x] **Favorites count display** — Shows in establishment info bar with solid heart icon

### Phase 2: Hero & Search
- [ ] Hero section with search bar
- [ ] Location picker (city selection)
- [ ] Category quick pills

### Phase 3: Discovery Sections
- [ ] Popular categories grid
- [ ] Featured stores carousel
- [ ] Nearby stores section (with geolocation)

### Phase 4: Store Cards & Lists
- [ ] Store card component (shared UI)
- [ ] Favorite toggle integration
- [ ] Rating display
- [ ] Distance calculation

### Phase 5: Navigation & Layout ✅ COMPLETED
- [ ] Default layout with header/navbar
- [ ] Mobile bottom navigation (Home, Discover, Favorites, Profile)
- [ ] Desktop footer with links
- [ ] Minimal layout for auth pages
- [ ] Color mode toggle integration
- [ ] Language selector integration
- [ ] iOS safe area support

### Phase 6: Data Integration
- [ ] Connect `useMarketplaceStores` to real Firebase
- [ ] Connect `useCategories` to real Firebase
- [ ] Geolocation API integration

### Phase 7: Search & Filtering
- [ ] Search page/overlay
- [ ] Category filter page
- [ ] Advanced filters (rating, distance, type)

### Phase 8: Store Detail Page (Establishment Page) — MVP PRIORITY
- [x] Create `DDEstablishmentPage.vue` in packages/ui
- [x] URL routing: `/{category}/{slug}` + storeType fallback
- [x] Category listing page `/{category}/`
- [/] Services list with booking triggers (component exists, needs data)
- [ ] Booking integration (MerkuryEngine)
- [/] Gallery carousel (component exists)
- [/] Events section (component exists, needs data)
- [ ] Reviews section (future)
- [ ] Map embed

#### 🌐 URL Structure Decision

**Pattern:** `/{category-slug}/{store-slug}`

**Examples:**
- `/barber/nordic-cuts`
- `/restaurant/fjord-bistro`
- `/spa/wellness-center`
- `/dentist/drammen-tannklinikk`

**Benefits:**
- SEO-friendly (keywords in URL)
- Users immediately know the business type
- Clean, memorable URLs
- Good for sharing

**Implementation:**
```
pages/
  [category]/           ← Category listing (optional)
    [slug].vue          ← Establishment page (DDEstablishmentPage)
```

**Nuxt Route:** `/pages/[category]/[slug].vue`

**Data Resolution:**
1. Validate `category` slug exists in categories collection
2. Find store by `slug` WHERE `category` matches
3. If not found → 404 or redirect to search

---

## 🎨 Design Principles (Cross-Platform)

1. **Mobile-First** — Design for touch, adapt for desktop
2. **Consistent Spacing** — 4px/8px/16px/24px/32px grid
3. **Dark Mode Native** — Not an afterthought
4. **Micro-Animations** — Subtle, purposeful transitions
5. **Accessible** — WCAG 2.1 AA minimum
6. **Offline-Tolerant** — Graceful degradation, cached data

---

## 📱 Flutter Translation Notes

When translating to Flutter:
- **Nuxt composables** → **Provider/Riverpod** state management
- **Vue components** → **Flutter Widgets** (Stateless/Stateful)
- **VueFire** → **cloud_firestore** package
- **Nuxt UI** → **Material 3** or custom design system
- **i18n** → **flutter_localizations** + arb files
- **CSS variables** → **ThemeData.extensions**

---

## 🔄 Related Tracks

| Track | Status | Dependency |
|-------|--------|------------|
| Map Integration | `[~]` | Store detail page needs this |
| Service Groups | ✅ | Store detail page displays these |
| Events Simple | ✅ | Events section on store page |
| Booking System | — | Phase 8 prerequisite |

---

## ✅ Decisions Captured (2026-01-04 Session)

### 1. Hero Section Design
> **Status:** 📌 PostIt — User has high-fidelity designs ready
- User will provide images, screenshots, and designs when ready

### 2. Category System — CLARIFIED ✅
- **Scale:** DOZENS of categories (Dentists, Tattoo, Hair salons, Yoga, Legal, etc.)
- **Structure:** Not yet established (flat vs hierarchical TBD)
- **Internal Business Types:** "Venues", "Restaurants", "Services" (high-level groupings)
- **Some dynamic:** e.g., "Café", "Bar", "Bar & Café"
- **Frontpage sections needed:**
  - "All Categories" — Icon grid with names
  - "Top 20 Categories" — Featured on frontpage
  - *Maybe:* "Top 10 Venues", "Top 10 Restaurants", "Top 20 Services"

### 3. Location Strategy — CLARIFIED ✅
- **Ground Zero:** Drammen 🎯
- **Expansion:** Lier (maybe), Buskerud Fylke (future)
- **Vision:** National within 2 years
- **Implementation:** Browser/App geolocation request (NOT hardcoded)
- **Fallback:** Manual city picker if geolocation denied

### 4. Engagement System — EVOLVED ✅
**Dual system proposed:**
| System | Users | Purpose |
|--------|-------|---------|
| ❤️ **Favorites** | Registered only | Personal saved list |
| 💜 **Love** | Everyone (incl. guests) | Public likes/popularity metric |

This creates:
- Authenticity for Favorites (your personal list)
- Viral potential for Love (social proof, trending)

### 5. Design System — DECISION DEFERRED ⏸️
- User experienced in Nuxt/Nuxt UI, not Flutter
- Portal & Admin = Nuxt (no native needed) ✅
- Public Marketplace = Conflict (web vs native)
- **Recommendation captured below**

### 6. MVP Definition — CRYSTAL CLEAR ✅
> **MVP is NOT the full frontpage — it's the Establishment Page with working bookings**

| MVP Component | Domain | Status |
|---------------|--------|--------|
| Establishment Page (Service) | public-marketplace | Needed |
| Establishment Page (Restaurant) | public-marketplace | Needed |
| Standard Booking Flow | MerkuryEngine | ~75% (Portal preview) |
| Reservation Booking Flow | MerkuryEngine | ~75% (Portal preview) |

The frontpage is **discovery navigation** to reach these establishments.

---

## 🧠 My Thoughts & Suggestions

### On Category Architecture 📂

Since you'll have DOZENS of categories with business types as groupings, I suggest:

```
Business Types (3)          Categories (many)         Services
├── Venues          →       Bar, Café, Nightclub      → Events, Reservations
├── Restaurants     →       Fine Dining, Fast Food    → Table Reservations
└── Services        →       Dentist, Hair, Tattoo     → Standard Bookings
```

**Implication:** Business Type could be a `storeType` field (you already have this!), and Categories become a filterable taxonomy within each type.

For the frontpage:
- **"Top 20 Categories"** — Cross-type, popularity-ranked
- **"Top 10 by Type"** — Filtered views (Venues, Restaurants, Services)

### On the Nuxt vs Flutter Dilemma 🤔

I understand the conflict! Here's my honest assessment:

| Approach | Pros | Cons |
|----------|------|------|
| **Nuxt PWA (current)** | Your expertise, faster, shared code | May lack native feel, push notifications harder |
| **Flutter** | True native, single codebase for iOS/Android | Learning curve, separate codebase from web |
| **Nuxt + Capacitor** | Wrap PWA in native shell | Best of both? But can feel "webview" |

**My suggestion:** 
1. **Build the web PWA first** with mobile-first design
2. **Design components platform-agnostically** (this plan helps!)
3. **Defer Flutter decision** until you hit PWA limitations
4. **When you do Flutter:** This Master Track becomes your blueprint

The key investments (composables, API design, component specs) transfer regardless.

### On MVP Scope 🎯

You said: *"MVP is get MerkuryEngine to work for production-grade bookings"*

This reframes the Master Track! The frontpage phases become:

| Phase | MVP? | Notes |
|-------|------|-------|
| Phase 8: Store Detail Page | ✅ **YES** | This IS the Establishment Page |
| Phase 4: Store Cards | ✅ **YES** | Need to navigate TO establishments |
| Phase 3: Discovery Sections | Soft yes | Minimal version for testing |
| Phase 1-2: Hero & Foundation | Later | Not blocking bookings |

**Suggested MVP Flow:**
```
Hardcoded landing → Category/Search → Store Card → Establishment Page → Book
```

### On the Love/Favorites System 💜❤️

I love this dual concept! Implementation thoughts:

```typescript
// Favorites = Firestore subcollection (authenticated)
users/{userId}/favorites/{storeId}

// Love = Firestore counter on store (anyone can increment)
stores/{storeId}.loveCount: number
// With Cloud Function to debounce/prevent spam
```

Guest "Love" could use:
- Device fingerprint (localStorage)
- Rate limiting (1 love per store per day per device)
- No authentication required

---

## 📋 Proposed Next Steps

> [!IMPORTANT]
> Based on this session, I recommend pivoting the track focus:

### Option A: Reframe as "Establishment Page Track"
Focus on Phase 8 first (Store Detail Page with bookings), backfill discovery later.

### Option B: Keep Master Track, but start from Phase 4+8
Build Store Cards + Establishment Page simultaneously, then layer frontpage.

### Option C: Split into sub-tracks
- `establishment_page_mvp` — MVP focus
- `discovery_foundation` — Hero, categories, search (later)

**Which resonates with you, Captain?**

---

## Session Notes

**2026-01-04 02:43** — Initial planning discussion
- Captured all 6 decision points
- Identified MVP is Establishment Page, not frontpage
- Proposed dual Love/Favorites system
- Deferred Flutter vs Nuxt decision (build PWA first, translate later)

**2026-01-04 03:20** — Architecture clarification
- Solar Theme screenshots added (constellations: Orion, Big Dipper, Cassiopeia!)
- Confirmed: `packages/ui` = source of truth
- Confirmed: Old pages in public-marketplace are legacy (to be replaced)
- Confirmed: Business Portal `preview.vue` = template for Establishment Page
- Location: Use browser geolocation (not hardcoded)
- Next: Build page templates → then connect MerkuryEngine

### 🚀 Proposed Sub-Tracks

1. **`solar_theme_integration`** — Migrate and integrate astronomical theming
2. **`establishment_page_template`** — Create shared component from preview.vue
3. **`merkuryengine_booking_mvp`** — Connect booking flows (after templates ready)

