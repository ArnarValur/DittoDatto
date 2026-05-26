---
tag: "noona.is"
---
Streams product groups for a company.

GET `/v1/hq/stream/companies/{company_id}/product_groups`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/product_groups"
```

Empty[List product groups GET](https://docs.noona.is/docs/hq/product-groups/ListProductGroups)

[

Previous Page

](https://docs.noona.is/docs/hq/product-groups/ListProductGroups)[

Update a product group POST

Next Page

](https://docs.noona.is/docs/hq/product-groups/UpdateProductGroup)