---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Products](https://docs.noona.is/docs/hq/products)

Streams products for a company.

GET `/v1/hq/stream/companies/{company_id}/products`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/products"
```

Empty[List products GET](https://docs.noona.is/docs/hq/products/ListProducts)

[

Previous Page

](https://docs.noona.is/docs/hq/products/ListProducts)[

Update a product POST

Next Page

](https://docs.noona.is/docs/hq/products/UpdateProduct)