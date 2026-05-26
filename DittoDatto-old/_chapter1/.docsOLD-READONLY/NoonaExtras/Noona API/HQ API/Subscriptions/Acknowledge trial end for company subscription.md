---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Acknowledges the end of a trial period for a specific subscription type within a company. This endpoint works for trial subscriptions that don't have an active subscription ID yet.

Use this instead of the regular subscription cancellation endpoint for trial acknowledgments.

POST `/v1/hq/companies/{company_id}/subscriptions/acknowledge-trial-end`

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

The type of subscription (powerup) for which the trial is being acknowledged. This is required since a company can have multiple subscription types. Examples: appointments\_pro, pos, restaurants\_pro, noshow

Format `enum`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/dwawd8awudawd/subscriptions/acknowledge-trial-end" \

  -H "Content-Type: application/json" \

  -d '{

    "subscription_type": "appointments_pro"

  }'
```

Empty

Empty

Empty[Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions)[

Cancel subscription POST

Next Page

](https://docs.noona.is/docs/hq/subscriptions/CancelSubscription)