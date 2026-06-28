# Events and Ticketing as Independent Feature Flags

> **Recorded:** 2026-06-28 17:30
> **Status:** accepted

The `enabled_features` object on Company has two independent boolean flags for the ticketing domain: `event_system` and `ticket_system`. They gate distinct capabilities with a directional dependency.

**`event_system`** gates the ability to create and display events (public or private) on an establishment. Events can be visibility-only — a grand opening announcement, a staff meeting — with no booking or ticketing attached.

**`ticket_system`** gates the ability to sell tickets (capacity-managed bookings via `bookingMode: ticketSystem`) for events. This flag **requires** `event_system` to also be enabled — you cannot sell tickets without events to attach them to.

| Flag combination | Capability |
|---|---|
| `event_system: false`, `ticket_system: false` | Standard booking only (appointments, table reservations) |
| `event_system: true`, `ticket_system: false` | Can create/display events (public + private), no ticket sales |
| `event_system: true`, `ticket_system: true` | Full events + ticket sales |
| `event_system: false`, `ticket_system: true` | ❌ Invalid — enforced at application level |

## Considered Options

- **Single `ticket_system` flag** — simpler, but conflates "having events" with "selling tickets." Many businesses want to announce events without running a box office.
- **Two independent flags with dependency** (chosen) — clean separation of concerns. Display-only events are a lightweight feature; ticketing is a heavier commitment (capacity management, payments, holds).

## Consequences

- UI must enforce the dependency: enabling `ticket_system` auto-enables `event_system`. Disabling `event_system` auto-disables `ticket_system`.
- BP navigation adapts: Events tab appears with `event_system`, ticket management sub-sections appear with `ticket_system`.
- Admin Panel feature toggle UI must reflect the dependency visually.
- AaaS metering can price the two features independently.
