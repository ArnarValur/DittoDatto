---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Resources](https://docs.noona.is/docs/hq/resources)

Deletes a resource at a company.

DELETE `/v1/hq/resources/{resource_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

resource\_id \* string

Resource ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/resources/string"
```

Empty[Create a resource POST](https://docs.noona.is/docs/hq/resources/CreateResource)

[

Previous Page

](https://docs.noona.is/docs/hq/resources/CreateResource)[

Retrieve a resource GET

Next Page

](https://docs.noona.is/docs/hq/resources/GetResource)