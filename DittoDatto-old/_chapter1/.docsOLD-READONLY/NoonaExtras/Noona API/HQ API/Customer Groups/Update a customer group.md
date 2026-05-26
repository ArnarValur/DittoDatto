---
tag: "noona.is"
---
Updates a customer group at a company.

POST `/v1/hq/customer_groups/{customer_group_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

customer\_group\_id \* string

Customer ID

Example `"dwawd8awudawd"`

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
curl -X POST "https://api.noona.is/v1/hq/customer_groups/dwawd8awudawd" \

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
```[List all customer groups GET](https://docs.noona.is/docs/hq/customer-groups/ListCustomerGroups)

[

Previous Page

](https://docs.noona.is/docs/hq/customer-groups/ListCustomerGroups)[

Customers

Next Page

](https://docs.noona.is/docs/hq/customers)