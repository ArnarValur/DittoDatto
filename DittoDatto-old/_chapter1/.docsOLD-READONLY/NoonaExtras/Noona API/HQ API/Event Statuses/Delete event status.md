---
tag: "noona.is"
---
Deletes an event status at company.

DELETE `/v1/hq/event_statuses/{event_status_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

event\_status\_id \* string

Event Status ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/event_statuses/string"
```

Empty[Create an event status POST](https://docs.noona.is/docs/hq/event-statuses/CreateEventStatus)

[

Previous Page

](https://docs.noona.is/docs/hq/event-statuses/CreateEventStatus)[

Retrieve an event status GET

Next Page

](https://docs.noona.is/docs/hq/event-statuses/GetEventStatus)