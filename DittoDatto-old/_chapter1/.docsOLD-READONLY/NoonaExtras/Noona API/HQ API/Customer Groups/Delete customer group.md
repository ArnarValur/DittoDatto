---
tag: "noona.is"
---
Deletes a customer group at company.

DELETE `/v1/hq/customer_groups/{customer_group_id}`

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
curl -X DELETE "https://api.noona.is/v1/hq/customer_groups/dwawd8awudawd"
```

Empty[Create a customer group POST](https://docs.noona.is/docs/hq/customer-groups/CreateCustomerGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/customer-groups/CreateCustomerGroup)[

Retrieve a customer group GET

Next Page

](https://docs.noona.is/docs/hq/customer-groups/GetCustomerGroup)