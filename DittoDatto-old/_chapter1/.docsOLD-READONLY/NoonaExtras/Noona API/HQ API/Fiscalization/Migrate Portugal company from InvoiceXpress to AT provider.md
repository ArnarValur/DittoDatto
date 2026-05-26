---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Migrates Portugal company from InvoiceXpress to AT provider

POST `/v1/hq/fiscalizations/companies/{company_id}/portugal/migrate_provider`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/companies/string/portugal/migrate_provider"
```

```
{

  "data": {

    "provider": "SaltPay",

    "saltpay_company": "7awdXwZoedakjad37a",

    "saltpay_store": "7awdXwZoedakjad37a",

    "fiscal_code": "1234567890",

    "tax_credentials_username": "username",

    "tax_credentials_password": "password",

    "series": [

      "string"

    ]

  }

}
```

Empty

Empty

Empty

Empty

Empty[Get user fiscalization onboarding data GET](https://docs.noona.is/docs/hq/fiscalization/GetUserFiscalizationData)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/GetUserFiscalizationData)[

Refund fiscalized transaction POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/RefundFiscalizedTransaction)