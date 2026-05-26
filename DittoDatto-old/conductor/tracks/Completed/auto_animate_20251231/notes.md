# AutoAnimate Track Notes

## Session: 2025-12-31

### User Request
- Install AutoAnimate for Nuxt applications
- Fix laggy auto-scroll on vertical carousel in preview page
- Want smooth, slow animation with seamless looping

### Key Insight
The current implementation uses JavaScript `scrollTo/scrollBy` with `behavior: 'smooth'`, but this:
1. Has a jarring reset when reaching the end
2. Browser-controlled smoothing isn't as smooth as CSS animations
3. No true infinite loop - it jumps back to start

### Solution
CSS-based infinite scroll with cloned images:
1. Render images twice (original + clone)
2. CSS animation scrolls through 50% (all original images)
3. When animation completes, it seamlessly loops (clone is identical to original start)
4. Result: undetectable loop point

### AutoAnimate vs CSS Animation
AutoAnimate is great for:
- List additions/removals
- DOM element reordering
- Fade in/out transitions

For infinite scrolling carousels, CSS keyframes are better because:
- Smoother (hardware accelerated)
- No JavaScript overhead
- Truly infinite loop possible
- Better performance

Will still install AutoAnimate for other UX improvements across the apps.

### Where to Install
**Recommendation:** Install in `packages/ui` as it's the shared layer consumed by all frontend apps.

The `@dittodatto/ui` package is a Nuxt layer that extends all consuming apps, so dependencies installed there are available everywhere.

---

## Session Bonus Fixes

### Logo Display Fix
- Changed `logoUrl` → `store.images?.logo` in preview page
- The store schema stores logo in `images.logo`, not `logoUrl`

### Lint Errors Fixed
- `coverLayoutMode` type casting simplified
- `store.images?.length` → `store.images?.gallery?.length`

### Storage Rules Delete Permission
- Split `write` into `create, update` and `delete`
- `request.resource` checks only apply to create/update (not delete)
- Delete now works with just auth + company access
