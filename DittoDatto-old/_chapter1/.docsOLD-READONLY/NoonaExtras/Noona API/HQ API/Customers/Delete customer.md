---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Customers](https://docs.noona.is/docs/hq/customers)

Deletes a customer at company.

DELETE `/v1/hq/customers/{customer_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

customer\_id \* string

Customer ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/customers/string"
```

Empty[Create a customer POST](https://docs.noona.is/docs/hq/customers/CreateCustomer)

[

Previous Page

](https://docs.noona.is/docs/hq/customers/CreateCustomer)[

Delete customer file DELETE

Next Page

](https://docs.noona.is/docs/hq/customers/DeleteCustomerFile)