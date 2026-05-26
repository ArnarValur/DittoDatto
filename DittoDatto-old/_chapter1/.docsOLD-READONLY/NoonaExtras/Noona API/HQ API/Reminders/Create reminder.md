---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Reminders](https://docs.noona.is/docs/hq/reminders)

Creates a new reminder for a company.

POST `/v1/hq/reminders`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

title?string

Example `"Lunch reminder"`

company\_id \* string

Company ID

Example `"cmp123"`

employees?array<string>

Employee IDs for employee-specific reminders

event\_types?array<string>

Event type IDs for event-specific reminders

minutes\_before \* integer

How many minutes before the event to send the reminder

Format `int32`

Example `1440`

notification\_channels \* array<NotificationChannel>

Channels through which the reminder should be sent

sms\_content\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

active?boolean

Whether the reminder is active or inactive. Defaults to true if not provided.

Default `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/reminders" \

  -H "Content-Type: application/json" \

  -d '{

    "company_id": "cmp123",

    "minutes_before": 1440,

    "notification_channels": [

      "hq"

    ]

  }'
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

Empty[Reminders](https://docs.noona.is/docs/hq/reminders)

[

Previous Page

](https://docs.noona.is/docs/hq/reminders)[

Delete a reminder DELETE

Next Page

](https://docs.noona.is/docs/hq/reminders/DeleteReminder)