---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Notification settings

Returns the structure of available notification categories, subcategories, and channels. This configuration is used to dynamically render notification settings UI.

GET `/v1/hq/companies/{company_id}/notifications_settings`

## Path Parameters

company\_id \* string

ID of the company to list notification settings for

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/notifications_settings"
```

```
[

  {

    "id": "online_bookings",

    "title": "Appointments in online bookings",

    "readable_id": "own_online_bookings",

    "subcategories": [

      {

        "id": "new_bookings",

        "title": "New appointments",

        "readable_id": "new_bookings",

        "channels": [

          {

            "id": "hq",

            "title": "In HQ",

            "readable_id": "hq",

            "locked": false

          }

        ]

      }

    ]

  }

]
```

Empty

Empty

Empty[Update booking channel POST](https://docs.noona.is/docs/hq/mozrest/UpdateMozrestBookingChannel)

[

Previous Page

](https://docs.noona.is/docs/hq/mozrest/UpdateMozrestBookingChannel)[

Notifications

Next Page

](https://docs.noona.is/docs/hq/notifications)