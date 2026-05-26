---
tag: "noona.is"
---
Retrieve all product groups and products in an ordered manner with respect to hierarchy.

GET `/v1/hq/companies/{company_id}/product_groups/expanded`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/product_groups/expanded"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "company": "7awdXwZoedakjad37a",

    "title": "Shampoo",

    "description": "All shampoo",

    "color": "#FCB834",

    "parent_group_id": "7awdUaw31aiwdjIDw",

    "order": 1,

    "is_default_group": false,

    "group_products": [

      {

        "id": "7awdXwZoedakjad37a",

        "order": 1,

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

    ],

    "import_job": "FzGMKqFnCX79N3zWk",

    "created_at": 1631558908,

    "updated_at": 1631558908,

    "group_product_groups": [

      {

        "id": "string"

      }

    ]

  }

]
```[Retrieve a product group GET](https://docs.noona.is/docs/hq/product-groups/GetProductGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups/GetProductGroup)[

List product groups GET

Next Page

](https://docs.noona.is/docs/hq/product-groups/ListProductGroups)