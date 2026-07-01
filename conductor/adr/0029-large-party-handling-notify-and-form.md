# Large party handling: notify + form replace datto

> **Recorded:** 2026-07-01 14:55
> **Status:** accepted

The `large_party_handling` enum in `reservation_config` had a `datto` value (route to the AI business agent) that doesn't exist yet. Rather than keeping a dead option, we replace it with two practical alternatives.

New enum values: `notify`, `email`, `call`, `form`, `disabled`.

- **`notify`** (new, default for restaurants): Accept the over-max booking and immediately push-notify the business owner/staff for manual accommodation. The booking is confirmed but flagged for attention.
- **`form`** (new): Show a "large party request" form in the Marketplace. Customer fills it in, restaurant gets notified. No booking is created — it's a request.
- **`email`**: Show the restaurant's contact email for the customer to reach out.
- **`call`**: Show a phone number for the customer to call.
- **`disabled`**: Reject the booking with a "sorry, max N guests" message.

When Datto ships, `notify` behavior naturally upgrades — the notification can be routed to the AI agent instead of a human.

## Consequences

- Schema: update ASSERT on `reservation_config.large_party_handling` to `['notify', 'email', 'call', 'form', 'disabled']`, default to `'notify'`.
- Marketplace: implement push notification for `notify` mode, request form for `form` mode.
- BP UI: dropdown with all 5 options in the reservation config section.
