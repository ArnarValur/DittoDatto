---
tag: "noona.is"
---
Creates a new customer group at company.

POST `/v1/hq/customer_groups`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company?string

Example `"QwYwhN8HH2CaFtwiW"`

title?string

Example `"Regulars"`

description?string

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/customer_groups" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7dj29KiAE1wdjw731",

  "company": "QwYwhN8HH2CaFtwiW",

  "title": "Regulars",

  "description": "Customers that come in regularly",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

Empty[Customer Groups](https://docs.noona.is/docs/hq/customer-groups)

[

Previous Page

](https://docs.noona.is/docs/hq/customer-groups)[

Delete customer group DELETE

Next Page

](https://docs.noona.is/docs/hq/customer-groups/DeleteCustomerGroup)