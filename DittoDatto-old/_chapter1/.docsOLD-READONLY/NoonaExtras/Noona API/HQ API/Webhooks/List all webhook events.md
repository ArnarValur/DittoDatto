---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Webhooks](https://docs.noona.is/docs/hq/webhooks)

Lists all events that can be used to trigger a webhook.

GET `/v1/hq/webhooks/events`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/webhooks/events"
```

```
[

  "event.created",

  "event.updated",

  "event.deleted"

]
```[Retrieve a webhook GET](https://docs.noona.is/docs/hq/webhooks/GetWebhook)

[

Previous Page

](https://docs.noona.is/docs/hq/webhooks/GetWebhook)[

List all webhooks GET

Next Page

](https://docs.noona.is/docs/hq/webhooks/ListWebhooks)