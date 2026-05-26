---
tag: "noona.is"
---
Streams blocked times for a company.

GET `/v1/hq/stream/companies/{company_id}/blocked_times`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/blocked_times"
```

Empty[List blocked times GET](https://docs.noona.is/docs/hq/blocked-times/ListBlockedTimes)

[

Previous Page

](https://docs.noona.is/docs/hq/blocked-times/ListBlockedTimes)[

Update a blocked time POST

Next Page

](https://docs.noona.is/docs/hq/blocked-times/UpdateBlockedTime)