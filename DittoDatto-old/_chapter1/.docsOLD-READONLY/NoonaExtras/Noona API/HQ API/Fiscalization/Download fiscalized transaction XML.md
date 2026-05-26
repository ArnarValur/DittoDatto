---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Download fiscalized transaction XML

GET `/v1/hq/fiscalizations/transactions/{transaction_id}/xml`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

transaction\_id \* string

Example `"dwawd8awudawd"`

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/fiscalizations/transactions/dwawd8awudawd/xml"
```

```
"string"
```

Empty

Empty

Empty[Download fiscalized transaction PDF GET](https://docs.noona.is/docs/hq/fiscalization/GetFiscalizedTransactionPDF)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/GetFiscalizedTransactionPDF)[

Get user fiscalization onboarding data GET

Next Page

](https://docs.noona.is/docs/hq/fiscalization/GetUserFiscalizationData)