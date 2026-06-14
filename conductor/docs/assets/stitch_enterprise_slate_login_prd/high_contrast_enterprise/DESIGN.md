---
name: High-Contrast Enterprise
colors:
  surface: '#131318'
  surface-dim: '#131318'
  surface-bright: '#39383f'
  surface-container-lowest: '#0e0e13'
  surface-container-low: '#1b1b21'
  surface-container: '#1f1f25'
  surface-container-high: '#2a292f'
  surface-container-highest: '#35343a'
  on-surface: '#e4e1e9'
  on-surface-variant: '#c7c5d3'
  inverse-surface: '#e4e1e9'
  inverse-on-surface: '#303036'
  outline: '#918f9d'
  outline-variant: '#464651'
  surface-tint: '#c1c1ff'
  primary: '#c1c1ff'
  on-primary: '#23227d'
  primary-container: '#8588e4'
  on-primary-container: '#1b1a76'
  inverse-primary: '#5354ad'
  secondary: '#c5c5d3'
  on-secondary: '#2e303b'
  secondary-container: '#444652'
  on-secondary-container: '#b3b4c2'
  tertiary: '#efc052'
  on-tertiary: '#3f2e00'
  tertiary-container: '#b48a20'
  on-tertiary-container: '#372700'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e1dfff'
  primary-fixed-dim: '#c1c1ff'
  on-primary-fixed: '#09026a'
  on-primary-fixed-variant: '#3a3c94'
  secondary-fixed: '#e1e1f0'
  secondary-fixed-dim: '#c5c5d3'
  on-secondary-fixed: '#191b25'
  on-secondary-fixed-variant: '#444652'
  tertiary-fixed: '#ffdf9d'
  tertiary-fixed-dim: '#efc052'
  on-tertiary-fixed: '#251a00'
  on-tertiary-fixed-variant: '#5b4300'
  background: '#131318'
  on-background: '#e4e1e9'
  surface-variant: '#35343a'
typography:
  display-lg:
    fontFamily: Outfit
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Outfit
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Outfit
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Outfit
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 40px
  xl: 64px
  gutter: 24px
  margin: 32px
---

## Brand & Style
The design system is engineered for high-performance enterprise environments that require clarity, speed, and a modern edge. It bridges the gap between **Corporate Modern** and **High-Contrast Bold**, moving away from muted grey-scales toward a more saturated, vibrant palette. 

The aesthetic is characterized by sharp precision and high-intensity accents. It targets professional users who need to navigate complex data without visual fatigue, using "Moody Blue" as a functional beacon for primary interactions. The emotional response is one of authority, focus, and technical sophistication.

## Colors
The palette is built on a high-contrast foundation. In dark mode, the "Deep Slate Void" provides a bottomless depth that allows the "Moody Blue" accents to appear as if they are emitting light. In light mode, the focus shifts to stark, clinical cleanliness with deep charcoal typography for maximum legibility. 

The secondary colors should be used sparingly for semantic states (Success, Warning, Error), while the primary blue carries the weight of all critical path actions.

## Typography
This design system utilizes a dual-font strategy. **Outfit** is used for headlines to provide a geometric, modern, and confident appearance. **Manrope** is used for body text and UI labels due to its exceptional readability in data-heavy contexts.

Use `label-md` for small metadata, table headers, and overlines. Headlines should maintain tight letter spacing to emphasize the "bold" brand personality, while body text uses standard spacing for long-form comfort.

## Layout & Spacing
The layout follows a strict 12-column fluid grid for desktop, transitioning to a 4-column grid for mobile. 

We utilize a 4px baseline grid to ensure all components and spacing increments are mathematically consistent. Content is housed in Material-inspired containers that use generous internal padding (`md` or 24px) to balance the high-contrast color choices with breathing room. Horizontal margins should increase on larger displays to prevent line lengths from becoming unreadable.

## Elevation & Depth
Elevation is communicated through **Tonal Layering** rather than heavy shadows. 

1.  **Level 0 (Background):** The base canvas (`#0B0D14` or `#FFFFFF`).
2.  **Level 1 (Surface):** Default card and container state (`#161822` or `#F8F9FD`).
3.  **Level 2 (Overlay):** Used for modals and menus, slightly lighter than Level 1 in dark mode, with a crisp 1px border.

Shadows are used exclusively to indicate interactivity. Active states or focused inputs should utilize a **Moody Blue Glow**—a soft, diffused outer shadow using the `accent_glow` token to simulate a light-emitting component.

## Shapes
The shape language is defined by a consistent 12px corner radius (`rounded-lg`) for all primary containers and cards. This radius provides a professional yet contemporary feel that softens the high-contrast color palette. 

Small components like tags and buttons should maintain the `base` 8px radius, while checkboxes use a smaller 4px radius to feel more precise.

## Components
- **Buttons:** Primary buttons use the Moody Blue background with high-contrast text. Secondary buttons use a transparent background with a 1.5px Moody Blue border.
- **Cards:** Use a 12px radius. In dark mode, cards have a subtle 1px border of `#2D303E` to separate them from the void.
- **Inputs:** Focus states are critical; when active, the input border changes to Moody Blue and gains a 4px glow (`accent_glow`).
- **Chips:** Used for filtering and status. They should be semi-transparent versions of the primary color to avoid competing with the main CTA.
- **Data Tables:** Use a subtle alternating row tint. Headers should use the `label-md` typography style for clear categorization.
- **Lists:** Items should have a clear hover state that uses the `surface` color to provide tactile feedback without shifting layout.