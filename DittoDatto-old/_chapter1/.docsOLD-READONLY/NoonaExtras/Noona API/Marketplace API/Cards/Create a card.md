---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Cards](https://docs.noona.is/docs/marketplace/cards)

Creates a card for a marketplace user.

POST `/v1/marketplace/cards`

Marketplace-Authentication

## Query Parameters

## Request Body

application/json

method \* string

Format `enum`

Value in `"Card"`

cardholder\_name?string

Example `"Dee Hock"`

pan \* string

Example `"1564854695481453"`

expiry\_month \* string

Example `"02"`

expiry\_year \* string

Example `"02"`

cvc \* string

Example `"070"`

temporary?boolean

Whether the card is temporary or not. A temporary card is only valid for a short amount of time and can only be used once.

save\_card?boolean

Whether the card should be saved for future use.

If the card is saved, it can be used for future payments without having to enter the card details again.

Example `true`

return\_url \* string

If provided, the user is redirected to this URL after the payment is processed.

This is required for 3D Secure payments.

browser\_information?

channel \* string

three\_ds2\_sdk\_version?string

PARes?string

The `PARes` parameter from the 3D Secure flow.

CRes?string

The `CRes` parameter from the 3D Secure flow.

## Response Body

```
curl -X POST "https://api.noona.is/v1/marketplace/cards" \

  -H "Content-Type: application/json" \

  -d '{

    "method": "Card",

    "pan": "1564854695481453",

    "expiry_month": "02",

    "expiry_year": "02",

    "cvc": "070",

    "return_url": "string",

    "channel": "iOS"

  }'
```

```
{

  "method": "Card",

  "id": "7awdXwZoedakjad37a",

  "cardholder_name": "Dee Hock",

  "pan": "1564854695481453",

  "masked_pan": "1564854695481453",

  "expiry_month": "02",

  "expiry_year": "02",

  "cvc": "070",

  "temporary": true,

  "type": "visa",

  "provider": "teya",

  "save_card": true,

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

  "CRes": "string",

  "created_at": "2019-08-24T14:15:22Z"

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
```[Cards](https://docs.noona.is/docs/marketplace/cards)

[

Previous Page

](https://docs.noona.is/docs/marketplace/cards)[

Delete card DELETE

Next Page

](https://docs.noona.is/docs/marketplace/cards/DeleteMarketplaceCard)