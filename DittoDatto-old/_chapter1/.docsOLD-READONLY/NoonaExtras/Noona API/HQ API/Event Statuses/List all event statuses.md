---
tag: "noona.is"
---
Lists all event statuses of a company.

GET `/v1/hq/companies/{company_id}/event_statuses`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/event_statuses"
```

```
[

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

]
```[Retrieve an event status GET](https://docs.noona.is/docs/hq/event-statuses/GetEventStatus)

[

Previous Page

](https://docs.noona.is/docs/hq/event-statuses/GetEventStatus)[

Update an event status POST

Next Page

](https://docs.noona.is/docs/hq/event-statuses/UpdateEventStatus)