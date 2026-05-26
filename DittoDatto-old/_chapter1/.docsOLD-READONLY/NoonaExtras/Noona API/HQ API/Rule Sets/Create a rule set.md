---
tag: "noona.is"
---
Creates a rule set for a company.

POST `/v1/hq/rule_sets`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Query Parameters

## Request Body

application/json

date \* string

The date of the rule set.

For recurring rule sets, this is the date where the recurrance rule starts.

Example `"2020-08-24"`

rrule?string

[RRULE](https://icalendar.org/iCalendar-RFC-5545/3-3-10-recurrence-rule.html) string.

The dtstart property is ignored, and the date attribute of the rule set is used to define the beginnin of the reccurence.

rule\_set\_template\_id?string

The template that was used to create this rule set

Example `"7awdXwZoedakjad37a"`

company \* string | never

[Expandable](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

title?string

starts\_at \* string

Start time

Example `"11:00"`

ends\_at \* string

End time

Example `"13:00"`

priority?integer

Lower numbers have higher priority.

This can be used to explicitly overwrite certain rules on dates where multiple rules apply.

Format `int32`

Example `1`

rules?

## Response Body

```
curl -X POST "https://api.noona.is/v1/hq/rule_sets" \

  -H "Content-Type: application/json" \

  -d '{

    "company": "string",

    "date": "2020-08-24",

    "starts_at": "11:00",

    "ends_at": "13:00"

  }'
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
```[Rule Sets](https://docs.noona.is/docs/hq/rule-sets)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-sets)[

Delete a rule set DELETE

Next Page

](https://docs.noona.is/docs/hq/rule-sets/DeleteRuleSet)