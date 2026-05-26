---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Events](https://docs.noona.is/docs/hq/events)

Delete event for a company

DELETE `/v1/hq/events/{event_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

event\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/events/dwawd8awudawd"
```

Empty

Empty

Empty[Create an event POST](https://docs.noona.is/docs/hq/events/CreateEvent)

[

Previous Page

](https://docs.noona.is/docs/hq/events/CreateEvent)[

Delete event file DELETE

Next Page

](https://docs.noona.is/docs/hq/events/DeleteEventFile)