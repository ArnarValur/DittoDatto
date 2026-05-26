---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Companies

Lists all companies user has access to.

GET `/v1/hq/companies`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies"
```

```
[

  {

    "id": "QwYwhN8HH2CaFtwiW",

    "reference_id": "external-service-id",

    "vertical": "appointment",

    "enterprise": "string",

    "enterprise_order": 0,

    "name": "Noonacuts",

    "phone_country_code": "string",

    "phone_number": "string",

    "profile": {

      "store_name": "John's Hair Salon",

      "description": "string",

      "description_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "favorites": 0,

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

      "cover_images": [

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

      "phone_country_code": "354",

      "phone_number": "5885522",

      "contact_email": "string",

      "max_bookable_future_days": 0,

      "min_booking_notice_minutes": 0,

      "client_reschedule_disabled": true,

      "min_reschedule_notice_hours": 0,

      "client_cancel_disabled": true,

      "min_cancel_notice_hours": 0,

      "booking_interval": 15,

      "service_buffer": 0,

      "min_guests_per_booking": 0,

      "max_guests_per_booking": 0,

      "max_guests_per_interval": 0,

      "max_same_time_arrival": 0,

      "prefer_12_hours": true,

      "required_fields": {

        "kennitala": true,

        "email": true,

        "license_plate": true

      },

      "license_plate": true,

      "web_auth_opt_out": true,

      "exceed_max_guests_message": "string",

      "booking_success_message": "string",

      "booking_success_message_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "booking_redirect_url": "string",

      "company_types": [

        "string"

      ],

      "cuisines": [

        {

          "id": "7awdXwZoedakjad37a",

          "name": "Bistro",

          "readable_id": "bistro",

          "order": 1,

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z"

        }

      ],

      "dietaries": [

        {

          "id": "7awdXwZoedakjad37a",

          "name": "Bistro",

          "readable_id": "bistro",

          "order": 1,

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z"

        }

      ],

      "ambiences": [

        {

          "id": "7awdXwZoedakjad37a",

          "name": "Bistro",

          "readable_id": "bistro",

          "order": 1,

          "created_at": "2019-08-24T14:15:22Z",

          "updated_at": "2019-08-24T14:15:22Z"

        }

      ],

      "opening_hours": [

        {

          "opens_at": "08:00",

          "closes_at": "18:00",

          "is_closed": true

        }

      ],

      "store_opens_at": 8,

      "store_closes_at": 18,

      "unconfirmed_opening_hours": true,

      "price_category": 3

    },

    "marketplace": {

      "onboarded_at": "2019-08-24T14:15:22Z",

      "enabled": true,

      "visible": true,

      "url_name": "noonacuts",

      "email_notification": true,

      "allow_booking_without_confirmation": true,

      "allow_booking_over_cancelled_events": true,

      "allow_booking_multiple_services": true,

      "waitlist_enabled": true,

      "booking_offer_expiry_minutes": 1440,

      "booking_offer_message": "Your spot is available! Please book within the next 24 hours.",

      "booking_offer_message_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      }

    },

    "messaging": {

      "custom_reminder": "Hello, we are a hair salon. Please call us if you need to reschedule or cancel your appointment.",

      "custom_reminder_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

      "enable_reminders": true,

      "sender_name": "NoonaCuts",

      "send_sms_from_employee": true,

      "show_booking_ends_at": true,

      "new_sms_reminders_enabled": true

    },

    "notification_settings": {

      "new_notifications_enabled": true

    },

    "location": {

      "google_place_id": "string",

      "address": {

        "city": "string",

        "postalCode": "string",

        "street": "string",

        "region": "string",

        "locality": "string",

        "country": "string"

      },

      "formatted_address": "string",

      "lat_lng": {

        "lat": 0.1,

        "lng": 0.1

      },

      "country": {

        "short_name": "IS",

        "long_name": "Iceland"

      },

      "time_zone": "Atlantic/Reykjavik"

    },

    "currency": {

      "code": "EUR",

      "name": "Euro",

      "symbol": "€"

    },

    "locale": {

      "ui_language": "en",

      "messaging_language": "en"

    },

    "checkin": {

      "success_message": "Thank you for visiting us!"

    },

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

    "payment_fees": {

      "event": 0.019,

      "paylink": 0.019,

      "voucher": 0.05

    },

    "vouchers": {

      "enabled": true,

      "amount_vouchers_enabled": true

    },

    "pos": {

      "name_on_invoices": "Monsters inc.",

      "legal_address": "My Street 1, 101 Reykjavik",

      "extra_invoice_info": "Some extra info to include on invoices.",

      "initial_invoice_number": 1,

      "invoice_series": "NOONA",

      "starting_capital": "5000.00",

      "eac_code": "string",

      "vat_number": "123456",

      "default_vat": "string",

      "kennitala": "1234567890",

      "checkout_first_tab": "products",

      "fiscalization_enabled": false,

      "tax_exemption_reason": "M99",

      "contact_email": "accounting@company.com"

    },

    "adyen": {

      "onboarded_at": "2019-08-24T14:15:22Z",

      "onboarding_status": "not_started",

      "has_transfer_instrument": true

    },

    "teya": {

      "connected": true,

      "has_token": true

    },

    "google_analytics": {

      "measurement_id": "string",

      "api_secret": "string"

    },

    "claims": {

      "claimant_id": "string"

    },

    "signup": {

      "completed": true,

      "company_size": "solo",

      "signup_goal": [

        "stay_on_top_of_appointments"

      ],

      "referer": {

        "type": "social_media",

        "detail": "Instagram ad",

        "affiliate_link": "https://example.com/ref123"

      }

    },

    "subscriptions": [

      {

        "id": "string",

        "type": "appointments_pro",

        "status": "active",

        "active_since": "2022-06-30T14:15:16Z",

        "deactivated_at": "2022-06-30T14:15:16Z",

        "trial_started_at": "2022-06-30T14:15:16Z",

        "trial_ends_at": "2022-07-14T14:15:16Z",

        "trial_end_acknowledged_at": "2022-06-30T14:15:16Z"

      }

    ],

    "subscription_dunning": {

      "oldest_unpaid_invoice": "2019-08-24T14:15:22Z",

      "dunning_deadline": "2019-08-24T14:15:22Z",

      "unpaid_amount": 0,

      "currency": "string",

      "dunning_period_days": 0,

      "dunning_status": "in_progress"

    },

    "billing_status": {

      "payment_method": "invoice",

      "paid_invoices": 0,

      "unpaid_invoices": 0

    },

    "entitlements": [

      {

        "feature_id": "calendars",

        "feature_name": "string",

        "feature_type": "switch",

        "plan_id": "string",

        "bool_value": true,

        "int_value": 0,

        "string_value": "string",

        "is_enabled": true,

        "is_overridden": true

      }

    ],

    "locked_sections": {

      "reports": true,

      "transactions": true,

      "dashboard": true,

      "pin_expiry_time": 0,

      "pin": "string",

      "pin_hash": "string"

    },

    "visible_fields": {

      "kennitala": true,

      "email": true,

      "license_plate": true

    },

    "migrations": {

      "staff_work_hours_enabled": false

    },

    "has_secretary": true,

    "last_active_at": "2019-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[Create a new company POST](https://docs.noona.is/docs/hq/companies/CreateCompany)

[

Previous Page

](https://docs.noona.is/docs/hq/companies/CreateCompany)[

Get company GET

Next Page

](https://docs.noona.is/docs/hq/companies/GetCompany)