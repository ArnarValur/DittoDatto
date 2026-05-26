---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Downloads fiscalization report for the company over a specified period.

GET `/v1/hq/fiscalizations/companies/{company_id}/report`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

from \* string

Format `date-time`

Example `"2020-01-01T00:00:00.000Z"`

to \* string

Format `date-time`

Example `"2020-02-01T00:00:00.000Z"`

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/fiscalizations/companies/dwawd8awudawd/report?from=2020-01-01T00%3A00%3A00.000Z&to=2020-02-01T00%3A00%3A00.000Z"
```

Empty

Empty[Get fiscalization onboarding data GET](https://docs.noona.is/docs/hq/fiscalization/GetCompanyFiscalizationData)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/GetCompanyFiscalizationData)[

Download fiscalized transaction PDF GET

Next Page

](https://docs.noona.is/docs/hq/fiscalization/GetFiscalizedTransactionPDF)