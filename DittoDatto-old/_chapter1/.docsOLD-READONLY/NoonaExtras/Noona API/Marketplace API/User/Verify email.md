---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [User](https://docs.noona.is/docs/marketplace/marketplace-user)

Verify email with a token from the verification email.

```
curl -X POST "https://api.noona.is/v1/marketplace/user/verify_email" \

  -H "Content-Type: application/json" \

  -d '{

    "token": "AwxswpSz06iTefog91MMAG6X9fS7ZOsPwO7NMa5"

  }'
```

Empty

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Update user POST](https://docs.noona.is/docs/marketplace/marketplace-user/UpdateUser)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-user/UpdateUser)[

Verify phone number POST

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-user/VerifyPhoneNumber)