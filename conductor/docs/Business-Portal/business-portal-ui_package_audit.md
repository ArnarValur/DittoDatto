# Technical Audit: `@dittodatto/ui` Layer Integration & Usage

This report examines the integration relationship and architectural boundaries between the shared UI package (`@dittodatto/ui` located at `packages/ui/`) and the Business Portal application (`business-portal` located at `apps/web/business-portal/`).

---

## 1. Overview of Shared Architecture

The `@dittodatto/ui` package is structured as a **Nuxt Layer**. 
* **Layer Extension**: The Business Portal inherits the shared package's components and settings in `nuxt.config.ts` via:
  ```typescript
  extends: ['@dittodatto/ui']
  ```
* **Auto-registration Prefix**: Components in the shared layer's `components/` directory are auto-registered with a `DD` prefix as defined in `packages/ui/nuxt.config.ts`:
  ```typescript
  export default defineNuxtConfig({
    components: [
      { 
        path: './components',
        prefix: 'DD'
      }
    ]
  })
  ```
* **Exports**: Subdirectories (`components`, `composables`, `data`, `types`, `utils`) are exposed through `exports` in the layer's `package.json`.

---

## 2. Component Usage Trace

Nuxt resolves nested folders inside layers by concatenating directory prefixes. The Business Portal consumes the following shared UI components:

