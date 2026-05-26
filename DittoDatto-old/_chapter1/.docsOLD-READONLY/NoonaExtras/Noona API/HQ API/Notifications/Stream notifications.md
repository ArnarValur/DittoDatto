---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Notifications](https://docs.noona.is/docs/hq/notifications)

Streams all notifications at a company.

GET `/v1/hq/stream/companies/{company_id}/notifications`

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
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd/notifications"
```

Empty[List all notifications GET](https://docs.noona.is/docs/hq/notifications/ListNotifications)

[

Previous Page

](https://docs.noona.is/docs/hq/notifications/ListNotifications)[

OAuth

Next Page

](https://docs.noona.is/docs/hq/oauth)