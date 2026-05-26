---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Line items

Retrieve a single line item

Product, event type and voucher are [point in time properties](https://docs.noona.is/docs/hq/line-items/#section/Point-in-time-properties)

GET `/v1/hq/line_items/{line_item_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

line\_item\_id \* string

Line Item ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/line_items/string"
```

```
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

    "id": "7awdXwZoedakjad37a",

    "voucher": {

      "id": "string"

    },

    "code": "A328DB",

    "data": {

      "type": "service",

      "template_id": "string",

      "sessions_total": 6,

      "amount": 2500,

      "value": 5000,

      "event_type_id": "d0a9w8da09w8dindwa"

    }

  },

  "claim": "string",

  "event": "string",

  "variation_id": "string",

  "booked_by": "8wa9uiah28dawd123"

}
```

Empty

Empty

Empty[Delete a line item DELETE](https://docs.noona.is/docs/hq/line-items/DeleteLineItem)

[

Previous Page

](https://docs.noona.is/docs/hq/line-items/DeleteLineItem)[

List line items GET

Next Page

](https://docs.noona.is/docs/hq/line-items/ListLineItems)