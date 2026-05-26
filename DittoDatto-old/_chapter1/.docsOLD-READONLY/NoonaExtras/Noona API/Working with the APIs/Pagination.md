---
tag: "noona.is"
---
Working with the APIs

---

All top-level API resources have support for bulk fetches via "list" API methods. These list API methods support pagination via the **pagination** query parameter.

The **pagination** query parameter accepts a JSON object with the following properties:

```
{

    "limit": <1-100>, # Defaults to 10

    "offset": <0-N> # Defaults to 0

}
```

The **pagination** query parameter accepts a JSON object with the following properties:

```
{

    "limit": <1-100>, # Defaults to 10

    "page": "<page>"

}
```

When a list API method is called, it returns headers that can be used for pagination.

```
/v1/hq/enterprises/dw8awuda8wud/vouchers?pagination={"limit":20}
```

The page can then be passed via the pagination object to the API method again.

```
/v1/hq/enterprises/dw8awuda8wud/vouchers?pagination={"limit":10,"page":"<desired page>"}
```

When paginating with the **sort** or **filter** query parameters, they must remain unchanged on subsequent requests for consistent results.

**Request**

```
<path>?filter={"status":"fully_used"}&sort={"field":"amount"}&pagination={"limit":10}
```

**Response**

```
...

Next-Page: da89wud9a8wud9aw8udaowdjalwjdl

...
```

**Next Page**

```
<path>?filter={"status":"fully_used"}&sort={"field":"amount"}&pagination={"limit":10,"page":"da89wud9a8wud9aw8udaowdjalwjdl"}
```[Behavior](https://docs.noona.is/docs/working-with-the-apis/behavior)

[

Point In Time Properties

](https://docs.noona.is/docs/working-with-the-apis/point-in-time-properties)