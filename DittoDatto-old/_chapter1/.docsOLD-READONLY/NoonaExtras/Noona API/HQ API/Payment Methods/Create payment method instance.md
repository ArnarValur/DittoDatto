---
tag: "noona.is"
---
Creates a new payment method instance for a company.

POST `/v1/hq/payment_method_instances`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company \* string

Example `"abc123"`

payment\_method \* string

Example `"HvMpDGJq9dFLb2Tgv"`

title \* string

enabled?boolean

Default `true`

Example `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/payment_method_instances" \

  -H "Content-Type: application/json" \

  -d '{

    "company": "abc123",

    "payment_method": "HvMpDGJq9dFLb2Tgv",

    "title": "Custom Gift Voucher"

  }'
```

```
{

  "id": "comp_pm_123456",

  "company": "string",

  "payment_method": "string",

  "is_custom": true,

  "title": "Cash",

  "title_translations": {

    "en": "Cash",

    "is": "Reiðufé"

  },

  "order": 0,

  "enabled": true,

  "available": true,

  "created_at": "2025-04-01T12:00:00Z",

  "updated_at": "2025-04-01T12:00:00Z"

}
```

Empty

Empty

Empty[Payment Methods](https://docs.noona.is/docs/hq/payment-methods)

[

Previous Page

](https://docs.noona.is/docs/hq/payment-methods)[

List all card types GET

Next Page

](https://docs.noona.is/docs/hq/payment-methods/ListCardTypes)