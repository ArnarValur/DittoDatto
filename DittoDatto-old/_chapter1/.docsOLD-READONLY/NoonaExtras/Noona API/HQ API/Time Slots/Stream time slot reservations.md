---
tag: "noona.is"
---
Streams time slot reservations for a company.

GET `/v1/hq/stream/companies/{company_id}/time_slot_reservations`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/time_slot_reservations"
```

Empty[List time slots GET](https://docs.noona.is/docs/hq/time-slots/ListTimeSlots)

[

Previous Page

](https://docs.noona.is/docs/hq/time-slots/ListTimeSlots)[

Tokens

Next Page

](https://docs.noona.is/docs/hq/tokens)