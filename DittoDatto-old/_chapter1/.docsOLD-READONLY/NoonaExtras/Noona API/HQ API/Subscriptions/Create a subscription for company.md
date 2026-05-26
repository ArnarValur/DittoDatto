---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Subscriptions](https://docs.noona.is/docs/hq/subscriptions)

Creates the subscription for the company and updates the relevant database fields.

POST `/v1/hq/companies/{company_id}/subscriptions`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Company id

## Query Parameters

## Request Body

application/json

product?string

Format `enum`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/companies/string/subscriptions" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "customer": "7awdXwZoedakjad37a",

  "status": "future",

  "subscription_items": [

    {

      "item_price_id": "7awdXwZoedakjad37a",

      "item_type": "plan",

      "quantity": 0,

      "unit_price": 0,

      "amount": 0,

      "trial_end": "2019-08-24T14:15:22Z"

    }

  ],

  "charged_items": [

    {

      "item_price_id": "7awdXwZoedakjad37a",

      "last_charged_at": "2019-08-24T14:15:22Z"

    }

  ],

  "coupons": [

    {

      "coupon_id": "7awdXwZoedakjad37a",

      "coupon_code": "50off",

      "applied_count": 0,

      "apply_till": "2019-08-24T14:15:22Z"

    }

  ],

  "discounts": [

    {

      "id": "7awdXwZoedakjad37a",

      "coupon": "7awdXwZoedakjad37a",

      "invoice_name": "Good customer discount",

      "apply_on": "invoice_amount",

      "item_price_id": "7awdXwZoedakjad37a",

      "percentage": 100,

      "amount": 0,

      "duration_type": "one_time",

      "period_unit": "day",

      "period": 1,

      "currency_code": "str",

      "included_in_mrr": true,

      "applied_count": 0,

      "apply_till": "2019-08-24T14:15:22Z",

      "created_at": "2019-08-24T14:15:22Z"

    }

  ],

  "currency_code": "str",

  "exchange_rate": 0.1,

  "auto_close_invoices": true,

  "due_invoices_count": 0,

  "total_dues": 0,

  "due_since": "2019-08-24T14:15:22Z",

  "cancel_reason": "not_paid",

  "cancelled_at": "2019-08-24T14:15:22Z",

  "trial_start": "2019-08-24T14:15:22Z",

  "current_term_start": "2019-08-24T14:15:22Z",

  "current_term_end": "2019-08-24T14:15:22Z",

  "next_billing_at": "2019-08-24T14:15:22Z",

  "started_at": "2019-08-24T14:15:22Z",

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z",

  "deleted": true

}
```

Empty

Empty[Create a payment intent POST](https://docs.noona.is/docs/hq/subscriptions/CreatePaymentIntent)

[

Previous Page

](https://docs.noona.is/docs/hq/subscriptions/CreatePaymentIntent)[

Download billing invoice PDF GET

Next Page

](https://docs.noona.is/docs/hq/subscriptions/GetBillingInvoice)