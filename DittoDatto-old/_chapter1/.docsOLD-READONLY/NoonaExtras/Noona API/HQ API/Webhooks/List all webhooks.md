---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Webhooks](https://docs.noona.is/docs/hq/webhooks)

Lists all webhooks of a company.

GET `/v1/hq/companies/{company_id}/webhooks`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body[List all webhook events GET](https://docs.noona.is/docs/hq/webhooks/ListWebhookEvents)

[

Previous Page

](https://docs.noona.is/docs/hq/webhooks/ListWebhookEvents)[

Update a webhook POST

Next Page

](https://docs.noona.is/docs/hq/webhooks/UpdateWebhook)