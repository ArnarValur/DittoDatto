---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Waitlists](https://docs.noona.is/docs/marketplace/waitlists)

Lists all waitlist entries for user.

```
curl -X GET "https://api.noona.is/v1/marketplace/waitlist_entries"
```

```
[

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

]
```[Get waitlist entry GET](https://docs.noona.is/docs/marketplace/waitlists/GetWaitlistEntry)

[

Previous Page

](https://docs.noona.is/docs/marketplace/waitlists/GetWaitlistEntry)[

App Store

](https://docs.noona.is/docs/app-store)