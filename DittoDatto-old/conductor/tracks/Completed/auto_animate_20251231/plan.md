# Plan: AutoAnimate Integration for Smooth UX ✅

## Overview
Install and integrate `@formkit/auto-animate` package to provide smooth, seamless animations across Nuxt applications. The first use case is fixing the "laggy" auto-scroll in the Showcase mode vertical carousel on the store preview page.

**Target Apps:**
- `packages/ui` - ✅ Installed here since it's the shared UI layer consumed by all apps
- `apps/web/business-portal` - Store previews
- `apps/web/public-marketplace` - Published store pages (future use)

---

## Phase 1: Package Installation ✅
*Goal: Add @formkit/auto-animate to shared UI layer*

- [x] **Task 1.1:** Install `@formkit/auto-animate` in `packages/ui`
- [x] **Task 1.2:** Create `useAutoAnimate` re-export composable in `packages/ui/composables`
- [x] **Task 1.3:** Verify package is available to consuming apps

---

## Phase 2: Seamless Carousel Implementation ✅
*Goal: Replace current scroll-based carousel with smooth looping animation*

- [x] **Task 2.1:** Refactor showcase carousel to use CSS keyframe animation for smooth scroll
- [x] **Task 2.2:** Duplicate images at the end for seamless loop illusion
- [x] **Task 2.3:** Add configurable scroll speed (5s per image, 15s minimum)
- [x] **Task 2.4:** Maintain pause-on-hover functionality (`.paused` class)
- [x] **Task 2.5:** Add gradient overlays for visual polish

---

## Phase 3: AutoAnimate Global Setup ✅
*Goal: Make useAutoAnimate available as utility across apps*

- [x] **Task 3.1:** Add AutoAnimate composable to UI package exports
- [x] **Task 3.2:** Available via Nuxt auto-imports

---

## Phase 4: Manual Verification ✅

- [x] **Test A:** Preview page shows smooth upward scroll
- [x] **Test B:** Carousel loops seamlessly (no jump back to start)
- [x] **Test C:** Hover pauses animation
- [x] **Test D:** Animation speed is pleasant and not rushed

**User Rating: 10/10** 🎉

---

## Technical Implementation

### CSS Infinite Scroll Solution
```css
@keyframes scroll-up {
  0% { transform: translateY(0); }
  100% { transform: translateY(-50%); }
}

.carousel-track {
  animation: scroll-up linear infinite;
}

.carousel-track.paused {
  animation-play-state: paused;
}
```

### Key Changes
1. Images are doubled (`infiniteScrollImages`) for seamless loop
2. CSS transforms are hardware-accelerated (60fps smooth)
3. Animation duration scales with image count
4. Pause on hover via class toggle

---

## Files Modified

- `packages/ui/package.json` - Added `@formkit/auto-animate`
- `packages/ui/composables/useAutoAnimate.ts` - New composable
- `packages/ui/components/establishment/EstablishmentImageGallery.vue` - Refactored carousel
