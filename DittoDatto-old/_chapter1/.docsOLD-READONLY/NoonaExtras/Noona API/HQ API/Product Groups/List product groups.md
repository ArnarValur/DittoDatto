---
tag: "noona.is"
---
Returns a list of all product groups tied to company.

GET `/v1/hq/companies/{company_id}/product_groups`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/product_groups"
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

        "id": "7dj29KiAE1wdjw731",

        "order": 1

      }

    ],

    "import_job": "FzGMKqFnCX79N3zWk",

    "created_at": 1631558908,

    "updated_at": 1631558908

  }

]
```[List product groups expanded GET](https://docs.noona.is/docs/hq/product-groups/ListGroupsAndProducts)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups/ListGroupsAndProducts)[

Stream product groups GET

Next Page

](https://docs.noona.is/docs/hq/product-groups/StreamProductGroups)