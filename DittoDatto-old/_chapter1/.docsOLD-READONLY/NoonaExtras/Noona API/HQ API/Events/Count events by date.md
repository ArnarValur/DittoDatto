---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Events](https://docs.noona.is/docs/hq/events)

Returns a count of events per day within the specified date range, if there are no events on a date, it will not appear in the result.

GET `/v1/hq/companies/{company_id}/events_count`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/events_count"
```

```
[

  {

    "date": "2022-09-12",

    "count": 1

  }

]
```

Empty

Empty

Empty

Empty[Check in a customer POST](https://docs.noona.is/docs/hq/events/CheckinWithPayment)

[

Previous Page

](https://docs.noona.is/docs/hq/events/CheckinWithPayment)[

Checkout an event POST

Next Page

](https://docs.noona.is/docs/hq/events/CreateCheckoutForEvent)