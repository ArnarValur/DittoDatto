---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [User](https://docs.noona.is/docs/marketplace/marketplace-user)

Verifies a phone number by sending a unique code to it.

The code is then used in conjuction with the phone number to create a new user or verify an existing one.

This endpoint can also be used to verify phone numbers of users that have authenticated with external identity providers.

```
curl -X POST "https://api.noona.is/v1/marketplace/user/verify_phone_number" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "next_retry_at": "2022-01-01T00:00:00Z"

}
```

```
{

  "type": "verify_phone_number_error",

  "message": "Verification already in progress",

  "code": "verification_in_progress"

}
```

```
{

  "type": "verify_phone_number_error",

  "message": "Verification already in progress",

  "code": "verification_in_progress"

}
```[Verify email POST](https://docs.noona.is/docs/marketplace/marketplace-user/VerifyEmail)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-user/VerifyEmail)[

Payments

Next Page

](https://docs.noona.is/docs/marketplace/payments)