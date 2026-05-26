---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Vouchers](https://docs.noona.is/docs/hq/vouchers)

Sends a voucher notification to the specified recipient.

POST `/v1/hq/vouchers/{voucher_id}/notification`

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

## Request Body

application/json

email?string

Email to send voucher to.

Example `"test@testy.is"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/vouchers/string/notification" \

  -H "Content-Type: application/json" \

  -d '{}'
```

Empty

Empty

Empty[Vouchers](https://docs.noona.is/docs/hq/vouchers)

[

Previous Page

](https://docs.noona.is/docs/hq/vouchers)[

Delete voucher DELETE

Next Page

](https://docs.noona.is/docs/hq/vouchers/DeleteVoucher)