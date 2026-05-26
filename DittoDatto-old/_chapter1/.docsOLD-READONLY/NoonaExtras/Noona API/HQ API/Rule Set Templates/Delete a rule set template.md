---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) [Rule Set Templates](https://docs.noona.is/docs/hq/rule-set-templates)

Deletes a rule set template at company.

DELETE `/v1/hq/rule_set_templates/{rule_set_template_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

rule\_set\_template\_id \* string

Rule Set Template ID

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/rule_set_templates/dwawd8awudawd"
```

Empty[Create a rule set template POST](https://docs.noona.is/docs/hq/rule-set-templates/CreateRuleSetTemplate)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-set-templates/CreateRuleSetTemplate)[

Retrieve a rule set template GET

Next Page

](https://docs.noona.is/docs/hq/rule-set-templates/GetRuleSetTemplate)