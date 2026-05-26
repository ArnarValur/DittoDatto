---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Resources](https://docs.noona.is/docs/hq/resources)

Creates a resource for a company.

POST `/v1/hq/resources`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

id?string

Example `"7dj29KiAE1wdjw731"`

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

resource\_group?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

type?string

Format `enum`

name?string

Example `"Table 1"`

name\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

description?string

description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

priority?string

Controls the priority of the resource when being randomly selected in the booking process.

Format `enum`

image?

reference\_id?string

The reference ID of the resource.

Example `"1234567890"`

marketplace?boolean

If true, resource is visible on the marketplace.

Example `true`

available\_for\_bookings?boolean

Whether the resource is visible on the calendar

Example `true`

booking\_interval?integer

Booking interval in minutes.

Dictates how often customers can book events with employee or resource.

A booking interval of 15 would render results like: `10:00` `10:15` `10:30`.

A booking interval is set on the company level but can be overridden on the resource/employee level.

Default `15`

Format `int32`

Example `15`

order?integer

The order of the resource in the list of resources on the marketplace and in the HQ UI.

Format `int32`

Example `1`

min\_capacity?integer

The mininum capacity of the resource, for example how many people can occupy a table at minimum.

Format `int32`

Example `1`

max\_capacity?integer

The maximum capacity of the resource, for example how many people can occupy a table at maximum.

Format `int32`

Example `2`

allow\_overlapping\_bookings?boolean

If true, multiple bookings per timeslot is allowed for this resource.

Example `false`

sub\_resources?array<string>

event\_type\_preferences?

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/resources" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7dj29KiAE1wdjw731",

  "company": "string",

  "resource_group": {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "resources": [

      {

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

      }

    ],

    "title": "Lunch",

    "order": 1,

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

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

}
```[Resources](https://docs.noona.is/docs/hq/resources)

[

Previous Page

](https://docs.noona.is/docs/hq/resources)[

Delete resource DELETE

Next Page

](https://docs.noona.is/docs/hq/resources/DeleteResource)