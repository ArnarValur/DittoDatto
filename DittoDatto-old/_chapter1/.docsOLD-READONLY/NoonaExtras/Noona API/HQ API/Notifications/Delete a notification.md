---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Notifications](https://docs.noona.is/docs/hq/notifications)

Deletes a notification at a users company.

DELETE `/v1/hq/notifications/{notification_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

notification\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/notifications/dwawd8awudawd"
```

Empty

Empty[Create a notification POST](https://docs.noona.is/docs/hq/notifications/CreateNotification)

[

Previous Page

](https://docs.noona.is/docs/hq/notifications/CreateNotification)[

Delete all notifications DELETE

Next Page

](https://docs.noona.is/docs/hq/notifications/DeleteNotifications)