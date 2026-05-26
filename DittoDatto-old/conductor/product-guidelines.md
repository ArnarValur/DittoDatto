# Product Guidelines: DittoDatto.no

## Brand Identity & Voice

**Name Origin:** "DittoDatto" plays on the Norwegian phrase _"ditt og datt"_ ("this and that"). It represents a comprehensive marketplace where you can find everything you need.
**Slogan:** _"Alt mellom ditten og datten finner du på DittoDatto. Prøv gratis, spør hva du trenger."_ ("Everything between this and that you'll find on DittoDatto. Try for free, ask for what you need.")

### Personality

The brand strikes a balance between ambitious innovation and relatable Norwegian charm.

- **Witty & Clever:** We anticipate the quirks of human-AI interaction with a wink. We aren't afraid to be slightly silly to make the tech feel human.
- **Confident:** We aim to be the "Vipps of Service Booking"—a ubiquitous, trusted utility for the entire nation.
- **Pragmatic:** Underneath the wit is a rock-solid, reliable system.

### Agent Personas

- **Ditto (User Agent):** Friendly, Conversational, and Witty. Bridges the gap for non-technical users with warmth and a bit of humor.
- **Datto (Business Agent):** Efficient, Precise, and Confident. The "Digital Manager" that gets things done without fluff.

## Strategic Principles: "Open Search"

- **Public Access:** Ditto (User Agent) and Search are completely **FREE** for the public. Unregistered users can query availability (with rate limits).
- **Data-Driven Sales:** We leverage "Shadow Demand" data (searches with no results) to identify high-demand services/areas and recruit relevant businesses.
- **Privacy First:** We capture search trends (Keywords + Location) to drive business insights, but strictly anonymize unauthenticated queries to respect GDPR.

## Visual Design Guidelines

### Foundation

- **Mobile (Primary):** Flutter + Material 3 (consumer marketplace & future portal)
- **Web Shell (Legacy):** Nuxt UI (Tailwind CSS based) — frozen Chapter 1 web apps
- **Agent UI:** TBD — Ditto/Datto interface in Flutter (v1.5 roadmap)
- **Style:** "SaaS Professional" meets "Futuristic Tech."
  - **Flutter App:** Material 3 adaptive design, premium native feel for app stores.
  - **Web Shell:** SEO landing pages + legacy portal access.
- **Theming:**
  - **Primary Color:** **Moody Blue** `#6F71CC` (confirmed v1 palette).
    | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 950 |
    |---|---|---|---|---|---|---|---|---|---|---|
    | `#F1F5FC` | `#E6EBF9` | `#D1DBF4` | `#B5C2EC` | `#97A4E2` | `#7D86D7` | `#6F71CC` | `#5353AF` | `#45468E` | `#3D3F72` | `#242442` |
  - **Modes:** Fully supports Dark Mode (for the "high-tech" feel) and Light Mode (for accessibility/daytime use).

### Interface Principles

1.  **Consistency:** Leverage the shared `packages/ui` library to ensure buttons, inputs, and cards look identical across Admin, Portal, and Marketplace.
2.  **Accessibility:** High contrast text, clear touch targets (for Mobile), and screen-reader friendly structure (supporting our "Marginal Groups" mission).
3.  **Agentic Presence:** Subtle animations or visual cues (e.g., a glowing ring or chat bubble) should indicate when Ditto or Datto is "thinking" or active.

## Code & Structure Conventions

- **Monorepo Hierarchy:** `apps/*` for client apps, `services/*` for backend services, `packages/*` for shared code.
- **Source of Truth:** Pydantic models in `services/mercury-engine/src/mercury_core/models/` are the domain schema authority.
- **Legacy Reference:** TypeScript/Zod schemas in `packages/shared-types/` are frozen Chapter 1 artifacts.
- **Component Reuse (Flutter):** Shared widgets in a common library package when multi-app.

---

*Updated for Chapter 2 — 2026-05-05*
