---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Download billing invoice PDF

GET `/v1/hq/subscriptions/invoices/{invoice_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

invoice\_id \* string

Invoice id

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/subscriptions/invoices/string"
```

```
{

  "download_url": "string"

}
```

Empty

Empty[Create a subscription for company POST](https://docs.noona.is/docs/hq/subscriptions/CreateSubscription)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/CreateSubscription)[

Retrieve subscription for company GET

Next Page

](https://docs.noona.is/docs/hq/subscriptions/GetSubscription)