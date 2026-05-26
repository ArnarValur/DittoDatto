---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Reminders](https://docs.noona.is/docs/hq/reminders)

Delete a reminder (soft delete).

DELETE `/v1/hq/reminders/{reminder_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

reminder\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/reminders/dwawd8awudawd"
```

Empty

Empty

Empty

Empty[Create reminder POST](https://docs.noona.is/docs/hq/reminders/CreateReminder)

[

Previous Page

](https://docs.noona.is/docs/hq/reminders/CreateReminder)[

Retrieve a reminder GET

Next Page

](https://docs.noona.is/docs/hq/reminders/GetReminder)