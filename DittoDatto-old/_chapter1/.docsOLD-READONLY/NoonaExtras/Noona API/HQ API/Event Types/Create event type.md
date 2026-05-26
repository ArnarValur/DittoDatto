---
tag: "noona.is"
---
Creates an event type

POST `/v1/hq/event_types`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

reference\_id?string

An ID that can be used to reference the event type in an external system. This ID is not used by Noona and is not guaranteed to be unique.

Example `"external-service-id"`

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

event\_type\_category?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

event\_type\_category\_group?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

title?string

Example `"Men's haircut"`

title\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

description?string

description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

minutes?integer Deprecated

Deprecated, please use duration instead

Format `int32`

Example `30`

duration?integer

Duration of the event type

Format `int32`

Example `30`

delay?integer

Delay in minutes from event start time

Format `int32`

Example `30`

beforePause?integer

The event duration before the pause

Format `int32`

Example `30`

pause?integer

The pause duration

Format `int32`

Example `30`

afterPause?integer

The event duration after the pause

Format `int32`

Example `30`

buffer\_after\_service?integer

How many minutes of buffer the service needs after it ends. This does not affect the duration of the event shown to customers but is considered when calculating timeslots.

Format `int32`

Example `10`

min\_guests\_per\_booking?integer

Format `int32`

max\_guests\_per\_booking?integer

Format `int32`

thumb?string Deprecated

Use images instead.

Example `"https://cdn.noona.is/static/haircut-thumb.png"`

image?string Deprecated

Use images instead.

Example `"https://cdn.noona.is/static/haircut-org.png"`

images?

color?string

Color code for the event

Example `"#66d8cd"`

overbookable?string

How event is overbookable

Format `enum`

Example `"partially_overbookable"`

vat?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

variations?

price\_ranges?

connections?

custom\_payment\_settings?boolean Deprecated

By providing a **payments** object this is implicitly `true`.

By using the unset query parameter and passing in the **payments** key this is implicitly `false`.

payments?

tax\_exemption\_reason?string

The reason for tax exemption. This is only used if the event type is tax exempt. If the event type is not tax exempt, this field is ignored.

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/event_types" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "reference_id": "external-service-id",

  "company": "string",

  "event_type_category": "string",

  "event_type_category_group": "string",

  "title": "Men's haircut",

  "title_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "description": "30 minute men's haircut",

  "description_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "minutes": 30,

  "duration": 30,

  "delay": 30,

  "beforePause": 30,

  "pause": 30,

  "afterPause": 30,

  "buffer_after_service": 10,

  "min_guests_per_booking": 0,

  "max_guests_per_booking": 0,

  "thumb": "https://cdn.noona.is/static/haircut-thumb.png",

  "image": "https://cdn.noona.is/static/haircut-org.png",

  "images": [

    {

      "thumb": "https://placekitten.com/200/200",

      "image": "https://placekitten.com/200/300",

      "public_id": "https://placekitten.com/200/300",

      "type": "thumbnail",

      "provider": "cloudinary",

      "width": 200,

      "height": 300,

      "bytes": 95849

    }

  ],

  "color": "#66d8cd",

  "overbookable": "partially_overbookable",

  "vat": "string",

  "variations": [

    {

      "id": "string",

      "label": "Premium",

      "label_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "description": "Premium service with extra attention",

      "description_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "selectable_in_marketplace": true,

      "prices": [

        {

          "currency": "EUR",

          "amount": 40

        }

      ],

      "customer_group": "string"

    }

  ],

  "price_ranges": [

    {

      "min": 10,

      "max": 30,

      "currency": "EUR"

    }

  ],

  "connections": {

    "service_needs": "employee",

    "customer_selects": "employee",

    "booking_question": "What color do you want to dye your hair?",

    "booking_question_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "booking_questions": [

      {

        "id": "string",

        "title": "string",

        "title_translations": {

          "is": "King Accounting tenging",

          "fr": "Connexion King Accounting"

        },

        "description": "string",

        "description_translations": {

          "is": "King Accounting tenging",

          "fr": "Connexion King Accounting"

        },

        "answer_required": true,

        "answer_type": "string"

      }

    ],

    "booking_success_message": "Remember to bring your smile with you!",

    "booking_success_message_translations": {

      "is": "King Accounting tenging",

      "fr": "Connexion King Accounting"

    },

    "hidden": true

  },

  "custom_payment_settings": true,

  "payments": {

    "pre_payment_enabled": true,

    "pre_payment_type": "payment",

    "pre_payment_required": true,

    "pre_payment_min_pax": 1,

    "flat_fee": 100000,

    "pre_payment_ratio": 20,

    "optional_full_payment": true,

    "settlement_account": "string",

    "onboarded_at": "2019-08-24T14:15:22Z",

    "enabled_card_types": [

      "visa"

    ]

  },

  "price": {

    "currency": "ISK",

    "amount": 10000,

    "amount_upper_limit": 10000

  },

  "tax_exemption_reason": "string",

  "created_at": "2019-01-01T00:00:00.000Z",

  "updated_at": "2019-01-02T00:00:00.000Z"

}
```

Empty

Empty

Empty[Event Types](https://docs.noona.is/docs/hq/event-types)

[

Previous Page

](https://docs.noona.is/docs/hq/event-types)[

Delete event type DELETE

Next Page

](https://docs.noona.is/docs/hq/event-types/DeleteEventType)