---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Line items

Deletes a line item if allowed

DELETE `/v1/hq/line_items/{line_item_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

line\_item\_id \* string

Line Item ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/line_items/string"
```

Empty

Empty

Empty

Empty[Create a line item POST](https://docs.noona.is/docs/hq/line-items/CreateLineItem)

[

Previous Page

](https://docs.noona.is/docs/hq/line-items/CreateLineItem)[

Retrieve line item GET

Next Page

](https://docs.noona.is/docs/hq/line-items/GetLineItem)