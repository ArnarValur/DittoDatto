---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Applications](https://docs.noona.is/docs/hq/applications)

Updates the oauth application with the specified id.

POST `/v1/hq/oauth/applications/{application_id}`

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

## Request Body

application/json

id?string

Example `"7awdXwZoedakjad37a"`

logo?string

Example `"https://example.com/logo.png"`

name?string

Shown to the user when they are asked to give consent.

name\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

developer\_name?string

Example `"King Accounting"`

developer\_url?string

Home page or documentation for your application.

Example `"https://example.com/about_king_accounting"`

description?string

Short text about the functionality of the app that appears next to the icon in the list.

description\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

uninstall\_message?string

Short text that is displayed to the user when uninstalling the app.

uninstall\_message\_translations?

A map of translations for a given attribute.

The key is the language code, and the value is the translated string.

about?string

A longer description of the application which opens in a modal and support HTML.

redirect\_uris?array<string>

scopes?OAuthScopes

public?boolean

If true, the application will be usable from outside of the company.

Example `true`

app\_store?boolean

If true, the application will be listed in the Noona App Store.

Example `true`

verticals?array<CompanyVertical>

The verticals the application is available in.

If omitted or empty, the application is available for all verticals.

countries?array<string>

The countries the application is available in.

If omitted or empty, the application is available in all countries.

payment\_type?string

Example `"free"`

price?integer

Price in x100 format. (100 is 1.00)

Format `int32`

Example `1000`

currency?string

Example `"ISK"`

approved?boolean

Example `true`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/oauth/applications/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
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
```[List application users GET](https://docs.noona.is/docs/hq/applications/ListOAuthApplicationUsers)

[

Previous Page

](https://docs.noona.is/docs/hq/applications/ListOAuthApplicationUsers)[

Apps

Next Page

](https://docs.noona.is/docs/hq/apps)