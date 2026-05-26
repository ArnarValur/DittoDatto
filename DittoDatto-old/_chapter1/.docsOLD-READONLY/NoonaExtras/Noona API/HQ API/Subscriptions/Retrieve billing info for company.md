---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Retrieves billing information for company

GET `/v1/hq/companies/{company_id}/subscriptions/billing_info`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company id

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/subscriptions/billing_info"
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

Empty[Retrieve subscription for company GET](https://docs.noona.is/docs/hq/subscriptions/GetSubscription)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/GetSubscription)[

Retrieve subscription pricing for company GET

Next Page

](https://docs.noona.is/docs/hq/subscriptions/GetSubscriptionPricing)