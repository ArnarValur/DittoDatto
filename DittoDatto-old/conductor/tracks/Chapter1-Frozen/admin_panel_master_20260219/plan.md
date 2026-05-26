# Admin Panel — Master Track

**Track ID:** `admin_panel_master_20260219`
**Domain:** `admin-panel`
**Created:** 2026-02-19
**Status:** In Progress

---

## Overview

Bring the admin panel up to date with DittoDatto brand standards, clean up legacy Nuxt UI dashboard template leftovers, and lay groundwork for future admin features.

---

## Phase 1: Moody Blue Theming 🎨

Swap the green primary to Moody Blue. Straightforward — same palette already live on public-marketplace.

- [x] `main.css` — Replace `--color-green-*` → `--color-moody-blue-*` (copy from marketplace)
- [x] `app.config.ts` — `primary: 'green'` → `primary: 'moody-blue'`
- [ ] Verify sidebar, buttons, active states all render in Moody Blue

---

## Phase 2: Profile Menu Cleanup 🧹

- [x] Remove **Billing** item
- [x] Fix **GitHub URL** typo: `dittodttom` → `dittodatto`
- [ ] Keep: Docs, GitHub, Templates, Theme picker, Appearance, Logout

---

## Phase 3: Sidebar & Navigation Polish 🧭

- [ ] Rename **Inbox** → **Ditto** (user-facing agent channel)
- [ ] Clone **Ditto** → **Datto** (business-facing agent channel)
- [ ] Disabled items audit: Reviews, Restaurants, Events
- [ ] Inbox badge hardcoded `'4'` → wire to real count or remove

---

## Phase 4: Data Views & Slideover Polish ✨

- [ ] **Users slideover** — makeover, smoother
- [ ] **Stores** — add Company column
- [ ] **Companies** — owner editing permission bug

---

## Phase 5: Future / Backlog 📋

- [ ] **Billing page concept** — self-serve subscription overview, reusable for business portal clients
- [ ] **Maintenance page** — resplash and wiring (low priority)
- [ ] **Business portal theming** — also still on green
- [ ] DittoBar search source link → points to Nuxt UI template

---

## Related Files

| File | Purpose |
|------|---------|
| `app/assets/css/main.css` | Color system |
| `app/app.config.ts` | Nuxt UI color config |
| `app/components/UserMenu.vue` | Profile dropdown menu |
| `app/layouts/admin-dashboard.vue` | Dashboard layout + sidebar nav |
