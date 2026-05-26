---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Webhooks](https://docs.noona.is/docs/hq/webhooks)

Deletes a webhook at company.

DELETE `/v1/hq/webhooks/{webhook_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

webhook\_id \* string

Webhook ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/webhooks/string"
```

Empty[Create a webhook POST](https://docs.noona.is/docs/hq/webhooks/CreateWebhook)

[

Previous Page

](https://docs.noona.is/docs/hq/webhooks/CreateWebhook)[

Retrieve a webhook GET

Next Page

](https://docs.noona.is/docs/hq/webhooks/GetWebhook)