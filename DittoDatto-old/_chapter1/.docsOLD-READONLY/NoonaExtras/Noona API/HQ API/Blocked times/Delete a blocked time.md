---
tag: "noona.is"
---
Delete blocked time for a company

DELETE `/v1/hq/blocked_times/{blocked_time_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

blocked\_time\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/blocked_times/dwawd8awudawd?date=2024-04-01"
```

Empty

```
{

  "message": "Customer onboarding error."

}
```

Empty

Empty

Empty[Create a blocked time POST](https://docs.noona.is/docs/hq/blocked-times/CreateBlockedTime)

[

Previous Page

](https://docs.noona.is/docs/hq/blocked-times/CreateBlockedTime)[

Retrieve a blocked time GET

Next Page

](https://docs.noona.is/docs/hq/blocked-times/GetBlockedTime)