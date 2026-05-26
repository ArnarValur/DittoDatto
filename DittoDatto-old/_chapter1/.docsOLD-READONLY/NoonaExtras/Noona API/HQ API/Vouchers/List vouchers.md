---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Vouchers](https://docs.noona.is/docs/hq/vouchers)

Lists the vouchers for a company.

GET `/v1/hq/companies/{company_id}/vouchers`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/string/vouchers"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "currency": "ISK",

    "amount": 3990,

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

    "code": "A328DB",

    "color": "#0f0f0f",

    "message": "You deserve to relax a bit!",

    "status": "never_used",

    "name": "Jon Snow",

    "phone_country_code": "354",

    "phone_number": "7134124",

    "email": "test@testy.is",

    "marketplace_user": "string",

    "customer": {

      "id": "string"

    },

    "company": "string",

    "template": "string",

    "expiration": "2022-08-24T14:15:22Z",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z",

    "deleted_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty[Get voucher GET](https://docs.noona.is/docs/hq/vouchers/GetVoucher)

[

Previous Page

](https://docs.noona.is/docs/hq/vouchers/GetVoucher)[

Update voucher POST

Next Page

](https://docs.noona.is/docs/hq/vouchers/UpdateVoucher)