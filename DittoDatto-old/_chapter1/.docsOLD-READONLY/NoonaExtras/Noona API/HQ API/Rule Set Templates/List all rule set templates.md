---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Rule Set Templates](https://docs.noona.is/docs/hq/rule-set-templates)

Lists all rule set templates of a company.

GET `/v1/hq/companies/{company_id}/rule_set_templates`

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
curl -X GET "https://api.noona.is/v1/hq/companies/dwawd8awudawd/rule_set_templates"
```

```
[

  {

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
```[Retrieve a rule set template GET](https://docs.noona.is/docs/hq/rule-set-templates/GetRuleSetTemplate)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-set-templates/GetRuleSetTemplate)[

Update a rule set template POST

Next Page

](https://docs.noona.is/docs/hq/rule-set-templates/UpdateRuleSetTemplate)