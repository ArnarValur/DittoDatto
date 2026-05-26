---
tag: "noona.is"
---
Lists all customer groups of a company.

GET `/v1/hq/companies/{company_id}/customer_groups`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/customer_groups"
```

```
[

  {

    "id": "7dj29KiAE1wdjw731",

    "company": "QwYwhN8HH2CaFtwiW",

    "title": "Regulars",

    "description": "Customers that come in regularly",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[Retrieve a customer group GET](https://docs.noona.is/docs/hq/customer-groups/GetCustomerGroup)

[

Previous Page

](https://docs.noona.is/docs/hq/customer-groups/GetCustomerGroup)[

Update a customer group POST

Next Page

](https://docs.noona.is/docs/hq/customer-groups/UpdateCustomerGroup)