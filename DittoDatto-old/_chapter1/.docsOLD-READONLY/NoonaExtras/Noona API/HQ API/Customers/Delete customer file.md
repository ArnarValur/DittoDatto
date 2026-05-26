---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Customers](https://docs.noona.is/docs/hq/customers)

Delete a file attached to a customer

DELETE `/v1/hq/customers/{customer_id}/files/{file_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

customer\_id \* string

Example `"dwawd8awudawd"`

file\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/customers/dwawd8awudawd/files/dwawd8awudawd"
```

Empty

Empty

Empty

Empty

Empty

Empty[Delete customer DELETE](https://docs.noona.is/docs/hq/customers/DeleteCustomer)

[

Previous Page

](https://docs.noona.is/docs/hq/customers/DeleteCustomer)[

Retrieve a customer GET

Next Page

](https://docs.noona.is/docs/hq/customers/GetCustomer)