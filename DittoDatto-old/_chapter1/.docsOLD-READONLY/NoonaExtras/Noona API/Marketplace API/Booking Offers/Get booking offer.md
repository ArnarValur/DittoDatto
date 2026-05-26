---
tag: "noona.is"
---
Retrieves a specific booking offer by ID.

```
curl -X GET "https://api.noona.is/v1/marketplace/booking_offers/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "employee": "string",

  "time_slot_reservation": {

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

      "id": "string"

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

  },

  "waitlist_entry": "string",

  "is_desired_time": true,

  "message": "We have an opening for your requested service!",

  "expires_at": "2019-08-24T14:15:22Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Delete booking offer DELETE](https://docs.noona.is/docs/marketplace/booking-offers/DeleteBookingOffer)

[

Previous Page

](https://docs.noona.is/docs/marketplace/booking-offers/DeleteBookingOffer)[

List booking offers GET

Next Page

](https://docs.noona.is/docs/marketplace/booking-offers/ListBookingOffers)