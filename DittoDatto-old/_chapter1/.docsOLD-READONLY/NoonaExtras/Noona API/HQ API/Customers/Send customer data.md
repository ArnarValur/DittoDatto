---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Customers](https://docs.noona.is/docs/hq/customers)

Emails the customer overview of the data stored about them in the system.

POST `/v1/hq/customers/{customer_id}/send`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

customer\_id \* string

Customer ID

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

email \* string

Example `"someone@example.com"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/customers/dwawd8awudawd/send" \

  -H "Content-Type: application/json" \

  -d '{

    "email": "someone@example.com"

  }'
```

Empty[Merge customers POST](https://docs.noona.is/docs/hq/customers/MergeCustomers)

[

Previous Page

](https://docs.noona.is/docs/hq/customers/MergeCustomers)[

Update a customer POST

Next Page

](https://docs.noona.is/docs/hq/customers/UpdateCustomer)