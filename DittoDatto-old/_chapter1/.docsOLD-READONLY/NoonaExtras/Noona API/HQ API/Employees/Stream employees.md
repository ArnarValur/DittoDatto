---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Employees](https://docs.noona.is/docs/hq/employees)

Streams employees for a company.

GET `/v1/hq/stream/companies/{company_id}/employees`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/employees"
```

Empty[List all employees GET](https://docs.noona.is/docs/hq/employees/ListEmployees)

[

Previous Page

](https://docs.noona.is/docs/hq/employees/ListEmployees)[

Update an employee POST

Next Page

](https://docs.noona.is/docs/hq/employees/UpdateEmployee)