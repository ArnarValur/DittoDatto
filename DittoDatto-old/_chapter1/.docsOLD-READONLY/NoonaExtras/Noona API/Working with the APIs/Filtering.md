---
tag: "noona.is"
---
Working with the APIs

---

All top-level API resources have support for bulk fetches via "list" API methods. Some of these list API methods support filtering via the **filter** query parameter.

The **filter** query parameter accepts a JSON object that is specific to each resource type being queried. An example for vouchers:

```
{

  "marketplace_user": "<id>",

  "status": "never_used/partly_used/fully_used/expired",

  "type": "service/amount",

  "customer": "<id>",

  "code": "<regex-match-of-code",

  "from": "<date-time>",

  "to": "<date-time>"

}
```

Only resources that have values matching the filter will be returned. The filter is implicitly an **$and** filter.