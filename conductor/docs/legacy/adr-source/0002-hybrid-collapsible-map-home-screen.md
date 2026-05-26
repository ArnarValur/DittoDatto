---
title: "ADR-0002: Hybrid Collapsible Map Home Screen"
type: "adr"
status: "accepted"
date: "2026-05-02"
session: 1
domain: "Public Marketplace"
tags:
  - "map"
  - "ui"
  - "home-screen"
  - "flutter"
---

# Hybrid collapsible map as Home screen default

The Public Marketplace Home screen uses a hybrid collapsible map layout: a compact map header (~30% screen) showing the user's location and nearby Establishment pins, with DittoBar prominent and curated listing rows below. The map expands to full-screen on pull-up.

**Why not map-first?** At launch in Drammen with 20-50 Establishments, a full-screen map looks empty. Content-first ensures the screen always feels populated regardless of inventory density.

**Why not content-only?** The map is not just a utility — it's a canvas for the agent. In v1.5, Ditto will personalize the map with curated flags, highlighted Establishments, and contextual markers based on user intent. Building the map as a first-class collapsible element now means no Home screen rebuild when the agentic path lands.

**Why hybrid?** It adapts to context. Collapsed = content-driven browsing for lean inventory phases. Expanded = spatial discovery and future agent canvas. Both modes from day one.

## Consequences

- Home screen is more complex to build than a flat list or a full-screen map — requires a draggable/collapsible sheet pattern (common in Flutter, well-supported).
- Map widget loads even in collapsed state — minor resource cost, but necessary for instant expansion.
- The map component must be designed as an "agent canvas" from the start — accepting dynamic markers, overlays, and state from external sources (Ditto in v1.5).
