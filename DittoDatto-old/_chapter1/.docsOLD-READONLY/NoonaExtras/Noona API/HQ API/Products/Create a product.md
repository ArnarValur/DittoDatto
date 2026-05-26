---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Products](https://docs.noona.is/docs/hq/products)

Creates a new product at company.

POST `/v1/hq/products`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company\_id \* string

Example `"7awdXwZoedakjad37a"`

vat\_id \* string

Id of VAT to use for product

Example `"FzGMKqFnCX79N3zWk"`

title \* string

Example `"Black Shampoo"`

description?string

amount?number

Default `0`

Format `double`

Example `2990`

sku?string

Example `"ANE123"`

stock\_level?integer

Format `int32`

Example `10`

cost?integer

The cost of the product from a wholesaler.

In the x100 format.

Format `int32`

barcode?string

Example `8004608258995`

product\_groups?array<string>

List of product group ids product belongs to.

image?

tax\_exemption\_reason?string

VAT exemption reason when having a VAT amount of 0%

Example `"M01"`

import\_reference\_id?string

Set during import of products, usually an identifier from an external system.

Example `"FzGMKqFnCX79N3zWk"`

import\_job\_id?string

ID of the import job that created this product.

Example `"FzGMKqFnCX79N3zWk"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/products" \

  -H "Content-Type: application/json" \

  -d '{

    "company_id": "7awdXwZoedakjad37a",

    "vat_id": "FzGMKqFnCX79N3zWk",

    "title": "Black Shampoo"

  }'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "7awdXwZoedakjad37a",

  "title": "Black Shampoo",

  "description": "A shampoo for black hair",

  "amount": 2990,

  "sku": "ANE123",

  "stock_level": 10,

  "cost": 0,

  "barcode": 8004608258995,

  "product_groups": [

    "string"

  ],

  "image": {

    "thumb": "<link-to-image>"

  },

  "vat_id": "FzGMKqFnCX79N3zWk",

  "tax_exemption_reason": "M01",

  "import_reference_id": "FzGMKqFnCX79N3zWk",

  "created_at": 1631558908,

  "updated_at": 1631558908

}
```

Empty[Products](https://docs.noona.is/docs/hq/products)

[

Previous Page

](https://docs.noona.is/docs/hq/products)[

Delete a product DELETE

Next Page

](https://docs.noona.is/docs/hq/products/DeleteProduct)