# SearchAnalytics — Product Guidelines

> Internal analytics tool. Function over flash — but still Mercury quality.

---

## Design Philosophy

SearchAnalytics is a **data-first dashboard**, not a consumer-facing product. The design should prioritize:

1. **Scannability** — KPIs and tables at a glance, zero cognitive overhead
2. **Data density** — Maximize information per viewport, minimize decorative whitespace
3. **Dark mode default** — Easier on the eyes for data-heavy screens
4. **Nuxt UI native** — Use `@nuxt/ui` components exclusively. No custom design system needed.

## Visual Identity

- **Colors:** Inherit from Nuxt UI's color system. Primary: `green` (Mercury standard). Neutral: `slate`.
- **Typography:** System font stack (Nuxt UI defaults)
- **Icons:** Lucide icon set (consistent with DittoDatto ecosystem)
- **No branding required** — This is an internal tool

## Component Patterns

- Use `UTable` for data tables (top queries, zero-result queries)
- Use `UCard` for KPI summary cards
- Use `UDashboard*` components for layout (sidebar, panels)
- Charts: lightweight library (e.g., Chart.js or similar) — no heavy BI frameworks

## Tone & Language

- English UI (internal tool, Captain is bilingual)
- Labels should be concise and data-oriented: "Queries", "CTR", "Zero Results", "Sessions"
- No marketing language — this IS the marketing intelligence source

## Accessibility

- Standard Nuxt UI accessibility (ARIA, keyboard nav come built-in)
- High contrast data visualizations (colorblind-friendly palette for charts)
