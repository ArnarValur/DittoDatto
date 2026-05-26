# Frontpage Theme Splash

**Track ID:** `frontpage_theme_splash_20260210`  
**Domain:** `public-marketplace`  
**Created:** 2026-02-10  
**Status:** Not Started  
**Viewport:** Mobile-first

---

## Overview

Evaluate and apply the user's custom **SolarTheme** to the public-marketplace frontpage. This track covers Nuxt UI 4.4.0 theming best practices, production-grade theme setup, and integrating the SolarTheme concept into the frontpage design.

---

## Current Theme State

| Config | Value |
|--------|-------|
| `app.config.ts` primary | `green` |
| `app.config.ts` neutral | `slate` |
| Nuxt UI theme colors | `primary, secondary, success, info, warning, error` |
| Fonts | Enabled via `ui.fonts: true` |
| CSS entry | `~/assets/css/main.css` |

---

## Phases

### Phase 1: Theme Architecture Review
- [ ] Review Nuxt UI 4.4.0 theming docs & production recommendations
- [ ] Understand user's SolarTheme concept and color palette
- [ ] Audit current frontpage components for theme token usage

### Phase 2: Theme Implementation
- [ ] Configure SolarTheme in `app.config.ts` (colors, variants)
- [ ] Update CSS custom properties / design tokens if needed
- [ ] Apply theme to frontpage sections (hero, cards, categories)

### Phase 3: Mobile-First Polish
- [ ] Verify all changes at mobile viewport first
- [ ] Responsive refinements for tablet/desktop
- [ ] Micro-animations and transitions

---

## Related Files

| File | Purpose |
|------|---------|
| `app/app.config.ts` | Nuxt UI color configuration |
| `nuxt.config.ts` | Module config, theme colors array |
| `app/pages/index.vue` | Frontpage — map hero, nearby, categories |
| `app/assets/css/main.css` | Global styles entry |

---

## Notes

- Nuxt UI 4.4.0 — user confirmed version
- Mobile-first viewport for this session
- Awaiting user's SolarTheme concept and palette details
