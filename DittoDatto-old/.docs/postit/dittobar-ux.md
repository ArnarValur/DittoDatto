---
title: "PostIT: DittoBar UX — A2UI Visor"
type: "postit"
status: "concept"
date: "2026-05-02"
session: 4
domain: "Discovery"
tags:
  - "dittobar"
  - "ux"
  - "a2ui"
  - "visor"
---

# PostIt: DittoBar UX — A2UI Visor

## Concept

The DittoBar is not a search bar. It's an **A2UI (Agent-to-User Interface) component** — Ditto's eyes into the graph.

### v1.0 — Clean Search UX
- Text input with debounce (300ms)
- Client-side autocomplete from cached categories/service types
- Cleaned query → TheOracle API → SurrealDB graph traversal
- Results rendered as map pins + list

### v1.5 — Agentic Visor
- Every keystroke feeds Ditto's intent model
- Ditto constructs semantic graph traversals
- "something relaxing near bragernes" → spa, massage, sauna categories → geo filter
- Each result node carries Datto's endpoint
- Ditto can "call" Datto to check availability, ask questions

## Graph ↔ Map Mental Model

Captain Arnar's insight: the knowledge graph (Obsidian-style) and the Google Map are the **same data** projected differently:
- **Graph view:** Clusters by category, edges by relationships
- **Map view:** Clusters by geography, pins by coordinates
- **DittoBar:** Traverses both dimensions simultaneously

## Arnar Has Ideas

> "We can put a PostIt regarding the UX experience on the screen itself... I have some ideas about that also"

Dedicated grill session needed for the screen-level interaction design.

## Key Design Principle

Ditto is the NLU layer. The DittoBar doesn't need Meilisearch-style typo tolerance — Ditto interprets user intent and constructs clean queries. The agent IS the search intelligence.
