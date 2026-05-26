---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Google calendar

Creates a new Google Calendar connection for the user.

POST `/v1/hq/user/google_calendar_connection`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Request Body

application/json

sync\_events?boolean

Whether events should be synced between Noona and Google Calendar.

Default `true`

Example `true`

sync\_blocked\_times\_to\_google?boolean

Whether blocked times should be synced from Noona to Google.

Default `true`

Example `true`

sync\_blocked\_times\_to\_noona?boolean

Whether blocked times should be synced from Google to Noona.

Default `true`

Example `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user/google_calendar_connection" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "name": "Noona",

  "sync_events": true,

  "sync_blocked_times_to_google": true,

  "sync_blocked_times_to_noona": true

}
```[Update a task POST](https://docs.noona.is/docs/hq/goals/UpdateTask)

[

Previous Page

](https://docs.noona.is/docs/hq/goals/UpdateTask)[

Delete Google Calendar connection DELETE

Next Page

](https://docs.noona.is/docs/hq/google-calendar/DeleteGoogleCalendarConnection)