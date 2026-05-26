---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Applications](https://docs.noona.is/docs/hq/applications)

Returns the payouts for the oauth application with the specified id.

GET `/v1/hq/oauth/applications/{application_id}/payouts`

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
curl -X GET "https://api.noona.is/v1/hq/oauth/applications/dwawd8awudawd/payouts"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "amount": 0,

    "currency": "string",

    "status": "pending",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[List application events GET](https://docs.noona.is/docs/hq/applications/ListOAuthApplicationEvents)

[

Previous Page

](https://docs.noona.is/docs/hq/applications/ListOAuthApplicationEvents)[

List applications GET

Next Page

](https://docs.noona.is/docs/hq/applications/ListOAuthApplications)