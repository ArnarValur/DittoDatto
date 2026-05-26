---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Payments](https://docs.noona.is/docs/hq/payments)

Sends a payment receipt to the specified email address.

POST `/v1/hq/payments/{payment_id}/receipt`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

payment\_id \* string

Payment ID

## Query Parameters

## Request Body

application/json

email?string

Example `"example@example.is"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/payments/string/receipt" \

  -H "Content-Type: application/json" \

  -d '{}'
```

Empty

Empty[List payments GET](https://docs.noona.is/docs/hq/payments/ListPayments)

[

Previous Page

](https://docs.noona.is/docs/hq/payments/ListPayments)[

Update payment POST

Next Page

](https://docs.noona.is/docs/hq/payments/UpdatePayment)