# Global Image Overhaul

**Track ID:** `global_image_overhaul_20260212`  
**Domain:** `cross-cutting`  
**Created:** 2026-02-12  
**Status:** Not Started

---

## Overview

Migrate all image rendering to `@nuxt/image` (`<NuxtImg>`) for automatic resizing, format conversion (WebP/AVIF), and lazy loading. The module is already installed and registered in the public marketplace but unused. This track covers consumer-side optimization and ensures the business portal's upload pipeline produces images compatible with the optimization layer.

**Key Benefit:** Significant mobile performance gains — store cover images dropping from ~2MB raw to ~100KB optimized, gallery images lazy-loaded and format-converted.

---

## Phases

### Phase 1: Configuration & Foundation
- [ ] Add `image` config in `nuxt.config.ts` — whitelist Firebase Storage and Google CDN domains
- [ ] Configure `ipx` provider settings (quality defaults, format preferences)
- [ ] Verify `@nuxt/image` works with Firebase Storage URLs in dev (emulator + production URLs)
- [ ] Document image sizing conventions:
  - Avatar: 80px / 160px (1x/2x)
  - Store card thumbnail: 400px
  - Store cover hero: 800px / 1200px
  - Gallery full: 1200px
  - Gallery thumb: 300px

### Phase 2: Public Marketplace — High-Impact Surfaces
- [ ] Store cards on browse/discover pages → `<NuxtImg>` with `sizes` prop
- [ ] Establishment page hero cover → `<NuxtImg>` with responsive sizes
- [ ] Establishment page gallery → `<NuxtImg>` with lazy loading
- [ ] Favorites page cards → `<NuxtImg>`
- [ ] Service images on store pages → `<NuxtImg>`

### Phase 3: Avatars & Small Images
- [ ] Navbar avatar → `<NuxtImg>` or keep `<UAvatar>` (check if Nuxt UI's avatar uses NuxtImg internally)
- [ ] Profile header avatar → same
- [ ] Review avatars → same
- [ ] Store logos (small badges) → `<NuxtImg>` with fixed width

### Phase 4: Business Portal — Upload Pipeline Alignment
- [ ] Audit current upload flow (Firebase Storage direct upload)
- [ ] Consider upload-time resizing (Cloud Function or client-side) vs runtime optimization via ipx
- [ ] Ensure uploaded images have consistent naming/paths for cache-friendly URLs
- [ ] Business portal store editor previews → `<NuxtImg>` if applicable

### Phase 5: Admin Panel (Low Priority)
- [ ] Admin panel image displays (store listings, user avatars) → `<NuxtImg>` if worth the effort
- [ ] Admin panel is internal — optimize only if performance is noticeably poor

---

## Related Files

| File | Purpose |
|------|---------|
| `apps/web/public-marketplace/nuxt.config.ts` | Already has `@nuxt/image` module registered |
| `apps/web/public-marketplace/package.json` | Already has `@nuxt/image` v2 dependency |
| `apps/web/public-marketplace/app/pages/browse.vue` | Store cards with raw `<img>` |
| `apps/web/public-marketplace/app/pages/[category]/[slug].vue` | Establishment page with cover + gallery |
| `apps/web/public-marketplace/app/pages/profile/favorites.vue` | Favorite cards with raw `<img>` |
| `apps/web/business-portal/` | Upload pipeline — Storage handling lives here |

---

## Decision Log

- **2026-02-12:** Track created. `@nuxt/image` already installed but unused. ipx provider is the right choice for Firebase Storage URLs since we use `node-server` Nitro preset. No need for external services (Cloudinary/imgix) at this stage.
- **Upload-time vs runtime resize:** Defer decision to Phase 4. Runtime ipx is sufficient for MVP, upload-time resize is a future optimization for production scale.

---

## Notes

- `@nuxt/image` v2 docs: https://image.nuxt.com/
- Firebase Storage URLs format: `https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{path}?alt=media`
- Google Auth photo URLs: `https://lh3.googleusercontent.com/...` (already optimized by Google's CDN)
- The `ipx` provider runs server-side, which is compatible with our SSR setup
- Consider adding `placeholder` prop for blur-up loading effect on hero images