### A. Media Components (`components/media/`)
* **`<DDMediaPickerButton>`** (resolves `components/media/PickerButton.vue`): Used to select images from the shared media library modal.
  * Used in [EventFormSlideover.vue:L411](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/components/events/EventFormSlideover.vue#L411)
  * Used in [ServiceFormSlideover.vue:L414](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/components/services/ServiceFormSlideover.vue#L414) and [ServiceFormSlideover.vue:L443](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/components/services/ServiceFormSlideover.vue#L443)
  * Used in [StaffFormSlideover.vue:L375](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/components/staff/StaffFormSlideover.vue#L375)
  * Used in [establishments/[slug]/index.vue:L552, 730, 759, 774](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/index.vue#L552)

### B. Establishment Components (`components/establishment/`)
* **`<DDEstablishmentImageGallery>`** (resolves `components/establishment/EstablishmentImageGallery.vue`): Used in preview sections.
  * Used in [preview.vue:L167](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L167)
  * Used in [establishment-preview.vue:L30](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/establishment-preview.vue#L30)
  * Used in [[id].vue:L78](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/%5Bid%5D.vue#L78)
* **`<DDEstablishmentInfoBar>`** (resolves `components/establishment/EstablishmentInfoBar.vue`):
  * Used in [preview.vue:L173](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L173)
  * Used in [establishment-preview.vue:L35](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/establishment-preview.vue#L35)
  * Used in [[id].vue:L84](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/%5Bid%5D.vue#L84)
* **`<DDEstablishmentAboutSection>`** (resolves `components/establishment/AboutSection.vue`):
  * Used in [preview.vue:L268](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L268)
  * Used in [establishment-preview.vue:L90](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/establishment-preview.vue#L90)
  * Used in [[id].vue:L136](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/%5Bid%5D.vue#L136)
* **`<DDEstablishmentExperienceCard>`** (resolves `components/establishment/ExperienceCard.vue`):
  * Used in [establishment-preview.vue:L76](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/establishment-preview.vue#L76)

### C. Booking Components (`components/booking/`)
* **`<DDBookingModal>`** (resolves `components/booking/BookingModal.vue`):
  * Used in [establishment-preview.vue:L100](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/establishment-preview.vue#L100)
  * Used in [[id].vue:L147](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/preview/%5Bid%5D.vue#L147)
* **`<DDBookingSlideover>`** (resolves `components/booking/BookingSlideover.vue`):
  * Used in [preview.vue:L280](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L280)
* **`<DDBookingFlowsTicketBookingFlow>`** (resolves `components/booking/flows/TicketBookingFlow.vue`):
  * Used in [preview.vue:L297](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L297)

### D. Map Components (`components/map/`)
* **`<DDMapStoreMap>`** (resolves `components/map/StoreMap.vue`): Interactive Google Map for store locations.
  * Used in [establishments/[slug]/index.vue:L512](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/index.vue#L512)

### E. Other Shared Components
* **`<DDDattoBar>`** (resolves `components/DDDattoBar.vue`): Shared top navigation header.
  * Used in [visual-preview.vue:L12](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/layouts/visual-preview.vue#L12)
* **`<DDServiceGrid>`** (resolves `components/ServiceGrid.vue`):
  * Used in [preview.vue:L221](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L221)
* **`<DDEventGrid>`** (resolves `components/event/DDEventGrid.vue`):
  * Used in [preview.vue:L254](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/pages/establishments/%5Bslug%5D/preview.vue#L254)

---

## 3. Composables, Utilities & Assets Usage

* **`clearBypassCookie`** (`utils/bypass-cookie.ts`): Dynamically imported inside [UserMenu.vue:L122](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/apps/web/business-portal/app/components/UserMenu.vue#L122) during the user logout sequence to clear maintenance page bypass credentials on subdomains.
* **Unused Composables**: The Business Portal **does not import or execute** any other shared composables from the layer, including:
  * `useBookingState` (state wrapper is handled locally inside Business Portal preview pages instead)
  * `useMediaUpload` (used internally by `<DDMediaLibraryModal>` but not by the host app)
  * `useSolarTheme` (theme mechanics not used by the business portal)
  * `useFavorites`, `useIconFavorites`, `useAutoAnimate`

---

## 4. Technical Debt & Anti-Patterns Identified

### A. Fragile `@nuxt/ui` Dependency Chain
* **Issue**: The shared UI package `@dittodatto/ui` uses Nuxt UI components (such as `<UButton>`, `<UIcon>`, and `<UModal>`) throughout its code, and imports `@import "@nuxt/ui";` in its stylesheet. However, it does not specify `@nuxt/ui` inside its own `package.json` dependencies or peerDependencies.
* **Risk**: If a different portal or project extends `@dittodatto/ui` without manually installing `@nuxt/ui`, it will encounter module resolution failures at build-time.

### B. Obsolete Tailwind v3 Configuration
* **Issue**: `packages/ui/tailwind.config.ts` contains a legacy Tailwind CSS v3 JavaScript-based config. 
* **Context**: Both the Business Portal and the shared layer styles (`packages/ui/assets/css/tailwind.css`) utilize **Tailwind CSS v4.0** (characterized by CSS-first theme syntax, `@import "tailwindcss";`, and `@theme`). 
* **Impact**: The `tailwind.config.ts` file in the UI package is dead code and is ignored by Tailwind v4.

### C. Theme Colors Duplication (Maintenance Hazard)
* **Issue**: The main color variables (Moody Blue `#6F71CC`, Pickled Bluewood `#496080`, Jumbo neutral `#71717a`, etc.) are duplicated line-for-line between:
  1. `packages/ui/assets/css/tailwind.css` (Lines 18–96)
  2. `apps/web/business-portal/app/assets/css/main.css` (Lines 8–86)
* **Root Cause**: The shared layer `@dittodatto/ui/nuxt.config.ts` does **not** specify `css: ['./assets/css/tailwind.css']`. Therefore, the styling config is not inherited by the extending apps. The portal was forced to duplicate the variables to render the correct design tokens.
* **Risk**: Future branding modifications in the UI package will not propagate to the Business Portal.

### D. Obsolete Composable Code
* **Issue**: The composable [useAppToast.ts](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/packages/ui/composables/useAppToast.ts) is entirely commented out. 
* **Impact**: Dead file that should be removed. The portals use Nuxt UI's native `useToast()` directly.

### E. Deprecated Google Maps API Usage
* **Issue**: [StoreMap.vue:L103](file:///home/solmundur/Projects/DittoDatto/DittoDatto-old/packages/ui/components/map/StoreMap.vue#L103) uses `new google.maps.Marker()`.
* **Impact**: The standard `Marker` class is deprecated in the Google Maps JS API (since v3.56). Developers should transition to `google.maps.marker.AdvancedMarkerElement` to ensure long-term support and improved performance. (Note: AdvancedMarkerElement requires a Map ID configuration).

---

## 5. Architectural Recommendations

1. **Expose Shared CSS**: Update `packages/ui/nuxt.config.ts` to include the global stylesheet:
   ```typescript
   export default defineNuxtConfig({
     css: ['./assets/css/tailwind.css'],
     components: [
       { path: './components', prefix: 'DD' }
     ]
   })
   ```
   *Once done, remove the copy-pasted CSS variable definitions from the Business Portal's `app/assets/css/main.css` to prevent divergence.*
2. **Clean up Dead Configs & Files**:
   * Delete `packages/ui/tailwind.config.ts` (Tailwind v4 is fully CSS-driven).
   * Delete the commented out `packages/ui/composables/useAppToast.ts`.
3. **Declare Layer Peer Dependencies**: Add `@nuxt/ui` to the `peerDependencies` in `packages/ui/package.json` to prevent dependency resolution issues for new host apps.
4. **Upgrade Google Maps Marker**: Migrate `StoreMap.vue` from `google.maps.Marker` to `google.maps.marker.AdvancedMarkerElement`.
