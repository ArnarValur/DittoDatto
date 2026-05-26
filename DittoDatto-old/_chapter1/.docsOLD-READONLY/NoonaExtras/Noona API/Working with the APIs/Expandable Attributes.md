---
tag: "noona.is"
---
Working with the APIs

---

All attributes that are tagged with "Expandable attribute" can be expanded.

Expanding an attribute returns the referenced object opposed to just the ID.

To expand an attribute, append the `expand` query parameter to the URL.

`GET /v1/marketplace/vouchers`

```
[

  {

    ...

    "amount": 3990,

    "id": "tJzkMy8OVe4FCGcUg",

    "user": "62458fa81fefab001e1ca18f"

    ...

  }

]
```

`GET /v1/marketplace/vouchers?expand=user`

```
[

  {

    ...

    "amount": 3990,

    "id": "tJzkMy8OVe4FCGcUg",

    "user": {

      "id": "62458fa81fefab001e1ca18f",

      "name": "John The Voucher Buyer"

      ...

    }

    ...

  }

]
```

Nested expanding is also supported.

Let's say we have a list of transactions, and we want to get the titles of all customer groups with ties to that transaction.

- A transaction is a part of a sale
- A sale is possibly tied to a customer
- A customer might belong to 0-N groups

This relationship can be conceptualized as a graph, where a transaction is a node, and the edges represent the connections to sales, customers, and groups.

---

