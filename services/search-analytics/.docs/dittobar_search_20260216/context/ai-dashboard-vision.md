# AI Dashboard Vision

> The landing dashboard as the primary engagement surface between User and Agent.

## The Concept

The **AI Dashboard** is a Business Portal landing page where Ditto (the AI agent) is not just a chatbot in a sidebar — it **owns the main panel**. The dashboard is the canvas on which the agent renders, updates, and visually pings the user with what's happening in their business in real-time.

Think of it as: **the agent IS the dashboard.**

```
┌─────────────────────────────────────────────────────────────┐
│  Business Portal                                    [User]  │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│  Sidebar │     ┌──────────────────────────────────┐         │
│          │     │     AI DASHBOARD (main panel)     │         │
│  • Home  │     │                                    │         │
│  • Book  │     │  ┌─────────┐ ┌─────────┐ ┌──────┐│         │
│  • Staff │     │  │ KPI Card│ │ KPI Card│ │ KPI  ││         │
│  • Serv  │     │  │ 23 today│ │ €1,240  │ │ 7 new││         │
│  • Media │     │  └─────────┘ └─────────┘ └──────┘│         │
│          │     │                                    │         │
│          │     │  ┌──────────────────────────────┐ │         │
│          │     │  │   🔔 Visual Ping: New booking │ │         │
│          │     │  │   Maria → Haircut → 14:30     │ │         │
│          │     │  └──────────────────────────────┘ │         │
│          │     │                                    │         │
│          │     │  ┌──────────────────────────────┐ │         │
│          │     │  │   Agent Message Area          │ │         │
│          │     │  │   "You have 3 bookings left   │ │         │
│          │     │  │    today. Maria's 14:30 is    │ │         │
│          │     │  │    confirmed."                 │ │         │
│          │     │  └──────────────────────────────┘ │         │
│          │     │                                    │         │
│          │     │  ┌──────────────────────────────┐ │         │
│          │     │  │  [ Ask Ditto anything... ]    │ │         │
│          │     │  └──────────────────────────────┘ │         │
│          │     └──────────────────────────────────┘         │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

## Core Principles

### 1. The Agent Owns the Canvas

The dashboard layout is **not hardcoded**. It's generated and managed by the agent via A2UI surfaces. This means:

- The dashboard can adapt to what's relevant _right now_
- The agent decides what to show, when, and where
- New features don't require frontend code — the agent just creates new surfaces

### 2. Visual Pings

The agent can **push visual notifications** directly into the dashboard canvas — not browser notifications, but rendered UI elements that appear, pulse, and draw attention:

- **New booking**: A card slides in with the booking details, pulses green
- **Cancellation**: A warning card appears with options to contact the customer
- **Revenue milestone**: A celebration card with confetti icon
- **Staff alert**: A card about a staff member running late

Implementation idea: Use `createSurface` with a special region/zone identifier (e.g., `surfaceId: "ping-{timestamp}"`), render as toast-like cards with auto-dismiss.

### 3. Contextual Intelligence

The dashboard surfaces change based on:

- **Time of day**: Morning → upcoming bookings overview. Evening → daily summary.
- **Business state**: Busy day → show capacity warnings. Slow day → suggest promotions.
- **User behavior**: First login in 3 days → show catch-up summary. Frequent user → skip the basics.

### 4. Bidirectional Engagement

The user can:

- Chat with Ditto via the prompt area at the bottom
- Click buttons in the rendered surfaces (e.g., "Confirm", "Reschedule")
- Interact with form inputs (e.g., override a price, add a note)

All interactions flow back to the agent as A2UI client-to-server events.

## Technical Architecture

```
┌─────────────────────────────────────────────────┐
│                Business Portal                   │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │         AI Dashboard Component              │ │
│  │                                              │ │
│  │  ┌──────────────────────────────────────┐   │ │
│  │  │  useA2uiSurface (multi-surface)       │   │ │
│  │  │  • surfaces: Map<string, Surface>     │   │ │
│  │  │  • zones: kpis, pings, main, chat     │   │ │
│  │  └──────────┬───────────────────────────┘   │ │
│  │             │                                │ │
│  │  ┌──────────▼───────────────────────────┐   │ │
│  │  │  WebSocket Connection                 │   │ │
│  │  │  • Agent pushes surfaces in realtime  │   │ │
│  │  │  • User events sent back to agent     │   │ │
│  │  └──────────┬───────────────────────────┘   │ │
│  │             │                                │ │
│  └─────────────┼────────────────────────────────┘ │
│                │                                  │
└────────────────┼──────────────────────────────────┘
                 │
    ┌────────────▼────────────────────┐
    │       Ditto Agent (A2A)         │
    │                                  │
    │  • Connects to Firestore         │
    │  • Watches bookings collection   │
    │  • Monitors business metrics     │
    │  • Generates A2UI surfaces       │
    │  • Handles user interactions     │
    └─────────────────────────────────┘
