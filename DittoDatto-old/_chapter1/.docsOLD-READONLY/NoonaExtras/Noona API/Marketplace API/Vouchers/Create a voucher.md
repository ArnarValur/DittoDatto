---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Vouchers](https://docs.noona.is/docs/marketplace/vouchers)

Creates a voucher for a marketplace user.

There are two voucher types that are supported:

- Amount
- Service

**company** and **payment** are always required fields. But depending on the voucher type, additional fields are required.

---

#### Amount

Amount vouchers represent a monetary value that can be used to pay for services at a company.

The following fields are required when creating an amount voucher:

- **amount** - The amount of the voucher.
- **currency** - The currency of the voucher.

#### Service (event\_type)

Service vouchers represent a service that can be redeemed at a company.

The following fields are required when creating a service voucher:

- **voucher\_template** - The voucher template ID. This is the template that will be used to create the voucher.

POST `/v1/marketplace/vouchers`

Marketplace-Authentication

## Query Parameters

## Request Body

application/json

amount?number

Format `double`

Example `3990`

voucher\_template?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

data?|

color?string

Example `"#0f0f0f"`

message?string

is\_gift?boolean

Example `true`

phone\_country\_code?string

Example `"354"`

phone\_number?string

If a phone number is provided, it receives news of the newly created voucher.

This keeps the original owner, while send\_to\_user transfers it to a different user.

Example `"7134124"`

send\_to\_user?

email?string

If an email is provided, it receives news of the newly created voucher.

Example `"test@testy.is"`

user?string |

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

company \* string |

[Expandable](https://docs.noona.is/docs/marketplace/vouchers/#section/Expandable-attributes)

payment \* | | | |

bought\_by?string

ID of the user who bought the voucher.

Example `"7awdXwZoedakjad37a"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/vouchers" \

  -H "Content-Type: application/json" \

  -d '{

    "company": "string",

    "payment": {

      "method": "SavedCard",

      "card_id": "9d8aj2oi2audawo",

      "return_url": "string",

      "channel": "iOS"

    }

  }'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "currency": "ISK",

  "amount": 3990,

  "voucher_template": "string",

  "data": {

    "type": "service",

    "sessions_used": 0,

    "sessions_total": 0,

    "event_type_name": "Quicky Haircut",

    "event_type_id": "d0a9w8da09w8dindwa",

    "number_of_guests": 2,

    "voucher_template": "7awdXwZoedakjad37a",

    "voucher_template_amount": 0.1,

    "voucher_template_value": 0.1

  },

  "color": "#0f0f0f",

  "message": "You deserve to relax a bit!",

  "is_gift": true,

  "code": "A328DB",

  "phone_country_code": "354",

  "phone_number": "7134124",

  "send_to_user": {

    "phone_number": "8124132",

    "phone_country_code": "354"

  },

  "email": "test@testy.is",

  "user": "string",

  "company": "string",

  "expiration": "2022-08-24T14:15:22Z",

  "payment": {

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

  "payment_information": {

    "payment_method": "ApplePay",

    "pan": "1842********8123"

  },

  "fully_used": true,

  "original_owner": true,

  "bought_by": "7awdXwZoedakjad37a",

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
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Vouchers](https://docs.noona.is/docs/marketplace/vouchers)

[

Previous Page

](https://docs.noona.is/docs/marketplace/vouchers)[

Send a voucher notification POST

Next Page

](https://docs.noona.is/docs/marketplace/vouchers/CreateVoucherNotification)