---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Vouchers](https://docs.noona.is/docs/marketplace/vouchers)

Creates a voucher for a marketplace user.

POST `/v2/marketplace/vouchers`

Marketplace-Authentication

## Query Parameters

## Request Body

application/json

company\_id \* string

Example `"7awdXwZoedakjad37a"`

voucher\_template\_id?string

amount?number

Format `double`

Example `3990`

message?string

name \* string

Name of the customer purchasing the user

Example `"John Snow"`

email \* string

If an email is provided, it receives news of the newly created voucher.

Example `"test@testy.is"`

payment \* | | | |

phone\_country\_code?string

Example `"354"`

phone\_number?string

Example `"7134124"`

## Response Body

```
curl -X POST "https://api.noona.is/v2/marketplace/vouchers" \

  -H "Content-Type: application/json" \

  -d '{

    "company_id": "7awdXwZoedakjad37a",

    "name": "John Snow",

    "email": "test@testy.is",

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

  "voucher": {

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

  },

  "payment": {

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "user": "string",

    "event": {

      "id": "string"

    },

    "currency": "ISK",

    "amount": 10000,

    "status": "refunded",

    "provider": "teya",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  },

  "action": {

    "type": "redirect",

    "url": "https://example.com"

  }

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
```[Send a voucher notification POST](https://docs.noona.is/docs/marketplace/vouchers/CreateVoucherNotification)

[

Previous Page

](https://docs.noona.is/docs/marketplace/vouchers/CreateVoucherNotification)[

Retrieve voucher GET

Next Page

](https://docs.noona.is/docs/marketplace/vouchers/GetVoucher)