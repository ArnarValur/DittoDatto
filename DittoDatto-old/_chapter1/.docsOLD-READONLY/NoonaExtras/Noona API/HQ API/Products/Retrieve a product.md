---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Products](https://docs.noona.is/docs/hq/products)

Retrieves information about an existing product.

GET `/v1/hq/products/{id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

id \* string

Product ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/products/string"
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

Empty[Delete a product DELETE](https://docs.noona.is/docs/hq/products/DeleteProduct)

[

Previous Page

](https://docs.noona.is/docs/hq/products/DeleteProduct)[

List products GET

Next Page

](https://docs.noona.is/docs/hq/products/ListProducts)