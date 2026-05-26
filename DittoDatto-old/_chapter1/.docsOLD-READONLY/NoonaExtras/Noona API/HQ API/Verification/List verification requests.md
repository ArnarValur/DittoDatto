---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Verification

Lists verification requests that the current user can review.

GET `/v1/hq/verifications`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/verifications"
```

```
[

  {

    "user_id": "7awdXawZoolkjad37a",

    "email": "user@example.com",

    "name": "John Doe",

    "image": {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "public_id": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "provider": "cloudinary",

      "width": 200,

      "height": 300,

      "bytes": 95849

    },

    "verification": {

      "status": "pending",

      "file": "string",

      "certification_type": "cosmetology",

      "certification_level": "apprentice",

      "submitted_at": "2019-08-24T14:15:22Z",

      "approved_at": "2019-08-24T14:15:22Z",

      "rejected_at": "2019-08-24T14:15:22Z",

      "rejected_reason": "string"

    }

  }

]
```

Empty

Empty

Empty

Empty[Get verification request file GET](https://docs.noona.is/docs/hq/verification/GetVerificationRequestFile)

[

Previous Page

](https://docs.noona.is/docs/hq/verification/GetVerificationRequestFile)[

Update verification request status POST

Next Page

](https://docs.noona.is/docs/hq/verification/UpdateVerificationRequest)