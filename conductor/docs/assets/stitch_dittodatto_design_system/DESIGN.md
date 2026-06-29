---
name: DittoDatto
colors:
  surface: '#f9f9fc'
  surface-dim: '#dadadc'
  surface-bright: '#f9f9fc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f6'
  surface-container: '#eeeef0'
  surface-container-high: '#e8e8ea'
  surface-container-highest: '#e2e2e5'
  on-surface: '#1a1c1e'
  on-surface-variant: '#454652'
  inverse-surface: '#2f3133'
  inverse-on-surface: '#f0f0f3'
  outline: '#757684'
  outline-variant: '#c5c5d4'
  surface-tint: '#4355b9'
  primary: '#24389c'
  on-primary: '#ffffff'
  primary-container: '#3f51b5'
  on-primary-container: '#cacfff'
  inverse-primary: '#bac3ff'
  secondary: '#4d5a9c'
  on-secondary: '#ffffff'
  secondary-container: '#abb7ff'
  on-secondary-container: '#394687'
  tertiary: '#88003b'
  on-tertiary: '#ffffff'
  tertiary-container: '#b40050'
  on-tertiary-container: '#ffc3ce'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dee0ff'
  primary-fixed-dim: '#bac3ff'
  on-primary-fixed: '#00105c'
  on-primary-fixed-variant: '#293ca0'
  secondary-fixed: '#dee1ff'
  secondary-fixed-dim: '#b9c3ff'
  on-secondary-fixed: '#021355'
  on-secondary-fixed-variant: '#354282'
  tertiary-fixed: '#ffd9df'
  tertiary-fixed-dim: '#ffb1c1'
  on-tertiary-fixed: '#3f0018'
  on-tertiary-fixed-variant: '#8f003f'
  background: '#f9f9fc'
  on-background: '#1a1c1e'
  surface-variant: '#e2e2e5'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 64px
---

## Brand & Style
The design system is built on a foundation of "Moody Blue" tones, designed to feel reliable yet expressive. It targets a mobile-first audience that appreciates the fluidity and structural integrity of the Flutter framework. 

The aesthetic is **Corporate Modern with a Soft Edge**. It balances the systematic precision of Material Design with custom curves and deep tonal layering. The emotional response should be one of "composed energy"—professional enough for enterprise use, but tactile enough for consumer engagement. We utilize subtle gradients and elevations to guide the user's eye through complex information hierarchies without overwhelming them.

## Colors
The palette is rooted in the "Moody Blue" spectrum, utilizing a deep primary blue for structural elements and a softer secondary blue for accents and secondary actions. 

- **Primary (#3F51B5):** Used for key brand moments, primary buttons, and active states.
- **Secondary (#7986CB):** Used for background tints, chips, and tonal buttons.
- **Tertiary (#FF4081):** A high-contrast pink used sparingly for "Call to Action" (CTA) moments and notifications.
- **Neutral:** A range of cool grays that transition into deep navies for the dark mode.

The design system supports a full **Dark Mode** implementation. In dark mode, surfaces are shifted to deep navies rather than pure black to maintain the "Moody Blue" brand identity, ensuring that shadows and elevations remain visible and soft.

## Typography
The typography system uses **Plus Jakarta Sans** for headlines to provide a friendly, modern character with its slightly rounded geometric forms. **Inter** is used for body and labels to ensure maximum legibility and a systematic, clean feel.

- **Headlines:** Use tight letter spacing for large displays to maintain a cohesive visual block.
- **Body:** Use Inter with standard leading to ensure comfortable reading in data-heavy screens like Profile or Establishment lists.
- **Labels:** Use Inter Medium for UI controls (buttons, input labels) and Bold for small metadata to ensure they remain distinct at small sizes.

## Layout & Spacing
This design system follows a **Fluid Grid** model based on an 8px rhythm (with 4px sub-units for fine-tuning). 

- **Mobile:** Uses a 4-column grid with 20px side margins and 16px gutters.
- **Desktop:** Scales to a 12-column grid with a maximum content width of 1200px, centered on the screen.
- **Reflow:** Components like cards in the "Establishment" view should stack vertically on mobile and transition to a multi-column masonry or grid layout on larger screens.

Consistency in vertical rhythm is achieved by strictly adhering to the `md (16px)` and `lg (24px)` spacing units for section headers and component grouping.

## Elevation & Depth
Depth in this design system is communicated through **Tonal Layers** supplemented by **Ambient Shadows**.

1.  **Level 0 (Base):** The main background color.
2.  **Level 1 (Cards/Inputs):** A slight elevation using a soft, diffused shadow (Blur: 10px, Y: 4px, Opacity: 6% Primary Color).
3.  **Level 2 (Dropdowns/Modals):** A more pronounced shadow to indicate overlay (Blur: 20px, Y: 8px, Opacity: 12% Primary Color).

In Dark Mode, elevation is primarily shown through "surface tinting"—higher elevation elements use a lighter shade of the navy neutral color rather than relying solely on shadows, which are less visible on dark backgrounds.

## Shapes
The shape language is **Rounded (Level 2)**. This choice mirrors the friendly nature of the typography while maintaining enough structure for a professional application.

- **Standard Elements:** 0.5rem (8px) radius for buttons and small input fields.
- **Large Elements:** 1rem (16px) radius for cards and modal sheets.
- **Full Radius:** Used exclusively for tags, avatars, and search bars to create a "pill" effect that stands out from the rectangular grid.

## Components

### Buttons
- **Primary:** Solid Primary Blue fill with White text. 8px border radius. Use Haptic feedback on press.
- **Secondary:** Tonal fill (Secondary Blue at 15% opacity) with Primary Blue text.
- **Outlined:** 1.5px border in Secondary Blue. No fill.

### Input Fields
- **Style:** Filled & Underlined or Outlined depending on context. The "Moody" style prefers a light gray fill with a 1px bottom border that transitions to a 2px Primary Blue border on focus.
- **Icons:** Use 24px rounded icons centered vertically.

### Cards
- **Structure:** 16px padding, 16px border radius. Use Level 1 elevation.
- **Content:** Headline-md for titles, body-md for descriptions.

### Chips/Tags
- **Style:** Pill-shaped (Full radius). Use tonal backgrounds based on category (e.g., Green for "Open," Red for "Closed").

### Navigation
- **Bottom Bar:** Use a blurred background effect (Backdrop Filter) with active icons tinted in Primary Blue. Labels should use `label-sm`.