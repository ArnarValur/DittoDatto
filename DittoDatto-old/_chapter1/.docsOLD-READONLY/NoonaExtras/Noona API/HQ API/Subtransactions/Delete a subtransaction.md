---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subtransactions](https://docs.noona.is/docs/hq/subtransactions)

Deletes a subtransaction.

DELETE `/v1/hq/subtransactions/{subtransaction_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

subtransaction\_id \* string

Subtransaction ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/subtransactions/string"
```

Empty

Empty[Create a subtransaction POST](https://docs.noona.is/docs/hq/subtransactions/CreateSubtransaction)

[

Previous Page

](https://docs.noona.is/docs/hq/subtransactions/CreateSubtransaction)[

Retrieve a subtransaction GET

Next Page

](https://docs.noona.is/docs/hq/subtransactions/GetSubtransaction)