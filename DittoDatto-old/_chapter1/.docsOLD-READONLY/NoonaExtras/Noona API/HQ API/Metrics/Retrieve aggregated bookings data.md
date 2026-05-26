---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Metrics

Retrieves aggregated bookings data for a company for a specific timeframe.

GET `/v1/hq/companies/{company_id}/aggregate/events`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/aggregate/events?group_by=booking_day&from=2024-10-01T00%3A00%3A00Z&to=2024-10-31T23%3A59%3A59Z&created_from=2019-08-24T14%3A15%3A22Z&created_to=2019-08-24T14%3A15%3A22Z&time_bucket=2024-10-month&employees=string&resources=string&event_types=string&origins=online&statuses=noshow&custom_property_values=string&customer_custom_property_values=string&only_new_customers=true&include_canceled_noshow=true&include_deleted=true"
```

```
[

  {

    "key": {

      "time_bucket": "string",

      "booking_day": "string",

      "created_day": "string",

      "booking_source_group": "string",

      "number_of_guests": "string",

      "status": "string",

      "event_type": "string",

      "start_time": "string",

      "duration": "string"

    },

    "count": 0,

    "hours": 0.1,

    "number_of_guests": 0,

    "new_customers": 0

  }

]
```

Empty

Empty

Empty[Retrieve aggregated customers data GET](https://docs.noona.is/docs/hq/metrics/GetCustomersAggregate)

[

Previous Page

](https://docs.noona.is/docs/hq/metrics/GetCustomersAggregate)[

Retrieve events metrics GET

Next Page

](https://docs.noona.is/docs/hq/metrics/GetEventsMetrics)