---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [User](https://docs.noona.is/docs/hq/user)

Updates current user information, inferred from token.

This endpoint is subject to extreme change in the near future and offers no promise of backwards compatability.

POST `/v1/hq/user`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

active\_company\_id?string

settings?

pos?

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/user" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "email": "example@example.com",

  "locale": "en",

  "user_profile": {

    "name": "John Doe"

  },

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

  "active_company": "string",

  "companies": [

    "string"

  ],

  "connections": {

    "adyen": {

      "onboarded_at": "2019-08-24T14:15:22Z",

      "onboarding_status": "not_started",

      "has_transfer_instrument": true

    },

    "google": {

      "connected": true,

      "calendar_connection": "string"

    },

    "teya": {

      "connected": true,

      "has_token": true

    },

    "verifone": {

      "connected": true

    }

  },

  "employees": [

    {

      "id": "7awdXawZoolkjad37a",

      "reference_id": "external-service-id",

      "company_id": "98aDWa8da9wda9dwa8",

      "company": "string",

      "name": "Noony Adams",

      "description": "Noony is a great employee",

      "description_translations": {

        "is": "King Accounting tenging",

        "fr": "Connexion King Accounting"

      },

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

      "email": "example@example.com",

      "email_verified": true,

      "has_password": true,

      "phone_country_code": "354",

      "phone_number": "5885522",

      "order": 1,

      "marketplace": {

        "enabled": true,

        "booking_interval": 15,

        "prioritized": true,

        "allow_booking_without_confirmation": true,

        "exclude_from_randomization_pool": true,

        "exclude_new_customers": true,

        "pre_payments_enabled": true,

        "own_settlements_allowed": true,

        "own_settlements_preferred": true,

        "own_settlements": true

      },

      "notifications": {

        "booking_email": true,

        "own_online_bookings": {

          "new_bookings": {

            "hq": true,

            "email": true,

            "push": true

          },

          "reschedules": {

            "hq": true,

            "email": true,

            "push": true

          },

          "cancellations": {

            "hq": true,

            "email": true,

            "push": true

          }

        },

        "staff_booking_updates": {

          "new_bookings": {

            "hq": true,

            "email": true,

            "push": true

          },

          "reschedules": {

            "hq": true,

            "email": true,

            "push": true

          },

          "cancellations": {

            "hq": true,

            "email": true,

            "push": true

          }

        },

        "other_online_bookings": {

          "new_bookings": {

            "hq": true,

            "email": true,

            "push": true

          },

          "reschedules": {

            "hq": true,

            "email": true,

            "push": true

          },

          "cancellations": {

            "hq": true,

            "email": true,

            "push": true

          }

        },

        "payments": {

          "successful_payouts": {

            "hq": true,

            "email": true,

            "push": true

          },

          "failed_payouts": {

            "hq": true,

            "email": true,

            "push": true

          }

        },

        "waitlist": {

          "new_requests": {

            "hq": true,

            "email": true,

            "push": true

          }

        },

        "booking_offers": {

          "approved": {

            "hq": true,

            "email": true,

            "push": true

          },

          "declined": {

            "hq": true,

            "email": true,

            "push": true

          }

        }

      },

      "sms": {

        "from": "Hair salon",

        "custom_text": "Please contact us via phone 777-7777 or Facebook page of the company in case you cannot make it to your appointment...",

        "custom_text_translations": {

          "is": "King Accounting tenging",

          "fr": "Connexion King Accounting"

        }

      },

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

      "role": "string",

      "pending_owner_approval": false,

      "available_for_bookings": true,

      "settlement_account": "string",

      "connected_to_teya": true,

      "adyen": {

        "onboarded_at": "2019-08-24T14:15:22Z",

        "onboarding_status": "not_started",

        "has_transfer_instrument": true

      },

      "teya": {

        "connected": true,

        "has_token": true

      },

      "commissions": {

        "pos": {

          "products": {

            "type": "rates",

            "default_rate": 10

          },

          "services": {

            "type": "rates",

            "default_rate": 10

          },

          "vouchers": {

            "type": "rates",

            "default_rate": 10

          }

        },

        "calendar": {

          "bookings": {

            "type": "rates",

            "default_rate": 10

          }

        }

      },

      "disabled_at": "2019-08-24T14:15:22Z",

      "deleted_at": "2019-08-24T14:15:22Z",

      "created_at": "2019-08-24T14:15:22Z",

      "updated_at": "2019-08-24T14:15:22Z"

    }

  ],

  "settings": {

    "language": "string",

    "calendar_slot_height": 0

  },

  "pos": {

    "enabled": true,

    "initial_invoice_number": 1,

    "name": "Noona cuts",

    "bin": "string",

    "vat_id": "string",

    "legal_address": "My Street 1, 101 Reykjavik",

    "tax_exemption_reason": "M16",

    "extra_invoice_info": "Some extra info to include on invoices.",

    "invoice_series": "NOONA",

    "starting_capital": "5000.00",

    "street_address": "My Street 1",

    "city": "Reykjavik",

    "postal_code": "101",

    "contact_email": "user@example.com"

  },

  "verification": {

    "status": "pending",

    "file": "string",

    "certification_type": "cosmetology",

    "certification_level": "apprentice",

    "submitted_at": "2019-08-24T14:15:22Z",

    "approved_at": "2019-08-24T14:15:22Z",

    "rejected_at": "2019-08-24T14:15:22Z",

    "rejected_reason": "string"

  },

  "has_onboarded": true,

  "is_secretary": true,

  "is_admin": true

}
```

Empty

Empty

Empty

Empty

Empty[User email verification POST](https://docs.noona.is/docs/hq/user/SendUserEmailVerification)

[

Previous Page

](https://docs.noona.is/docs/hq/user/SendUserEmailVerification)[

OAuth POST

Next Page

](https://docs.noona.is/docs/hq/user/UserOAuthPost)