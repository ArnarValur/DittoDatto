---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Messaging

Lists all emails for the specified company.

GET `/v1/hq/companies/{company_id}/emails`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/emails"
```

```
[

  {

    "id": "string",

    "email": "string",

    "type": "event_confirmation_customer",

    "events": [

      {

        "status": "processed",

        "created_at": "2019-08-24T14:15:22Z"

      }

    ],

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[Update a memo POST](https://docs.noona.is/docs/hq/memos/UpdateMemo)

[

Previous Page

](https://docs.noona.is/docs/hq/memos/UpdateMemo)[

List SMS messages GET

Next Page

](https://docs.noona.is/docs/hq/messaging/ListSMSMessages)