---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Transactions](https://docs.noona.is/docs/hq/transactions)

Delete a transaction

DELETE `/v1/hq/transactions/{transaction_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

transaction\_id \* string

Transaction ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/transactions/string"
```

Empty

Empty

Empty

Empty[Create a transaction POST](https://docs.noona.is/docs/hq/transactions/CreateTransaction)

[

Previous Page

](https://docs.noona.is/docs/hq/transactions/CreateTransaction)[

Retreive a single transaction GET

Next Page

](https://docs.noona.is/docs/hq/transactions/GetTransaction)