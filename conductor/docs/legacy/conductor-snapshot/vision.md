# 🔭 Vision: DittoDatto — The Agentic Commerce Platform

**Last Updated:** 2026-05-05

---

## The Thesis

Commerce has evolved in waves:

| Era       | Window           | How People Find Services               |
| --------- | ---------------- | -------------------------------------- |
| 2000s     | **Websites**     | Phonebooks → browsers, contact forms   |
| 2010s     | **Social Media** | Influencers, feeds, discovery          |
| 2020s–30s | **Agents**       | Personal AI agents delegate & transact |

**DittoDatto's bet:** In 5 years, everyone has a personal AI agent. The interface between consumers and businesses shifts from _browsing_ to _delegating_. DittoDatto builds the infrastructure for this transition — starting in Norway.

---

## The Two-Layer Architecture

### Layer 1: The Platform (Building — v1.0 target)

A fully functional service marketplace that works **without** AI agents:

- **Public Marketplace** — browse, discover, book services
- **Business Portal** — manage stores, services, staff, bookings, reservations
- **MercuryEngine** — the booking/reservation/ticketing engine (source of truth)
- **Admin Panel** — platform operations and analytics

> This layer must be valuable on its own. Not everyone will want or pay for AI.

### Layer 2: The Agents (Future — tiered upgrade)

- **Ditto** — the customer's public-facing agent. Finds services, handles bookings, watches marketplaces.
- **Datto** — the business's receptionist agent. Handles inquiries, manages availability, communicates with Ditto.
- **Protocol:** UCP (Universal Commerce Protocol) for agent-to-agent interoperability.
- **A2NUI** — Adapted A2UI framework for Nuxt-based agentic interfaces (proof of concept at a2nui.merkurial-studio.com).

> The "Datto tier" — businesses upgrade when they want AI-powered reception, auto-replies, smart waitlists, demand prediction.

---

## The 5-Year Horizon

| Year           | Milestone                                                                                                         |
| -------------- | ----------------------------------------------------------------------------------------------------------------- |
| **2026 Q1–Q2** | ✅ MercuryEngine (Python/FastAPI/SurrealDB), Flutter scaffolding, auth architecture locked.                    |
| **2026 Q2–Q3** | Flutter native app v1.0 (tracer bullet). Saturn infrastructure. First business onboarding in Drammen.            |
| **2026 Q3–Q4** | Ditto/Datto MVP — basic agentic booking. Waitlist + rebook engine. Vipps payment.                                |
| **2027**       | Scale beyond Drammen — open one fylke at a time. Ticketing system. Restaurant vertical.                          |
| **2028**       | Ditto becomes a household name in Drammen/Buskerud. Marketplace features (second-hand, local commerce via Ditto). |
| **2029-30**    | National coverage. "Finn.no but agentic" — the Death of the Scroll. Agent-to-agent commerce via UCP.              |

---

## Competitive Positioning

| Competitor            | What They Do                                                         | DittoDatto's Edge                                           |
| --------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------- |
| **Noona** (noona.is)  | Scheduling/booking for salons                                        | No agentic layer, no marketplace, no Norwegian roots        |
| **Finn.no**           | Classifieds + discovery                                              | Scroll-based, no intelligent matching, no real-time booking |
| **Timely / Calendly** | Appointment scheduling                                               | No marketplace, no business portal, no multi-service        |
| **DittoDatto**        | **Full stack:** marketplace + portal + engine + agents + local focus |                                                             |

---

## Native App Strategy

| App                               | Framework                           | Target                              |
| --------------------------------- | ----------------------------------- | ----------------------------------- |
| **Public Marketplace** (consumer) | Flutter + Riverpod + GoRouter       | iOS + Android                       |
| **Business Portal** (merchant)    | Nuxt web (Chapter 1 frozen)         | Web only (later: Flutter if demand) |
| **Admin Panel** (internal)        | Nuxt web (Chapter 1 frozen)         | Web only                            |

**Rationale:** Flutter is Google-ecosystem native (Gemini, Material 3). The consumer app needs premium native feel for app stores. API communication via REST to MercuryEngine — no direct database access. The portal works best on tablet/desktop where planners and timetables have real estate.

---

## The Bigger Picture

> _"Websites were the windows of the 2000s. Social media was the window of the 2010s. Your Personal Agent is the only window you'll need in the 2030s. DittoDatto is building the frame."_

DittoDatto isn't just a booking app — it's the **Agentic Commerce infrastructure** for Norway. It bridges diverse groups (tourists, foreigners, people with accessibility needs) through agent-mediated interactions. It brings local businesses into the agentic future with minimal effort.

The platform proves value without AI. The agents amplify it.

---

_Vision authored by Captain Arnar Valur — March 2026_
