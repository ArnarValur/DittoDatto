---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Verification

Gets the file associated with a verification request. Returns a signed URL for accessing the file.

GET `/v1/hq/verifications/{userId}/file`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

userId \* string

The ID of the user whose verification file to retrieve

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/verifications/string/file"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "filename": "my_image.jpg",

  "type": "image/jpeg",

  "bytes": 0,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "signed_url": "string"

}
```

Empty

Empty

Empty

Empty

Empty[Create verification request POST](https://docs.noona.is/docs/hq/verification/CreateVerificationRequest)

[

Previous Page

](https://docs.noona.is/docs/hq/verification/CreateVerificationRequest)[

List verification requests GET

Next Page

](https://docs.noona.is/docs/hq/verification/ListVerificationRequests)