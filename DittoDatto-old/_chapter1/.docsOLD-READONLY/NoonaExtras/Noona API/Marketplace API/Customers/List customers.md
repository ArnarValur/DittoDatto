---
tag: "noona.is"
---
[Marketplace API](https://docs.noona.is/docs/marketplace) [Customers](https://docs.noona.is/docs/marketplace/customers)

Lists customers that user has ties with at company.

```
curl -X GET "https://api.noona.is/v1/marketplace/user/companies/string/customers"
```

```
[

  {

    "id": "7awdXwZoedakjad37a",

    "name": "John Doe",

    "ssn": 101011234,

    "email": "example@example.com",

    "license_plate": "ABC123",

    "default": true

  }

]
```

```
{

  "type": "generic_error",

  "message": "Time slot is not available."

}
```