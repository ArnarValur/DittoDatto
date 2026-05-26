---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [User](https://docs.noona.is/docs/marketplace/marketplace-user)

Requests deletion of the current marketplace user account. This marks the user with a deleteRequestedAt timestamp and sends a notification for manual processing.

```
curl -X DELETE "https://api.noona.is/v1/marketplace/user"
```

Empty

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Creates a new user POST](https://docs.noona.is/docs/marketplace/marketplace-user/CreateVerifiedUser)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-user/CreateVerifiedUser)[

Get user GET

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-user/GetUser)