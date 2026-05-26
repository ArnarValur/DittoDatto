---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

Fetches the data fiscalization for the company.

GET `/v1/hq/fiscalizations/companies/{company_id}/onboarding`

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

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/fiscalizations/companies/dwawd8awudawd/onboarding"
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
```[Fiscalize transaction POST](https://docs.noona.is/docs/hq/fiscalization/FiscalizeTransaction)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/FiscalizeTransaction)[

Download fiscalization report GET

Next Page

](https://docs.noona.is/docs/hq/fiscalization/GetFiscalizationReport)