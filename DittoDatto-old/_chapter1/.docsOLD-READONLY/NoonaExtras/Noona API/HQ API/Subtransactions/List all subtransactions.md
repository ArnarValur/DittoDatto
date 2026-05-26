---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subtransactions](https://docs.noona.is/docs/hq/subtransactions)

Lists all subtransactions that belong to a transaction.

GET `/v1/hq/transactions/{transaction_id}/subtransactions`

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
curl -X GET "https://api.noona.is/v1/hq/transactions/string/subtransactions"
```

```
[

  {

    "id": "8wa9uiah28dawd123",

    "amount": 2990,

    "currency": "ISK",

    "state": "pending",

    "failure_state": "declined",

    "origin": "checkin",

    "payment_method_id": "31aadiah28usli390",

    "payment_method_instance_id": "8nH4ahiOWX0ueoyphoWomeuu",

    "data": {

      "type": "terminal",

      "terminal_id": "9d8aj2oi2audawo"

    },

    "transaction_id": "8wa9uiah28dawd123",

    "note": "string",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty[Retrieve a subtransaction GET](https://docs.noona.is/docs/hq/subtransactions/GetSubtransaction)

[

Previous Page

](https://docs.noona.is/docs/hq/subtransactions/GetSubtransaction)[

Terminals

Next Page

](https://docs.noona.is/docs/hq/terminals)