---
tag: "noona.is"
---
Retrieve information about an existing product group.

GET `/v1/hq/product_groups/{id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

id \* string

Product Group ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/product_groups/string"
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

Empty[Delete a product group DELETE](https://docs.noona.is/docs/hq/product-groups/DeleteProductGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups/DeleteProductGroup)[

List product groups expanded GET

Next Page

](https://docs.noona.is/docs/hq/product-groups/ListGroupsAndProducts)