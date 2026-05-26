---
tag: "noona.is"
---
Creates a new product group for users company.

POST `/v1/hq/product_groups`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company?string

Example `"7awdXwZoedakjad37a"`

title \* string

Example `"Shampoo"`

description?string

Example `"All shampoo"`

color?string

Example `"#FCB834"`

parent\_group\_id?string

Example `"7awdUaw31aiwdjIDw"`

order?integer

Used to control how a product group is ordered with respect to siblings.

Format `int32`

Example `1`

is\_default\_group?boolean

If true the product group is a special, uneditable, group that contains all products that have not been added to user created product groups.

Example `false`

group\_products?

import\_job?string

ID of the import job that created this product group.

Example `"FzGMKqFnCX79N3zWk"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/product_groups" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
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

      "id": "7dj29KiAE1wdjw731",

      "order": 1

    }

  ],

  "import_job": "FzGMKqFnCX79N3zWk",

  "created_at": 1631558908,

  "updated_at": 1631558908

}
```

Empty[Product Groups](https://docs.noona.is/docs/hq/product-groups)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups)[

Delete a product group DELETE

Next Page

](https://docs.noona.is/docs/hq/product-groups/DeleteProductGroup)