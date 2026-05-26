---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Google calendar

Deletes the Google Calendar connection for the user.

DELETE `/v1/hq/user/google_calendar_connection`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/user/google_calendar_connection"
```

Empty[Create Google Calendar connection POST](https://docs.noona.is/docs/hq/google-calendar/CreateGoogleCalendarConnection)

[

Previous Page

](https://docs.noona.is/docs/hq/google-calendar/CreateGoogleCalendarConnection)[

Get Google Calendar connection GET

Next Page

](https://docs.noona.is/docs/hq/google-calendar/GetGoogleCalendarConnection)