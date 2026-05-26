---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Applications](https://docs.noona.is/docs/hq/applications)

Returns the users for the oauth application with the specified id.

GET `/v1/hq/oauth/applications/{application_id}/users`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

application\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/oauth/applications/dwawd8awudawd/users"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "name": "Best Company",

    "logo": "https://example.com/logo.png",

    "country": "IS"

  }

]
```[List applications GET](https://docs.noona.is/docs/hq/applications/ListOAuthApplications)

[

Previous Page

](https://docs.noona.is/docs/hq/applications/ListOAuthApplications)[

Update application POST

Next Page

](https://docs.noona.is/docs/hq/applications/UpdateOAuthApplication)