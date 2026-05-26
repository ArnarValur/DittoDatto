---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Waitlists](https://docs.noona.is/docs/marketplace/waitlists)

Creates a waitlist entry at a company.

POST `/v1/marketplace/waitlist_entries`

Marketplace-Authentication

## Query Parameters

## Request Body

application/json

name?string

The name of the person on the waitlist entry.

*Only needed if the waitlist entry is not created by an authenticated marketplace user.*

Example `"John Doe"`

email?string

The email of the person on the waitlist entry.

*Only needed if the waitlist entry is not created by an authenticated marketplace user.*

Example `"john.doe@example.com"`

phone\_country\_code?string

The country code of the phone number of the person on the waitlist entry.

*Only needed if the waitlist entry is not created by an authenticated marketplace user.*

Example `"354"`

phone\_number?string

The phone number of the person on the waitlist entry.

*Only needed if the waitlist entry is not created by an authenticated marketplace user.*

Example `"12345678"`

company \* string |

[Expandable](https://docs.noona.is/docs/marketplace/waitlists/#section/Expandable-attributes)

event\_types \*

employee?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

resource?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

number\_of\_guests?integer

Number of guests for the event.

Format `int32`

Example `1`

notes?string

preferred\_times?

expires\_at?string Deprecated

The date and time when the waitlist entry expires.

Format `date-time`

Example `"2024-10-08T11:00:00Z"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/waitlist_entries" \

  -H "Content-Type: application/json" \

  -d '{

    "company": "string",

    "event_types": [

      "string"

    ]

  }'
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
```[Waitlists](https://docs.noona.is/docs/marketplace/waitlists)

[

Previous Page

](https://docs.noona.is/docs/marketplace/waitlists)[

Delete waitlist entry DELETE

Next Page

](https://docs.noona.is/docs/marketplace/waitlists/DeleteWaitlistEntry)