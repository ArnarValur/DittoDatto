---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Updates the fiscalization status for the company to the specified value.

POST `/v1/hq/fiscalizations/companies/{company_id}/status`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Request Body

application/json

fiscalization\_enabled \* boolean

The desired fiscalization enabled status

Example `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/companies/string/status" \

  -H "Content-Type: application/json" \

  -d '{

    "fiscalization_enabled": true

  }'
```

```
{

  "fiscalization_enabled": true

}
```

Empty

Empty

Empty

Empty

Empty[Refund fiscalized transaction POST](https://docs.noona.is/docs/hq/fiscalization/RefundFiscalizedTransaction)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/RefundFiscalizedTransaction)[

Update user fiscalization status POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/UpdateUserFiscalizationStatus)