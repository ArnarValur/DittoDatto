---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Metrics

Retrieves aggregated customers data for a company for a specific timeframe.

GET `/v1/hq/companies/{company_id}/aggregate/customers`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/aggregate/customers?group_by=time_bucket&from=2024-10-01T00%3A00%3A00Z&to=2024-10-31T23%3A59%3A59Z&time_bucket=2024-10-month&employees=string&custom_property_values=string"
```

```
[

  {

    "key": {

      "time_bucket": "string"

    },

    "count": 0

  }

]
```

Empty

Empty

Empty[List SMS messages GET](https://docs.noona.is/docs/hq/messaging/ListSMSMessages)

[

Previous Page

](https://docs.noona.is/docs/hq/messaging/ListSMSMessages)[

Retrieve aggregated bookings data GET

Next Page

](https://docs.noona.is/docs/hq/metrics/GetEventsAggregate)