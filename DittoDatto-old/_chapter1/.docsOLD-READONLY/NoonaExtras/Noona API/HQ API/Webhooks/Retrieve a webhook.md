---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Webhooks](https://docs.noona.is/docs/hq/webhooks)

Retrieves information about an existing webhook.

GET `/v1/hq/webhooks/{webhook_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

webhook\_id \* string

Webhook ID

## Query Parameters

## Response Body[Delete webhook DELETE](https://docs.noona.is/docs/hq/webhooks/DeleteWebhook)

[

Previous Page

](https://docs.noona.is/docs/hq/webhooks/DeleteWebhook)[

List all webhook events GET

Next Page

](https://docs.noona.is/docs/hq/webhooks/ListWebhookEvents)