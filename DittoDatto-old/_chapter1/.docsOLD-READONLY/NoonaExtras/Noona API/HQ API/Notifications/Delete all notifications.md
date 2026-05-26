---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Notifications](https://docs.noona.is/docs/hq/notifications)

Deletes all notifications that user has access to at a company, including user specific notifications.

DELETE `/v1/hq/companies/{company_id}/notifications`

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
curl -X DELETE "https://api.noona.is/v1/hq/companies/dwawd8awudawd/notifications"
```

```
{

  "count": 3

}
```[Delete a notification DELETE](https://docs.noona.is/docs/hq/notifications/DeleteNotification)

[

Previous Page

](https://docs.noona.is/docs/hq/notifications/DeleteNotification)[

Retrieve a notification GET

Next Page

](https://docs.noona.is/docs/hq/notifications/GetNotification)