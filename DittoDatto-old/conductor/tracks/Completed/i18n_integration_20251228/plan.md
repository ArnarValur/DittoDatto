# Plan: i18n Integration for Admin Panel

## Phase 1: Configuration & Setup [checkpoint: 4504273]
*Goal: Install the module and configure the basics.*

- [x] Task: Install `@nuxtjs/i18n` dependency in `apps/web/admin-panel`.
- [x] Task: Create initial locale files (`en.json`, `nb.json`, `nn.json`) in `apps/web/admin-panel/locales/` with dummy data.
- [x] Task: Configure `apps/web/admin-panel/nuxt.config.ts` with the `prefix_except_default` strategy and locale definitions.
- [x] Task: Conductor - User Manual Verification 'Configuration & Setup' (Protocol in workflow.md)

## Phase 2: Shared Component Implementation [checkpoint: 5e57c2b]
*Goal: Create the reusable UI for language switching.*

- [x] Task: Create `packages/ui/components/LanguageSelector.vue` using Nuxt UI components (Dropdown/Select).
- [x] Task: Implement logic in `LanguageSelector.vue` using `useI18n()` to switch locales.
- [x] Task: Integrate `LanguageSelector` into `apps/web/admin-panel/app/layouts/admin-dashboard.vue`.
- [x] Task: Conductor - User Manual Verification 'Shared Component Implementation' (Protocol in workflow.md)

## Phase 3: Verification & Cleanup [checkpoint: e3805a9]
*Goal: Ensure everything works as expected.*

- [x] Task: Verify routing behavior (English default, `/nb`, `/nn` prefixes).
- [x] Task: Verify persistence (refreshing page keeps language).
- [x] Task: Conductor - User Manual Verification 'Verification & Cleanup' (Protocol in workflow.md)
