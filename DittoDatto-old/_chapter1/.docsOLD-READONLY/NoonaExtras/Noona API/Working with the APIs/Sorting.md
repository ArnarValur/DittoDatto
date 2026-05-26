---
tag: "noona.is"
---
Working with the APIs

---

All top-level API resources have support for bulk fetches via "list" API methods. Some of these list API methods support sorting via the **sort** query parameter.

The **sort** query parameter accepts a JSON object with the following properties:

```
{

    "field": "<field>",

    "order": "asc/desc", // Defaults to desc

    "ignore_casing": true/false // Defaults to false

}
```

- **field**: The field to sort by
- **order**: The sort direction, either `asc` (ascending) or `desc` (descending). Defaults to `desc` if not specified.
- **ignore\_casing**: When set to `true`, performs case-insensitive sorting for string fields. Defaults to `false`. Note that enabling this option may impact performance for large datasets.[Selecting Fields](https://docs.noona.is/docs/working-with-the-apis/select)

[

Filtering

](https://docs.noona.is/docs/working-with-the-apis/filtering)