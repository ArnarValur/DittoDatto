---
tag: "noona.is"
---
Retrieves information about an existing customer group.

GET `/v1/hq/customer_groups/{customer_group_id}`

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

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/customer_groups/dwawd8awudawd"
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

Empty[Delete customer group DELETE](https://docs.noona.is/docs/hq/customer-groups/DeleteCustomerGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/customer-groups/DeleteCustomerGroup)[

List all customer groups GET

Next Page

](https://docs.noona.is/docs/hq/customer-groups/ListCustomerGroups)