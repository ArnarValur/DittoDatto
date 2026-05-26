# Specification: i18n Integration for Admin Panel

## 1. Goal
Enable multi-language support in the `admin-panel` application, supporting English (Default), Norwegian Bokmål, and Norwegian Nynorsk. Establish a shared `LanguageSelector` component in `packages/ui` for consistency across all applications.

## 2. Core Features

### 2.1 Localization Module
*   **Module:** `@nuxtjs/i18n` (v9/Nuxt 4 compatible).
*   **Strategy:** `prefix_except_default`.
    *   `en` -> `/`
    *   `nb` -> `/nb`
    *   `nn` -> `/nn`
*   **Lazy Loading:** Translation files stored in `locales/` directory.

### 2.2 Translation Files
*   `en.json` (English)
*   `nb.json` (Norsk Bokmål)
*   `nn.json` (Norsk Nynorsk)
*   **Initial Content:** Basic keys for testing (e.g., "welcome", "settings", "logout").

### 2.3 Shared UI Component
*   **Name:** `LanguageSelector.vue`
*   **Location:** `packages/ui/components/LanguageSelector.vue`
*   **Functionality:**
    *   Dropdown/Menu to select language.
    *   Persists selection via URL/Cookie (handled by module).
    *   Uses Nuxt UI components.

## 3. Technical Implementation

### 3.1 Configuration
Update `apps/web/admin-panel/nuxt.config.ts` to include and configure the `@nuxtjs/i18n` module.

### 3.2 File Structure
```
apps/web/admin-panel/
├── nuxt.config.ts           # Config update
├── locales/
│   ├── en.json
│   ├── nb.json
│   └── nn.json
└── app/
    └── layouts/
        └── admin-dashboard.vue  # Integration point for Selector
packages/ui/
└── components/
    └── LanguageSelector.vue     # New shared component
```

## 4. Acceptance Criteria
1.  **Build:** Application builds successfully with the new module.
2.  **Routing:**
    *   `/` loads English content.
    *   `/nb` loads Bokmål content.
    *   `/nn` loads Nynorsk content.
3.  **Persistence:** Switching language redirects to correct route and persists on reload.
4.  **UI:** `LanguageSelector` is visible in the Admin Panel layout and functional.
