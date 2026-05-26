---
tag: "noona.is"
---
Updates order of multiple product groups. This also applies to the 'root' product groups that have no parent.

All groups in the request array must share the same parent.

POST `/v1/hq/product_groups/order`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/product_groups/order" \

  -H "Content-Type: application/json" \

  -d '[

    {

      "id": "7uk31KiAE1wdjw731",

      "order": 1

    },

    {

      "id": "8dj29KiAE1wdjw731",

      "order": 3

    },

    {

      "id": "a1j29KiAE1wdjw731",

      "order": 2

    }

  ]'
```

```
[

  {

    "id": "7uk31KiAE1wdjw731",

    "order": 1

  },

  {

    "id": "8dj29KiAE1wdjw731",

    "order": 3

  },

  {

    "id": "a1j29KiAE1wdjw731",

    "order": 2

  }

]
```

Empty[Update a product group POST](https://docs.noona.is/docs/hq/product-groups/UpdateProductGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups/UpdateProductGroup)[

Products

Next Page

](https://docs.noona.is/docs/hq/products)