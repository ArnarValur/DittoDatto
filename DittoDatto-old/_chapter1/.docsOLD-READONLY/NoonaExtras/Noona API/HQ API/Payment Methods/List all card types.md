---
tag: "noona.is"
---
Lists all possible card types.

GET `/v1/hq/card_types`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/card_types"
```

```
[

  "visa"

]
```[Create payment method instance POST](https://docs.noona.is/docs/hq/payment-methods/CreatePaymentMethodInstance)

[

Previous Page

](https://docs.noona.is/docs/hq/payment-methods/CreatePaymentMethodInstance)[

List company payment method instances GET

Next Page

](https://docs.noona.is/docs/hq/payment-methods/ListPaymentMethodInstances)