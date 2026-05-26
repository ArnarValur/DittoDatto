---
tag: "noona.is"
---
Deletes a settlement account for an enterprise.

DELETE `/v1/hq/enterprise/{enterprise_id}/settlement_accounts/{settlement_account_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

enterprise\_id \* string

Enterprise ID

settlement\_account\_id \* string

Settlement Account ID

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/enterprise/string/settlement_accounts/string"
```

Empty[Settlement Accounts](https://docs.noona.is/docs/hq/settlement-accounts)

[

Previous Page

](https://docs.noona.is/docs/hq/settlement-accounts)[

Get settlement account GET

Next Page

](https://docs.noona.is/docs/hq/settlement-accounts/GetEnterpriseSettlementAccount)