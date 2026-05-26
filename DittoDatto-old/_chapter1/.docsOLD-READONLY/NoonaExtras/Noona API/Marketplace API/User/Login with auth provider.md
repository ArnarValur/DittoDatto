---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [User](https://docs.noona.is/docs/marketplace/marketplace-user)

Logs in a marketplace user with Apple or Google Sign-In ID token

```
{

  "id": "7awdXwZoedakjad37a",

  "name": "string",

  "phone_number": "string",

  "phone_country_code": "44 (for UK)",

  "phone_number_verified": true,

  "favorite_companies": [

    "string"

  ],

  "push_token": {

    "platform": 0,

    "token": "string"

  },

  "kennitala": "string",

  "email": "string",

  "email_verified": true,

  "marketing_consent": false,

  "license_plate": "string",

  "token": "string",

  "locale": {

    "ui_language": "string"

  },

  "device_info": {

    "battery_level": 0.72,

    "brand": "Apple",

    "build_number": 1626691095,

    "carrier": "Vodafone",

    "device_id": "iPhone13,1",

    "device_name": "John's iPhone",

    "manufacturer": "Apple",

    "model": "iPhone 12 mini",

    "system_version": "15.0.1",

    "is_emulator": true,

    "readable_version": "1.4.1.1626691095",

    "android_api_level": 0,

    "code_push_app_version": "1.4.1_v74"

  },

  "created_at": 1631558908,

  "updated_at": 1631558908

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
```[List user companies GET](https://docs.noona.is/docs/marketplace/marketplace-user/ListUserCompanies)

[

Previous Page

](https://docs.noona.is/docs/marketplace/marketplace-user/ListUserCompanies)[

Update user POST

Next Page

](https://docs.noona.is/docs/marketplace/marketplace-user/UpdateUser)