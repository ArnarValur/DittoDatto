---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Event Type Groups](https://docs.noona.is/docs/hq/event-type-groups)

Deletes event type group by ID

DELETE `/v1/hq/event_type_groups/{event_type_group_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

event\_type\_group\_id \* string

Event Type Group ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/event_type_groups/string"
```

Empty

Empty

Empty

Empty[Create event type group POST](https://docs.noona.is/docs/hq/event-type-groups/CreateEventTypeGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/event-type-groups/CreateEventTypeGroup)[

Get event type group GET

Next Page

](https://docs.noona.is/docs/hq/event-type-groups/GetEventTypeGroup)