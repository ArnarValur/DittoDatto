---
tag: "noona.is"
---
Retrieves information about an existing event status.

GET `/v1/hq/event_statuses/{event_status_id}`

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
curl -X GET "https://api.noona.is/v1/hq/event_statuses/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "name": "showup",

  "label": "Show-up",

  "order": 1,

  "color": "#00FF00",

  "default": true,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

Empty[Delete event status DELETE](https://docs.noona.is/docs/hq/event-statuses/DeleteEventStatus)

[

Previous Page

](https://docs.noona.is/docs/hq/event-statuses/DeleteEventStatus)[

List all event statuses GET

Next Page

](https://docs.noona.is/docs/hq/event-statuses/ListEventStatuses)