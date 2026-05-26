---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Webhooks](https://docs.noona.is/docs/hq/webhooks)

Creates a webhook for a company. The webhook will be triggered when any of the defined events occur.

POST `/v1/hq/webhooks`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

## Response Body

## Callbacks

event[Webhooks](https://docs.noona.is/docs/hq/webhooks)

[

Previous Page

](https://docs.noona.is/docs/hq/webhooks)[

Delete webhook DELETE

Next Page

](https://docs.noona.is/docs/hq/webhooks/DeleteWebhook)