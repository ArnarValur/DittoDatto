---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq)

Lists available dietaries.

GET `/v1/hq/dietaries`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/dietaries"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "name": "Bistro",

    "readable_id": "bistro",

    "order": 1,

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[Create claim POST](https://docs.noona.is/docs/hq/claims/CreateClaim)

[

Next Page

](https://docs.noona.is/docs/hq/claims/CreateClaim)