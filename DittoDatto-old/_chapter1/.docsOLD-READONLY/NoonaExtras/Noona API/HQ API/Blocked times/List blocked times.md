---
tag: "noona.is"
---
Lists blocked times for a company with provided filters. The maximum queryable range is 31 days as repeating blocked times could be expanded infinitely.

GET `/v1/hq/companies/{company_id}/blocked_times`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

from \* string

Include blocked times starting on this date

Format `date-time`

Example `"2022-09-12T00:00:00Z"`

to \* string

Include blocked times ending before this date

Format `date-time`

Example `"2022-09-19T00:00:00Z"`

filter?

[Filtering](https://api.noona.is/docs/working-with-the-apis/filtering)

sort?

[Sorting](https://api.noona.is/docs/working-with-the-apis/sorting)

pagination?

[Pagination](https://api.noona.is/docs/working-with-the-apis/pagination)

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/blocked_times?from=2022-09-12T00%3A00%3A00Z&to=2022-09-19T00%3A00%3A00Z"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "employee": "string",

    "space": "string",

    "resource": {

      "id": "7dj29KiAE1wdjw731",

      "company": "string",

      "resource_group": {

        "id": "string"

      },

      "type": "space",

      "name": "Table 1",

      "name_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "description": "A good window view",

      "description_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "priority": "normal",

      "image": {

        "thumb": "https://placekitten.com/200/200",

        "image": "https://placekitten.com/200/300",

        "public_id": "https://placekitten.com/200/300",

        "type": "thumbnail",

        "provider": "cloudinary",

        "width": 200,

        "height": 300,

        "bytes": 95849

      },

      "reference_id": "1234567890",

      "marketplace": true,

      "available_for_bookings": true,

      "booking_interval": 15,

      "order": 1,

      "min_capacity": 1,

      "max_capacity": 2,

      "allow_overlapping_bookings": false,

      "sub_resources": [

        "string"

      ],

      "event_type_preferences": [

        {

          "event_type": "string",

          "skip": false,

          "skip_calendar": false,

          "skip_marketplace": false,

          "has_custom_duration": false,

          "custom_duration": {

            "duration": 60,

            "before_pause": 25,

            "pause": 10,

            "after_pause": 25

          }

        }

      ],

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z"

    },

    "title": "Lunch",

    "starts_at": "2022-09-12T12:00:00Z",

    "ends_at": "2022-09-12T13:00:00Z",

    "date": "2022-09-12",

    "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

    "duration": 60,

    "theme": "themeblack",

    "created_by": "string",

    "updated_by": "string",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty

Empty

Empty[Retrieve a blocked time GET](https://docs.noona.is/docs/hq/blocked-times/GetBlockedTime)

[

Previous Page

](https://docs.noona.is/docs/hq/blocked-times/GetBlockedTime)[

Stream blocked times GET

Next Page

](https://docs.noona.is/docs/hq/blocked-times/StreamBlockedTimes)