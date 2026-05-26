---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) User invites

Gets the context of an user invite token and returns company information if valid. This endpoint is public and doesn't require authentication.

GET `/v1/hq/user_invites/{token}`

## Path Parameters

token \* string

User invite token

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/user_invites/string"
```

```
{

  "company_id": "string",

  "company_name": "string",

  "invited_by": "string",

  "email": "string",

  "is_valid": true,

  "expires_at": "2019-08-24T14:15:22Z"

}
```

Empty

```
{

  "message": "Customer onboarding error.",

  "code": "user_invite_expired"

}
```

Empty[Delete user invite DELETE](https://docs.noona.is/docs/hq/user-invites/DeleteUserInvite)

[

Previous Page

](https://docs.noona.is/docs/hq/user-invites/DeleteUserInvite)[

List user invites GET

Next Page

](https://docs.noona.is/docs/hq/user-invites/ListUserInvites)