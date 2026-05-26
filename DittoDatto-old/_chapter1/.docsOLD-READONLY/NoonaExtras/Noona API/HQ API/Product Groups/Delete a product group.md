---
tag: "noona.is"
---
Deletes product group tied to users comapny.

DELETE `/v1/hq/product_groups/{id}`

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
curl -X DELETE "https://api.noona.is/v1/hq/product_groups/string"
```

Empty

Empty[Create a product group POST](https://docs.noona.is/docs/hq/product-groups/CreateProductGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups/CreateProductGroup)[

Retrieve a product group GET

Next Page

](https://docs.noona.is/docs/hq/product-groups/GetProductGroup)