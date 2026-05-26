---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Line items

List line items on a transaction

Product, event type and voucher are [point in time properties](https://docs.noona.is/docs/hq/line-items/#section/Point-in-time-properties)

GET `/v1/hq/transactions/{transaction_id}/line_items`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

transaction\_id \* string

Transaction ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/transactions/string/line_items"
```

```
[

  {

    "id": "8wa9uiah28dawd123",

    "type": "event_type",

    "transaction": "8wa9uiah28dawd123",

    "company": "string",

    "title": "Awesome shampoo",

    "quantity": 1,

    "unit_price": {

      "id": "8wa9uiah28dawd123",

      "currency": "ISK",

      "amount": 1990,

      "original_amount": 1990,

      "discount": 20

    },

    "discount": 20,

    "vat_amount": 0.24,

    "tax_exemption_reason": "M01",

    "is_returning": false,

    "employee": "string",

    "product": "string",

    "event_type": "string",

    "voucher_template": "string",

    "voucher": {

      "id": "7awdXwZoedakjad37a"

    },

    "claim": "string",

    "event": "string",

    "variation_id": "string",

    "booked_by": "8wa9uiah28dawd123"

  }

]
```

Empty

Empty

Empty[Retrieve line item GET](https://docs.noona.is/docs/hq/line-items/GetLineItem)

[

Previous Page

](https://docs.noona.is/docs/hq/line-items/GetLineItem)[

Update a line item POST

Next Page

](https://docs.noona.is/docs/hq/line-items/UpdateLineItem)