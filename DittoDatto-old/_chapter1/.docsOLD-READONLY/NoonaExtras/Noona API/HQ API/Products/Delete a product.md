---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Products](https://docs.noona.is/docs/hq/products)

Deletes a product.

DELETE `/v1/hq/products/{id}`

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
curl -X DELETE "https://api.noona.is/v1/hq/products/string"
```

Empty

Empty[Create a product POST](https://docs.noona.is/docs/hq/products/CreateProduct)

[

Previous Page

](https://docs.noona.is/docs/hq/products/CreateProduct)[

Retrieve a product GET

Next Page

](https://docs.noona.is/docs/hq/products/GetProduct)