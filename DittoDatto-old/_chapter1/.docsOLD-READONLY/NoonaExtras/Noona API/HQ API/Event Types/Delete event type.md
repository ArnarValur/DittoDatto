---
tag: "noona.is"
---
Deletes event type by ID

DELETE `/v1/hq/event_types/{event_type_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

event\_type\_id \* string

Event Type ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/event_types/string"
```

Empty

Empty

Empty

Empty[Create event type POST](https://docs.noona.is/docs/hq/event-types/CreateEventType)

[

Previous Page

](https://docs.noona.is/docs/hq/event-types/CreateEventType)[

Get event type GET

Next Page

](https://docs.noona.is/docs/hq/event-types/GetEventType)