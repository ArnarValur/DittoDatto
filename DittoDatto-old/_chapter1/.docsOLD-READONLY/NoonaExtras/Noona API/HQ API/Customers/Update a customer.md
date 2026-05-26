---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Customers](https://docs.noona.is/docs/hq/customers)

Updates a customer at a company.

POST `/v1/hq/customers/{customer_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

customer\_id \* string

Customer ID

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

name?string

kennitala?string

Example `"1613772649"`

phone\_number?string

Example `8578844`

phone\_country\_code?string

Example `354`

email?string

Example `"example@example.com"`

license\_plate?string

Example `"DF302"`

license\_plates?array<string>

All different license plates that the customer has used.

company?string

ID of the company that the customer belongs to.

Example `"2fj29KiKX1wdjw985"`

groups?

Customer groups that the customer belongs to.

employee\_ids?array<string>

previous\_event?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

next\_event?| string

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

duplicates?

This field can only be appended to. Any customer ids currently not in the duplicates array will be added, causing those customers to be merged into this one. This operation can not be undone.

duplicateStatus?string

The customers duplicate status.

If `approved` the customer has been approved as a duplicate.

If `possible` the duplication has to be manually resolved.

Format `enum`

notes?string

update\_origin?string

Example `"hq"`

custom\_properties?

attachments?

notices?

tags?

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/customers/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7dj29KiAE1wdjw731",

  "name": "Joe the cuttee",

  "kennitala": "1613772649",

  "phone_number": 8578844,

  "phone_country_code": 354,

  "email": "example@example.com",

  "license_plate": "DF302",

  "license_plates": [

    "DF302"

  ],

  "company_id": "2fj29KiKX1wdjw985",

  "company": "2fj29KiKX1wdjw985",

  "event_count": 69,

  "groups": [

    "string"

  ],

  "employee_ids": [

    "1gj29KiKX1wdjw155"

  ],

  "previous_event": {

    "id": "7awdXwZoedakjad37a",

    "recurring_event": {

      "id": "7awdXwZoedakjad37a",

      "recurring_event": {

        "id": "7awdXwZoedakjad37a",

        "recurring_event": {

          "id": "7awdXwZoedakjad37a",

          "recurring_event": {

            "id": "7awdXwZoedakjad37a",

            "recurring_event": {

              "id": "7awdXwZoedakjad37a",

              "recurring_event": {

                "id": "7awdXwZoedakjad37a",

                "recurring_event": {

                  "id": "7awdXwZoedakjad37a",

                  "recurring_event": {

                    "id": "7awdXwZoedakjad37a",

                    "recurring_event": {

                      "id": "7awdXwZoedakjad37a",

                      "recurring_event": {

                        "id": "7awdXwZoedakjad37a",

                        "recurring_event": {

                          "id": "7awdXwZoedakjad37a",

                          "recurring_event": {

                            "id": "7awdXwZoedakjad37a",

                            "recurring_event": {

                              "customer": {},

                              "resources": {},

                              "event_types": [],

                              "variation_selections": [],

                              "booking_source": {},

                              "booking_questions": [],

                              "booking_question_answers": [],

                              "tags": {},

                              "sale": {},

                              "payment": {},

                              "price": {},

                              "custom_properties": [],

                              "notification_preferences": {},

                              "attachments": [],

                              "booking_offer": {},

                              "rwg": {}

                            },

                            "company": "string",

                            "employee_name": "Joe The Cutter",

                            "employee": "string",

                            "customer_name": "Harry Hairlong",

                            "new_customer": true,

                            "customer": {},

                            "number_of_guests": 1,

                            "space_name": "My Space",

                            "space": "string",

                            "resources": {},

                            "license_plate": "string",

                            "event_date": "2022-09-12",

                            "start_time": "15:30",

                            "end_time": "16:00",

                            "starts_at": "2022-09-12T12:00:00Z",

                            "ends_at": "2022-09-12T13:00:00Z",

                            "duration": 30,

                            "check_in_at": 1600541746,

                            "check_in_origin": "string",

                            "event_types": [

                              {}

                            ],

                            "variation_selections": [

                              {}

                            ],

                            "invoice_status": "paid",

                            "status": "noshow",

                            "claim_status": "Paid",

                            "origin": "online",

                            "booking_source": {},

                            "booking_questions": [

                              {}

                            ],

                            "booking_question_answers": [

                              null

                            ],

                            "comment": "string",

                            "customer_comment": "string",

                            "unconfirmed": true,

                            "special": true,

                            "pinned": true,

                            "tags": {},

                            "cancel_reason": "I'm sick and can't make it",

                            "sale": {},

                            "payment": {},

                            "price": {},

                            "outstanding_no_show_fee": 1000,

                            "custom_properties": [

                              {}

                            ],

                            "notification_preferences": {},

                            "attachments": [

                              {}

                            ],

                            "waitlist_entry": "string",

                            "booking_offer": {},

                            "scheduled_event": "string",

                            "ticket_id": "A3B7C2K9",

                            "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                            "version": 1,

                            "created_by": "string",

                            "updated_by": "string",

                            "update_origin": "online",

                            "accepted_at": "2019-08-24T14:15:22Z",

                            "declined_at": "2019-08-24T14:15:22Z",

                            "created_at": "2019-08-24T14:15:22Z",

                            "updated_at": "2019-08-24T14:15:22Z",

                            "deleted_at": "2019-08-24T14:15:22Z",

                            "rwg": {}

                          },

                          "company": "string",

                          "employee_name": "Joe The Cutter",

                          "employee": "string",

                          "customer_name": "Harry Hairlong",

                          "new_customer": true,

                          "customer": {

                            "id": "string"

                          },

                          "number_of_guests": 1,

                          "space_name": "My Space",

                          "space": "string",

                          "resources": {

                            "id": "string"

                          },

                          "license_plate": "string",

                          "event_date": "2022-09-12",

                          "start_time": "15:30",

                          "end_time": "16:00",

                          "starts_at": "2022-09-12T12:00:00Z",

                          "ends_at": "2022-09-12T13:00:00Z",

                          "duration": 30,

                          "check_in_at": 1600541746,

                          "check_in_origin": "string",

                          "event_types": [

                            {

                              "title_translations": {},

                              "description_translations": {},

                              "images": [],

                              "variations": [],

                              "price_ranges": [],

                              "connections": {},

                              "payments": {},

                              "price": {}

                            }

                          ],

                          "variation_selections": [

                            {}

                          ],

                          "invoice_status": "paid",

                          "status": "noshow",

                          "claim_status": "Paid",

                          "origin": "online",

                          "booking_source": {

                            "group": "hq",

                            "channel": "calendar",

                            "funnel": "ads"

                          },

                          "booking_questions": [

                            {}

                          ],

                          "booking_question_answers": [

                            {

                              "title_translations": {},

                              "description_translations": {}

                            }

                          ],

                          "comment": "string",

                          "customer_comment": "string",

                          "unconfirmed": true,

                          "special": true,

                          "pinned": true,

                          "tags": {

                            "birthday": true

                          },

                          "cancel_reason": "I'm sick and can't make it",

                          "sale": {

                            "id": "string"

                          },

                          "payment": {

                            "id": "string"

                          },

                          "price": {

                            "currency": "ISK",

                            "amount": 10000,

                            "amount_upper_limit": 10000

                          },

                          "outstanding_no_show_fee": 1000,

                          "custom_properties": [

                            {

                              "values": []

                            }

                          ],

                          "notification_preferences": {

                            "sms": true,

                            "email": true,

                            "push": true

                          },

                          "attachments": [

                            {}

                          ],

                          "waitlist_entry": "string",

                          "booking_offer": {

                            "id": "string"

                          },

                          "scheduled_event": "string",

                          "ticket_id": "A3B7C2K9",

                          "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                          "version": 1,

                          "created_by": "string",

                          "updated_by": "string",

                          "update_origin": "online",

                          "accepted_at": "2019-08-24T14:15:22Z",

                          "declined_at": "2019-08-24T14:15:22Z",

                          "created_at": "2019-08-24T14:15:22Z",

                          "updated_at": "2019-08-24T14:15:22Z",

                          "deleted_at": "2019-08-24T14:15:22Z",

                          "rwg": {

                            "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                            "merchant_changed": "2"

                          }

                        },

                        "company": "string",

                        "employee_name": "Joe The Cutter",

                        "employee": "string",

                        "customer_name": "Harry Hairlong",

                        "new_customer": true,

                        "customer": {

                          "id": "string"

                        },

                        "number_of_guests": 1,

                        "space_name": "My Space",

                        "space": "string",

                        "resources": {

                          "id": "string"

                        },

                        "license_plate": "string",

                        "event_date": "2022-09-12",

                        "start_time": "15:30",

                        "end_time": "16:00",

                        "starts_at": "2022-09-12T12:00:00Z",

                        "ends_at": "2022-09-12T13:00:00Z",

                        "duration": 30,

                        "check_in_at": 1600541746,

                        "check_in_origin": "string",

                        "event_types": [

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

                              {}

                            ],

                            "color": "#66d8cd",

                            "overbookable": "partially_overbookable",

                            "vat": "string",

                            "variations": [

                              {}

                            ],

                            "price_ranges": [

                              {}

                            ],

                            "connections": {

                              "booking_question_translations": {},

                              "booking_questions": [],

                              "booking_success_message_translations": {}

                            },

                            "custom_payment_settings": true,

                            "payments": {

                              "enabled_card_types": []

                            },

                            "price": {},

                            "tax_exemption_reason": "string",

                            "created_at": "2019-01-01T00:00:00.000Z",

                            "updated_at": "2019-01-02T00:00:00.000Z"

                          }

                        ],

                        "variation_selections": [

                          {

                            "variation_id": "7awdXwZoedakjad37a",

                            "event_type_id": "7awdXwZoedakjad37a",

                            "quantity": 1

                          }

                        ],

                        "invoice_status": "paid",

                        "status": "noshow",

                        "claim_status": "Paid",

                        "origin": "online",

                        "booking_source": {

                          "group": "hq",

                          "channel": "calendar",

                          "funnel": "ads"

                        },

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

                            "answer_type": "string",

                            "answer": "string"

                          }

                        ],

                        "comment": "string",

                        "customer_comment": "string",

                        "unconfirmed": true,

                        "special": true,

                        "pinned": true,

                        "tags": {

                          "birthday": true

                        },

                        "cancel_reason": "I'm sick and can't make it",

                        "sale": {

                          "id": "string"

                        },

                        "payment": {

                          "id": "string"

                        },

                        "price": {

                          "currency": "ISK",

                          "amount": 10000,

                          "amount_upper_limit": 10000

                        },

                        "outstanding_no_show_fee": 1000,

                        "custom_properties": [

                          {

                            "id": "7awdXwZoedakjad37a",

                            "values": [

                              null

                            ],

                            "valueIsId": true

                          }

                        ],

                        "notification_preferences": {

                          "sms": true,

                          "email": true,

                          "push": true

                        },

                        "attachments": [

                          {

                            "id": "7awdXwZoedakjad37a",

                            "filename": "my_image.jpg",

                            "type": "image/jpeg",

                            "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                            "relative_url": "/7awdXwZoedakjad37a.jpg",

                            "created_at": "2019-08-24T14:15:22Z",

                            "updated_at": "2019-08-24T14:15:22Z"

                          }

                        ],

                        "waitlist_entry": "string",

                        "booking_offer": {

                          "id": "string"

                        },

                        "scheduled_event": "string",

                        "ticket_id": "A3B7C2K9",

                        "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                        "version": 1,

                        "created_by": "string",

                        "updated_by": "string",

                        "update_origin": "online",

                        "accepted_at": "2019-08-24T14:15:22Z",

                        "declined_at": "2019-08-24T14:15:22Z",

                        "created_at": "2019-08-24T14:15:22Z",

                        "updated_at": "2019-08-24T14:15:22Z",

                        "deleted_at": "2019-08-24T14:15:22Z",

                        "rwg": {

                          "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                          "merchant_changed": "2"

                        }

                      },

                      "company": "string",

                      "employee_name": "Joe The Cutter",

                      "employee": "string",

                      "customer_name": "Harry Hairlong",

                      "new_customer": true,

                      "customer": {

                        "id": "string"

                      },

                      "number_of_guests": 1,

                      "space_name": "My Space",

                      "space": "string",

                      "resources": {

                        "id": "string"

                      },

                      "license_plate": "string",

                      "event_date": "2022-09-12",

                      "start_time": "15:30",

                      "end_time": "16:00",

                      "starts_at": "2022-09-12T12:00:00Z",

                      "ends_at": "2022-09-12T13:00:00Z",

                      "duration": 30,

                      "check_in_at": 1600541746,

                      "check_in_origin": "string",

                      "event_types": [

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

                            {}

                          ],

                          "color": "#66d8cd",

                          "overbookable": "partially_overbookable",

                          "vat": "string",

                          "variations": [

                            {

                              "label_translations": {},

                              "description_translations": {},

                              "prices": []

                            }

                          ],

                          "price_ranges": [

                            {}

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

                              {}

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

                              null

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

                      ],

                      "variation_selections": [

                        {

                          "variation_id": "7awdXwZoedakjad37a",

                          "event_type_id": "7awdXwZoedakjad37a",

                          "quantity": 1

                        }

                      ],

                      "invoice_status": "paid",

                      "status": "noshow",

                      "claim_status": "Paid",

                      "origin": "online",

                      "booking_source": {

                        "group": "hq",

                        "channel": "calendar",

                        "funnel": "ads"

                      },

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

                          "answer_type": "string",

                          "answer": "string"

                        }

                      ],

                      "comment": "string",

                      "customer_comment": "string",

                      "unconfirmed": true,

                      "special": true,

                      "pinned": true,

                      "tags": {

                        "birthday": true

                      },

                      "cancel_reason": "I'm sick and can't make it",

                      "sale": {

                        "id": "string"

                      },

                      "payment": {

                        "id": "string"

                      },

                      "price": {

                        "currency": "ISK",

                        "amount": 10000,

                        "amount_upper_limit": 10000

                      },

                      "outstanding_no_show_fee": 1000,

                      "custom_properties": [

                        {

                          "id": "7awdXwZoedakjad37a",

                          "values": [

                            "string"

                          ],

                          "valueIsId": true

                        }

                      ],

                      "notification_preferences": {

                        "sms": true,

                        "email": true,

                        "push": true

                      },

                      "attachments": [

                        {

                          "id": "7awdXwZoedakjad37a",

                          "filename": "my_image.jpg",

                          "type": "image/jpeg",

                          "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                          "relative_url": "/7awdXwZoedakjad37a.jpg",

                          "created_at": "2019-08-24T14:15:22Z",

                          "updated_at": "2019-08-24T14:15:22Z"

                        }

                      ],

                      "waitlist_entry": "string",

                      "booking_offer": {

                        "id": "string"

                      },

                      "scheduled_event": "string",

                      "ticket_id": "A3B7C2K9",

                      "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                      "version": 1,

                      "created_by": "string",

                      "updated_by": "string",

                      "update_origin": "online",

                      "accepted_at": "2019-08-24T14:15:22Z",

                      "declined_at": "2019-08-24T14:15:22Z",

                      "created_at": "2019-08-24T14:15:22Z",

                      "updated_at": "2019-08-24T14:15:22Z",

                      "deleted_at": "2019-08-24T14:15:22Z",

                      "rwg": {

                        "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                        "merchant_changed": "2"

                      }

                    },

                    "company": "string",

                    "employee_name": "Joe The Cutter",

                    "employee": "string",

                    "customer_name": "Harry Hairlong",

                    "new_customer": true,

                    "customer": {

                      "id": "string"

                    },

                    "number_of_guests": 1,

                    "space_name": "My Space",

                    "space": "string",

                    "resources": {

                      "id": "string"

                    },

                    "license_plate": "string",

                    "event_date": "2022-09-12",

                    "start_time": "15:30",

                    "end_time": "16:00",

                    "starts_at": "2022-09-12T12:00:00Z",

                    "ends_at": "2022-09-12T13:00:00Z",

                    "duration": 30,

                    "check_in_at": 1600541746,

                    "check_in_origin": "string",

                    "event_types": [

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

                              {}

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

                              "title_translations": {},

                              "description_translations": {}

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

                    ],

                    "variation_selections": [

                      {

                        "variation_id": "7awdXwZoedakjad37a",

                        "event_type_id": "7awdXwZoedakjad37a",

                        "quantity": 1

                      }

                    ],

                    "invoice_status": "paid",

                    "status": "noshow",

                    "claim_status": "Paid",

                    "origin": "online",

                    "booking_source": {

                      "group": "hq",

                      "channel": "calendar",

                      "funnel": "ads"

                    },

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

                        "answer_type": "string",

                        "answer": "string"

                      }

                    ],

                    "comment": "string",

                    "customer_comment": "string",

                    "unconfirmed": true,

                    "special": true,

                    "pinned": true,

                    "tags": {

                      "birthday": true

                    },

                    "cancel_reason": "I'm sick and can't make it",

                    "sale": {

                      "id": "string"

                    },

                    "payment": {

                      "id": "string"

                    },

                    "price": {

                      "currency": "ISK",

                      "amount": 10000,

                      "amount_upper_limit": 10000

                    },

                    "outstanding_no_show_fee": 1000,

                    "custom_properties": [

                      {

                        "id": "7awdXwZoedakjad37a",

                        "values": [

                          "string"

                        ],

                        "valueIsId": true

                      }

                    ],

                    "notification_preferences": {

                      "sms": true,

                      "email": true,

                      "push": true

                    },

                    "attachments": [

                      {

                        "id": "7awdXwZoedakjad37a",

                        "filename": "my_image.jpg",

                        "type": "image/jpeg",

                        "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                        "relative_url": "/7awdXwZoedakjad37a.jpg",

                        "created_at": "2019-08-24T14:15:22Z",

                        "updated_at": "2019-08-24T14:15:22Z"

                      }

                    ],

                    "waitlist_entry": "string",

                    "booking_offer": {

                      "id": "string"

                    },

                    "scheduled_event": "string",

                    "ticket_id": "A3B7C2K9",

                    "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                    "version": 1,

                    "created_by": "string",

                    "updated_by": "string",

                    "update_origin": "online",

                    "accepted_at": "2019-08-24T14:15:22Z",

                    "declined_at": "2019-08-24T14:15:22Z",

                    "created_at": "2019-08-24T14:15:22Z",

                    "updated_at": "2019-08-24T14:15:22Z",

                    "deleted_at": "2019-08-24T14:15:22Z",

                    "rwg": {

                      "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                      "merchant_changed": "2"

                    }

                  },

                  "company": "string",

                  "employee_name": "Joe The Cutter",

                  "employee": "string",

                  "customer_name": "Harry Hairlong",

                  "new_customer": true,

                  "customer": {

                    "id": "string"

                  },

                  "number_of_guests": 1,

                  "space_name": "My Space",

                  "space": "string",

                  "resources": {

                    "id": "string"

                  },

                  "license_plate": "string",

                  "event_date": "2022-09-12",

                  "start_time": "15:30",

                  "end_time": "16:00",

                  "starts_at": "2022-09-12T12:00:00Z",

                  "ends_at": "2022-09-12T13:00:00Z",

                  "duration": 30,

                  "check_in_at": 1600541746,

                  "check_in_origin": "string",

                  "event_types": [

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

                            {}

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

                  ],

                  "variation_selections": [

                    {

                      "variation_id": "7awdXwZoedakjad37a",

                      "event_type_id": "7awdXwZoedakjad37a",

                      "quantity": 1

                    }

                  ],

                  "invoice_status": "paid",

                  "status": "noshow",

                  "claim_status": "Paid",

                  "origin": "online",

                  "booking_source": {

                    "group": "hq",

                    "channel": "calendar",

                    "funnel": "ads"

                  },

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

                      "answer_type": "string",

                      "answer": "string"

                    }

                  ],

                  "comment": "string",

                  "customer_comment": "string",

                  "unconfirmed": true,

                  "special": true,

                  "pinned": true,

                  "tags": {

                    "birthday": true

                  },

                  "cancel_reason": "I'm sick and can't make it",

                  "sale": {

                    "id": "string"

                  },

                  "payment": {

                    "id": "string"

                  },

                  "price": {

                    "currency": "ISK",

                    "amount": 10000,

                    "amount_upper_limit": 10000

                  },

                  "outstanding_no_show_fee": 1000,

                  "custom_properties": [

                    {

                      "id": "7awdXwZoedakjad37a",

                      "values": [

                        "string"

                      ],

                      "valueIsId": true

                    }

                  ],

                  "notification_preferences": {

                    "sms": true,

                    "email": true,

                    "push": true

                  },

                  "attachments": [

                    {

                      "id": "7awdXwZoedakjad37a",

                      "filename": "my_image.jpg",

                      "type": "image/jpeg",

                      "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                      "relative_url": "/7awdXwZoedakjad37a.jpg",

                      "created_at": "2019-08-24T14:15:22Z",

                      "updated_at": "2019-08-24T14:15:22Z"

                    }

                  ],

                  "waitlist_entry": "string",

                  "booking_offer": {

                    "id": "string"

                  },

                  "scheduled_event": "string",

                  "ticket_id": "A3B7C2K9",

                  "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                  "version": 1,

                  "created_by": "string",

                  "updated_by": "string",

                  "update_origin": "online",

                  "accepted_at": "2019-08-24T14:15:22Z",

                  "declined_at": "2019-08-24T14:15:22Z",

                  "created_at": "2019-08-24T14:15:22Z",

                  "updated_at": "2019-08-24T14:15:22Z",

                  "deleted_at": "2019-08-24T14:15:22Z",

                  "rwg": {

                    "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                    "merchant_changed": "2"

                  }

                },

                "company": "string",

                "employee_name": "Joe The Cutter",

                "employee": "string",

                "customer_name": "Harry Hairlong",

                "new_customer": true,

                "customer": {

                  "id": "string"

                },

                "number_of_guests": 1,

                "space_name": "My Space",

                "space": "string",

                "resources": {

                  "id": "string"

                },

                "license_plate": "string",

                "event_date": "2022-09-12",

                "start_time": "15:30",

                "end_time": "16:00",

                "starts_at": "2022-09-12T12:00:00Z",

                "ends_at": "2022-09-12T13:00:00Z",

                "duration": 30,

                "check_in_at": 1600541746,

                "check_in_origin": "string",

                "event_types": [

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

                ],

                "variation_selections": [

                  {

                    "variation_id": "7awdXwZoedakjad37a",

                    "event_type_id": "7awdXwZoedakjad37a",

                    "quantity": 1

                  }

                ],

                "invoice_status": "paid",

                "status": "noshow",

                "claim_status": "Paid",

                "origin": "online",

                "booking_source": {

                  "group": "hq",

                  "channel": "calendar",

                  "funnel": "ads"

                },

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

                    "answer_type": "string",

                    "answer": "string"

                  }

                ],

                "comment": "string",

                "customer_comment": "string",

                "unconfirmed": true,

                "special": true,

                "pinned": true,

                "tags": {

                  "birthday": true

                },

                "cancel_reason": "I'm sick and can't make it",

                "sale": {

                  "id": "string"

                },

                "payment": {

                  "id": "string"

                },

                "price": {

                  "currency": "ISK",

                  "amount": 10000,

                  "amount_upper_limit": 10000

                },

                "outstanding_no_show_fee": 1000,

                "custom_properties": [

                  {

                    "id": "7awdXwZoedakjad37a",

                    "values": [

                      "string"

                    ],

                    "valueIsId": true

                  }

                ],

                "notification_preferences": {

                  "sms": true,

                  "email": true,

                  "push": true

                },

                "attachments": [

                  {

                    "id": "7awdXwZoedakjad37a",

                    "filename": "my_image.jpg",

                    "type": "image/jpeg",

                    "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                    "relative_url": "/7awdXwZoedakjad37a.jpg",

                    "created_at": "2019-08-24T14:15:22Z",

                    "updated_at": "2019-08-24T14:15:22Z"

                  }

                ],

                "waitlist_entry": "string",

                "booking_offer": {

                  "id": "string"

                },

                "scheduled_event": "string",

                "ticket_id": "A3B7C2K9",

                "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                "version": 1,

                "created_by": "string",

                "updated_by": "string",

                "update_origin": "online",

                "accepted_at": "2019-08-24T14:15:22Z",

                "declined_at": "2019-08-24T14:15:22Z",

                "created_at": "2019-08-24T14:15:22Z",

                "updated_at": "2019-08-24T14:15:22Z",

                "deleted_at": "2019-08-24T14:15:22Z",

                "rwg": {

                  "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                  "merchant_changed": "2"

                }

              },

              "company": "string",

              "employee_name": "Joe The Cutter",

              "employee": "string",

              "customer_name": "Harry Hairlong",

              "new_customer": true,

              "customer": {

                "id": "string"

              },

              "number_of_guests": 1,

              "space_name": "My Space",

              "space": "string",

              "resources": {

                "id": "string"

              },

              "license_plate": "string",

              "event_date": "2022-09-12",

              "start_time": "15:30",

              "end_time": "16:00",

              "starts_at": "2022-09-12T12:00:00Z",

              "ends_at": "2022-09-12T13:00:00Z",

              "duration": 30,

              "check_in_at": 1600541746,

              "check_in_origin": "string",

              "event_types": [

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

              ],

              "variation_selections": [

                {

                  "variation_id": "7awdXwZoedakjad37a",

                  "event_type_id": "7awdXwZoedakjad37a",

                  "quantity": 1

                }

              ],

              "invoice_status": "paid",

              "status": "noshow",

              "claim_status": "Paid",

              "origin": "online",

              "booking_source": {

                "group": "hq",

                "channel": "calendar",

                "funnel": "ads"

              },

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

                  "answer_type": "string",

                  "answer": "string"

                }

              ],

              "comment": "string",

              "customer_comment": "string",

              "unconfirmed": true,

              "special": true,

              "pinned": true,

              "tags": {

                "birthday": true

              },

              "cancel_reason": "I'm sick and can't make it",

              "sale": {

                "id": "string"

              },

              "payment": {

                "id": "string"

              },

              "price": {

                "currency": "ISK",

                "amount": 10000,

                "amount_upper_limit": 10000

              },

              "outstanding_no_show_fee": 1000,

              "custom_properties": [

                {

                  "id": "7awdXwZoedakjad37a",

                  "values": [

                    "string"

                  ],

                  "valueIsId": true

                }

              ],

              "notification_preferences": {

                "sms": true,

                "email": true,

                "push": true

              },

              "attachments": [

                {

                  "id": "7awdXwZoedakjad37a",

                  "filename": "my_image.jpg",

                  "type": "image/jpeg",

                  "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                  "relative_url": "/7awdXwZoedakjad37a.jpg",

                  "created_at": "2019-08-24T14:15:22Z",

                  "updated_at": "2019-08-24T14:15:22Z"

                }

              ],

              "waitlist_entry": "string",

              "booking_offer": {

                "id": "string"

              },

              "scheduled_event": "string",

              "ticket_id": "A3B7C2K9",

              "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

              "version": 1,

              "created_by": "string",

              "updated_by": "string",

              "update_origin": "online",

              "accepted_at": "2019-08-24T14:15:22Z",

              "declined_at": "2019-08-24T14:15:22Z",

              "created_at": "2019-08-24T14:15:22Z",

              "updated_at": "2019-08-24T14:15:22Z",

              "deleted_at": "2019-08-24T14:15:22Z",

              "rwg": {

                "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                "merchant_changed": "2"

              }

            },

            "company": "string",

            "employee_name": "Joe The Cutter",

            "employee": "string",

            "customer_name": "Harry Hairlong",

            "new_customer": true,

            "customer": {

              "id": "string"

            },

            "number_of_guests": 1,

            "space_name": "My Space",

            "space": "string",

            "resources": {

              "id": "string"

            },

            "license_plate": "string",

            "event_date": "2022-09-12",

            "start_time": "15:30",

            "end_time": "16:00",

            "starts_at": "2022-09-12T12:00:00Z",

            "ends_at": "2022-09-12T13:00:00Z",

            "duration": 30,

            "check_in_at": 1600541746,

            "check_in_origin": "string",

            "event_types": [

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

            ],

            "variation_selections": [

              {

                "variation_id": "7awdXwZoedakjad37a",

                "event_type_id": "7awdXwZoedakjad37a",

                "quantity": 1

              }

            ],

            "invoice_status": "paid",

            "status": "noshow",

            "claim_status": "Paid",

            "origin": "online",

            "booking_source": {

              "group": "hq",

              "channel": "calendar",

              "funnel": "ads"

            },

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

                "answer_type": "string",

                "answer": "string"

              }

            ],

            "comment": "string",

            "customer_comment": "string",

            "unconfirmed": true,

            "special": true,

            "pinned": true,

            "tags": {

              "birthday": true

            },

            "cancel_reason": "I'm sick and can't make it",

            "sale": {

              "id": "string"

            },

            "payment": {

              "id": "string"

            },

            "price": {

              "currency": "ISK",

              "amount": 10000,

              "amount_upper_limit": 10000

            },

            "outstanding_no_show_fee": 1000,

            "custom_properties": [

              {

                "id": "7awdXwZoedakjad37a",

                "values": [

                  "string"

                ],

                "valueIsId": true

              }

            ],

            "notification_preferences": {

              "sms": true,

              "email": true,

              "push": true

            },

            "attachments": [

              {

                "id": "7awdXwZoedakjad37a",

                "filename": "my_image.jpg",

                "type": "image/jpeg",

                "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                "relative_url": "/7awdXwZoedakjad37a.jpg",

                "created_at": "2019-08-24T14:15:22Z",

                "updated_at": "2019-08-24T14:15:22Z"

              }

            ],

            "waitlist_entry": "string",

            "booking_offer": {

              "id": "string"

            },

            "scheduled_event": "string",

            "ticket_id": "A3B7C2K9",

            "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

            "version": 1,

            "created_by": "string",

            "updated_by": "string",

            "update_origin": "online",

            "accepted_at": "2019-08-24T14:15:22Z",

            "declined_at": "2019-08-24T14:15:22Z",

            "created_at": "2019-08-24T14:15:22Z",

            "updated_at": "2019-08-24T14:15:22Z",

            "deleted_at": "2019-08-24T14:15:22Z",

            "rwg": {

              "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

              "merchant_changed": "2"

            }

          },

          "company": "string",

          "employee_name": "Joe The Cutter",

          "employee": "string",

          "customer_name": "Harry Hairlong",

          "new_customer": true,

          "customer": {

            "id": "string"

          },

          "number_of_guests": 1,

          "space_name": "My Space",

          "space": "string",

          "resources": {

            "id": "string"

          },

          "license_plate": "string",

          "event_date": "2022-09-12",

          "start_time": "15:30",

          "end_time": "16:00",

          "starts_at": "2022-09-12T12:00:00Z",

          "ends_at": "2022-09-12T13:00:00Z",

          "duration": 30,

          "check_in_at": 1600541746,

          "check_in_origin": "string",

          "event_types": [

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

          ],

          "variation_selections": [

            {

              "variation_id": "7awdXwZoedakjad37a",

              "event_type_id": "7awdXwZoedakjad37a",

              "quantity": 1

            }

          ],

          "invoice_status": "paid",

          "status": "noshow",

          "claim_status": "Paid",

          "origin": "online",

          "booking_source": {

            "group": "hq",

            "channel": "calendar",

            "funnel": "ads"

          },

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

              "answer_type": "string",

              "answer": "string"

            }

          ],

          "comment": "string",

          "customer_comment": "string",

          "unconfirmed": true,

          "special": true,

          "pinned": true,

          "tags": {

            "birthday": true

          },

          "cancel_reason": "I'm sick and can't make it",

          "sale": {

            "id": "string"

          },

          "payment": {

            "id": "string"

          },

          "price": {

            "currency": "ISK",

            "amount": 10000,

            "amount_upper_limit": 10000

          },

          "outstanding_no_show_fee": 1000,

          "custom_properties": [

            {

              "id": "7awdXwZoedakjad37a",

              "values": [

                "string"

              ],

              "valueIsId": true

            }

          ],

          "notification_preferences": {

            "sms": true,

            "email": true,

            "push": true

          },

          "attachments": [

            {

              "id": "7awdXwZoedakjad37a",

              "filename": "my_image.jpg",

              "type": "image/jpeg",

              "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

              "relative_url": "/7awdXwZoedakjad37a.jpg",

              "created_at": "2019-08-24T14:15:22Z",

              "updated_at": "2019-08-24T14:15:22Z"

            }

          ],

          "waitlist_entry": "string",

          "booking_offer": {

            "id": "string"

          },

          "scheduled_event": "string",

          "ticket_id": "A3B7C2K9",

          "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

          "version": 1,

          "created_by": "string",

          "updated_by": "string",

          "update_origin": "online",

          "accepted_at": "2019-08-24T14:15:22Z",

          "declined_at": "2019-08-24T14:15:22Z",

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z",

          "deleted_at": "2019-08-24T14:15:22Z",

          "rwg": {

            "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

            "merchant_changed": "2"

          }

        },

        "company": "string",

        "employee_name": "Joe The Cutter",

        "employee": "string",

        "customer_name": "Harry Hairlong",

        "new_customer": true,

        "customer": {

          "id": "string"

        },

        "number_of_guests": 1,

        "space_name": "My Space",

        "space": "string",

        "resources": {

          "id": "string"

        },

        "license_plate": "string",

        "event_date": "2022-09-12",

        "start_time": "15:30",

        "end_time": "16:00",

        "starts_at": "2022-09-12T12:00:00Z",

        "ends_at": "2022-09-12T13:00:00Z",

        "duration": 30,

        "check_in_at": 1600541746,

        "check_in_origin": "string",

        "event_types": [

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

        ],

        "variation_selections": [

          {

            "variation_id": "7awdXwZoedakjad37a",

            "event_type_id": "7awdXwZoedakjad37a",

            "quantity": 1

          }

        ],

        "invoice_status": "paid",

        "status": "noshow",

        "claim_status": "Paid",

        "origin": "online",

        "booking_source": {

          "group": "hq",

          "channel": "calendar",

          "funnel": "ads"

        },

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

            "answer_type": "string",

            "answer": "string"

          }

        ],

        "comment": "string",

        "customer_comment": "string",

        "unconfirmed": true,

        "special": true,

        "pinned": true,

        "tags": {

          "birthday": true

        },

        "cancel_reason": "I'm sick and can't make it",

        "sale": {

          "id": "string"

        },

        "payment": {

          "id": "string"

        },

        "price": {

          "currency": "ISK",

          "amount": 10000,

          "amount_upper_limit": 10000

        },

        "outstanding_no_show_fee": 1000,

        "custom_properties": [

          {

            "id": "7awdXwZoedakjad37a",

            "values": [

              "string"

            ],

            "valueIsId": true

          }

        ],

        "notification_preferences": {

          "sms": true,

          "email": true,

          "push": true

        },

        "attachments": [

          {

            "id": "7awdXwZoedakjad37a",

            "filename": "my_image.jpg",

            "type": "image/jpeg",

            "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

            "relative_url": "/7awdXwZoedakjad37a.jpg",

            "created_at": "2019-08-24T14:15:22Z",

            "updated_at": "2019-08-24T14:15:22Z"

          }

        ],

        "waitlist_entry": "string",

        "booking_offer": {

          "id": "string"

        },

        "scheduled_event": "string",

        "ticket_id": "A3B7C2K9",

        "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

        "version": 1,

        "created_by": "string",

        "updated_by": "string",

        "update_origin": "online",

        "accepted_at": "2019-08-24T14:15:22Z",

        "declined_at": "2019-08-24T14:15:22Z",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z",

        "deleted_at": "2019-08-24T14:15:22Z",

        "rwg": {

          "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

          "merchant_changed": "2"

        }

      },

      "company": "string",

      "employee_name": "Joe The Cutter",

      "employee": "string",

      "customer_name": "Harry Hairlong",

      "new_customer": true,

      "customer": {

        "id": "string"

      },

      "number_of_guests": 1,

      "space_name": "My Space",

      "space": "string",

      "resources": {

        "id": "string"

      },

      "license_plate": "string",

      "event_date": "2022-09-12",

      "start_time": "15:30",

      "end_time": "16:00",

      "starts_at": "2022-09-12T12:00:00Z",

      "ends_at": "2022-09-12T13:00:00Z",

      "duration": 30,

      "check_in_at": 1600541746,

      "check_in_origin": "string",

      "event_types": [

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

      ],

      "variation_selections": [

        {

          "variation_id": "7awdXwZoedakjad37a",

          "event_type_id": "7awdXwZoedakjad37a",

          "quantity": 1

        }

      ],

      "invoice_status": "paid",

      "status": "noshow",

      "claim_status": "Paid",

      "origin": "online",

      "booking_source": {

        "group": "hq",

        "channel": "calendar",

        "funnel": "ads"

      },

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

          "answer_type": "string",

          "answer": "string"

        }

      ],

      "comment": "string",

      "customer_comment": "string",

      "unconfirmed": true,

      "special": true,

      "pinned": true,

      "tags": {

        "birthday": true

      },

      "cancel_reason": "I'm sick and can't make it",

      "sale": {

        "id": "string"

      },

      "payment": {

        "id": "string"

      },

      "price": {

        "currency": "ISK",

        "amount": 10000,

        "amount_upper_limit": 10000

      },

      "outstanding_no_show_fee": 1000,

      "custom_properties": [

        {

          "id": "7awdXwZoedakjad37a",

          "values": [

            "string"

          ],

          "valueIsId": true

        }

      ],

      "notification_preferences": {

        "sms": true,

        "email": true,

        "push": true

      },

      "attachments": [

        {

          "id": "7awdXwZoedakjad37a",

          "filename": "my_image.jpg",

          "type": "image/jpeg",

          "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

          "relative_url": "/7awdXwZoedakjad37a.jpg",

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z"

        }

      ],

      "waitlist_entry": "string",

      "booking_offer": {

        "id": "string"

      },

      "scheduled_event": "string",

      "ticket_id": "A3B7C2K9",

      "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

      "version": 1,

      "created_by": "string",

      "updated_by": "string",

      "update_origin": "online",

      "accepted_at": "2019-08-24T14:15:22Z",

      "declined_at": "2019-08-24T14:15:22Z",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z",

      "deleted_at": "2019-08-24T14:15:22Z",

      "rwg": {

        "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

        "merchant_changed": "2"

      }

    },

    "company": "string",

    "employee_name": "Joe The Cutter",

    "employee": "string",

    "customer_name": "Harry Hairlong",

    "new_customer": true,

    "customer": {

      "id": "string"

    },

    "number_of_guests": 1,

    "space_name": "My Space",

    "space": "string",

    "resources": {

      "id": "string"

    },

    "license_plate": "string",

    "event_date": "2022-09-12",

    "start_time": "15:30",

    "end_time": "16:00",

    "starts_at": "2022-09-12T12:00:00Z",

    "ends_at": "2022-09-12T13:00:00Z",

    "duration": 30,

    "check_in_at": 1600541746,

    "check_in_origin": "string",

    "event_types": [

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

    ],

    "variation_selections": [

      {

        "variation_id": "7awdXwZoedakjad37a",

        "event_type_id": "7awdXwZoedakjad37a",

        "quantity": 1

      }

    ],

    "invoice_status": "paid",

    "status": "noshow",

    "claim_status": "Paid",

    "origin": "online",

    "booking_source": {

      "group": "hq",

      "channel": "calendar",

      "funnel": "ads"

    },

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

        "answer_type": "string",

        "answer": "string"

      }

    ],

    "comment": "string",

    "customer_comment": "string",

    "unconfirmed": true,

    "special": true,

    "pinned": true,

    "tags": {

      "birthday": true

    },

    "cancel_reason": "I'm sick and can't make it",

    "sale": {

      "id": "string"

    },

    "payment": {

      "id": "string"

    },

    "price": {

      "currency": "ISK",

      "amount": 10000,

      "amount_upper_limit": 10000

    },

    "outstanding_no_show_fee": 1000,

    "custom_properties": [

      {

        "id": "7awdXwZoedakjad37a",

        "values": [

          "string"

        ],

        "valueIsId": true

      }

    ],

    "notification_preferences": {

      "sms": true,

      "email": true,

      "push": true

    },

    "attachments": [

      {

        "id": "7awdXwZoedakjad37a",

        "filename": "my_image.jpg",

        "type": "image/jpeg",

        "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

        "relative_url": "/7awdXwZoedakjad37a.jpg",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z"

      }

    ],

    "waitlist_entry": "string",

    "booking_offer": {

      "id": "string"

    },

    "scheduled_event": "string",

    "ticket_id": "A3B7C2K9",

    "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

    "version": 1,

    "created_by": "string",

    "updated_by": "string",

    "update_origin": "online",

    "accepted_at": "2019-08-24T14:15:22Z",

    "declined_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "deleted_at": "2019-08-24T14:15:22Z",

    "rwg": {

      "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

      "merchant_changed": "2"

    }

  },

  "next_event": {

    "id": "7awdXwZoedakjad37a",

    "recurring_event": {

      "id": "7awdXwZoedakjad37a",

      "recurring_event": {

        "id": "7awdXwZoedakjad37a",

        "recurring_event": {

          "id": "7awdXwZoedakjad37a",

          "recurring_event": {

            "id": "7awdXwZoedakjad37a",

            "recurring_event": {

              "id": "7awdXwZoedakjad37a",

              "recurring_event": {

                "id": "7awdXwZoedakjad37a",

                "recurring_event": {

                  "id": "7awdXwZoedakjad37a",

                  "recurring_event": {

                    "id": "7awdXwZoedakjad37a",

                    "recurring_event": {

                      "id": "7awdXwZoedakjad37a",

                      "recurring_event": {

                        "id": "7awdXwZoedakjad37a",

                        "recurring_event": {

                          "id": "7awdXwZoedakjad37a",

                          "recurring_event": {

                            "id": "7awdXwZoedakjad37a",

                            "recurring_event": {

                              "customer": {},

                              "resources": {},

                              "event_types": [],

                              "variation_selections": [],

                              "booking_source": {},

                              "booking_questions": [],

                              "booking_question_answers": [],

                              "tags": {},

                              "sale": {},

                              "payment": {},

                              "price": {},

                              "custom_properties": [],

                              "notification_preferences": {},

                              "attachments": [],

                              "booking_offer": {},

                              "rwg": {}

                            },

                            "company": "string",

                            "employee_name": "Joe The Cutter",

                            "employee": "string",

                            "customer_name": "Harry Hairlong",

                            "new_customer": true,

                            "customer": {},

                            "number_of_guests": 1,

                            "space_name": "My Space",

                            "space": "string",

                            "resources": {},

                            "license_plate": "string",

                            "event_date": "2022-09-12",

                            "start_time": "15:30",

                            "end_time": "16:00",

                            "starts_at": "2022-09-12T12:00:00Z",

                            "ends_at": "2022-09-12T13:00:00Z",

                            "duration": 30,

                            "check_in_at": 1600541746,

                            "check_in_origin": "string",

                            "event_types": [

                              {}

                            ],

                            "variation_selections": [

                              {}

                            ],

                            "invoice_status": "paid",

                            "status": "noshow",

                            "claim_status": "Paid",

                            "origin": "online",

                            "booking_source": {},

                            "booking_questions": [

                              {}

                            ],

                            "booking_question_answers": [

                              null

                            ],

                            "comment": "string",

                            "customer_comment": "string",

                            "unconfirmed": true,

                            "special": true,

                            "pinned": true,

                            "tags": {},

                            "cancel_reason": "I'm sick and can't make it",

                            "sale": {},

                            "payment": {},

                            "price": {},

                            "outstanding_no_show_fee": 1000,

                            "custom_properties": [

                              {}

                            ],

                            "notification_preferences": {},

                            "attachments": [

                              {}

                            ],

                            "waitlist_entry": "string",

                            "booking_offer": {},

                            "scheduled_event": "string",

                            "ticket_id": "A3B7C2K9",

                            "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                            "version": 1,

                            "created_by": "string",

                            "updated_by": "string",

                            "update_origin": "online",

                            "accepted_at": "2019-08-24T14:15:22Z",

                            "declined_at": "2019-08-24T14:15:22Z",

                            "created_at": "2019-08-24T14:15:22Z",

                            "updated_at": "2019-08-24T14:15:22Z",

                            "deleted_at": "2019-08-24T14:15:22Z",

                            "rwg": {}

                          },

                          "company": "string",

                          "employee_name": "Joe The Cutter",

                          "employee": "string",

                          "customer_name": "Harry Hairlong",

                          "new_customer": true,

                          "customer": {

                            "id": "string"

                          },

                          "number_of_guests": 1,

                          "space_name": "My Space",

                          "space": "string",

                          "resources": {

                            "id": "string"

                          },

                          "license_plate": "string",

                          "event_date": "2022-09-12",

                          "start_time": "15:30",

                          "end_time": "16:00",

                          "starts_at": "2022-09-12T12:00:00Z",

                          "ends_at": "2022-09-12T13:00:00Z",

                          "duration": 30,

                          "check_in_at": 1600541746,

                          "check_in_origin": "string",

                          "event_types": [

                            {

                              "title_translations": {},

                              "description_translations": {},

                              "images": [],

                              "variations": [],

                              "price_ranges": [],

                              "connections": {},

                              "payments": {},

                              "price": {}

                            }

                          ],

                          "variation_selections": [

                            {}

                          ],

                          "invoice_status": "paid",

                          "status": "noshow",

                          "claim_status": "Paid",

                          "origin": "online",

                          "booking_source": {

                            "group": "hq",

                            "channel": "calendar",

                            "funnel": "ads"

                          },

                          "booking_questions": [

                            {}

                          ],

                          "booking_question_answers": [

                            {

                              "title_translations": {},

                              "description_translations": {}

                            }

                          ],

                          "comment": "string",

                          "customer_comment": "string",

                          "unconfirmed": true,

                          "special": true,

                          "pinned": true,

                          "tags": {

                            "birthday": true

                          },

                          "cancel_reason": "I'm sick and can't make it",

                          "sale": {

                            "id": "string"

                          },

                          "payment": {

                            "id": "string"

                          },

                          "price": {

                            "currency": "ISK",

                            "amount": 10000,

                            "amount_upper_limit": 10000

                          },

                          "outstanding_no_show_fee": 1000,

                          "custom_properties": [

                            {

                              "values": []

                            }

                          ],

                          "notification_preferences": {

                            "sms": true,

                            "email": true,

                            "push": true

                          },

                          "attachments": [

                            {}

                          ],

                          "waitlist_entry": "string",

                          "booking_offer": {

                            "id": "string"

                          },

                          "scheduled_event": "string",

                          "ticket_id": "A3B7C2K9",

                          "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                          "version": 1,

                          "created_by": "string",

                          "updated_by": "string",

                          "update_origin": "online",

                          "accepted_at": "2019-08-24T14:15:22Z",

                          "declined_at": "2019-08-24T14:15:22Z",

                          "created_at": "2019-08-24T14:15:22Z",

                          "updated_at": "2019-08-24T14:15:22Z",

                          "deleted_at": "2019-08-24T14:15:22Z",

                          "rwg": {

                            "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                            "merchant_changed": "2"

                          }

                        },

                        "company": "string",

                        "employee_name": "Joe The Cutter",

                        "employee": "string",

                        "customer_name": "Harry Hairlong",

                        "new_customer": true,

                        "customer": {

                          "id": "string"

                        },

                        "number_of_guests": 1,

                        "space_name": "My Space",

                        "space": "string",

                        "resources": {

                          "id": "string"

                        },

                        "license_plate": "string",

                        "event_date": "2022-09-12",

                        "start_time": "15:30",

                        "end_time": "16:00",

                        "starts_at": "2022-09-12T12:00:00Z",

                        "ends_at": "2022-09-12T13:00:00Z",

                        "duration": 30,

                        "check_in_at": 1600541746,

                        "check_in_origin": "string",

                        "event_types": [

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

                              {}

                            ],

                            "color": "#66d8cd",

                            "overbookable": "partially_overbookable",

                            "vat": "string",

                            "variations": [

                              {}

                            ],

                            "price_ranges": [

                              {}

                            ],

                            "connections": {

                              "booking_question_translations": {},

                              "booking_questions": [],

                              "booking_success_message_translations": {}

                            },

                            "custom_payment_settings": true,

                            "payments": {

                              "enabled_card_types": []

                            },

                            "price": {},

                            "tax_exemption_reason": "string",

                            "created_at": "2019-01-01T00:00:00.000Z",

                            "updated_at": "2019-01-02T00:00:00.000Z"

                          }

                        ],

                        "variation_selections": [

                          {

                            "variation_id": "7awdXwZoedakjad37a",

                            "event_type_id": "7awdXwZoedakjad37a",

                            "quantity": 1

                          }

                        ],

                        "invoice_status": "paid",

                        "status": "noshow",

                        "claim_status": "Paid",

                        "origin": "online",

                        "booking_source": {

                          "group": "hq",

                          "channel": "calendar",

                          "funnel": "ads"

                        },

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

                            "answer_type": "string",

                            "answer": "string"

                          }

                        ],

                        "comment": "string",

                        "customer_comment": "string",

                        "unconfirmed": true,

                        "special": true,

                        "pinned": true,

                        "tags": {

                          "birthday": true

                        },

                        "cancel_reason": "I'm sick and can't make it",

                        "sale": {

                          "id": "string"

                        },

                        "payment": {

                          "id": "string"

                        },

                        "price": {

                          "currency": "ISK",

                          "amount": 10000,

                          "amount_upper_limit": 10000

                        },

                        "outstanding_no_show_fee": 1000,

                        "custom_properties": [

                          {

                            "id": "7awdXwZoedakjad37a",

                            "values": [

                              null

                            ],

                            "valueIsId": true

                          }

                        ],

                        "notification_preferences": {

                          "sms": true,

                          "email": true,

                          "push": true

                        },

                        "attachments": [

                          {

                            "id": "7awdXwZoedakjad37a",

                            "filename": "my_image.jpg",

                            "type": "image/jpeg",

                            "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                            "relative_url": "/7awdXwZoedakjad37a.jpg",

                            "created_at": "2019-08-24T14:15:22Z",

                            "updated_at": "2019-08-24T14:15:22Z"

                          }

                        ],

                        "waitlist_entry": "string",

                        "booking_offer": {

                          "id": "string"

                        },

                        "scheduled_event": "string",

                        "ticket_id": "A3B7C2K9",

                        "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                        "version": 1,

                        "created_by": "string",

                        "updated_by": "string",

                        "update_origin": "online",

                        "accepted_at": "2019-08-24T14:15:22Z",

                        "declined_at": "2019-08-24T14:15:22Z",

                        "created_at": "2019-08-24T14:15:22Z",

                        "updated_at": "2019-08-24T14:15:22Z",

                        "deleted_at": "2019-08-24T14:15:22Z",

                        "rwg": {

                          "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                          "merchant_changed": "2"

                        }

                      },

                      "company": "string",

                      "employee_name": "Joe The Cutter",

                      "employee": "string",

                      "customer_name": "Harry Hairlong",

                      "new_customer": true,

                      "customer": {

                        "id": "string"

                      },

                      "number_of_guests": 1,

                      "space_name": "My Space",

                      "space": "string",

                      "resources": {

                        "id": "string"

                      },

                      "license_plate": "string",

                      "event_date": "2022-09-12",

                      "start_time": "15:30",

                      "end_time": "16:00",

                      "starts_at": "2022-09-12T12:00:00Z",

                      "ends_at": "2022-09-12T13:00:00Z",

                      "duration": 30,

                      "check_in_at": 1600541746,

                      "check_in_origin": "string",

                      "event_types": [

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

                            {}

                          ],

                          "color": "#66d8cd",

                          "overbookable": "partially_overbookable",

                          "vat": "string",

                          "variations": [

                            {

                              "label_translations": {},

                              "description_translations": {},

                              "prices": []

                            }

                          ],

                          "price_ranges": [

                            {}

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

                              {}

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

                              null

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

                      ],

                      "variation_selections": [

                        {

                          "variation_id": "7awdXwZoedakjad37a",

                          "event_type_id": "7awdXwZoedakjad37a",

                          "quantity": 1

                        }

                      ],

                      "invoice_status": "paid",

                      "status": "noshow",

                      "claim_status": "Paid",

                      "origin": "online",

                      "booking_source": {

                        "group": "hq",

                        "channel": "calendar",

                        "funnel": "ads"

                      },

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

                          "answer_type": "string",

                          "answer": "string"

                        }

                      ],

                      "comment": "string",

                      "customer_comment": "string",

                      "unconfirmed": true,

                      "special": true,

                      "pinned": true,

                      "tags": {

                        "birthday": true

                      },

                      "cancel_reason": "I'm sick and can't make it",

                      "sale": {

                        "id": "string"

                      },

                      "payment": {

                        "id": "string"

                      },

                      "price": {

                        "currency": "ISK",

                        "amount": 10000,

                        "amount_upper_limit": 10000

                      },

                      "outstanding_no_show_fee": 1000,

                      "custom_properties": [

                        {

                          "id": "7awdXwZoedakjad37a",

                          "values": [

                            "string"

                          ],

                          "valueIsId": true

                        }

                      ],

                      "notification_preferences": {

                        "sms": true,

                        "email": true,

                        "push": true

                      },

                      "attachments": [

                        {

                          "id": "7awdXwZoedakjad37a",

                          "filename": "my_image.jpg",

                          "type": "image/jpeg",

                          "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                          "relative_url": "/7awdXwZoedakjad37a.jpg",

                          "created_at": "2019-08-24T14:15:22Z",

                          "updated_at": "2019-08-24T14:15:22Z"

                        }

                      ],

                      "waitlist_entry": "string",

                      "booking_offer": {

                        "id": "string"

                      },

                      "scheduled_event": "string",

                      "ticket_id": "A3B7C2K9",

                      "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                      "version": 1,

                      "created_by": "string",

                      "updated_by": "string",

                      "update_origin": "online",

                      "accepted_at": "2019-08-24T14:15:22Z",

                      "declined_at": "2019-08-24T14:15:22Z",

                      "created_at": "2019-08-24T14:15:22Z",

                      "updated_at": "2019-08-24T14:15:22Z",

                      "deleted_at": "2019-08-24T14:15:22Z",

                      "rwg": {

                        "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                        "merchant_changed": "2"

                      }

                    },

                    "company": "string",

                    "employee_name": "Joe The Cutter",

                    "employee": "string",

                    "customer_name": "Harry Hairlong",

                    "new_customer": true,

                    "customer": {

                      "id": "string"

                    },

                    "number_of_guests": 1,

                    "space_name": "My Space",

                    "space": "string",

                    "resources": {

                      "id": "string"

                    },

                    "license_plate": "string",

                    "event_date": "2022-09-12",

                    "start_time": "15:30",

                    "end_time": "16:00",

                    "starts_at": "2022-09-12T12:00:00Z",

                    "ends_at": "2022-09-12T13:00:00Z",

                    "duration": 30,

                    "check_in_at": 1600541746,

                    "check_in_origin": "string",

                    "event_types": [

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

                              {}

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

                              "title_translations": {},

                              "description_translations": {}

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

                    ],

                    "variation_selections": [

                      {

                        "variation_id": "7awdXwZoedakjad37a",

                        "event_type_id": "7awdXwZoedakjad37a",

                        "quantity": 1

                      }

                    ],

                    "invoice_status": "paid",

                    "status": "noshow",

                    "claim_status": "Paid",

                    "origin": "online",

                    "booking_source": {

                      "group": "hq",

                      "channel": "calendar",

                      "funnel": "ads"

                    },

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

                        "answer_type": "string",

                        "answer": "string"

                      }

                    ],

                    "comment": "string",

                    "customer_comment": "string",

                    "unconfirmed": true,

                    "special": true,

                    "pinned": true,

                    "tags": {

                      "birthday": true

                    },

                    "cancel_reason": "I'm sick and can't make it",

                    "sale": {

                      "id": "string"

                    },

                    "payment": {

                      "id": "string"

                    },

                    "price": {

                      "currency": "ISK",

                      "amount": 10000,

                      "amount_upper_limit": 10000

                    },

                    "outstanding_no_show_fee": 1000,

                    "custom_properties": [

                      {

                        "id": "7awdXwZoedakjad37a",

                        "values": [

                          "string"

                        ],

                        "valueIsId": true

                      }

                    ],

                    "notification_preferences": {

                      "sms": true,

                      "email": true,

                      "push": true

                    },

                    "attachments": [

                      {

                        "id": "7awdXwZoedakjad37a",

                        "filename": "my_image.jpg",

                        "type": "image/jpeg",

                        "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                        "relative_url": "/7awdXwZoedakjad37a.jpg",

                        "created_at": "2019-08-24T14:15:22Z",

                        "updated_at": "2019-08-24T14:15:22Z"

                      }

                    ],

                    "waitlist_entry": "string",

                    "booking_offer": {

                      "id": "string"

                    },

                    "scheduled_event": "string",

                    "ticket_id": "A3B7C2K9",

                    "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                    "version": 1,

                    "created_by": "string",

                    "updated_by": "string",

                    "update_origin": "online",

                    "accepted_at": "2019-08-24T14:15:22Z",

                    "declined_at": "2019-08-24T14:15:22Z",

                    "created_at": "2019-08-24T14:15:22Z",

                    "updated_at": "2019-08-24T14:15:22Z",

                    "deleted_at": "2019-08-24T14:15:22Z",

                    "rwg": {

                      "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                      "merchant_changed": "2"

                    }

                  },

                  "company": "string",

                  "employee_name": "Joe The Cutter",

                  "employee": "string",

                  "customer_name": "Harry Hairlong",

                  "new_customer": true,

                  "customer": {

                    "id": "string"

                  },

                  "number_of_guests": 1,

                  "space_name": "My Space",

                  "space": "string",

                  "resources": {

                    "id": "string"

                  },

                  "license_plate": "string",

                  "event_date": "2022-09-12",

                  "start_time": "15:30",

                  "end_time": "16:00",

                  "starts_at": "2022-09-12T12:00:00Z",

                  "ends_at": "2022-09-12T13:00:00Z",

                  "duration": 30,

                  "check_in_at": 1600541746,

                  "check_in_origin": "string",

                  "event_types": [

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

                            {}

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

                  ],

                  "variation_selections": [

                    {

                      "variation_id": "7awdXwZoedakjad37a",

                      "event_type_id": "7awdXwZoedakjad37a",

                      "quantity": 1

                    }

                  ],

                  "invoice_status": "paid",

                  "status": "noshow",

                  "claim_status": "Paid",

                  "origin": "online",

                  "booking_source": {

                    "group": "hq",

                    "channel": "calendar",

                    "funnel": "ads"

                  },

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

                      "answer_type": "string",

                      "answer": "string"

                    }

                  ],

                  "comment": "string",

                  "customer_comment": "string",

                  "unconfirmed": true,

                  "special": true,

                  "pinned": true,

                  "tags": {

                    "birthday": true

                  },

                  "cancel_reason": "I'm sick and can't make it",

                  "sale": {

                    "id": "string"

                  },

                  "payment": {

                    "id": "string"

                  },

                  "price": {

                    "currency": "ISK",

                    "amount": 10000,

                    "amount_upper_limit": 10000

                  },

                  "outstanding_no_show_fee": 1000,

                  "custom_properties": [

                    {

                      "id": "7awdXwZoedakjad37a",

                      "values": [

                        "string"

                      ],

                      "valueIsId": true

                    }

                  ],

                  "notification_preferences": {

                    "sms": true,

                    "email": true,

                    "push": true

                  },

                  "attachments": [

                    {

                      "id": "7awdXwZoedakjad37a",

                      "filename": "my_image.jpg",

                      "type": "image/jpeg",

                      "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                      "relative_url": "/7awdXwZoedakjad37a.jpg",

                      "created_at": "2019-08-24T14:15:22Z",

                      "updated_at": "2019-08-24T14:15:22Z"

                    }

                  ],

                  "waitlist_entry": "string",

                  "booking_offer": {

                    "id": "string"

                  },

                  "scheduled_event": "string",

                  "ticket_id": "A3B7C2K9",

                  "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                  "version": 1,

                  "created_by": "string",

                  "updated_by": "string",

                  "update_origin": "online",

                  "accepted_at": "2019-08-24T14:15:22Z",

                  "declined_at": "2019-08-24T14:15:22Z",

                  "created_at": "2019-08-24T14:15:22Z",

                  "updated_at": "2019-08-24T14:15:22Z",

                  "deleted_at": "2019-08-24T14:15:22Z",

                  "rwg": {

                    "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                    "merchant_changed": "2"

                  }

                },

                "company": "string",

                "employee_name": "Joe The Cutter",

                "employee": "string",

                "customer_name": "Harry Hairlong",

                "new_customer": true,

                "customer": {

                  "id": "string"

                },

                "number_of_guests": 1,

                "space_name": "My Space",

                "space": "string",

                "resources": {

                  "id": "string"

                },

                "license_plate": "string",

                "event_date": "2022-09-12",

                "start_time": "15:30",

                "end_time": "16:00",

                "starts_at": "2022-09-12T12:00:00Z",

                "ends_at": "2022-09-12T13:00:00Z",

                "duration": 30,

                "check_in_at": 1600541746,

                "check_in_origin": "string",

                "event_types": [

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

                ],

                "variation_selections": [

                  {

                    "variation_id": "7awdXwZoedakjad37a",

                    "event_type_id": "7awdXwZoedakjad37a",

                    "quantity": 1

                  }

                ],

                "invoice_status": "paid",

                "status": "noshow",

                "claim_status": "Paid",

                "origin": "online",

                "booking_source": {

                  "group": "hq",

                  "channel": "calendar",

                  "funnel": "ads"

                },

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

                    "answer_type": "string",

                    "answer": "string"

                  }

                ],

                "comment": "string",

                "customer_comment": "string",

                "unconfirmed": true,

                "special": true,

                "pinned": true,

                "tags": {

                  "birthday": true

                },

                "cancel_reason": "I'm sick and can't make it",

                "sale": {

                  "id": "string"

                },

                "payment": {

                  "id": "string"

                },

                "price": {

                  "currency": "ISK",

                  "amount": 10000,

                  "amount_upper_limit": 10000

                },

                "outstanding_no_show_fee": 1000,

                "custom_properties": [

                  {

                    "id": "7awdXwZoedakjad37a",

                    "values": [

                      "string"

                    ],

                    "valueIsId": true

                  }

                ],

                "notification_preferences": {

                  "sms": true,

                  "email": true,

                  "push": true

                },

                "attachments": [

                  {

                    "id": "7awdXwZoedakjad37a",

                    "filename": "my_image.jpg",

                    "type": "image/jpeg",

                    "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                    "relative_url": "/7awdXwZoedakjad37a.jpg",

                    "created_at": "2019-08-24T14:15:22Z",

                    "updated_at": "2019-08-24T14:15:22Z"

                  }

                ],

                "waitlist_entry": "string",

                "booking_offer": {

                  "id": "string"

                },

                "scheduled_event": "string",

                "ticket_id": "A3B7C2K9",

                "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

                "version": 1,

                "created_by": "string",

                "updated_by": "string",

                "update_origin": "online",

                "accepted_at": "2019-08-24T14:15:22Z",

                "declined_at": "2019-08-24T14:15:22Z",

                "created_at": "2019-08-24T14:15:22Z",

                "updated_at": "2019-08-24T14:15:22Z",

                "deleted_at": "2019-08-24T14:15:22Z",

                "rwg": {

                  "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                  "merchant_changed": "2"

                }

              },

              "company": "string",

              "employee_name": "Joe The Cutter",

              "employee": "string",

              "customer_name": "Harry Hairlong",

              "new_customer": true,

              "customer": {

                "id": "string"

              },

              "number_of_guests": 1,

              "space_name": "My Space",

              "space": "string",

              "resources": {

                "id": "string"

              },

              "license_plate": "string",

              "event_date": "2022-09-12",

              "start_time": "15:30",

              "end_time": "16:00",

              "starts_at": "2022-09-12T12:00:00Z",

              "ends_at": "2022-09-12T13:00:00Z",

              "duration": 30,

              "check_in_at": 1600541746,

              "check_in_origin": "string",

              "event_types": [

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

              ],

              "variation_selections": [

                {

                  "variation_id": "7awdXwZoedakjad37a",

                  "event_type_id": "7awdXwZoedakjad37a",

                  "quantity": 1

                }

              ],

              "invoice_status": "paid",

              "status": "noshow",

              "claim_status": "Paid",

              "origin": "online",

              "booking_source": {

                "group": "hq",

                "channel": "calendar",

                "funnel": "ads"

              },

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

                  "answer_type": "string",

                  "answer": "string"

                }

              ],

              "comment": "string",

              "customer_comment": "string",

              "unconfirmed": true,

              "special": true,

              "pinned": true,

              "tags": {

                "birthday": true

              },

              "cancel_reason": "I'm sick and can't make it",

              "sale": {

                "id": "string"

              },

              "payment": {

                "id": "string"

              },

              "price": {

                "currency": "ISK",

                "amount": 10000,

                "amount_upper_limit": 10000

              },

              "outstanding_no_show_fee": 1000,

              "custom_properties": [

                {

                  "id": "7awdXwZoedakjad37a",

                  "values": [

                    "string"

                  ],

                  "valueIsId": true

                }

              ],

              "notification_preferences": {

                "sms": true,

                "email": true,

                "push": true

              },

              "attachments": [

                {

                  "id": "7awdXwZoedakjad37a",

                  "filename": "my_image.jpg",

                  "type": "image/jpeg",

                  "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                  "relative_url": "/7awdXwZoedakjad37a.jpg",

                  "created_at": "2019-08-24T14:15:22Z",

                  "updated_at": "2019-08-24T14:15:22Z"

                }

              ],

              "waitlist_entry": "string",

              "booking_offer": {

                "id": "string"

              },

              "scheduled_event": "string",

              "ticket_id": "A3B7C2K9",

              "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

              "version": 1,

              "created_by": "string",

              "updated_by": "string",

              "update_origin": "online",

              "accepted_at": "2019-08-24T14:15:22Z",

              "declined_at": "2019-08-24T14:15:22Z",

              "created_at": "2019-08-24T14:15:22Z",

              "updated_at": "2019-08-24T14:15:22Z",

              "deleted_at": "2019-08-24T14:15:22Z",

              "rwg": {

                "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

                "merchant_changed": "2"

              }

            },

            "company": "string",

            "employee_name": "Joe The Cutter",

            "employee": "string",

            "customer_name": "Harry Hairlong",

            "new_customer": true,

            "customer": {

              "id": "string"

            },

            "number_of_guests": 1,

            "space_name": "My Space",

            "space": "string",

            "resources": {

              "id": "string"

            },

            "license_plate": "string",

            "event_date": "2022-09-12",

            "start_time": "15:30",

            "end_time": "16:00",

            "starts_at": "2022-09-12T12:00:00Z",

            "ends_at": "2022-09-12T13:00:00Z",

            "duration": 30,

            "check_in_at": 1600541746,

            "check_in_origin": "string",

            "event_types": [

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

            ],

            "variation_selections": [

              {

                "variation_id": "7awdXwZoedakjad37a",

                "event_type_id": "7awdXwZoedakjad37a",

                "quantity": 1

              }

            ],

            "invoice_status": "paid",

            "status": "noshow",

            "claim_status": "Paid",

            "origin": "online",

            "booking_source": {

              "group": "hq",

              "channel": "calendar",

              "funnel": "ads"

            },

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

                "answer_type": "string",

                "answer": "string"

              }

            ],

            "comment": "string",

            "customer_comment": "string",

            "unconfirmed": true,

            "special": true,

            "pinned": true,

            "tags": {

              "birthday": true

            },

            "cancel_reason": "I'm sick and can't make it",

            "sale": {

              "id": "string"

            },

            "payment": {

              "id": "string"

            },

            "price": {

              "currency": "ISK",

              "amount": 10000,

              "amount_upper_limit": 10000

            },

            "outstanding_no_show_fee": 1000,

            "custom_properties": [

              {

                "id": "7awdXwZoedakjad37a",

                "values": [

                  "string"

                ],

                "valueIsId": true

              }

            ],

            "notification_preferences": {

              "sms": true,

              "email": true,

              "push": true

            },

            "attachments": [

              {

                "id": "7awdXwZoedakjad37a",

                "filename": "my_image.jpg",

                "type": "image/jpeg",

                "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

                "relative_url": "/7awdXwZoedakjad37a.jpg",

                "created_at": "2019-08-24T14:15:22Z",

                "updated_at": "2019-08-24T14:15:22Z"

              }

            ],

            "waitlist_entry": "string",

            "booking_offer": {

              "id": "string"

            },

            "scheduled_event": "string",

            "ticket_id": "A3B7C2K9",

            "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

            "version": 1,

            "created_by": "string",

            "updated_by": "string",

            "update_origin": "online",

            "accepted_at": "2019-08-24T14:15:22Z",

            "declined_at": "2019-08-24T14:15:22Z",

            "created_at": "2019-08-24T14:15:22Z",

            "updated_at": "2019-08-24T14:15:22Z",

            "deleted_at": "2019-08-24T14:15:22Z",

            "rwg": {

              "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

              "merchant_changed": "2"

            }

          },

          "company": "string",

          "employee_name": "Joe The Cutter",

          "employee": "string",

          "customer_name": "Harry Hairlong",

          "new_customer": true,

          "customer": {

            "id": "string"

          },

          "number_of_guests": 1,

          "space_name": "My Space",

          "space": "string",

          "resources": {

            "id": "string"

          },

          "license_plate": "string",

          "event_date": "2022-09-12",

          "start_time": "15:30",

          "end_time": "16:00",

          "starts_at": "2022-09-12T12:00:00Z",

          "ends_at": "2022-09-12T13:00:00Z",

          "duration": 30,

          "check_in_at": 1600541746,

          "check_in_origin": "string",

          "event_types": [

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

          ],

          "variation_selections": [

            {

              "variation_id": "7awdXwZoedakjad37a",

              "event_type_id": "7awdXwZoedakjad37a",

              "quantity": 1

            }

          ],

          "invoice_status": "paid",

          "status": "noshow",

          "claim_status": "Paid",

          "origin": "online",

          "booking_source": {

            "group": "hq",

            "channel": "calendar",

            "funnel": "ads"

          },

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

              "answer_type": "string",

              "answer": "string"

            }

          ],

          "comment": "string",

          "customer_comment": "string",

          "unconfirmed": true,

          "special": true,

          "pinned": true,

          "tags": {

            "birthday": true

          },

          "cancel_reason": "I'm sick and can't make it",

          "sale": {

            "id": "string"

          },

          "payment": {

            "id": "string"

          },

          "price": {

            "currency": "ISK",

            "amount": 10000,

            "amount_upper_limit": 10000

          },

          "outstanding_no_show_fee": 1000,

          "custom_properties": [

            {

              "id": "7awdXwZoedakjad37a",

              "values": [

                "string"

              ],

              "valueIsId": true

            }

          ],

          "notification_preferences": {

            "sms": true,

            "email": true,

            "push": true

          },

          "attachments": [

            {

              "id": "7awdXwZoedakjad37a",

              "filename": "my_image.jpg",

              "type": "image/jpeg",

              "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

              "relative_url": "/7awdXwZoedakjad37a.jpg",

              "created_at": "2019-08-24T14:15:22Z",

              "updated_at": "2019-08-24T14:15:22Z"

            }

          ],

          "waitlist_entry": "string",

          "booking_offer": {

            "id": "string"

          },

          "scheduled_event": "string",

          "ticket_id": "A3B7C2K9",

          "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

          "version": 1,

          "created_by": "string",

          "updated_by": "string",

          "update_origin": "online",

          "accepted_at": "2019-08-24T14:15:22Z",

          "declined_at": "2019-08-24T14:15:22Z",

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z",

          "deleted_at": "2019-08-24T14:15:22Z",

          "rwg": {

            "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

            "merchant_changed": "2"

          }

        },

        "company": "string",

        "employee_name": "Joe The Cutter",

        "employee": "string",

        "customer_name": "Harry Hairlong",

        "new_customer": true,

        "customer": {

          "id": "string"

        },

        "number_of_guests": 1,

        "space_name": "My Space",

        "space": "string",

        "resources": {

          "id": "string"

        },

        "license_plate": "string",

        "event_date": "2022-09-12",

        "start_time": "15:30",

        "end_time": "16:00",

        "starts_at": "2022-09-12T12:00:00Z",

        "ends_at": "2022-09-12T13:00:00Z",

        "duration": 30,

        "check_in_at": 1600541746,

        "check_in_origin": "string",

        "event_types": [

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

        ],

        "variation_selections": [

          {

            "variation_id": "7awdXwZoedakjad37a",

            "event_type_id": "7awdXwZoedakjad37a",

            "quantity": 1

          }

        ],

        "invoice_status": "paid",

        "status": "noshow",

        "claim_status": "Paid",

        "origin": "online",

        "booking_source": {

          "group": "hq",

          "channel": "calendar",

          "funnel": "ads"

        },

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

            "answer_type": "string",

            "answer": "string"

          }

        ],

        "comment": "string",

        "customer_comment": "string",

        "unconfirmed": true,

        "special": true,

        "pinned": true,

        "tags": {

          "birthday": true

        },

        "cancel_reason": "I'm sick and can't make it",

        "sale": {

          "id": "string"

        },

        "payment": {

          "id": "string"

        },

        "price": {

          "currency": "ISK",

          "amount": 10000,

          "amount_upper_limit": 10000

        },

        "outstanding_no_show_fee": 1000,

        "custom_properties": [

          {

            "id": "7awdXwZoedakjad37a",

            "values": [

              "string"

            ],

            "valueIsId": true

          }

        ],

        "notification_preferences": {

          "sms": true,

          "email": true,

          "push": true

        },

        "attachments": [

          {

            "id": "7awdXwZoedakjad37a",

            "filename": "my_image.jpg",

            "type": "image/jpeg",

            "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

            "relative_url": "/7awdXwZoedakjad37a.jpg",

            "created_at": "2019-08-24T14:15:22Z",

            "updated_at": "2019-08-24T14:15:22Z"

          }

        ],

        "waitlist_entry": "string",

        "booking_offer": {

          "id": "string"

        },

        "scheduled_event": "string",

        "ticket_id": "A3B7C2K9",

        "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

        "version": 1,

        "created_by": "string",

        "updated_by": "string",

        "update_origin": "online",

        "accepted_at": "2019-08-24T14:15:22Z",

        "declined_at": "2019-08-24T14:15:22Z",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z",

        "deleted_at": "2019-08-24T14:15:22Z",

        "rwg": {

          "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

          "merchant_changed": "2"

        }

      },

      "company": "string",

      "employee_name": "Joe The Cutter",

      "employee": "string",

      "customer_name": "Harry Hairlong",

      "new_customer": true,

      "customer": {

        "id": "string"

      },

      "number_of_guests": 1,

      "space_name": "My Space",

      "space": "string",

      "resources": {

        "id": "string"

      },

      "license_plate": "string",

      "event_date": "2022-09-12",

      "start_time": "15:30",

      "end_time": "16:00",

      "starts_at": "2022-09-12T12:00:00Z",

      "ends_at": "2022-09-12T13:00:00Z",

      "duration": 30,

      "check_in_at": 1600541746,

      "check_in_origin": "string",

      "event_types": [

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

      ],

      "variation_selections": [

        {

          "variation_id": "7awdXwZoedakjad37a",

          "event_type_id": "7awdXwZoedakjad37a",

          "quantity": 1

        }

      ],

      "invoice_status": "paid",

      "status": "noshow",

      "claim_status": "Paid",

      "origin": "online",

      "booking_source": {

        "group": "hq",

        "channel": "calendar",

        "funnel": "ads"

      },

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

          "answer_type": "string",

          "answer": "string"

        }

      ],

      "comment": "string",

      "customer_comment": "string",

      "unconfirmed": true,

      "special": true,

      "pinned": true,

      "tags": {

        "birthday": true

      },

      "cancel_reason": "I'm sick and can't make it",

      "sale": {

        "id": "string"

      },

      "payment": {

        "id": "string"

      },

      "price": {

        "currency": "ISK",

        "amount": 10000,

        "amount_upper_limit": 10000

      },

      "outstanding_no_show_fee": 1000,

      "custom_properties": [

        {

          "id": "7awdXwZoedakjad37a",

          "values": [

            "string"

          ],

          "valueIsId": true

        }

      ],

      "notification_preferences": {

        "sms": true,

        "email": true,

        "push": true

      },

      "attachments": [

        {

          "id": "7awdXwZoedakjad37a",

          "filename": "my_image.jpg",

          "type": "image/jpeg",

          "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

          "relative_url": "/7awdXwZoedakjad37a.jpg",

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z"

        }

      ],

      "waitlist_entry": "string",

      "booking_offer": {

        "id": "string"

      },

      "scheduled_event": "string",

      "ticket_id": "A3B7C2K9",

      "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

      "version": 1,

      "created_by": "string",

      "updated_by": "string",

      "update_origin": "online",

      "accepted_at": "2019-08-24T14:15:22Z",

      "declined_at": "2019-08-24T14:15:22Z",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z",

      "deleted_at": "2019-08-24T14:15:22Z",

      "rwg": {

        "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

        "merchant_changed": "2"

      }

    },

    "company": "string",

    "employee_name": "Joe The Cutter",

    "employee": "string",

    "customer_name": "Harry Hairlong",

    "new_customer": true,

    "customer": {

      "id": "string"

    },

    "number_of_guests": 1,

    "space_name": "My Space",

    "space": "string",

    "resources": {

      "id": "string"

    },

    "license_plate": "string",

    "event_date": "2022-09-12",

    "start_time": "15:30",

    "end_time": "16:00",

    "starts_at": "2022-09-12T12:00:00Z",

    "ends_at": "2022-09-12T13:00:00Z",

    "duration": 30,

    "check_in_at": 1600541746,

    "check_in_origin": "string",

    "event_types": [

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

    ],

    "variation_selections": [

      {

        "variation_id": "7awdXwZoedakjad37a",

        "event_type_id": "7awdXwZoedakjad37a",

        "quantity": 1

      }

    ],

    "invoice_status": "paid",

    "status": "noshow",

    "claim_status": "Paid",

    "origin": "online",

    "booking_source": {

      "group": "hq",

      "channel": "calendar",

      "funnel": "ads"

    },

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

        "answer_type": "string",

        "answer": "string"

      }

    ],

    "comment": "string",

    "customer_comment": "string",

    "unconfirmed": true,

    "special": true,

    "pinned": true,

    "tags": {

      "birthday": true

    },

    "cancel_reason": "I'm sick and can't make it",

    "sale": {

      "id": "string"

    },

    "payment": {

      "id": "string"

    },

    "price": {

      "currency": "ISK",

      "amount": 10000,

      "amount_upper_limit": 10000

    },

    "outstanding_no_show_fee": 1000,

    "custom_properties": [

      {

        "id": "7awdXwZoedakjad37a",

        "values": [

          "string"

        ],

        "valueIsId": true

      }

    ],

    "notification_preferences": {

      "sms": true,

      "email": true,

      "push": true

    },

    "attachments": [

      {

        "id": "7awdXwZoedakjad37a",

        "filename": "my_image.jpg",

        "type": "image/jpeg",

        "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

        "relative_url": "/7awdXwZoedakjad37a.jpg",

        "created_at": "2019-08-24T14:15:22Z",

        "updated_at": "2019-08-24T14:15:22Z"

      }

    ],

    "waitlist_entry": "string",

    "booking_offer": {

      "id": "string"

    },

    "scheduled_event": "string",

    "ticket_id": "A3B7C2K9",

    "rrule": "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR",

    "version": 1,

    "created_by": "string",

    "updated_by": "string",

    "update_origin": "online",

    "accepted_at": "2019-08-24T14:15:22Z",

    "declined_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "deleted_at": "2019-08-24T14:15:22Z",

    "rwg": {

      "token": "AJKvS9WeONmWKEwjG0--HdpzMq0yAVNL8KMxbb44QtbcxMhSx_NUud5b8PLUBFehAIxOBO-iYRIJOknEFkIJmdsofdVJ6uOweQ==",

      "merchant_changed": "2"

    }

  },

  "duplicates": [

    {

      "id": "string"

    }

  ],

  "duplicateStatus": "possible",

  "notes": "Loves to be called Joe the cuttee",

  "update_origin": "hq",

  "updated_by": "2fj29KiKX1wdjw985",

  "last_employee": "John the hairy",

  "last_event": "date-time",

  "custom_properties": [

    {

      "id": "7awdXwZoedakjad37a",

      "values": [

        "string"

      ],

      "valueIsId": true

    }

  ],

  "attachments": [

    {

      "id": "7awdXwZoedakjad37a",

      "filename": "my_image.jpg",

      "type": "image/jpeg",

      "secure_url": "https://static.noona.is/attachments/7awdXwZoedakjad37a.jpg",

      "relative_url": "/7awdXwZoedakjad37a.jpg",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z"

    }

  ],

  "notices": [

    {

      "id": "8wa9uiah28dawd123",

      "message": "Important information!",

      "variant": "info",

      "dismissable": false,

      "expires_at": "2019-08-24T14:15:22Z",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z"

    }

  ],

  "tags": {

    "gluten_free": true,

    "lactose_intolerant": true,

    "severe_nut_allergy": true,

    "severe_shellfish_allergy": true,

    "vegan": true,

    "vegetarian": true,

    "vip": true,

    "wheelchair": true

  },

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "marketplace_user": "string",

  "parent_marketplace_user": "string"

}
```[Send customer data POST](https://docs.noona.is/docs/hq/customers/SendCustomerData)

[

Previous Page

](https://docs.noona.is/docs/hq/customers/SendCustomerData)[

Employees

Next Page

](https://docs.noona.is/docs/hq/employees)