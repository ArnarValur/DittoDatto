---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Sales](https://docs.noona.is/docs/hq/sales)

Marketplace sales originate from online bookings that include payments (represented as subtransactions in transactions under the sale).

This endpoint allows for a refund of the payments associated with the sale.

A refund is not possible if:

- The underlying payment of a subtransaction has been settled to the merchant.
- A subtransaction has been processed through HQ since the sale was created.

The possible error scenarios are explained in the 400 description below.

The refund, when successful, is different in these scenarios:

- **Completed Invoice**: All subtransactions are refunded and a credit invoice is created.
- **Draft Invoice**: All subtransactions are refunded and the invoice is deleted.

POST `/v1/hq/sales/{sale_id}/refund`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

sale\_id \* string

Sale ID

## Query Parameters

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/sales/string/refund"
```

Empty

```
{

  "message": "Customer onboarding error.",

  "code": "payment_has_been_settled"

}
```[List all sales GET](https://docs.noona.is/docs/hq/sales/ListSales)

[

Previous Page

](https://docs.noona.is/docs/hq/sales/ListSales)[

Update a sale POST

Next Page

](https://docs.noona.is/docs/hq/sales/UpdateSale)