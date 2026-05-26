---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Vouchers](https://docs.noona.is/docs/hq/vouchers)

Deletes a voucher with ID

DELETE `/v1/hq/vouchers/{voucher_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

voucher\_id \* string

Voucher ID

## Query Parameters

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/vouchers/string"
```

Empty

Empty[Send a voucher notification POST](https://docs.noona.is/docs/hq/vouchers/CreateVoucherNotification)

[

Previous Page

](https://docs.noona.is/docs/hq/vouchers/CreateVoucherNotification)[

Get voucher GET

Next Page

](https://docs.noona.is/docs/hq/vouchers/GetVoucher)