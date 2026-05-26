---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Applications](https://docs.noona.is/docs/hq/applications)

Returns the metrics for the oauth application with the specified id.

GET `/v1/hq/oauth/applications/{application_id}/metrics`

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
curl -X GET "https://api.noona.is/v1/hq/oauth/applications/dwawd8awudawd/metrics"
```

```
{

  "approved": true,

  "users": {

    "timeframe": 0,

    "timeframe_week_before": 0,

    "percent_change": 0

  },

  "revenue": {

    "this_month": 0,

    "last_month": 0,

    "percent_change": 0,

    "currency": "ISK"

  }

}
```[Get application GET](https://docs.noona.is/docs/hq/applications/GetOAuthApplication)

[

Previous Page

](https://docs.noona.is/docs/hq/applications/GetOAuthApplication)[

List application events GET

Next Page

](https://docs.noona.is/docs/hq/applications/ListOAuthApplicationEvents)