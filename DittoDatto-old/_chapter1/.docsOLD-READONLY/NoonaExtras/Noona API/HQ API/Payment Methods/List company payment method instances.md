---
tag: "noona.is"
---
Lists payment method instances for a specific company.

GET `/v1/hq/companies/{company_id}/payment_method_instances`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/payment_method_instances"
```

```
[

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

]
```

Empty

Empty

Empty[List all card types GET](https://docs.noona.is/docs/hq/payment-methods/ListCardTypes)

[

Previous Page

](https://docs.noona.is/docs/hq/payment-methods/ListCardTypes)[

List all payment methods GET

Next Page

](https://docs.noona.is/docs/hq/payment-methods/ListPaymentMethods)