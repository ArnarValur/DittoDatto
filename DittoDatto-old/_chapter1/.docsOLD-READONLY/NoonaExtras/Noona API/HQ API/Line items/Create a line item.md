---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Line items

Create a line item

POST `/v1/hq/line_items`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

transaction \* string

Example `"8wa9uiah28dawd123"`

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

title \* string

Example `"Awesome shampoo"`

quantity?integer

Format `int32`

Example `1`

unit\_price \*

discount?number

Discount percentage

Format `double`

Example `20`

vat\_amount?number

The VAT ratio

Format `double`

Example `0.24`

tax\_exemption\_reason?string

The VAT exemption reason when the VAT amount is equal to 0

Example `"M01"`

is\_returning?boolean

True if the item was returned. Quantity and all amounts are positive for returning items.

Example `false`

employee?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

product?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

event\_type?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

voucher\_template?string

voucher?

The voucher object is only returned when the line item is a voucher template.

The voucher object is accepted and returned when the line item is an amount voucher.

claim?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

event?string

variation\_id?string

booked\_by?string

ID of the employee that booked the service on the appointment linked to the transaction. This is used to calculate commissions for the employee that booked the service.

Example `"8wa9uiah28dawd123"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/line_items" \

  -H "Content-Type: application/json" \

  -d '{}'
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

Empty[List available invoice issuers GET](https://docs.noona.is/docs/hq/issuers/ListIssuers)

[

Previous Page

](https://docs.noona.is/docs/hq/issuers/ListIssuers)[

Delete a line item DELETE

Next Page

](https://docs.noona.is/docs/hq/line-items/DeleteLineItem)