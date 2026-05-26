---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Cards](https://docs.noona.is/docs/marketplace/cards)

Lists the cards of a marketplace user.

```
curl -X GET "https://api.noona.is/v1/marketplace/cards"
```

```
[

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

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```[Retrieve card GET](https://docs.noona.is/docs/marketplace/cards/GetMarketplaceCard)

[

Previous Page

](https://docs.noona.is/docs/marketplace/cards/GetMarketplaceCard)