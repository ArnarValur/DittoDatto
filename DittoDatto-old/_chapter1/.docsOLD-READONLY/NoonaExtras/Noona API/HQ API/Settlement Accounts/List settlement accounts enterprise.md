---
tag: "noona.is"
---
Lists the settlement accounts of an enterprise.

GET `/v1/hq/enterprise/{enterprise_id}/settlement_accounts`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

enterprise\_id \* string

Enterprise ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/enterprise/string/settlement_accounts"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "name": "Main account",

    "description": "I want all the money here!",

    "ssn": "0503205160",

    "bank": "0542",

    "book": "02",

    "account": "220865",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```

Empty[Get settlement account GET](https://docs.noona.is/docs/hq/settlement-accounts/GetEnterpriseSettlementAccount)

[

Previous Page

](https://docs.noona.is/docs/hq/settlement-accounts/GetEnterpriseSettlementAccount)[

List settlement accounts GET

Next Page

](https://docs.noona.is/docs/hq/settlement-accounts/ListUserSettlementAccounts)