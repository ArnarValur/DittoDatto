---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Metrics

Streams sales metrics for a company for a specific timeframe

GET `/v1/hq/stream/companies/{company_id}/metrics/sales`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/string/metrics/sales"
```

Empty

Empty

Empty

Empty[Retrieve aggregated SMS messages data GET](https://docs.noona.is/docs/hq/metrics/GetSMSMessagesAggregate)

[

Previous Page

](https://docs.noona.is/docs/hq/metrics/GetSMSMessagesAggregate)[

Mozrest

Next Page

](https://docs.noona.is/docs/hq/mozrest)