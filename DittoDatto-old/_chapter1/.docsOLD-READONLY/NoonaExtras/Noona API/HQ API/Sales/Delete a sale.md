---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Sales](https://docs.noona.is/docs/hq/sales)

Deletes a sale if allowed

DELETE `/v1/hq/sales/{sale_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

sale\_id \* string

Sale ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/sales/string"
```

Empty

Empty

Empty

Empty[Create a sale POST](https://docs.noona.is/docs/hq/sales/CreateSale)

[

Previous Page

](https://docs.noona.is/docs/hq/sales/CreateSale)[

Retrieve a sale GET

Next Page

](https://docs.noona.is/docs/hq/sales/GetSale)