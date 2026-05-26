---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Roles

DELETE `/v1/hq/roles/{role_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

role\_id \* string

ID of the role to delete

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/roles/string"
```

Empty

Empty

Empty[Create Role POST](https://docs.noona.is/docs/hq/roles/CreateRole)

[

Previous Page

](https://docs.noona.is/docs/hq/roles/CreateRole)[

Get Role GET

Next Page

](https://docs.noona.is/docs/hq/roles/GetRole)