# SearchAnalytics — Tech Stack

> Lean and deliberate. No unnecessary dependencies.

---

## Core Framework

| Layer | Technology | Version | Notes |
|-------|-----------|---------|-------|
| **Framework** | Nuxt 4 | ^4.3.1 | SSR-capable, but likely SPA/CSR for this use case |
| **UI Library** | @nuxt/ui | ^4.4.0 | Dashboard components, tables, forms |
| **CSS** | Tailwind CSS 4 | ^4.1.18 | Via Nuxt UI integration |
| **Language** | TypeScript | ^5.9.3 | Strict mode |
| **Linting** | ESLint 10 | ^10.0.0 | Via @nuxt/eslint |

## Data Layer

| Layer | Technology | Notes |
|-------|-----------|-------|
| **Database** | Cloud Firestore | DittoDatto's Firebase project — read-only access |
| **Auth** | Firebase Auth | Same Firebase project — `super_admin` role check |
| **SDK** | Firebase JS SDK (v10+) | Client-side, modular imports |

## Data Visualization

| Layer | Technology | Notes |
|-------|-----------|-------|
| **Charts** | TBD | Evaluate: Chart.js, Apache ECharts, or lightweight alternative. Decision deferred to first track implementation. |

## Icons

| Package | Purpose |
|---------|---------|
| `@iconify-json/lucide` | Primary icon set |
| `@iconify-json/simple-icons` | Brand/service icons |

## Deployment

| Layer | Technology | Notes |
|-------|-----------|-------|
| **Hosting** | TBD | Firebase Hosting or Vercel — decision after MVP |
| **Region** | `europe-west1` | Norway-local |

## Dependencies NOT Used

- No monorepo tooling (standalone project)
- No `shared-types` package import (schema knowledge is copied/inferred from Firestore documents)
- No Cloud Functions (read-only consumer)
- No Hono, no server routes beyond Nuxt's built-in

## Change Log

| Date | Change | Reason |
|------|--------|--------|
| 2026-02-19 | Initial stack definition | Conductor setup |
