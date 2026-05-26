---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Cancels a subscription with churn reasons

POST `/v1/hq/subscriptions/{subscription_id}/cancel`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

subscription\_id \* string

Subscription id

## Query Parameters

## Request Body

application/json

churn\_reasons?SubscriptionChurnReasons

churn\_elaboration?string

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/subscriptions/string/cancel" \

  -H "Content-Type: application/json" \

  -d '{}'
```

Empty

Empty

Empty

Empty

Empty

Empty[Acknowledge trial end for company subscription POST](https://docs.noona.is/docs/hq/subscriptions/AcknowledgeTrialEnd)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/AcknowledgeTrialEnd)[

Create a payment intent POST

Next Page

](https://docs.noona.is/docs/hq/subscriptions/CreatePaymentIntent)