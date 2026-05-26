---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Metrics

Retrieves sales metrics for a company for a specific timeframe.

GET `/v1/hq/companies/{company_id}/metrics/sales`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/metrics/sales"
```

```
{

  "transactions": {

    "today": {

      "currency": "string",

      "total": 0.1,

      "average": 0.1,

      "count": 0

    },

    "same_day_last_week": {

      "currency": "string",

      "total": 0.1,

      "average": 0.1,

      "count": 0

    },

    "percent_change": {

      "total": 0.1,

      "average": 0.1,

      "count": 0.1

    }

  },

  "payments": {

    "today": {

      "currency": "string",

      "total": 0.1,

      "average": 0.1,

      "count": 0

    },

    "same_day_last_week": {

      "currency": "string",

      "total": 0.1,

      "average": 0.1,

      "count": 0

    },

    "percent_change": {

      "total": 0.1,

      "average": 0.1,

      "count": 0.1

    }

  }

}
```

Empty

Empty

Empty[Retrieve events metrics GET](https://docs.noona.is/docs/hq/metrics/GetEventsMetrics)

[

Previous Page

](https://docs.noona.is/docs/hq/metrics/GetEventsMetrics)[

Retrieve aggregated SMS messages data GET

Next Page

](https://docs.noona.is/docs/hq/metrics/GetSMSMessagesAggregate)