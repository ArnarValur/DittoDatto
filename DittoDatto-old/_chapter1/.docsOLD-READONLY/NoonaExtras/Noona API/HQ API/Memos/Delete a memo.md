---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Memos

Deletes a memo of a company.

DELETE `/v1/hq/memos/{memo_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

memo\_id \* string

Memo ID

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/memos/dwawd8awudawd"
```

Empty[Create a memo POST](https://docs.noona.is/docs/hq/memos/CreateMemo)

[

Previous Page

](https://docs.noona.is/docs/hq/memos/CreateMemo)[

Retrieve a memo GET

Next Page

](https://docs.noona.is/docs/hq/memos/GetMemo)