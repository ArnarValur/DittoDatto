---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Payments](https://docs.noona.is/docs/hq/payments)

Lists the payments for a company.

GET `/v1/hq/companies/{company_id}/payments`

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
curl -X GET "https://api.noona.is/v1/hq/companies/string/payments"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "reference": "ABCD1234",

    "company": "string",

    "marketplace_user": "string",

    "customer": {

      "id": "string"

    },

    "employee": "string",

    "event": {

      "id": "string"

    },

    "status": "refunded",

    "refundable": true,

    "reason": "voucher",

    "provider": "teya",

    "currency": "ISK",

    "amount": 10000,

    "settles_to_employee": true,

    "settled_to": "John The Cutter",

    "settlement": "7awdXwZoedakjad37a",

    "refunded_at": "2019-08-24T14:15:22Z",

    "settled_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty[Get payment GET](https://docs.noona.is/docs/hq/payments/GetPayment)

[

Previous Page

](https://docs.noona.is/docs/hq/payments/GetPayment)[

Send payment receipt POST

Next Page

](https://docs.noona.is/docs/hq/payments/SendPaymentReceipt)