<svg id="_r_ig_" width="100%" xmlns="http://www.w3.org/2000/svg" class="flowchart" style="max-width: 475.3125px;" viewBox="0 0 475.3125 486" role="graphics-document document" aria-roledescription="flowchart-v2"><g><marker id="_r_ig__flowchart-v2-pointEnd" class="marker flowchart-v2" viewBox="0 0 10 10" refX="5" refY="5" markerUnits="userSpaceOnUse" markerWidth="8" markerHeight="8" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" class="arrowMarkerPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker><marker id="_r_ig__flowchart-v2-pointStart" class="marker flowchart-v2" viewBox="0 0 10 10" refX="4.5" refY="5" markerUnits="userSpaceOnUse" markerWidth="8" markerHeight="8" orient="auto"><path d="M 0 5 L 10 10 L 10 0 z" class="arrowMarkerPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker><marker id="_r_ig__flowchart-v2-circleEnd" class="marker flowchart-v2" viewBox="0 0 10 10" refX="11" refY="5" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><circle cx="5" cy="5" r="5" class="arrowMarkerPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></circle></marker><marker id="_r_ig__flowchart-v2-circleStart" class="marker flowchart-v2" viewBox="0 0 10 10" refX="-1" refY="5" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><circle cx="5" cy="5" r="5" class="arrowMarkerPath" style="stroke-width: 1; stroke-dasharray: 1, 0;"></circle></marker><marker id="_r_ig__flowchart-v2-crossEnd" class="marker cross flowchart-v2" viewBox="0 0 11 11" refX="12" refY="5.2" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><path d="M 1,1 l 9,9 M 10,1 l -9,9" class="arrowMarkerPath" style="stroke-width: 2; stroke-dasharray: 1, 0;"></path></marker><marker id="_r_ig__flowchart-v2-crossStart" class="marker cross flowchart-v2" viewBox="0 0 11 11" refX="-1" refY="5.2" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><path d="M 1,1 l 9,9 M 10,1 l -9,9" class="arrowMarkerPath" style="stroke-width: 2; stroke-dasharray: 1, 0;"></path></marker><g class="root"><g class="clusters"></g><g class="edgePaths"><path d="M235.969,62L235.969,66.167C235.969,70.333,235.969,78.667,235.969,86.333C235.969,94,235.969,101,235.969,104.5L235.969,108" id="L_transaction_sale_0" class=" edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" style=";" data-edge="true" data-et="edge" data-id="L_transaction_sale_0" data-points="W3sieCI6MjM1Ljk2ODc1LCJ5Ijo2Mn0seyJ4IjoyMzUuOTY4NzUsInkiOjg3fSx7IngiOjIzNS45Njg3NSwieSI6MTEyfV0=" marker-end="url(#_r_ig__flowchart-v2-pointEnd)"></path><path d="M235.969,166L235.969,170.167C235.969,174.333,235.969,182.667,235.969,190.333C235.969,198,235.969,205,235.969,208.5L235.969,212" id="L_sale_customer_0" class=" edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" style=";" data-edge="true" data-et="edge" data-id="L_sale_customer_0" data-points="W3sieCI6MjM1Ljk2ODc1LCJ5IjoxNjZ9LHsieCI6MjM1Ljk2ODc1LCJ5IjoxOTF9LHsieCI6MjM1Ljk2ODc1LCJ5IjoyMTZ9XQ==" marker-end="url(#_r_ig__flowchart-v2-pointEnd)"></path><path d="M235.969,270L235.969,274.167C235.969,278.333,235.969,286.667,235.969,294.333C235.969,302,235.969,309,235.969,312.5L235.969,316" id="L_customer_groups_0" class=" edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" style=";" data-edge="true" data-et="edge" data-id="L_customer_groups_0" data-points="W3sieCI6MjM1Ljk2ODc1LCJ5IjoyNzB9LHsieCI6MjM1Ljk2ODc1LCJ5IjoyOTV9LHsieCI6MjM1Ljk2ODc1LCJ5IjozMjB9XQ==" marker-end="url(#_r_ig__flowchart-v2-pointEnd)"></path><path d="M179.531,364.346L160.74,370.122C141.948,375.897,104.365,387.449,85.573,396.724C66.781,406,66.781,413,66.781,416.5L66.781,420" id="L_groups_group_0_0" class=" edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" style=";" data-edge="true" data-et="edge" data-id="L_groups_group_0_0" data-points="W3sieCI6MTc5LjUzMTI1LCJ5IjozNjQuMzQ2MTM5NjM3OTc1Nn0seyJ4Ijo2Ni43ODEyNSwieSI6Mzk5fSx7IngiOjY2Ljc4MTI1LCJ5Ijo0MjR9XQ==" marker-end="url(#_r_ig__flowchart-v2-pointEnd)"></path><path d="M235.969,374L235.969,378.167C235.969,382.333,235.969,390.667,235.969,398.333C235.969,406,235.969,413,235.969,416.5L235.969,420" id="L_groups_group_1_0" class=" edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" style=";" data-edge="true" data-et="edge" data-id="L_groups_group_1_0" data-points="W3sieCI6MjM1Ljk2ODc1LCJ5IjozNzR9LHsieCI6MjM1Ljk2ODc1LCJ5IjozOTl9LHsieCI6MjM1Ljk2ODc1LCJ5Ijo0MjR9XQ==" marker-end="url(#_r_ig__flowchart-v2-pointEnd)"></path><path d="M292.406,364.175L311.479,369.979C330.552,375.783,368.698,387.392,387.771,396.696C406.844,406,406.844,413,406.844,416.5L406.844,420" id="L_groups_group_2_0" class=" edge-thickness-normal edge-pattern-solid edge-thickness-normal edge-pattern-solid flowchart-link" style=";" data-edge="true" data-et="edge" data-id="L_groups_group_2_0" data-points="W3sieCI6MjkyLjQwNjI1LCJ5IjozNjQuMTc0ODM1NDA1OTk4NX0seyJ4Ijo0MDYuODQzNzUsInkiOjM5OX0seyJ4Ijo0MDYuODQzNzUsInkiOjQyNH1d" marker-end="url(#_r_ig__flowchart-v2-pointEnd)"></path></g><g class="edgeLabels"><g class="edgeLabel"><g class="label" data-id="L_transaction_sale_0" transform="translate(0, 0)"></g></g><g class="edgeLabel"><g class="label" data-id="L_sale_customer_0" transform="translate(0, 0)"></g></g><g class="edgeLabel"><g class="label" data-id="L_customer_groups_0" transform="translate(0, 0)"></g></g><g class="edgeLabel"><g class="label" data-id="L_groups_group_0_0" transform="translate(0, 0)"></g></g><g class="edgeLabel"><g class="label" data-id="L_groups_group_1_0" transform="translate(0, 0)"></g></g><g class="edgeLabel"><g class="label" data-id="L_groups_group_2_0" transform="translate(0, 0)"></g></g></g><g class="nodes"><g class="node default  " id="flowchart-transaction-0" transform="translate(235.96875, 35)"><rect class="basic label-container" style="" x="-72.2109375" y="-27" width="144.421875" height="54"></rect><g class="label" style="" transform="translate(-42.2109375, -12)"><rect></rect><foreignObject width="84.421875" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">transaction</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g><g class="node default  " id="flowchart-sale-1" transform="translate(235.96875, 139)"><rect class="basic label-container" style="" x="-45.3203125" y="-27" width="90.640625" height="54"></rect><g class="label" style="" transform="translate(-15.3203125, -12)"><rect></rect><foreignObject width="30.640625" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">sale</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g><g class="node default  " id="flowchart-customer-3" transform="translate(235.96875, 243)"><rect class="basic label-container" style="" x="-65.546875" y="-27" width="131.09375" height="54"></rect><g class="label" style="" transform="translate(-35.546875, -12)"><rect></rect><foreignObject width="71.09375" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">customer</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g><g class="node default  " id="flowchart-groups-5" transform="translate(235.96875, 347)"><rect class="basic label-container" style="" x="-56.4375" y="-27" width="112.875" height="54"></rect><g class="label" style="" transform="translate(-26.4375, -12)"><rect></rect><foreignObject width="52.875" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">groups</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g><g class="node default  " id="flowchart-group_0-7" transform="translate(66.78125, 451)"><rect class="basic label-container" style="" x="-58.78125" y="-27" width="117.5625" height="54"></rect><g class="label" style="" transform="translate(-28.78125, -12)"><rect></rect><foreignObject width="57.5625" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">Group 1</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g><g class="node default  " id="flowchart-group_1-9" transform="translate(235.96875, 451)"><rect class="basic label-container" style="" x="-60.40625" y="-27" width="120.8125" height="54"></rect><g class="label" style="" transform="translate(-30.40625, -12)"><rect></rect><foreignObject width="60.8125" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">Group 2</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g><g class="node default  " id="flowchart-group_2-11" transform="translate(406.84375, 451)"><rect class="basic label-container" style="" x="-60.46875" y="-27" width="120.9375" height="54"></rect><g class="label" style="" transform="translate(-30.46875, -12)"><rect></rect><foreignObject width="60.9375" height="24"><p xmlns="http://www.w3.org/1999/xhtml"><span></span></p><p xmlns="http://www.w3.org/1999/xhtml">Group 3</p><p xmlns="http://www.w3.org/1999/xhtml"></p></foreignObject></g></g></g></g></g></svg>

---

By issuing a single API call with nested expanding, it is possible to retrieve the required data, eliminating the need for multiple back-and-forth requests.

`GET /v1/hq/companies/4bF8BQmKtowFKdguf/transactions?expand=sale.customer.groups&select=sale.customer.groups.title`

```
[

  {

    "sale": {

      "customer": {

        "groups": [

          {

            "title": "Family"

          },

          {

            "title": "Regulars"

          }

        ]

      }

    }

  },

  {

    "sale": {

      "customer": {

        "groups": []

      }

    }

  }

]
```

It is also possible expand multiple fields at any depth. The usage is the same as with select, an array of keys to expand is sent as a query parameter:

```
?expand=sale.customer.groups&expand=sale.company&expand=employees
```[Golang Guide \[Template\]](https://docs.noona.is/docs/app-store/guides/golang-template)

[

Selecting Fields

](https://docs.noona.is/docs/working-with-the-apis/select)