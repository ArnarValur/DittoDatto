---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Webhooks](https://docs.noona.is/docs/hq/webhooks)

Updates a webhook at a company.

POST `/v1/hq/webhooks/{webhook_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

webhook\_id \* string

Webhook ID

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

## Response Body[List all webhooks GET](https://docs.noona.is/docs/hq/webhooks/ListWebhooks)

[

Previous Page

](https://docs.noona.is/docs/hq/webhooks/ListWebhooks)[

Marketplace API

Build booking experiences for customers to discover and book services

](https://docs.noona.is/docs/marketplace)