---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Fiscalization](https://docs.noona.is/docs/hq/fiscalization)

If the transaction is not fiscalized, it will be fiscalized. If the transaction is already fiscalized, the fiscalization record will be returned.

POST `/v1/hq/fiscalizations/transactions/{transaction_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

transaction\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

## Request Body

application/json

customer\_tax\_id?string

The customer's identification number in the tax authority's system.

Different between markets but an example is NIF in Portugal.

Example `"dwawd8awudawd"`

country\_code?string

The customer's country code in the tax authority's system.

Different between markets but an example is PT in Portugal.

Example `"PT"`

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/fiscalizations/transactions/dwawd8awudawd" \

  -H "Content-Type: application/json" \

  -d '{}'
```

```
{

  "id": "7awdXwZoedakjad37a",

  "company": "7awdXwZoedakjad37a",

  "data": {

    "provider": "SaltPay",

    "external_id": "da8wu89dauwd"

  },

  "created_at": "2019-08-24T14:15:22Z",

  "updated_at": "2019-08-24T14:15:22Z"

}
```

```
{

  "message": "Customer onboarding error.",

  "code": "customer_onboarding_error"

}
```[Delete user fiscalization onboarding data DELETE](https://docs.noona.is/docs/hq/fiscalization/DeleteUserFiscalizationData)

[

Previous Page

](https://docs.noona.is/docs/hq/fiscalization/DeleteUserFiscalizationData)[

Get fiscalization onboarding data GET

Next Page

](https://docs.noona.is/docs/hq/fiscalization/GetCompanyFiscalizationData)