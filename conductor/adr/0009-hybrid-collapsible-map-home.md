# Hybrid Collapsible Map Home Screen

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0002 Session 1; no edits — decision is stack-independent)
> **Status:** accepted

## Context

The Public Marketplace Home screen needs to balance two requirements that pull in opposite directions: (1) a populated, content-rich first impression at launch in Drammen with 20-50 Establishments; (2) a spatial discovery surface that an agent (future Ditto v1.5) can use as a canvas.

## Decision

The Public Marketplace Home screen uses a **hybrid collapsible map layout**: a compact map header (~30% screen) showing the user's location and nearby Establishment pins, with DittoBar prominent and curated listing rows below. The map expands to full-screen on pull-up.

## Why Hybrid

- **Not map-first:** A full-screen map looks empty at Drammen launch density. Content-first ensures the screen always feels populated regardless of inventory.
- **Not content-only:** The map is not just a utility — it is the canvas for the future agent (Ditto v1.5 personalizes the map with curated flags, highlighted Establishments, contextual markers). Building the map as a first-class collapsible element now means no Home rebuild when the agentic path lands.
- **Hybrid adapts:** Collapsed = content browsing for lean inventory; expanded = spatial discovery + future agent canvas. Both modes from day one.

## Consequences

- More complex to build than a flat list or a full-screen map — requires a draggable/collapsible sheet pattern (well-supported in Flutter).
- Map widget loads even in collapsed state — minor resource cost, but necessary for instant expansion.
- The map component is designed as an "agent canvas" from the start — accepting dynamic markers, overlays, and state from external sources (Ditto in v1.5).

---

*Origin: Session 1 Grill. Promoted into canonical conductor/adr/ during /grill foundation 2026-05-26 — decision is stack-independent and no edits were needed.*
