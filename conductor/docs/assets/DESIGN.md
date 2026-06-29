---
version: alpha
name: DittoDatto Design System
colors:
  primary: "#6F71CC"
  surface-dark: "#0f1117"
  sidebar-dark: "#141720"
  surface-container-dark: "#161922"
  surface-container-high-dark: "#1c1f2b"
  surface-light: "#F8F9FD"
  surface-container-light: "#EEEEF5"
  surface-container-high-light: "#E4E1E9"
  success: "#22c55e"
  error: "#ef4444"
  warning: "#f59e0b"
  premium: "#3b82f6"
  free: "#6b7280"
typography:
  headline:
    fontFamily: Outfit
    fontWeight: 600
  body:
    fontFamily: Inter
    fontWeight: 400
  label:
    fontFamily: Inter
    fontWeight: 500
rounded:
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  base: 16px
  lg: 24px
  xl: 32px
components:
  card:
    rounded: "{rounded.md}"
    elevation: 0
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#ffffff"
    rounded: "{rounded.sm}"
    padding: 14px
  input-decoration:
    rounded: "{rounded.sm}"
    padding: 14px
---

# DittoDatto Design System

## Overview

DittoDatto’s visual identity is built on a modern, premium dark aesthetic for back-office administration (Admin Panel) and a clean, high-contrast light system derived from the Stitch Enterprise Slate guidelines for partner operations (Business Portal) and consumers (Public Marketplace).
The entire system is powered by a shared foundation (`packages/ditto_design`) to ensure consistency across the admin, business, and marketplace apps.

## Colors

The system is built on a single accent anchor, **Moody Blue**, with hand-tuned surface grades for dark and light environments.

### Brand Anchor

- **Primary / Moody Blue (#6F71CC):** The key interaction and brand identifier. Used for active states, focal actions, and key brand touchpoints.

### Dark Surface Grades

Reproduces the sleek, low-noise administration interface.

- **Surface Dark (#0f1117):** The default window background for pages and dialogs.
- **Sidebar Background (#141720):** Used specifically for navigation sidebars and secondary side rails.
- **Surface Container (#161922):** The standard card and surface container background.
- **Surface Container High (#1c1f2b):** Used for elevated elements, hover states, and input fields.

### Light Surface Grades (Stitch Enterprise Slate)

Warm, highly readable layout foundation.

- **Surface Light (#F8F9FD):** Clean, warm background for portals and pages.
- **Surface Container Light (#EEEEF5):** The background for card lists, section separators, and input fields.
- **Surface Container High Light (#E4E1E9):** High-contrast container layer for accents and interactive states.

### Status & Utility Colors

- **Success (#22c55e):** Positive states, confirmations, and active status indicators.
- **Error (#ef4444):** Warnings, destructive actions, and invalid inputs.
- **Warning (#f59e0b):** Temporary notices, cautions, or holds.
- **Premium (#3b82f6):** Designates premium tiers and capabilities.
- **Free (#6b7280):** Designates free tier or standard properties.

## Typography

DittoDatto employs a strict "one platform, one voice" hierarchy:

- **Headlines & Titles:** Set in **Outfit** (Semi-Bold `600`) to project a clean, structural identity.
- **Body & Labels:** Set in **Inter** (Regular `400` / Medium `500`) for high-legibility interface reading, data grids, and forms.

## Layout & Spacing

A strict 4px spacing grid powers the layout rhythm. Spacing tokens are:

- **xs (4px):** Gaps between labels, micro-paddings, small icon margins.
- **sm (8px):** Gaps within button components, small padding.
- **md (12px):** Medium container padding, list item gaps.
- **base (16px):** Standard page padding, main grid gap.
- **lg (24px):** Large gap between major sections or headers.
- **xl (32px):** Page margins for spacious viewports.

Responsive layouts utilize the `DittoDashboardShell` layout with Material 3 breakpoints represented in `DittoWindowClass`:

- **Compact:** `< 600px` (drawers, single-column lists)
- **Medium:** `600px – 839px` (collapsed side rails)
- **Expanded:** `840px – 1199px` (expanded sidebars, side panels)
- **Large:** `≥ 1200px` (fixed layouts, multi-pane views)

## Elevation & Depth

Depth is created using tonal layering rather than heavy drop shadows:

- **Level 0 (Background):** Base layer (`#0f1117` in Dark, `#ffffff` or `#F8F9FD` in Light).
- **Level 1 (Containers):** Standard cards and navigation surfaces (`#161922` in Dark, `#F8F9FD`/`#EEEEF5` in Light).
- **Level 2 (Overlays):** Dropdowns, dialogs, and text fields (`#1c1f2b` in Dark, `#E4E1E9` in Light).
- **Accent Glow:** A subtle blue-purple glow (`rgba(111, 113, 204, 0.15)`) with a blur radius of 12px is used to indicate focus and active interactions.

## Shapes

We use rounded corners to soften the user interface, balancing structure and modern friendliness:

- **sm (8px):** Applied to small buttons, text input fields, badges, and snackbars.
- **md (12px):** The standard corner radius for cards and modal dialogs.
- **lg (16px):** Applied to larger sections and container panels.
- **xl (24px):** Used for large components and full-sheet sheets.

## Components

- **Buttons (Elevated/Primary):** Uses `colors.primary` background and `white`/`onPrimary` text. Rounded corner `sm` (8px), horizontal padding of 24px, and vertical padding of 14px.
- **Inputs:** 1px border (`white 10%` in Dark, `outline 30%` in Light) with 8px corner radius (`sm`), filled with container background, and padded at 16px horizontal / 14px vertical. Focused inputs get a 1.5px Moody Blue border.
- **Cards:** Flat (0 elevation) with a 12px (`md`) corner radius and a 1px border outline (`white 6%` in Dark, `outlineVariant 50%` in Light).
- **Dividers:** Thickness of 1px, colored using low-opacity dividers (`white 6%` in Dark, `outlineVariant 30%` in Light).
- **AppBars:** Solid, flat color matching the container background with Inter 18px semi-bold titles.

## Do’s and Don’ts

- **Do** stick to Outfit for headlines and titles, and Inter for body text.
- **Don't** add custom drop shadows to cards — rely on tonal values and thin borders.
- **Do** use Moody Blue sparingly to highlight key interactive flows.
- **Don't** mix rounded scales (e.g. putting a sharp 2px input inside a 12px card). Keep rounding to `sm` (8px) for controls and `md` (12px) for cards.
