---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Starts the trial period for a specific subscription type within a company. This endpoint works for trial subscriptions that don't have an active subscription ID yet.

POST `/v1/hq/companies/{company_id}/subscriptions/start-trial`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

subscription\_type \* string

The type of subscription (powerup) for trial is being started. This is required since a company can have multiple subscription types. Examples: appointments\_pro, pos, restaurants\_pro, noshow

Format `enum`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/dwawd8awudawd/subscriptions/start-trial" \

  -H "Content-Type: application/json" \

  -d '{

    "subscription_type": "appointments_pro"

  }'
```

Empty

Empty

Empty

Empty[List plans for item family GET](https://docs.noona.is/docs/hq/subscriptions/ListBillingPlans)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/ListBillingPlans)[

Create or update billing info for customer POST

Next Page

](https://docs.noona.is/docs/hq/subscriptions/UpdateBillingInfo)