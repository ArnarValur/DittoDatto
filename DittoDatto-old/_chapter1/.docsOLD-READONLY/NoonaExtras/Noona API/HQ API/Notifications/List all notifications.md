---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Notifications](https://docs.noona.is/docs/hq/notifications)

Lists all notifications at a company.

GET `/v1/hq/companies/{company_id}/notifications`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body[Retrieve a notification GET](https://docs.noona.is/docs/hq/notifications/GetNotification)

[

Previous Page

](https://docs.noona.is/docs/hq/notifications/GetNotification)[

Stream notifications GET

Next Page

](https://docs.noona.is/docs/hq/notifications/StreamNotifications)