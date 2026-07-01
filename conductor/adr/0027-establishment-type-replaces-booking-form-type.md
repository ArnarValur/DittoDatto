# EstablishmentType replaces booking_form_type

> **Recorded:** 2026-07-01 14:55
> **Status:** accepted

The `booking_form_type` field on `establishment` (values: `standard`, `none`, `tableReservation`, `ticketSystem`) conflated establishment identity with booking behavior. Since booking mode already lives on each Service (project-context.md §7), this field's role was ambiguous.

We introduce `establishment_type` with three archetype values: `shop` (appointment-based: salons, garages, clinics), `restaurant` (table reservations), `venue` (events/ticketing). The type is mutable after creation. All three types are available to every company — no tiering or feature-gating per type. The type drives:
1. The **default booking mode** pre-filled when creating new Services at the establishment.
2. Which **config blocks** are visible in the BP edit UI (e.g., `reservation_config` only shown for restaurants).

Services remain free to use any booking mode independently of the establishment type.

## Considered Options

- Keep `booking_form_type` as a "default for new services" — rejected because the name was confusing and the enum mixed identity with behavior.
- Two fields (`establishment_type` + `booking_form_type`) — rejected as redundant; the type implies the default mode.
- Remove entirely — rejected because the archetype drives meaningful config visibility differences.

## Consequences

- Schema: rename `booking_form_type` → `establishment_type`, update ASSERT values to `['shop', 'restaurant', 'venue']`, default to `'shop'`.
- Dart model: add `establishmentType` field to `Establishment` model.
- BP UI: add type selector, conditionally show `reservation_config` section for restaurants.
