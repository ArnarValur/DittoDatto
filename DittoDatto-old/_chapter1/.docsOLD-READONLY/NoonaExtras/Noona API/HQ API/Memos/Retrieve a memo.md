---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Memos

Retrieves information about a memo.

GET `/v1/hq/memos/{memo_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

memo\_id \* string

Memo ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/memos/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "employee": "string",

  "title": "string",

  "content": "string",

  "date": "string",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

Empty[Delete a memo DELETE](https://docs.noona.is/docs/hq/memos/DeleteMemo)

[

Previous Page

](https://docs.noona.is/docs/hq/memos/DeleteMemo)[

List all memos GET

Next Page

](https://docs.noona.is/docs/hq/memos/ListMemos)