---
tag: "noona.is"
---
Retrieves information about a rule set.

GET `/v1/hq/rule_sets/{rule_set_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

rule\_set\_id \* string

Rule Set ID

## Query Parameters

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/rule_sets/string"
```

```
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
```

Empty[Delete a rule set DELETE](https://docs.noona.is/docs/hq/rule-sets/DeleteRuleSet)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-sets/DeleteRuleSet)[

List all rule sets GET

Next Page

](https://docs.noona.is/docs/hq/rule-sets/ListRuleSets)