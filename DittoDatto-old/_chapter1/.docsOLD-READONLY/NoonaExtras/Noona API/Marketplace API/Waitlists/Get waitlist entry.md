---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Waitlists](https://docs.noona.is/docs/marketplace/waitlists)

Get a waitlist entry by ID.

```
curl -X GET "https://api.noona.is/v1/marketplace/waitlist_entries/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "name": "John Doe",

  "email": "john.doe@example.com",

  "phone_country_code": "354",

  "phone_number": "12345678",

  "company": "string",

  "event_types": [

    "string"

  ],

  "employee": "string",

  "resource": "string",

  "number_of_guests": 1,

  "notes": "I can only make it after noon",

  "preferred_times": [

    {

      "date": "2024-10-08",

      "times": [

        "11:00"

      ]

    }

  ],

  "expires_at": "2024-10-08T11:00:00Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Delete waitlist entry DELETE](https://docs.noona.is/docs/marketplace/waitlists/DeleteWaitlistEntry)

[

Previous Page

](https://docs.noona.is/docs/marketplace/waitlists/DeleteWaitlistEntry)[

List waitlist entries GET

Next Page

](https://docs.noona.is/docs/marketplace/waitlists/ListWaitlistEntries)