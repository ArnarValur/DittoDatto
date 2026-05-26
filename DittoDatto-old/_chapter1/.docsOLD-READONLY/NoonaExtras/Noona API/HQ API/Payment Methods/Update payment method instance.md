---
tag: "noona.is"
---
Updates an existing payment method instance. When updating order, the system automatically shifts other resources to maintain sequence. Order values always remain sequential (0, 1, 2, 3...).

POST `/v1/hq/payment_method_instances/{instance_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

instance\_id \* string

Payment Method Instance ID

## Query Parameters

## Request Body

application/json

order?integer

New position for this payment method. Other methods will be reordered automatically.

Format `int32`

Example `3`

enabled?boolean

Whether this payment method is enabled for the company.

Example `true`

title?string

Display name of the payment method.

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/payment_method_instances/string" \

  -H "Content-Type: application/json" \

  -d '{}'
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

Empty[List all payment methods GET](https://docs.noona.is/docs/hq/payment-methods/ListPaymentMethods)

[

Previous Page

](https://docs.noona.is/docs/hq/payment-methods/ListPaymentMethods)[

Payments

Next Page

](https://docs.noona.is/docs/hq/payments)