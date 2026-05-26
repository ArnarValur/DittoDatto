---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Applications](https://docs.noona.is/docs/hq/applications)

Returns the events for the oauth application with the specified id.

GET `/v1/hq/oauth/applications/{application_id}/events`

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
curl -X GET "https://api.noona.is/v1/hq/oauth/applications/dwawd8awudawd/events"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "public_company": "string",

    "application": "string",

    "event": "installed",

    "created_at": "2019-08-24T14:15:22Z"

  }

]
```[Get application metrics GET](https://docs.noona.is/docs/hq/applications/GetOAuthApplicationMetrics)

[

Previous Page

](https://docs.noona.is/docs/hq/applications/GetOAuthApplicationMetrics)[

List application payouts GET

Next Page

](https://docs.noona.is/docs/hq/applications/ListOAuthApplicationPayouts)