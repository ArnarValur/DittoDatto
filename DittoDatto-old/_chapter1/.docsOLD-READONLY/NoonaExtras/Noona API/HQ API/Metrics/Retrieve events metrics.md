---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Metrics

Retrieves event/booking metrics for a company for a specific timeframe.

GET `/v1/hq/companies/{company_id}/metrics/events`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/metrics/events"
```

```
{

  "events": {

    "timeframe": 0,

    "timeframe_week_before": 0,

    "percent_change": 0

  },

  "guests": {

    "timeframe": 0,

    "timeframe_week_before": 0,

    "percent_change": 0

  },

  "marketplace_events": {

    "timeframe": 0,

    "timeframe_week_before": 0,

    "percent_change": 0

  },

  "new_customers": {

    "timeframe": 0,

    "timeframe_week_before": 0,

    "percent_change": 0

  },

  "occupancy": {

    "timeframe": 0,

    "timeframe_week_before": 0,

    "percent_change": 0

  }

}
```

Empty

Empty

Empty[Retrieve aggregated bookings data GET](https://docs.noona.is/docs/hq/metrics/GetEventsAggregate)

[

Previous Page

](https://docs.noona.is/docs/hq/metrics/GetEventsAggregate)[

Retrieve sales metrics GET

Next Page

](https://docs.noona.is/docs/hq/metrics/GetSalesMetrics)