---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Employees](https://docs.noona.is/docs/hq/employees)

Updates an employee at a company.

Partially implemented, only supports updating:

- event\_type\_preferences
- pre\_payments\_enabled
- own\_settlements\_preferred
- own\_settlements\_allowed
- commissions
- role

POST `/v1/hq/companies/{company_id}/employees/{employee_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

employee\_id \* string

Employee ID

Example `"dwawd8awudawd"`

## Query Parameters

## Request Body

application/json

reference\_id?string

An ID that can be used to reference the event type in an external system. This ID is not used by Noona and is not guaranteed to be unique.

Example `"external-service-id"`

company\_id?string Deprecated

Use `company` instead

Example `"98aDWa8da9wda9dwa8"`

company?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

name?string

Example `"Noony Adams"`

description?string

description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

image?

email?string

Example `"example@example.com"`

phone\_country\_code?string

Example `"354"`

phone\_number?string

Example `"5885522"`

order?integer

The order of the employee in the list of employees on the marketplace.

Format `int32`

Example `1`

marketplace?

notifications?

sms?

event\_type\_preferences?

role?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

pending\_owner\_approval?boolean

Whether the employee is pending owner approval

Example `false`

available\_for\_bookings?boolean

Whether the employee is visible on the calendar

Example `true`

commissions?

disabled\_at?string

Format `date-time`

deleted\_at?string

Format `date-time`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/dwawd8awudawd/employees/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
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
```

Empty

Empty

Empty[Stream employees GET](https://docs.noona.is/docs/hq/employees/StreamEmployees)

[

Previous Page

](https://docs.noona.is/docs/hq/employees/StreamEmployees)[

Retrieve enterprise GET

Next Page

](https://docs.noona.is/docs/hq/enterprise/GetEnterprise)