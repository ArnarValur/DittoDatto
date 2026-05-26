---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Applications](https://docs.noona.is/docs/hq/applications)

Deletes the oauth application with the specified id.

DELETE `/v1/hq/oauth/applications/{application_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

application\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/oauth/applications/dwawd8awudawd"
```

```
{

  "id": "7awdXwZoedakjad37a",

  "logo": "https://example.com/logo.png",

  "name": "King Accounting Connection",

  "name_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "developer_name": "King Accounting",

  "developer_url": "https://example.com/about_king_accounting",

  "description": "King Accounting Connection automatically syncs your Noona POS system with the King Accounting software.",

  "description_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "uninstall_message": "Note that all data that the app stored will be deleted.",

  "uninstall_message_translations": {

    "is": "King Accounting tenging",

    "fr": "Connexion King Accounting"

  },

  "about": "string",

  "redirect_uris": [

    "https://example.com"

  ],

  "scopes": [

    "activities:read"

  ],

  "public": true,

  "app_store": true,

  "show_in_navigation": true,

  "verticals": [

    "restaurant",

    "appointment"

  ],

  "countries": [

    "US",

    "CA"

  ],

  "payment_type": "free",

  "price": 1000,

  "currency": "ISK",

  "client_id": "7awdXwZoedakjad37a",

  "client_secret": "7awdXwZoedakjad37a7awdXwZoedakjad37a7awdXwZoedakjad37a",

  "approved": true,

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```[Create application POST](https://docs.noona.is/docs/hq/applications/CreateOAuthApplication)

[

Previous Page

](https://docs.noona.is/docs/hq/applications/CreateOAuthApplication)[

Get application GET

Next Page

](https://docs.noona.is/docs/hq/applications/GetOAuthApplication)