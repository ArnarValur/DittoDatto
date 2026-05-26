---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Notifications](https://docs.noona.is/docs/hq/notifications)

Creates a notification at company.

POST `/v1/hq/notifications`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Request Body

application/json

title \* string

Example `"Something happened"`

message \* string

company \* string

Example `"daw89dw9a7wd9a8w7d"`

employee \* string

Example `"daw89dw9a7wd9a8w7d"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/notifications" \

  -H "Content-Type: application/json" \

  -d '{

    "title": "Something happened",

    "message": "This is more details about what happened",

    "company": "daw89dw9a7wd9a8w7d",

    "employee": "daw89dw9a7wd9a8w7d"

  }'
```

Empty[Notifications](https://docs.noona.is/docs/hq/notifications)

[

Previous Page

](https://docs.noona.is/docs/hq/notifications)[

Delete a notification DELETE

Next Page

](https://docs.noona.is/docs/hq/notifications/DeleteNotification)