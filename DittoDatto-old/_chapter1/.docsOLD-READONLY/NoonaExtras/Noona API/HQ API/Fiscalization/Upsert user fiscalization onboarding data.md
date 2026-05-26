---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Uses the provided data to setup fiscalization for the user.

POST `/v1/hq/fiscalizations/users/{user_id}/onboarding`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

user\_id \* string

Example `"user123"`

## Request Body

application/json

data?|

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/users/user123/onboarding" \

  -H "Content-Type: application/json" \

  -d '{}'
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

Empty[Upsert fiscalization onboarding data POST](https://docs.noona.is/docs/hq/fiscalization/UpsertCompanyFiscalizationData)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/UpsertCompanyFiscalizationData)[

Goals

Next Page

](https://docs.noona.is/docs/hq/goals)