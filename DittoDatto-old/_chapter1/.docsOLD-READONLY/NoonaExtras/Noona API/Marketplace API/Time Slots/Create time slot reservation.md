---
tag: "noona.is"
---
Creates a time slot reservation for a specific event type at a company.

The reservation can then be used to create an event.

POST `/v1/marketplace/time_slot_reservations`

Marketplace-Authentication

## Query Parameters

## Request Body

application/json

company?string |

[Expandable](https://docs.noona.is/docs/marketplace/time-slots/#section/Expandable-attributes)

event\_types?

variation\_selections?

The variations selected for the event type in a time slot reservation.

The total quantity of all variation selections must match the number of guests.

number\_of\_guests?integer

The total number of guests to book for.

Format `int32`

Example `10`

starts\_at?string

Format `date-time`

employee?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

space?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

booking\_question\_answers?

booking\_offer?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

scheduled\_event?string |

[Expandable](https://docs.noona.is/docs/marketplace/time-slots/#section/Expandable-attributes)

payment\_intents?

payment\_type?string

What to do with payment when creating an event.

`required` - Only pay the required amount in advance.

`full` - Pay the full amount in advance.

Default `"full"`

Format `enum`

Example `"full"`

phone\_country\_code?string

Example `354`

phone\_number?string

resources?array<string>

specific\_employee\_requested?boolean

specific\_space\_requested?boolean

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/time_slot_reservations" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "event_types": [

    "string"

  ],

  "variation_selections": [

    {

      "variation_id": "7awdXwZoedakjad37a",

      "event_type_id": "7awdXwZoedakjad37a",

      "quantity": 1

    }

  ],

  "number_of_guests": 10,

  "time_zone": "Atlantic/Reykjavik",

  "starts_at": "2019-08-24T14:15:22Z",

  "ends_at": "2019-08-24T14:15:22Z",

  "employee": "string",

  "space": "string",

  "booking_question_answers": [

    {

      "id": "string",

      "title": "string",

      "description": "string",

      "answer_required": true,

      "answer_type": "string",

      "answer": "string"

    }

  ],

  "booking_offer": {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "employee": "string",

    "time_slot_reservation": {

      "id": "string"

    },

    "waitlist_entry": "string",

    "is_desired_time": true,

    "message": "We have an opening for your requested service!",

    "expires_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  },

  "scheduled_event": "string",

  "payments": {

    "pre_payment_enabled": true,

    "pre_payment_type": "payment",

    "pre_payment_required": true,

    "pre_payment_min_pax": 1,

    "flat_fee": 100000,

    "pre_payment_ratio": 20,

    "optional_full_payment": true,

    "pre_payment_amount": 2000,

    "optional_pre_payment_amount": 10000,

    "on_location_payment_amount": 8000,

    "on_location_payment_amount_upper_limit": 8000,

    "pre_payment_currency": "ISK",

    "total_payment": 10000,

    "total_payment_upper_limit": 10000

  },

  "payment_intents": [

    {

      "id": "7awdXwZoedakjad37a",

      "method": "VoucherPayment",

      "voucher_code": "D6XC8A",

      "voucher": "string",

      "event_type_id": "7awdXwZoedakjad37a",

      "total_amount": 10000,

      "amount_to_use": 10000,

      "title": "Haircut",

      "sessions_total": 5

    }

  ],

  "payment_type": "full",

  "pending_payment_details": {

    "outstanding": 2000,

    "on_location": 8000,

    "on_location_upper_limit": 8000,

    "total": 10000,

    "total_upper_limit": 10000

  },

  "pending_payment_details_required": {

    "outstanding": 2000,

    "on_location": 8000,

    "on_location_upper_limit": 8000,

    "total": 10000,

    "total_upper_limit": 10000

  },

  "pending_payment_details_full": {

    "outstanding": 2000,

    "on_location": 8000,

    "on_location_upper_limit": 8000,

    "total": 10000,

    "total_upper_limit": 10000

  },

  "phone_country_code": 354,

  "phone_number": "string",

  "resources": [

    "string"

  ],

  "specific_employee_requested": true,

  "specific_space_requested": true,

  "expires_at": "2019-08-24T14:15:22Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "type": "create_timeslot_reservation_error",

  "code": "invalid_voucher",

  "message": "string",

  "user_message": "Voucher does not match services in booking."

}
```[Time Slots](https://docs.noona.is/docs/marketplace/time-slots)

[

Previous Page

](https://docs.noona.is/docs/marketplace/time-slots)[

Delete time slot reservation DELETE

Next Page

](https://docs.noona.is/docs/marketplace/time-slots/DeleteTimeSlotReservation)