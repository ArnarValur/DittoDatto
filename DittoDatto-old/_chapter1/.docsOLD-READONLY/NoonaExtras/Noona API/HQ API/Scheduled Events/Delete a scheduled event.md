---
tag: "noona.is"
---
Deletes a scheduled event and its managed entities.

DELETE `/v1/hq/scheduled_events/{scheduled_event_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

scheduled\_event\_id \* string

Scheduled Event ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/scheduled_events/string"
```

Empty

Empty

Empty[Create a scheduled event POST](https://docs.noona.is/docs/hq/scheduled-events/CreateScheduledEvent)

[

Previous Page

](https://docs.noona.is/docs/hq/scheduled-events/CreateScheduledEvent)[

Retrieve a scheduled event GET

Next Page

](https://docs.noona.is/docs/hq/scheduled-events/GetScheduledEvent)