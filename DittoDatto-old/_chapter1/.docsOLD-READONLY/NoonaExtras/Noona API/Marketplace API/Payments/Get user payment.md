---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Payments](https://docs.noona.is/docs/marketplace/payments)

Gets payment with ID.

```
curl -X GET "https://api.noona.is/v1/marketplace/user/payments/string"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "string",

  "user": "string",

  "event": {

    "id": "7awdXwZoedakjad37a",

    "time_slot_reservation": "7awdXwZoedakjad37a",

    "starts_at": "2019-08-24T14:15:22Z",

    "ends_at": "2019-08-24T14:15:22Z",

    "duration": 60,

    "number_of_guests": 1,

    "customer_name": "John Doe",

    "ssn": "0101011234",

    "email": "example@example.com",

    "license_plate": "ABC123",

    "phone_country_code": "354",

    "phone_number": "7771122",

    "booking_questions": [

      {

        "question": "What color is your hair?",

        "answer": "Blonde"

      }

    ],

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

    "comment": "I have blonde hair",

    "origin": "online",

    "channel": "google maps",

    "source": "quick bookings",

    "partner": "string",

    "no_show_acknowledged": false,

    "event_types": [

      {

        "id": "7awdXwZoedakjad37a",

        "title": "Men's haircut",

        "company_id": "831dXwZoedakjad40b",

        "company": "string",

        "minutes": 30,

        "description": "30 minute men's haircut",

        "min_guests_per_booking": 0,

        "max_guests_per_booking": 0,

        "thumb": "api.noona.is/static/haircut.png",

        "images": [

          {

            "thumb": "https://placekitten.com/200/200",

            "image": "https://placekitten.com/200/300",

            "type": "thumbnail",

            "public_id": "https://placekitten.com/200/300"

          }

        ],

        "variations": [

          {

            "id": "string",

            "label": "Premium",

            "description": "Premium service with extra attention",

            "selectable_in_marketplace": true,

            "customer_group": "7awdXwZoedakjad37a",

            "prices": [

              {

                "currency": "EUR",

                "amount": 40

              }

            ],

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

            }

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

          "customer_selects": "employee",

          "service_needs": "employee",

          "booking_question": "string",

          "booking_questions": [

            {

              "id": "string",

              "title": "string",

              "description": "string",

              "answer_required": true,

              "answer_type": "string"

            }

          ],

          "booking_success_message": "Remember to bring your smile with you!",

          "marketplace": true

        },

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

        "relative_location": {

          "lat": 0.1,

          "lng": 0.1,

          "distance": 0.1

        },

        "created_at": 1631558908,

        "updated_at": 1631558908,

        "deleted_at": "2019-08-24T14:15:22Z"

      }

    ],

    "variation_selections": [

      {

        "variation_id": "7awdXwZoedakjad37a",

        "event_type_id": "7awdXwZoedakjad37a",

        "quantity": 1

      }

    ],

    "confirmed": true,

    "status": "cancelled",

    "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

    "cancel_reason": "I'm sick and can't make it",

    "employee": "string",

    "space": "string",

    "company": "string",

    "scheduled_event": "string",

    "specific_employee_requested": true,

    "specific_space_requested": true,

    "booking_for_other": false,

    "customer": "7awdXwZoedakjad37a",

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

    "payment_information": {

      "method": "SavedCard",

      "card_id": "9d8aj2oi2audawo",

      "cvc": "070",

      "return_url": "string",

      "browser_information": {

        "language": "en-US",

        "color_depth": 0,

        "javascript_enabled": true,

        "screen_width": 0.1,

        "screen_height": 0.1,

        "time_zone_offset": 0

      },

      "channel": "iOS",

      "three_ds2_sdk_version": "string",

      "PARes": "string",

      "CRes": "string"

    },

    "payment": {

      "id": "string"

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

    "pending_payment_details": {

      "outstanding": 2000,

      "on_location": 8000,

      "on_location_upper_limit": 8000,

      "total": 10000,

      "total_upper_limit": 10000

    },

    "ticket_id": "A3B7C2K9",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "rwg": {

      "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

      "merchant_changed": "2"

    }

  },

  "currency": "ISK",

  "amount": 10000,

  "status": "refunded",

  "provider": "teya",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Delete user payment DELETE](https://docs.noona.is/docs/marketplace/payments/DeletePayment)

[

Previous Page

](https://docs.noona.is/docs/marketplace/payments/DeletePayment)[

List payment methods GET

Next Page

](https://docs.noona.is/docs/marketplace/payments/ListPaymentMethods)