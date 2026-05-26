---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Notifications](https://docs.noona.is/docs/hq/notifications)

Retrieves a notification at a users company.

GET `/v1/hq/notifications/{notification_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

notification\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body[Delete all notifications DELETE](https://docs.noona.is/docs/hq/notifications/DeleteNotifications)

[

Previous Page

](https://docs.noona.is/docs/hq/notifications/DeleteNotifications)[

List all notifications GET

Next Page

](https://docs.noona.is/docs/hq/notifications/ListNotifications)