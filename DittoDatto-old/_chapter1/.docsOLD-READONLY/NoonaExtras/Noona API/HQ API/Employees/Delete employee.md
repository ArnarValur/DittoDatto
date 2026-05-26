---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Employees](https://docs.noona.is/docs/hq/employees)

Deletes an employee at a company.

DELETE `/v1/hq/companies/{company_id}/employees/{employee_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

employee\_id \* string

Employee ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/companies/dwawd8awudawd/employees/string"
```

Empty[Create an employee POST](https://docs.noona.is/docs/hq/employees/CreateEmployee)

[

Previous Page

](https://docs.noona.is/docs/hq/employees/CreateEmployee)[

Retrieve an employee GET

Next Page

](https://docs.noona.is/docs/hq/employees/GetEmployee)