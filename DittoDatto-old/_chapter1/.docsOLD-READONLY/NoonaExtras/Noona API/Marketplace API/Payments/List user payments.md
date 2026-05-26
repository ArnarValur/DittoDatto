---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Payments](https://docs.noona.is/docs/marketplace/payments)

Lists the payments of a marketplace user.

```
curl -X GET "https://api.noona.is/v1/marketplace/user/payments"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "user": "string",

    "event": {

      "id": "string"

    },

    "currency": "ISK",

    "amount": 10000,

    "status": "refunded",

    "provider": "teya",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[List payment methods GET](https://docs.noona.is/docs/marketplace/payments/ListPaymentMethods)

[

Previous Page

](https://docs.noona.is/docs/marketplace/payments/ListPaymentMethods)[

Pay for pending payment POST

Next Page

](https://docs.noona.is/docs/marketplace/payments/PayForPendingPayment)