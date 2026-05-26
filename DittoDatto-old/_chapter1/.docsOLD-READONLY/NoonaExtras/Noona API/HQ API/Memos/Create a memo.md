---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Memos

Creates a memo for a company.

POST `/v1/hq/memos`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

company \* string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

employee?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

title \* string

content?string

date?string

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/memos" \

  -H "Content-Type: application/json" \

  -d '{

    "company": "string",

    "title": "string"

  }'
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
```[Update a line item POST](https://docs.noona.is/docs/hq/line-items/UpdateLineItem)

[

Previous Page

](https://docs.noona.is/docs/hq/line-items/UpdateLineItem)[

Delete a memo DELETE

Next Page

](https://docs.noona.is/docs/hq/memos/DeleteMemo)