---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Fetches the fiscalization onboarding data for a user.

GET `/v1/hq/fiscalizations/users/{user_id}/onboarding`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

user\_id \* string

Example `"user123"`

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/fiscalizations/users/user123/onboarding"
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

Empty[Download fiscalized transaction XML GET](https://docs.noona.is/docs/hq/fiscalization/GetFiscalizedTransactionXML)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/GetFiscalizedTransactionXML)[

Migrate Portugal company from InvoiceXpress to AT provider POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/MigratePortugalCompanyToATProvider)