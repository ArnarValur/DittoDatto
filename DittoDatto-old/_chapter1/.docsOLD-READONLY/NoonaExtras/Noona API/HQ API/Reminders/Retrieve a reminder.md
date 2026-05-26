---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Reminders](https://docs.noona.is/docs/hq/reminders)

Get a single reminder by ID.

GET `/v1/hq/reminders/{reminder_id}`

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
curl -X GET "https://api.noona.is/v1/hq/reminders/dwawd8awudawd"
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

Empty

Empty

Empty[Delete a reminder DELETE](https://docs.noona.is/docs/hq/reminders/DeleteReminder)

[

Previous Page

](https://docs.noona.is/docs/hq/reminders/DeleteReminder)[

List reminders GET

Next Page

](https://docs.noona.is/docs/hq/reminders/ListReminders)