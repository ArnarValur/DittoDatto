---
tag: "noona.is"
---
Deletes a rule set at company.

DELETE `/v1/hq/rule_sets/{rule_set_id}`

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

rule\_set\_id \* string

Rule Set ID

Example `"dwawd8awudawd"`

## Query Parameters

## Response Body

```
curl -X DELETE "https://api.noona.is/v1/hq/rule_sets/dwawd8awudawd"
```

Empty[Create a rule set POST](https://docs.noona.is/docs/hq/rule-sets/CreateRuleSet)

[

Previous Page

](https://docs.noona.is/docs/hq/rule-sets/CreateRuleSet)[

Retrieve a rule set GET

Next Page

](https://docs.noona.is/docs/hq/rule-sets/GetRuleSet)