```

## Surface Zones

The dashboard divides its layout into **zones** — named regions that surfaces can target:

| Zone      | Location   | Purpose                                     |
| --------- | ---------- | ------------------------------------------- |
| `kpi`     | Top row    | Metric cards (bookings, revenue, customers) |
| `ping`    | Below KPIs | Notification cards that appear/disappear    |
| `main`    | Center     | Primary content (tables, charts, summaries) |
| `chat`    | Bottom     | Agent message + user prompt                 |
| `sidebar` | Left panel | Quick actions, navigation shortcuts         |

A surface targets a zone via a convention in its `surfaceId`:

```jsonl
{"version":"v0.10","createSurface":{"surfaceId":"kpi-bookings","catalogId":"standard"}}
{"version":"v0.10","createSurface":{"surfaceId":"ping-1707831234","catalogId":"standard"}}
{"version":"v0.10","createSurface":{"surfaceId":"main-schedule","catalogId":"standard"}}
```

The dashboard component parses the prefix and routes the surface to the correct zone.

## Visual Ping Implementation

```ts
// Pseudo-code for visual ping handling in the dashboard
function handleNewSurface(surfaceId: string, surface: Surface) {
  if (surfaceId.startsWith("ping-")) {
    // Add to ping zone with animation
    pingQueue.value.push({
      surfaceId,
      surface,
      createdAt: Date.now(),
      autoDissmissMs: surface.dataModel?.ttl ?? 10000,
    });

    // Play subtle notification sound
    playPingSound();

    // Auto-dismiss after TTL
    setTimeout(() => {
      removePing(surfaceId);
    }, surface.dataModel?.ttl ?? 10000);
  }
}
```

Visual ping CSS could use `@keyframes` for a pulse/glow effect:

```css
.ping-card {
  animation: ping-pulse 2s ease-in-out;
}

@keyframes ping-pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(var(--color-primary), 0.4);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(var(--color-primary), 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(var(--color-primary), 0);
  }
}
```

## Relationship to Ditto & Datto

| Agent     | Role in Dashboard                                                                                    |
| --------- | ---------------------------------------------------------------------------------------------------- |
| **Ditto** | The "face" — handles user conversation, generates UI surfaces for displaying info, answers questions |
| **Datto** | The "brain" — watches Firestore, computes metrics, triggers visual pings when events occur           |

Both agents communicate with the dashboard via the same A2UI protocol. The dashboard doesn't need to know which agent generated a surface — it just renders what it receives.

## MVP Scope

For the first version of the AI Dashboard, focus on:

1. **Static KPI row** — Agent generates 3-4 metric cards on page load
2. **Chat area** — Reuse the playground's chat component
3. **Visual ping** — One notification type: new booking notification
4. **WebSocket transport** — Replace SSE with WebSocket for push capability

This gives you the core experience: a dashboard that the agent controls, with real-time updates.

## Future Extensions

- **Chart surfaces**: Revenue over time, booking trends (requires Chart component)
- **Table surfaces**: Today's schedule, staff overview (requires DataTable component)
- **Multi-agent routing**: Dashboard shows which agent generated each surface
- **User preferences**: "Show me revenue first" → agent remembers layout preferences
- **Mobile-first**: Dashboard adapts layout for mobile (single column, swipeable pings)
