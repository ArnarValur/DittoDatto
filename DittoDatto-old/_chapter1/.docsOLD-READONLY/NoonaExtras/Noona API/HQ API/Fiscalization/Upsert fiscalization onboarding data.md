---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Uses the provided data to setup the fiscalization for the company.

If the company already has fiscalization data, it will be updated.

POST `/v1/hq/fiscalizations/companies/{company_id}/onboarding`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Request Body

application/json

data?|

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/companies/dwawd8awudawd/onboarding" \

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
```[Update user fiscalization status POST](https://docs.noona.is/docs/hq/fiscalization/UpdateUserFiscalizationStatus)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/UpdateUserFiscalizationStatus)[

Upsert user fiscalization onboarding data POST

Next Page

](https://docs.noona.is/docs/hq/fiscalization/UpsertUserFiscalizationData)