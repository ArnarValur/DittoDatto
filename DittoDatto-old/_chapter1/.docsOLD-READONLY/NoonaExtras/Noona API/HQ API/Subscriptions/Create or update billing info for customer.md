---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Creates or updates the billing information for this customer

POST `/v1/hq/companies/{company_id}/subscriptions/billing_info`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

first\_name?string

Example `"John"`

last\_name?string

Example `"Smith"`

email?string

Format `email`

Example `"john.smith@example.com"`

phone?string

company?string

Example `"Best Company"`

business\_registration\_id?string

Example `"1234567890"`

vat\_number?string

Example `"1234567890"`

billing\_method?string

The billing method. "card" for regular card-based subscriptions (default), "invoice" for invoice-based subscriptions (only available for Icelandic companies).

Default `"card"`

Format `enum`

payment\_intent\_id?string

billing\_address?

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/dwawd8awudawd/subscriptions/billing_info" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "first_name": "John",

  "last_name": "Smith",

  "email": "john.smith@example.com",

  "phone": "string",

  "company": "Best Company",

  "business_registration_id": "1234567890",

  "vat_number": "1234567890",

  "vat_number_status": "valid",

  "billing_method": "card",

  "payment_intent_id": "string",

  "primary_payment_source_id": "string",

  "card": {

    "first_name": "string",

    "last_name": "string",

    "status": "valid",

    "last4": "string",

    "card_type": "visa",

    "expiry_month": 1,

    "expiry_year": 0

  },

  "billing_address": {

    "first_name": "John",

    "last_name": "Smith",

    "email": "john.smith@example.com",

    "phone": "string",

    "company": "Best Company",

    "street": "1600 Pennsylvania Avenue NW",

    "city": "Washington D.C.",

    "country": "US",

    "postal_code": "20500"

  }

}
```

Empty

Empty[Start trial POST](https://docs.noona.is/docs/hq/subscriptions/StartTrial)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/StartTrial)[

Subtransactions

Next Page

](https://docs.noona.is/docs/hq/subtransactions)