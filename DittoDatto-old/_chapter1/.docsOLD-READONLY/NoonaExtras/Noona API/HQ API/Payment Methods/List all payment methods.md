---
tag: "noona.is"
---
Lists all possible payment methods in the noona ecosystem.

GET `/v1/hq/payment_methods`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/payment_methods"
```

```
[

  {

    "id": "8wa9uiah28dawd123",

    "title": "Card",

    "order": 1,

    "icon_name": "credit-card-1",

    "readable_id": "paymentCard",

    "locale_key": "dbPaymentMethods:paymentCard",

    "use_terminal": true,

    "hidden": false

  }

]
```[List company payment method instances GET](https://docs.noona.is/docs/hq/payment-methods/ListPaymentMethodInstances)

[

Previous Page

](https://docs.noona.is/docs/hq/payment-methods/ListPaymentMethodInstances)[

Update payment method instance POST

Next Page

](https://docs.noona.is/docs/hq/payment-methods/UpdatePaymentMethodInstance)