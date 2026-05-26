---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) User invites

Deletes (invalidates) a user invite. Only company owners can delete user invites.

DELETE `/v1/hq/user_invites/{user_invite_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

user\_invite\_id \* string

User invite ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/user_invites/string"
```

Empty

Empty

Empty[Create user invite POST](https://docs.noona.is/docs/hq/user-invites/CreateUserInvite)

[

Previous Page

](https://docs.noona.is/docs/hq/user-invites/CreateUserInvite)[

Get user invite context GET

Next Page

](https://docs.noona.is/docs/hq/user-invites/GetUserInviteContext)