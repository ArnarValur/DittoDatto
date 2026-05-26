---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Payments](https://docs.noona.is/docs/hq/payments)

Downloads a payment receipt.

GET `/v1/hq/payments/{payment_id}/receipt`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

payment\_id \* string

Payment ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/payments/string/receipt"
```

```
"string"
```

Empty[Create a payment POST](https://docs.noona.is/docs/hq/payments/CreatePayment)

[

Previous Page

](https://docs.noona.is/docs/hq/payments/CreatePayment)[

Get payment GET

Next Page

](https://docs.noona.is/docs/hq/payments/GetPayment)