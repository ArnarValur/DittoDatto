---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subtransactions](https://docs.noona.is/docs/hq/subtransactions)

Creates a new subtransaction for a transaction or sale.

**Cash** and **Other** payment methods are settled immedietly.

The **Card** payment method gets created in the *unprocessed* state, wakes up the companies terminal and will be updated to *successful* once a payment has been made.

POST `/v1/hq/subtransactions`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

amount \* number

Format `double`

Example `2990`

currency \* string

Example `"ISK"`

payment\_method\_id?string

Example `"31aadiah28usli390"`

payment\_method\_instance\_id \* string

Example `"8nH4ahiOWX0ueoyphoWomeuu"`

data?| | | |

transaction\_id \* string

Example `"8wa9uiah28dawd123"`

note?string

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/subtransactions" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
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
```

Empty[Subtransactions](https://docs.noona.is/docs/hq/subtransactions)

[

Previous Page

](https://docs.noona.is/docs/hq/subtransactions)[

Delete a subtransaction DELETE

Next Page

](https://docs.noona.is/docs/hq/subtransactions/DeleteSubtransaction)