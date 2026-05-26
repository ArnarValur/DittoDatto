---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq)

Scheduled Events represent explicit, time-bound occurrences such as concerts, classes, workshops, group fitness sessions, or any event that happens at a specific time with limited capacity.

Unlike regular Event Types which define bookable services with flexible scheduling, Scheduled Events have:

- **Fixed start and end times** - The event occurs at a specific date and time
- **Capacity limits** - A maximum number of attendees across all tiers
- **Multiple pricing tiers** - Different ticket types (e.g., "Floor" vs "Balcony", "Adult" vs "Child")

Each tier in a Scheduled Event automatically creates managed Event Type and Resource entities behind the scenes. These managed entities:

- Are hidden from regular Event Type and Resource listings
- Have their lifecycle controlled by the parent Scheduled Event
- Are automatically deleted when the Scheduled Event is deleted

**Common use cases:**

- Concert or show ticketing with different seating sections
- Group fitness classes with limited spots
- Workshops or seminars with tiered pricing
- Tours or experiences with capacity constraints[Update Saltpay terminal POST](https://docs.noona.is/docs/hq/saltpay/UpdateSaltpayTerminal)

[

Previous Page

](https://docs.noona.is/docs/hq/saltpay/UpdateSaltpayTerminal)[

Create a scheduled event POST

Next Page

](https://docs.noona.is/docs/hq/scheduled-events/CreateScheduledEvent)