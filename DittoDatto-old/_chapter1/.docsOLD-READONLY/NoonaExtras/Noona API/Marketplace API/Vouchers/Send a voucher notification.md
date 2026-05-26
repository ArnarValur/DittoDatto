---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Vouchers](https://docs.noona.is/docs/marketplace/vouchers)

Sends a voucher notification to the specified recipients.

If **send\_to\_user** is provided, voucher ownership will be transferred to the user.

POST `/v1/marketplace/vouchers/{voucher_id}/notification`

Marketplace-Authentication

## Path Parameters

voucher\_id \* string

Voucher ID

## Request Body

application/json

phone\_country\_code?string

Example `"354"`

phone\_number?string

If a phone number is provided, it receives news of the newly created voucher.

Example `"7134124"`

email?string

If an email is provided, it receives news of the newly created voucher.

Example `"test@testy.is"`

send\_to\_user?

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/vouchers/string/notification" \

  -H "Content-Type: application/json" \

  -d '{}'
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
```[Create a voucher POST](https://docs.noona.is/docs/marketplace/vouchers/CreateVoucher)

[

Previous Page

](https://docs.noona.is/docs/marketplace/vouchers/CreateVoucher)[

Create a voucher V2 POST

Next Page

](https://docs.noona.is/docs/marketplace/vouchers/CreateVoucherV2)