---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Memos

Lists all memos of a company.

GET `/v1/hq/companies/{company_id}/memos`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/memos"
```

```
[

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

]
```[Retrieve a memo GET](https://docs.noona.is/docs/hq/memos/GetMemo)

[

Previous Page

](https://docs.noona.is/docs/hq/memos/GetMemo)[

Update a memo POST

Next Page

](https://docs.noona.is/docs/hq/memos/UpdateMemo)