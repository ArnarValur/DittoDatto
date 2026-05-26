---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Google calendar

Returns the Google Calendar connection for the user.

GET `/v1/hq/user/google_calendar_connection`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/user/google_calendar_connection"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "name": "Noona",

  "sync_events": true,

  "sync_blocked_times_to_google": true,

  "sync_blocked_times_to_noona": true

}
```[Delete Google Calendar connection DELETE](https://docs.noona.is/docs/hq/google-calendar/DeleteGoogleCalendarConnection)

[

Previous Page

](https://docs.noona.is/docs/hq/google-calendar/DeleteGoogleCalendarConnection)[

List Holidays GET

Next Page

](https://docs.noona.is/docs/hq/holidays/ListHolidays)