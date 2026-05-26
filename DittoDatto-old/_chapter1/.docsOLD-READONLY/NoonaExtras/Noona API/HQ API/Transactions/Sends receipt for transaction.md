---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Transactions](https://docs.noona.is/docs/hq/transactions)

Sends a receipt to the specified user for the transaction with transaction\_id

POST `/v1/hq/sales/{sale_id}/transactions/{transaction_id}/send_receipt`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

sale\_id \* string

Sale ID

transaction\_id \* string

Transaction ID

## Request Body

application/json

email \* string

Example `"example@example.com"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/sales/string/transactions/string/send_receipt" \

  -H "Content-Type: application/json" \

  -d '{

    "email": "example@example.com"

  }'
```

Empty

Empty[List all transactions GET](https://docs.noona.is/docs/hq/transactions/ListTransactions)

[

Previous Page

](https://docs.noona.is/docs/hq/transactions/ListTransactions)[

Update a transaction POST

Next Page

](https://docs.noona.is/docs/hq/transactions/UpdateTransaction)