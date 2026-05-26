---
tag: "noona.is"
---
Working with the APIs

---

All top-level API resources have support for bulk fetches via "list" API methods. Some of these list API methods support search via the **search** query parameter.

The **search** query parameter accepts a string.

`GET /v1/hq/companies/dpKiYtkTqGyDu9n9b/customers?search=John`

```
[

  {

    "company": "dpKiYtkTqGyDu9n9b",

    "email": "johnnyd@example.com",

    "employee_ids": ["S2YpwGRveYpqDFEPt", "ETTMLegnZ3nbPgbAP", "7orYdekw2hmukkBu8"],

    "event_count": 96,

    "id": "ryaNWRJcNRXMoqf4Z",

    "name": "John Doe The Cuttee",

    "phone_country_code": "354",

    "phone_number": "1111111"

  }

]
```

**Pagination** and **select** have the same functionality for search and *"normal"* requests.

Search is mutually exclusive with the **filter** and **sort** query parameters in most cases.

If **search** is provided, **filter** and **sort** are ignored.

An exception to this rule is when a filter offers **location/radius** based results, those also apply to search.