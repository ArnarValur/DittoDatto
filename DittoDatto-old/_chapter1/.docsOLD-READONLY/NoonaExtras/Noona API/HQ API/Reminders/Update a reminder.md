---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Reminders](https://docs.noona.is/docs/hq/reminders)

Updates a reminder.

POST `/v1/hq/reminders/{reminder_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

reminder\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

title?string

Example `"Lunch reminder"`

employees?array<string>

Employee IDs for employee-specific reminders

event\_types?array<string>

Event type IDs for event-specific reminders

minutes\_before?integer

How many minutes before the event to send the reminder

Format `int32`

Example `1440`

notification\_channels?array<NotificationChannel>

Channels through which the reminder should be sent

sms\_content\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

active?boolean

Whether the reminder is active or inactive

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/reminders/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "8wa9uiah28dawd123",

  "title": "Lunch reminder",

  "company": "string",

  "employees": [

    "emp123",

    "emp456"

  ],

  "event_types": [

    "svc123",

    "svc456"

  ],

  "minutes_before": 1440,

  "notification_channels": [

    "sms"

  ],

  "sms_content": "Hi {{customer_name}}, this is a reminder that {{employee_name}} will see you at {{event_time}} at {{company_name}}",

  "sms_content_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "default": true,

  "active": true,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "type": "validation",

  "message": "string",

  "user_message": "A global reminder with this time period already exists"

}
```

Empty

Empty

Empty[List reminders GET](https://docs.noona.is/docs/hq/reminders/ListReminders)

[

Previous Page

](https://docs.noona.is/docs/hq/reminders/ListReminders)[

Create a new report POST

Next Page

](https://docs.noona.is/docs/hq/reports/createReport)