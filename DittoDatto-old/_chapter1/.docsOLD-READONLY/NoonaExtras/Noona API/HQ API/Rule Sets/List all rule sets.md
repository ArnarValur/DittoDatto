---
tag: "noona.is"
---
Lists all rule sets of a company.

GET `/v1/hq/companies/{company_id}/rule_sets`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/rule_sets"
```

```
[

  {

    "date": "2020-08-24",

    "rrule": "string",

    "rule_set_template_id": "7awdXwZoedakjad37a",

    "id": "7awdXwZoedakjad37a",

    "company": "string",

    "title": "string",

    "starts_at": "11:00",

    "ends_at": "13:00",

    "priority": 1,

    "rules": [

      {

        "starts_at": "11:00",

        "ends_at": "13:00",

        "resources": [

          "string"

        ],

        "resources_association": "includes",

        "employees": [

          "string"

        ],

        "employees_association": "includes",

        "type": "availability",

        "open": true

      }

    ],

    "future_instance_count": 1,

    "next_instance": "2020-08-24",

    "created_at": "2019-08-24T14:15:22Z",

    "updated_at": "2019-08-24T14:15:22Z"

  }

]
```[Retrieve a rule set GET](https://docs.noona.is/docs/hq/rule-sets/GetRuleSet)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-sets/GetRuleSet)[

Update a rule set POST

Next Page

](https://docs.noona.is/docs/hq/rule-sets/UpdateRuleSet)