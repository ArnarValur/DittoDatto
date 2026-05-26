---
tag: "noona.is"
---
Updates a time slot reservation.

POST `/v1/marketplace/time_slot_reservations/{time_slot_reservation_id}`

Marketplace-Authentication

## Path Parameters

time\_slot\_reservation\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

variation\_selections?

The variations selected for the event type in a time slot reservation.

The total quantity of all variation selections must match the number of guests.

phone\_country\_code?string

Example `354`

phone\_number?string

booking\_question\_answers?

payment\_intents?

payment\_type?string

What to do with payment when creating an event.

`required` - Only pay the required amount in advance.

`full` - Pay the full amount in advance.

Default `"full"`

Format `enum`

Example `"full"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/time_slot_reservations/dwawd8awudawd" \

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
```[List time slots GET](https://docs.noona.is/docs/marketplace/time-slots/ListTimeSlots)

[

Previous Page

](https://docs.noona.is/docs/marketplace/time-slots/ListTimeSlots)[

Voucher Templates

Next Page

](https://docs.noona.is/docs/marketplace/voucher-templates)