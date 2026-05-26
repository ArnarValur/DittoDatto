---
title: "Vue Table Component"
source: "https://ui.nuxt.com/docs/components/table"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive table element to display data in rows and columns."
tags:
---
A responsive table element to display data in rows and columns.

## Usage

The Table component is built on top of [TanStack Table](https://tanstack.com/table/latest) and is powered by the [useVueTable](https://tanstack.com/table/latest/docs/framework/vue/vue-table#usevuetable) composable to provide a flexible and fully type-safe API.

|  | # | Date | Status |  | Amount |  |
| --- | --- | --- | --- | --- | --- | --- |
|  | #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |  |
|  | #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |  |
|  | #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |  |
|  | #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |  |
|  | #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |  |
|  | #4595 | Mar 10, 13:40 | refunded | ava.thomas@example.com | €428.00 |  |
|  | #4594 | Mar 10, 09:15 | paid | michael.wilson@example.com | €683.00 |  |
|  | #4593 | Mar 9, 20:25 |  | olivia.taylor@example.com | €947.00 |  |
|  | #4592 | Mar 9, 18:45 | paid | benjamin.jackson@example.com | €851.00 |  |
|  | #4591 | Mar 9, 16:05 | paid | sophia.miller@example.com | €762.00 |  |
|  | #4590 | Mar 9, 14:20 | paid | noah.clark@example.com | €573.00 |  |
|  | #4589 | Mar 9, 11:35 |  | isabella.lee@example.com | €389.00 |  |
|  | #4588 | Mar 8, 22:50 | refunded | liam.walker@example.com | €701.00 |  |
|  | #4587 | Mar 8, 20:15 | paid | charlotte.hall@example.com | €856.00 |  |
|  | #4586 | Mar 8, 17:40 | paid | mason.young@example.com | €492.00 |  |
|  | #4585 | Mar 8, 14:55 |  | amelia.king@example.com | €637.00 |  |
|  | #4584 | Mar 8, 12:30 | paid | elijah.wright@example.com | €784.00 |  |
|  | #4583 | Mar 8, 09:45 | refunded | harper.scott@example.com | €345.00 |  |
|  | #4582 | Mar 7, 23:10 | paid | evelyn.green@example.com | €918.00 |  |
|  | #4581 | Mar 7, 20:25 | paid | logan.baker@example.com | €567.00 |  |

0 of 20 row(s) selected.

This example demonstrates the most common use case of the `Table` component. Check out the source code on GitHub.

### Data

Use the `data` prop as an array of objects, the columns will be generated based on the keys of the objects.

| Id | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| 4600 | 2024-03-11T15:30:00 | paid | james.anderson@example.com | 594 |
| 4599 | 2024-03-11T10:10:00 | failed | mia.white@example.com | 276 |
| 4598 | 2024-03-11T08:50:00 | refunded | william.brown@example.com | 315 |
| 4597 | 2024-03-10T19:45:00 | paid | emma.davis@example.com | 529 |
| 4596 | 2024-03-10T15:55:00 | paid | ethan.harris@example.com | 639 |

```
<script setup lang="ts">

const data = ref([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

</script>

<template>

  <UTable :data="data" class="flex-1" />

</template>
```

### Columns

Use the `columns` prop as an array of [ColumnDef](https://tanstack.com/table/latest/docs/api/core/column-def) objects with properties like:

- `accessorKey`: The key of the row object to use when extracting the value for the column.
- `header`: The header to display for the column. If a string is passed, it can be used as a default for the column ID. If a function is passed, it will be passed a props object for the header and should return the rendered header value (the exact type depends on the adapter being used).
- `footer`: The footer to display for the column. Works exactly like header, but is displayed under the table.
- `cell`: The cell to display each row for the column. If a function is passed, it will be passed a props object for the cell and should return the rendered cell value (the exact type depends on the adapter being used).
- `meta`: Extra properties for the column.
	- `class`:
		- `td`: The classes to apply to the `td` element.
		- `th`: The classes to apply to the `th` element.
	- `style`:
		- `td`: The style to apply to the `td` element.
		- `th`: The style to apply to the `th` element.

In order to render components or other HTML elements, you will need to use the Vue [`h` function](https://vuejs.org/api/render-function.html#h) inside the `header` and `cell` props. This is different from other components that use slots but allows for more flexibility.

You can also use slots to customize the header and data cells of the table.

| # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
| #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
| #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
| #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

</script>

<template>

  <UTable :data="data" :columns="columns" class="flex-1" />

</template>
```

When rendering components with `h`, you can either use the `resolveComponent` function or import from `#components`.

### Meta

Use the `meta` prop as an object ([TableMeta](https://tanstack.com/table/latest/docs/api/core/table#meta)) to pass properties like:

- `class`:
	- `tr`: The classes to apply to the `tr` element.
- `style`:
	- `tr`: The style to apply to the `tr` element.

| ID | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| 4600 | Mar 11, 15:30 | paid | james.anderson@example.com | $594.00 |
| 4598 | Mar 11, 08:50 | refunded | william.brown@example.com | $315.00 |
| 4597 | Mar 10, 19:45 | paid | emma.davis@example.com | $529.00 |
| 4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | $639.00 |

```
<script setup lang="ts">

import type { TableColumn } from '@nuxt/ui'

import type { TableMeta, Row } from '@tanstack/vue-table'

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: 'ID',

    meta: {

      class: {

        th: 'text-center font-semibold',

        td: 'text-center font-mono'

      }

    }

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    meta: {

      class: {

        th: 'text-center',

        td: 'text-center'

      }

    },

    cell: ({ row }) => {

      const status = row.getValue('status') as string

      const colorMap = {

        paid: 'text-success',

        failed: 'text-error',

        refunded: 'text-warning'

      }

      return h(

        'span',

        { class: \`font-semibold capitalize ${colorMap[status as keyof typeof colorMap]}\` },

        status

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email',

    meta: {

      class: {

        th: 'text-left',

        td: 'text-left'

      }

    }

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right font-bold text-primary',

        td: 'text-right font-mono'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      const formatted = new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'USD'

      }).format(amount)

      return h('span', { class: 'font-semibold text-success' }, formatted)

    }

  }

]

const meta: TableMeta<Payment> = {

  class: {

    tr: (row: Row<Payment>) => {

      if (row.original.status === 'failed') {

        return 'bg-error/10'

      }

      if (row.original.status === 'refunded') {

        return 'bg-warning/10'

      }

      return ''

    }

  }

}

</script>

<template>

  <UTable :data="data" :columns="columns" :meta="meta" class="flex-1" />

</template>
```

Use the `loading` prop to display a loading state, the `loading-color` prop to change its color and the `loading-animation` prop to change its animation.

| Id | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| 4600 | 2024-03-11T15:30:00 | paid | james.anderson@example.com | 594 |
| 4599 | 2024-03-11T10:10:00 | failed | mia.white@example.com | 276 |
| 4598 | 2024-03-11T08:50:00 | refunded | william.brown@example.com | 315 |
| 4597 | 2024-03-10T19:45:00 | paid | emma.davis@example.com | 529 |
| 4596 | 2024-03-10T15:55:00 | paid | ethan.harris@example.com | 639 |

```
<script setup lang="ts">

const data = ref([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

</script>

<template>

  <UTable

    loading

    loading-color="primary"

    loading-animation="carousel"

    :data="data"

    class="flex-1"

  />

</template>
```

### Sticky

Use the `sticky` prop to make the header or footer sticky.

| Id | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| 4600 | 2024-03-11T15:30:00 | paid | james.anderson@example.com | 594 |
| 4599 | 2024-03-11T10:10:00 | failed | mia.white@example.com | 276 |
| 4598 | 2024-03-11T08:50:00 | refunded | william.brown@example.com | 315 |
| 4597 | 2024-03-10T19:45:00 | paid | emma.davis@example.com | 529 |
| 4596 | 2024-03-10T15:55:00 | paid | ethan.harris@example.com | 639 |
| 4595 | 2024-03-10T15:55:00 | paid | ethan.harris@example.com | 639 |
| 4594 | 2024-03-10T15:55:00 | paid | ethan.harris@example.com | 639 |

```
<script setup lang="ts">

const data = ref([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  },

  {

    id: '4595',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  },

  {

    id: '4594',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

</script>

<template>

  <UTable sticky :data="data" class="flex-1 max-h-[312px]" />

</template>
```

## Examples

### With row actions

You can add a new column that renders a [DropdownMenu](https://ui.nuxt.com/docs/components/dropdown-menu) component inside the `cell` to render row actions.

| # | Date | Status | Email | Amount |  |
| --- | --- | --- | --- | --- | --- |
| #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |  |
| #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |  |
| #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |  |
| #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |  |
| #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |  |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

import type { Row } from '@tanstack/vue-table'

import { useClipboard } from '@vueuse/core'

const UButton = resolveComponent('UButton')

const UBadge = resolveComponent('UBadge')

const UDropdownMenu = resolveComponent('UDropdownMenu')

const toast = useToast()

const { copy } = useClipboard()

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  },

  {

    id: 'actions',

    meta: {

      class: {

        td: 'text-right'

      }

    },

    cell: ({ row }) => {

      return h(

        UDropdownMenu,

        {

          content: {

            align: 'end'

          },

          items: getRowItems(row),

          'aria-label': 'Actions dropdown'

        },

        () =>

          h(UButton, {

            icon: 'i-lucide-ellipsis-vertical',

            color: 'neutral',

            variant: 'ghost',

            'aria-label': 'Actions dropdown'

          })

      )

    }

  }

]

function getRowItems(row: Row<Payment>) {

  return [

    {

      type: 'label',

      label: 'Actions'

    },

    {

      label: 'Copy payment ID',

      onSelect() {

        copy(row.original.id)

        toast.add({

          title: 'Payment ID copied to clipboard!',

          color: 'success',

          icon: 'i-lucide-circle-check'

        })

      }

    },

    {

      type: 'separator'

    },

    {

      label: 'View customer'

    },

    {

      label: 'View payment details'

    }

  ]

}

</script>

<template>

  <UTable :data="data" :columns="columns" class="flex-1" />

</template>
```

### With expandable rows

You can add a new column that renders a [Button](https://ui.nuxt.com/docs/components/button) component inside the `cell` to toggle the expandable state of a row using the TanStack Table [Expanding APIs](https://tanstack.com/table/latest/docs/api/features/expanding).

<table><thead><tr><th></th><th>#</th><th>Date</th><th>Status</th><th>Email</th><th>Amount</th></tr></thead><tbody><tr><td></td><td>#4600</td><td>Mar 11, 15:30</td><td><span>paid</span></td><td>james.anderson@example.com</td><td>€594.00</td></tr><tr><td></td><td>#4599</td><td>Mar 11, 10:10</td><td></td><td>mia.white@example.com</td><td>€276.00</td></tr><tr><td colspan="6"><pre><code>{
  "id": "4599",
  "date": "2024-03-11T10:10:00",
  "status": "failed",
  "email": "mia.white@example.com",
  "amount": 276
}</code></pre></td></tr><tr><td></td><td>#4598</td><td>Mar 11, 08:50</td><td><span>refunded</span></td><td>william.brown@example.com</td><td>€315.00</td></tr><tr><td></td><td>#4597</td><td>Mar 10, 19:45</td><td><span>paid</span></td><td>emma.davis@example.com</td><td>€529.00</td></tr><tr><td></td><td>#4596</td><td>Mar 10, 15:55</td><td><span>paid</span></td><td>ethan.harris@example.com</td><td>€639.00</td></tr></tbody></table>

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UButton = resolveComponent('UButton')

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'expand',

    cell: ({ row }) =>

      h(UButton, {

        color: 'neutral',

        variant: 'ghost',

        icon: 'i-lucide-chevron-down',

        square: true,

        'aria-label': 'Expand',

        ui: {

          leadingIcon: [

            'transition-transform',

            row.getIsExpanded() ? 'duration-200 rotate-180' : ''

          ]

        },

        onClick: () => row.toggleExpanded()

      })

  },

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const expanded = ref({ 1: true })

</script>

<template>

  <UTable

    v-model:expanded="expanded"

    :data="data"

    :columns="columns"

    :ui="{ tr: 'data-[expanded=true]:bg-elevated/50' }"

    class="flex-1"

  >

    <template #expanded="{ row }">

      <pre>{{ row.original }}</pre>

    </template>

  </UTable>

</template>
```

You can use the `expanded` prop to control the expandable state of the rows (can be binded with `v-model`).

You could also add this action to the [`DropdownMenu`](https://ui.nuxt.com/docs/components/dropdown-menu) component inside the `actions` column.

### With grouped rows

You can group rows based on a given column value and show/hide sub rows via some button added to the cell using the TanStack Table [Grouping APIs](https://tanstack.com/table/latest/docs/api/features/grouping).

#### Important parts:

- Add `grouping` prop with an array of column ids you want to group by.
- Add `grouping-options` prop. It must include `getGroupedRowModel`, you can import it from `@tanstack/vue-table` or implement your own.
- Expand rows via `row.toggleExpanded()` method on any cell of the row. Keep in mind, it also toggles `#expanded` slot.
- Use `aggregateFn` on column definition to define how to aggregate the rows.
- `agregatedCell` renderer on column definition only works if there is no `cell` renderer.

| Item | # | Date | Email | Amount |
| --- | --- | --- | --- | --- |
| **Account 1** | 3 records | Mar 11, 15:30 | 3 customers | €1,548.00 |
| **Account 2** | 2 records | Mar 11, 10:10 | 2 customers | €805.00 |

```
<script setup lang="ts">

import { resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

import { getGroupedRowModel } from '@tanstack/vue-table'

import type { GroupingOptions } from '@tanstack/vue-table'

const UBadge = resolveComponent('UBadge')

type Account = {

  id: string

  name: string

}

type PaymentStatus = 'paid' | 'failed' | 'refunded'

type Payment = {

  id: string

  date: string

  status: PaymentStatus

  email: string

  amount: number

  account: Account

}

const getColorByStatus = (status: PaymentStatus) => {

  return {

    paid: 'success',

    failed: 'error',

    refunded: 'neutral'

  }[status]

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594,

    account: {

      id: '1',

      name: 'Account 1'

    }

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276,

    account: {

      id: '2',

      name: 'Account 2'

    }

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315,

    account: {

      id: '1',

      name: 'Account 1'

    }

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529,

    account: {

      id: '2',

      name: 'Account 2'

    }

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639,

    account: {

      id: '1',

      name: 'Account 1'

    }

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'title',

    header: 'Item'

  },

  {

    id: 'account_id',

    accessorKey: 'account.id'

  },

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) =>

      row.getIsGrouped() ? \`${row.getValue('id')} records\` : \`#${row.getValue('id')}\`,

    aggregationFn: 'count'

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    },

    aggregationFn: 'max'

  },

  {

    accessorKey: 'status',

    header: 'Status'

  },

  {

    accessorKey: 'email',

    header: 'Email',

    meta: {

      class: {

        td: 'w-full'

      }

    },

    cell: ({ row }) =>

      row.getIsGrouped() ? \`${row.getValue('email')} customers\` : row.getValue('email'),

    aggregationFn: 'uniqueCount'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    },

    aggregationFn: 'sum'

  }

]

const grouping_options = ref<GroupingOptions>({

  groupedColumnMode: 'remove',

  getGroupedRowModel: getGroupedRowModel()

})

</script>

<template>

  <UTable

    :data="data"

    :columns="columns"

    :grouping="['account_id', 'status']"

    :grouping-options="grouping_options"

    :ui="{

      root: 'min-w-full',

      td: 'empty:p-0' // helps with the colspaned row added for expand slot

    }"

  >

    <template #title-cell="{ row }">

      <div v-if="row.getIsGrouped()" class="flex items-center">

        <span class="inline-block" :style="{ width: \`calc(${row.depth} * 1rem)\` }" />

        <UButton

          variant="outline"

          color="neutral"

          class="mr-2"

          size="xs"

          :icon="row.getIsExpanded() ? 'i-lucide-minus' : 'i-lucide-plus'"

          @click="row.toggleExpanded()"

        />

        <strong v-if="row.groupingColumnId === 'account_id'">{{

          row.original.account.name

        }}</strong>

        <UBadge

          v-else-if="row.groupingColumnId === 'status'"

          :color="getColorByStatus(row.original.status)"

          class="capitalize"

          variant="subtle"

        >

          {{ row.original.status }}

        </UBadge>

      </div>

    </template>

  </UTable>

</template>
```

### With row selection

You can add a new column that renders a [Checkbox](https://ui.nuxt.com/docs/components/checkbox) component inside the `header` and `cell` to select rows using the TanStack Table [Row Selection APIs](https://tanstack.com/table/latest/docs/api/features/row-selection).

|  | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
|  | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
|  | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
|  | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
|  | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
|  | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

1 of 5 row(s) selected.

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UCheckbox = resolveComponent('UCheckbox')

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'select',

    header: ({ table }) =>

      h(UCheckbox, {

        modelValue: table.getIsSomePageRowsSelected()

          ? 'indeterminate'

          : table.getIsAllPageRowsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') =>

          table.toggleAllPageRowsSelected(!!value),

        'aria-label': 'Select all'

      }),

    cell: ({ row }) =>

      h(UCheckbox, {

        modelValue: row.getIsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),

        'aria-label': 'Select row'

      })

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const table = useTemplateRef('table')

const rowSelection = ref({ 1: true })

</script>

<template>

  <div class="flex-1 w-full">

    <UTable ref="table" v-model:row-selection="rowSelection" :data="data" :columns="columns" />

    <div class="px-4 py-3.5 border-t border-accented text-sm text-muted">

      {{ table?.tableApi?.getFilteredSelectedRowModel().rows.length || 0 }} of

      {{ table?.tableApi?.getFilteredRowModel().rows.length || 0 }} row(s) selected.

    </div>

  </div>

</template>
```

You can use the `row-selection` prop to control the selection state of the rows (can be binded with `v-model`).

### With row select event

You can add a `@select` listener to make rows clickable with or without a checkbox column.

The handler function receives the `Event` and `TableRow` instance as the first and second arguments respectively.

|  | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
|  | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
|  | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
|  | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
|  | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
|  | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

0 of 5 row(s) selected.

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn, TableRow } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

const UCheckbox = resolveComponent('UCheckbox')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'select',

    header: ({ table }) =>

      h(UCheckbox, {

        modelValue: table.getIsSomePageRowsSelected()

          ? 'indeterminate'

          : table.getIsAllPageRowsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') =>

          table.toggleAllPageRowsSelected(!!value),

        'aria-label': 'Select all'

      }),

    cell: ({ row }) =>

      h(UCheckbox, {

        modelValue: row.getIsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),

        'aria-label': 'Select row'

      })

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const table = useTemplateRef('table')

const rowSelection = ref<Record<string, boolean>>({})

function onSelect(e: Event, row: TableRow<Payment>) {

  /* If you decide to also select the column you can do this  */

  row.toggleSelected(!row.getIsSelected())

}

</script>

<template>

  <div class="flex w-full flex-1 gap-1">

    <div class="flex-1">

      <UTable

        ref="table"

        v-model:row-selection="rowSelection"

        :data="data"

        :columns="columns"

        @select="onSelect"

      />

      <div class="px-4 py-3.5 border-t border-accented text-sm text-muted">

        {{ table?.tableApi?.getFilteredSelectedRowModel().rows.length || 0 }} of

        {{ table?.tableApi?.getFilteredRowModel().rows.length || 0 }} row(s) selected.

      </div>

    </div>

  </div>

</template>
```

You can use this to navigate to a page, open a modal or even to select the row manually.

You can add a `@contextmenu` listener to make rows right clickable and wrap the Table in a [ContextMenu](https://ui.nuxt.com/docs/components/context-menu) component to display row actions for example.

The handler function receives the `Event` and `TableRow` instance as the first and second arguments respectively.

|  | # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- | --- |
|  | #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
|  | #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
|  | #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
|  | #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
|  | #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { ContextMenuItem, TableColumn, TableRow } from '@nuxt/ui'

import { useClipboard } from '@vueuse/core'

const UBadge = resolveComponent('UBadge')

const UCheckbox = resolveComponent('UCheckbox')

const toast = useToast()

const { copy } = useClipboard()

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'select',

    header: ({ table }) =>

      h(UCheckbox, {

        modelValue: table.getIsSomePageRowsSelected()

          ? 'indeterminate'

          : table.getIsAllPageRowsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') =>

          table.toggleAllPageRowsSelected(!!value),

        'aria-label': 'Select all'

      }),

    cell: ({ row }) =>

      h(UCheckbox, {

        modelValue: row.getIsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),

        'aria-label': 'Select row'

      })

  },

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const items = ref<ContextMenuItem[]>([])

function getRowItems(row: TableRow<Payment>) {

  return [

    {

      type: 'label' as const,

      label: 'Actions'

    },

    {

      label: 'Copy payment ID',

      onSelect() {

        copy(row.original.id)

        toast.add({

          title: 'Payment ID copied to clipboard!',

          color: 'success',

          icon: 'i-lucide-circle-check'

        })

      }

    },

    {

      label: row.getIsExpanded() ? 'Collapse' : 'Expand',

      onSelect() {

        row.toggleExpanded()

      }

    },

    {

      type: 'separator' as const

    },

    {

      label: 'View customer'

    },

    {

      label: 'View payment details'

    }

  ]

}

function onContextmenu(_e: Event, row: TableRow<Payment>) {

  items.value = getRowItems(row)

}

</script>

<template>

  <UContextMenu :items="items">

    <UTable :data="data" :columns="columns" class="flex-1" @contextmenu="onContextmenu">

      <template #expanded="{ row }">

        <pre>{{ row.original }}</pre>

      </template>

    </UTable>

  </UContextMenu>

</template>
```

### With row hover event

You can add a `@hover` listener to make rows hoverable and use a [Popover](https://ui.nuxt.com/docs/components/popover) or a [Tooltip](https://ui.nuxt.com/docs/components/tooltip) component to display row details for example.

The handler function receives the `Event` and `TableRow` instance as the first and second arguments respectively.

|  | # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- | --- |
|  | #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
|  | #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
|  | #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
|  | #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
|  | #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn, TableRow } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

const UCheckbox = resolveComponent('UCheckbox')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'select',

    header: ({ table }) =>

      h(UCheckbox, {

        modelValue: table.getIsSomePageRowsSelected()

          ? 'indeterminate'

          : table.getIsAllPageRowsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') =>

          table.toggleAllPageRowsSelected(!!value),

        'aria-label': 'Select all'

      }),

    cell: ({ row }) =>

      h(UCheckbox, {

        modelValue: row.getIsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),

        'aria-label': 'Select row'

      })

  },

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const anchor = ref({ x: 0, y: 0 })

const reference = computed(() => ({

  getBoundingClientRect: () =>

    ({

      width: 0,

      height: 0,

      left: anchor.value.x,

      right: anchor.value.x,

      top: anchor.value.y,

      bottom: anchor.value.y,

      ...anchor.value

    }) as DOMRect

}))

const open = ref(false)

const openDebounced = refDebounced(open, 10)

const selectedRow = ref<TableRow<Payment> | null>(null)

function onHover(_e: Event, row: TableRow<Payment> | null) {

  selectedRow.value = row

  open.value = !!row

}

</script>

<template>

  <div class="flex w-full flex-1 gap-1">

    <UTable

      :data="data"

      :columns="columns"

      class="flex-1"

      @pointermove="

        (ev: PointerEvent) => {

          anchor.x = ev.clientX

          anchor.y = ev.clientY

        }

      "

      @hover="onHover"

    />

    <UPopover

      :content="{ side: 'top', sideOffset: 16, updatePositionStrategy: 'always' }"

      :open="openDebounced"

      :reference="reference"

    >

      <template #content>

        <div class="p-4">

          {{ selectedRow?.original?.id }}

        </div>

      </template>

    </UPopover>

  </div>

</template>
```

This example is similar as the Popover [with following cursor example](https://ui.nuxt.com/docs/components/popover#with-following-cursor) and uses a [`refDebounced`](https://vueuse.org/shared/refDebounced/#refdebounced) to prevent the Popover from opening and closing too quickly when moving the cursor from one row to another.

You can add a `footer` property to the column definition to render a footer for the column.

| # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
| #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
| #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
| #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |
|  |  |  |  | Total: €2,353.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn, TableRow } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    footer: ({ column }) => {

      const total = column

        .getFacetedRowModel()

        .rows.reduce(

          (acc: number, row: TableRow<Payment>) => acc + Number.parseFloat(row.getValue('amount')),

          0

        )

      const formatted = new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(total)

      return \`Total: ${formatted}\`

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

</script>

<template>

  <UTable :data="data" :columns="columns" class="flex-1" />

</template>
```

### With column sorting

You can update a column `header` to render a [Button](https://ui.nuxt.com/docs/components/button) component inside the `header` to toggle the sorting state using the TanStack Table [Sorting APIs](https://tanstack.com/table/latest/docs/api/features/sorting).

| # | Date | Status |  | Amount |
| --- | --- | --- | --- | --- |
| #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
| #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |
| #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
| #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

const UButton = resolveComponent('UButton')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: ({ column }) => {

      const isSorted = column.getIsSorted()

      return h(UButton, {

        color: 'neutral',

        variant: 'ghost',

        label: 'Email',

        icon: isSorted

          ? isSorted === 'asc'

            ? 'i-lucide-arrow-up-narrow-wide'

            : 'i-lucide-arrow-down-wide-narrow'

          : 'i-lucide-arrow-up-down',

        class: '-mx-2.5',

        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')

      })

    }

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const sorting = ref([

  {

    id: 'email',

    desc: false

  }

])

</script>

<template>

  <UTable v-model:sorting="sorting" :data="data" :columns="columns" class="flex-1" />

</template>
```

You can use the `sorting` prop to control the sorting state of the columns (can be binded with `v-model`).

You can also create a reusable component to make any column header sortable.

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |
| #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
| #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
| #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
| #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

import type { Column } from '@tanstack/vue-table'

const UBadge = resolveComponent('UBadge')

const UButton = resolveComponent('UButton')

const UDropdownMenu = resolveComponent('UDropdownMenu')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: ({ column }) => getHeader(column, 'ID'),

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: ({ column }) => getHeader(column, 'Date'),

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: ({ column }) => getHeader(column, 'Status'),

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: ({ column }) => getHeader(column, 'Email')

  },

  {

    accessorKey: 'amount',

    header: ({ column }) => getHeader(column, 'Amount'),

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

function getHeader(column: Column<Payment>, label: string) {

  const isSorted = column.getIsSorted()

  return h(

    UDropdownMenu,

    {

      content: {

        align: 'start'

      },

      'aria-label': 'Actions dropdown',

      items: [

        {

          label: 'Asc',

          type: 'checkbox',

          icon: 'i-lucide-arrow-up-narrow-wide',

          checked: isSorted === 'asc',

          onSelect: () => {

            if (isSorted === 'asc') {

              column.clearSorting()

            } else {

              column.toggleSorting(false)

            }

          }

        },

        {

          label: 'Desc',

          icon: 'i-lucide-arrow-down-wide-narrow',

          type: 'checkbox',

          checked: isSorted === 'desc',

          onSelect: () => {

            if (isSorted === 'desc') {

              column.clearSorting()

            } else {

              column.toggleSorting(true)

            }

          }

        }

      ]

    },

    () =>

      h(UButton, {

        color: 'neutral',

        variant: 'ghost',

        label,

        icon: isSorted

          ? isSorted === 'asc'

            ? 'i-lucide-arrow-up-narrow-wide'

            : 'i-lucide-arrow-down-wide-narrow'

          : 'i-lucide-arrow-up-down',

        class: '-mx-2.5 data-[state=open]:bg-elevated',

        'aria-label': \`Sort by ${isSorted === 'asc' ? 'descending' : 'ascending'}\`

      })

  )

}

const sorting = ref([

  {

    id: 'id',

    desc: false

  }

])

</script>

<template>

  <UTable v-model:sorting="sorting" :data="data" :columns="columns" class="flex-1" />

</template>
```

In this example, we use a function to define the column header but you can also create an actual component.

### With column pinning

You can update a column `header` to render a [Button](https://ui.nuxt.com/docs/components/button) component inside the `header` to toggle the pinning state using the TanStack Table [Pinning APIs](https://tanstack.com/table/latest/docs/api/features/row-pinning).

A pinned column will become sticky on the left or right side of the table. When using column pinning, you should define explicit `size` values for your columns to ensure proper column width handling, especially with multiple pinned columns.

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| #4600000000000000000000000000000000000000 | 2024-03-11T15:30:00 | paid | james.anderson@example.com | €594,000.00 |
| #4599000000000000000000000000000000000000 | 2024-03-11T10:10:00 |  | mia.white@example.com | €276,000.00 |
| #4598000000000000000000000000000000000000 | 2024-03-11T08:50:00 | refunded | william.brown@example.com | €315,000.00 |
| #4597000000000000000000000000000000000000 | 2024-03-10T19:45:00 | paid | emma.davis@example.com | €5,290,000.00 |
| #4596000000000000000000000000000000000000 | 2024-03-10T15:55:00 | paid | ethan.harris@example.com | €639,000.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

import type { Column } from '@tanstack/vue-table'

const UBadge = resolveComponent('UBadge')

const UButton = resolveComponent('UButton')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600000000000000000000000000000000000000',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594000

  },

  {

    id: '4599000000000000000000000000000000000000',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276000

  },

  {

    id: '4598000000000000000000000000000000000000',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315000

  },

  {

    id: '4597000000000000000000000000000000000000',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 5290000

  },

  {

    id: '4596000000000000000000000000000000000000',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639000

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: ({ column }) => getHeader(column, 'ID', 'left'),

    cell: ({ row }) => \`#${row.getValue('id')}\`,

    size: 381

  },

  {

    accessorKey: 'date',

    header: ({ column }) => getHeader(column, 'Date', 'left'),

    size: 172

  },

  {

    accessorKey: 'status',

    header: ({ column }) => getHeader(column, 'Status', 'left'),

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    },

    size: 103

  },

  {

    accessorKey: 'email',

    header: ({ column }) => getHeader(column, 'Email', 'left'),

    size: 232

  },

  {

    accessorKey: 'amount',

    header: ({ column }) => getHeader(column, 'Amount', 'right'),

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    },

    size: 130

  }

]

function getHeader(column: Column<Payment>, label: string, position: 'left' | 'right') {

  const isPinned = column.getIsPinned()

  return h(UButton, {

    color: 'neutral',

    variant: 'ghost',

    label,

    icon: isPinned ? 'i-lucide-pin-off' : 'i-lucide-pin',

    class: '-mx-2.5',

    onClick() {

      column.pin(isPinned === position ? false : position)

    }

  })

}

const columnPinning = ref({

  left: ['id'],

  right: ['amount']

})

</script>

<template>

  <UTable v-model:column-pinning="columnPinning" :data="data" :columns="columns" class="flex-1" />

</template>
```

You can use the `column-pinning` prop to control the pinning state of the columns (can be binded with `v-model`).

### With column visibility

You can use a [DropdownMenu](https://ui.nuxt.com/docs/components/dropdown-menu) component to toggle the visibility of the columns using the TanStack Table [Column Visibility APIs](https://tanstack.com/table/latest/docs/api/features/column-visibility).

| Date | Status | Email | Amount |
| --- | --- | --- | --- |
| Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
| Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
| Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
| Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import { upperFirst } from 'scule'

import type { TableColumn } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const table = useTemplateRef('table')

const columnVisibility = ref({

  id: false

})

</script>

<template>

  <div class="flex flex-col flex-1 w-full">

    <div class="flex justify-end px-4 py-3.5 border-b  border-accented">

      <UDropdownMenu

        :items="

          table?.tableApi

            ?.getAllColumns()

            .filter((column) => column.getCanHide())

            .map((column) => ({

              label: upperFirst(column.id),

              type: 'checkbox' as const,

              checked: column.getIsVisible(),

              onUpdateChecked(checked: boolean) {

                table?.tableApi?.getColumn(column.id)?.toggleVisibility(!!checked)

              },

              onSelect(e: Event) {

                e.preventDefault()

              }

            }))

        "

        :content="{ align: 'end' }"

      >

        <UButton

          label="Columns"

          color="neutral"

          variant="outline"

          trailing-icon="i-lucide-chevron-down"

        />

      </UDropdownMenu>

    </div>

    <UTable

      ref="table"

      v-model:column-visibility="columnVisibility"

      :data="data"

      :columns="columns"

    />

  </div>

</template>
```

You can use the `column-visibility` prop to control the visibility state of the columns (can be binded with `v-model`).

### With column filters

You can use an [Input](https://ui.nuxt.com/docs/components/input) component to filter per column the rows using the TanStack Table [Column Filtering APIs](https://tanstack.com/table/latest/docs/api/features/column-filtering).

| # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| #4600 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const table = useTemplateRef('table')

const columnFilters = ref([

  {

    id: 'email',

    value: 'james'

  }

])

</script>

<template>

  <div class="flex flex-col flex-1 w-full">

    <div class="flex px-4 py-3.5 border-b border-accented">

      <UInput

        :model-value="table?.tableApi?.getColumn('email')?.getFilterValue() as string"

        class="max-w-sm"

        placeholder="Filter emails..."

        @update:model-value="table?.tableApi?.getColumn('email')?.setFilterValue($event)"

      />

    </div>

    <UTable ref="table" v-model:column-filters="columnFilters" :data="data" :columns="columns" />

  </div>

</template>
```

You can use the `column-filters` prop to control the filters state of the columns (can be binded with `v-model`).

### With global filter

You can use an [Input](https://ui.nuxt.com/docs/components/input) component to filter the rows using the TanStack Table [Global Filtering APIs](https://tanstack.com/table/latest/docs/api/features/global-filtering).

| # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| #4599 | Mar 11, 10:10 |  | mia.white@example.com | €276.00 |
| #4598 | Mar 11, 08:50 | refunded | william.brown@example.com | €315.00 |
| #4597 | Mar 10, 19:45 | paid | emma.davis@example.com | €529.00 |
| #4596 | Mar 10, 15:55 | paid | ethan.harris@example.com | €639.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    status: 'paid',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    status: 'failed',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    status: 'refunded',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    status: 'paid',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    status: 'paid',

    email: 'ethan.harris@example.com',

    amount: 639

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const globalFilter = ref('45')

</script>

<template>

  <div class="flex flex-col flex-1 w-full">

    <div class="flex px-4 py-3.5 border-b border-accented">

      <UInput v-model="globalFilter" class="max-w-sm" placeholder="Filter..." />

    </div>

    <UTable ref="table" v-model:global-filter="globalFilter" :data="data" :columns="columns" />

  </div>

</template>
```

You can use the `global-filter` prop to control the global filter state (can be binded with `v-model`).

### With pagination

You can use a [Pagination](https://ui.nuxt.com/docs/components/pagination) component to control the pagination state using the [Pagination APIs](https://tanstack.com/table/latest/docs/api/features/pagination).

There are different pagination approaches as explained in [Pagination Guide](https://tanstack.com/table/latest/docs/guide/pagination#pagination-guide). In this example, we use client-side pagination so we need to manually pass `getPaginationRowModel()` function.

| # | Date | Email | Amount |
| --- | --- | --- | --- |
| #4600 | Mar 11, 15:30 | james.anderson@example.com | €594.00 |
| #4599 | Mar 11, 10:10 | mia.white@example.com | €276.00 |
| #4598 | Mar 11, 08:50 | william.brown@example.com | €315.00 |
| #4597 | Mar 10, 19:45 | emma.davis@example.com | €529.00 |
| #4596 | Mar 10, 15:55 | ethan.harris@example.com | €639.00 |

```
<script setup lang="ts">

import { getPaginationRowModel } from '@tanstack/vue-table'

import type { TableColumn } from '@nuxt/ui'

const table = useTemplateRef('table')

type Payment = {

  id: string

  date: string

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    email: 'emma.davis@example.com',

    amount: 529

  },

  {

    id: '4596',

    date: '2024-03-10T15:55:00',

    email: 'ethan.harris@example.com',

    amount: 639

  },

  {

    id: '4595',

    date: '2024-03-10T13:20:00',

    email: 'sophia.miller@example.com',

    amount: 428

  },

  {

    id: '4594',

    date: '2024-03-10T11:05:00',

    email: 'noah.wilson@example.com',

    amount: 673

  },

  {

    id: '4593',

    date: '2024-03-09T22:15:00',

    email: 'olivia.jones@example.com',

    amount: 382

  },

  {

    id: '4592',

    date: '2024-03-09T20:30:00',

    email: 'liam.taylor@example.com',

    amount: 547

  },

  {

    id: '4591',

    date: '2024-03-09T18:45:00',

    email: 'ava.thomas@example.com',

    amount: 291

  },

  {

    id: '4590',

    date: '2024-03-09T16:20:00',

    email: 'lucas.martin@example.com',

    amount: 624

  },

  {

    id: '4589',

    date: '2024-03-09T14:10:00',

    email: 'isabella.clark@example.com',

    amount: 438

  },

  {

    id: '4588',

    date: '2024-03-09T12:05:00',

    email: 'mason.rodriguez@example.com',

    amount: 583

  },

  {

    id: '4587',

    date: '2024-03-09T10:30:00',

    email: 'sophia.lee@example.com',

    amount: 347

  },

  {

    id: '4586',

    date: '2024-03-09T08:15:00',

    email: 'ethan.walker@example.com',

    amount: 692

  },

  {

    id: '4585',

    date: '2024-03-08T23:40:00',

    email: 'amelia.hall@example.com',

    amount: 419

  },

  {

    id: '4584',

    date: '2024-03-08T21:25:00',

    email: 'oliver.young@example.com',

    amount: 563

  },

  {

    id: '4583',

    date: '2024-03-08T19:50:00',

    email: 'aria.king@example.com',

    amount: 328

  },

  {

    id: '4582',

    date: '2024-03-08T17:35:00',

    email: 'henry.wright@example.com',

    amount: 647

  },

  {

    id: '4581',

    date: '2024-03-08T15:20:00',

    email: 'luna.lopez@example.com',

    amount: 482

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const pagination = ref({

  pageIndex: 0,

  pageSize: 5

})

const globalFilter = ref('')

</script>

<template>

  <div class="w-full space-y-4 pb-4">

    <div class="flex px-4 py-3.5 border-b border-accented">

      <UInput v-model="globalFilter" class="max-w-sm" placeholder="Filter..." />

    </div>

    <UTable

      ref="table"

      v-model:pagination="pagination"

      v-model:global-filter="globalFilter"

      :data="data"

      :columns="columns"

      :pagination-options="{

        getPaginationRowModel: getPaginationRowModel()

      }"

      class="flex-1"

    />

    <div class="flex justify-end border-t border-default pt-4 px-4">

      <UPagination

        :page="(table?.tableApi?.getState().pagination.pageIndex || 0) + 1"

        :items-per-page="table?.tableApi?.getState().pagination.pageSize"

        :total="table?.tableApi?.getFilteredRowModel().rows.length"

        @update:page="(p) => table?.tableApi?.setPageIndex(p - 1)"

      />

    </div>

  </div>

</template>
```

You can use the `pagination` prop to control the pagination state (can be binded with `v-model`).

### With fetched data

You can fetch data from an API and use them in the Table.

| ID | Name | Email | Company |
| --- | --- | --- | --- |
| 1 | ![Leanne Graham avatar](https://i.pravatar.cc/120?img=1)  Leanne Graham avatar  Leanne Graham  @Bret | Sincere@april.biz | Romaguera-Crona |
| 2 | ![Ervin Howell avatar](https://i.pravatar.cc/120?img=2)  Ervin Howell avatar  Ervin Howell  @Antonette | Shanna@melissa.tv | Deckow-Crist |
| 3 | ![Clementine Bauch avatar](https://i.pravatar.cc/120?img=3)  Clementine Bauch avatar  Clementine Bauch  @Samantha | Nathan@yesenia.net | Romaguera-Jacobson |
| 4 | ![Patricia Lebsack avatar](https://i.pravatar.cc/120?img=4)  Patricia Lebsack avatar  Patricia Lebsack  @Karianne | Julianne.OConner@kory.org | Robel-Corkery |
| 5 | ![Chelsey Dietrich avatar](https://i.pravatar.cc/120?img=5)  Chelsey Dietrich avatar  Chelsey Dietrich  @Kamren | Lucio\_Hettinger@annie.ca | Keebler LLC |
| 6 | ![Mrs. Dennis Schulist avatar](https://i.pravatar.cc/120?img=6)  Mrs. Dennis Schulist avatar  Mrs. Dennis Schulist  @Leopoldo\_Corkery | Karley\_Dach@jasper.info | Considine-Lockman |
| 7 | ![Kurtis Weissnat avatar](https://i.pravatar.cc/120?img=7)  Kurtis Weissnat avatar  Kurtis Weissnat  @Elwyn.Skiles | Telly.Hoeger@billy.biz | Johns Group |
| 8 | ![Nicholas Runolfsdottir V avatar](https://i.pravatar.cc/120?img=8)  Nicholas Runolfsdottir V avatar  Nicholas Runolfsdottir V  @Maxime\_Nienow | Sherwood@rosamond.me | Abernathy Group |
| 9 | ![Glenna Reichert avatar](https://i.pravatar.cc/120?img=9)  Glenna Reichert avatar  Glenna Reichert  @Delphine | Chaim\_McDermott@dana.io | Yost and Sons |
| 10 | ![Clementina DuBuque avatar](https://i.pravatar.cc/120?img=10)  Clementina DuBuque avatar  Clementina DuBuque  @Moriah.Stanton | Rey.Padberg@karina.biz | Hoeger LLC |

```
<script setup lang="ts">

import type { TableColumn } from '@nuxt/ui'

const UAvatar = resolveComponent('UAvatar')

type User = {

  id: number

  name: string

  username: string

  email: string

  avatar: { src: string }

  company: { name: string }

}

const { data, status } = await useFetch<User[]>('https://jsonplaceholder.typicode.com/users', {

  key: 'table-users',

  transform: (data) => {

    return (

      data?.map((user) => ({

        ...user,

        avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\`, alt: \`${user.name} avatar\` }

      })) || []

    )

  },

  lazy: true

})

const columns: TableColumn<User>[] = [

  {

    accessorKey: 'id',

    header: 'ID'

  },

  {

    accessorKey: 'name',

    header: 'Name',

    cell: ({ row }) => {

      return h('div', { class: 'flex items-center gap-3' }, [

        h(UAvatar, {

          ...row.original.avatar,

          size: 'lg'

        }),

        h('div', undefined, [

          h('p', { class: 'font-medium text-highlighted' }, row.original.name),

          h('p', { class: '' }, \`@${row.original.username}\`)

        ])

      ])

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'company',

    header: 'Company',

    cell: ({ row }) => row.original.company.name

  }

]

</script>

<template>

  <UTable :data="data" :columns="columns" :loading="status === 'pending'" class="flex-1 h-80" />

</template>
```

### With infinite scroll

If you use server-side pagination, you can use the [`useInfiniteScroll`](https://vueuse.org/core/useInfiniteScroll/#useinfinitescroll) composable to load more data as the user scrolls.

| ID | Avatar | First name | Email | Username |
| --- | --- | --- | --- | --- |
| 1 |  | Emily | emily.johnson@x.dummyjson.com | emilys |
| 2 |  | Michael | michael.williams@x.dummyjson.com | michaelw |
| 3 |  | Sophia | sophia.brown@x.dummyjson.com | sophiab |
| 4 |  | James | james.davis@x.dummyjson.com | jamesd |
| 5 |  | Emma | emma.miller@x.dummyjson.com | emmaj |
| 6 |  | Olivia | olivia.wilson@x.dummyjson.com | oliviaw |
| 7 |  | Alexander | alexander.jones@x.dummyjson.com | alexanderj |
| 8 |  | Ava | ava.taylor@x.dummyjson.com | avat |
| 9 |  | Ethan | ethan.martinez@x.dummyjson.com | ethanm |
| 10 |  | Isabella | isabella.anderson@x.dummyjson.com | isabellad |

```
<script setup lang="ts">

import type { TableColumn } from '@nuxt/ui'

import { useInfiniteScroll } from '@vueuse/core'

const UAvatar = resolveComponent('UAvatar')

type User = {

  id: number

  firstName: string

  username: string

  email: string

  image: string

}

type UserResponse = {

  users: User[]

  total: number

  skip: number

  limit: number

}

const skip = ref(0)

const { data, status, execute } = await useFetch(

  'https://dummyjson.com/users?limit=10&select=firstName,username,email,image',

  {

    key: 'table-users-infinite-scroll',

    params: { skip },

    transform: (data?: UserResponse) => {

      return data?.users

    },

    lazy: true,

    immediate: false

  }

)

const columns: TableColumn<User>[] = [

  {

    accessorKey: 'id',

    header: 'ID'

  },

  {

    accessorKey: 'image',

    header: 'Avatar',

    cell: ({ row }) => h(UAvatar, { src: row.original.image })

  },

  {

    accessorKey: 'firstName',

    header: 'First name'

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'username',

    header: 'Username'

  }

]

const users = ref<User[]>([])

watch(data, () => {

  users.value = [...users.value, ...(data.value || [])]

})

execute()

const table = useTemplateRef('table')

onMounted(() => {

  useInfiniteScroll(

    table.value?.$el,

    () => {

      skip.value += 10

    },

    {

      distance: 200,

      canLoadMore: () => {

        return status.value !== 'pending'

      }

    }

  )

})

</script>

<template>

  <UTable

    ref="table"

    :data="users"

    :columns="columns"

    :loading="status === 'pending'"

    sticky

    class="flex-1 h-80"

  />

</template>
```

### With drag and drop

You can use the [`useSortable`](https://vueuse.org/integrations/useSortable/) composable from [`@vueuse/integrations`](https://vueuse.org/integrations/README.html) to enable drag and drop functionality on the Table. This integration wraps [Sortable.js](https://sortablejs.github.io/Sortable/) to provide a seamless drag and drop experience.

Since the table ref doesn't expose the tbody element, add a unique class to it via the `:ui` prop to target it with `useSortable` (e.g. `:ui="{ tbody: 'my-table-tbody' }"`).

| # | Date | Email | Amount |
| --- | --- | --- | --- |
| #4600 | Mar 11, 15:30 | james.anderson@example.com | €594.00 |
| #4599 | Mar 11, 10:10 | mia.white@example.com | €276.00 |
| #4598 | Mar 11, 08:50 | william.brown@example.com | €315.00 |
| #4597 | Mar 10, 19:45 | emma.davis@example.com | €529.00 |

```
<script setup lang="ts">

import type { TableColumn } from '@nuxt/ui'

import { useSortable } from '@vueuse/integrations/useSortable'

type Payment = {

  id: string

  date: string

  email: string

  amount: number

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    email: 'james.anderson@example.com',

    amount: 594

  },

  {

    id: '4599',

    date: '2024-03-11T10:10:00',

    email: 'mia.white@example.com',

    amount: 276

  },

  {

    id: '4598',

    date: '2024-03-11T08:50:00',

    email: 'william.brown@example.com',

    amount: 315

  },

  {

    id: '4597',

    date: '2024-03-10T19:45:00',

    email: 'emma.davis@example.com',

    amount: 529

  }

])

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

useSortable('.my-table-tbody', data, {

  animation: 150

})

</script>

<template>

  <UTable

    ref="table"

    :data="data"

    :columns="columns"

    :ui="{

      tbody: 'my-table-tbody'

    }"

    class="flex-1"

  />

</template>
```

### With virtualization 4.1+

Use the `virtualize` prop to enable virtualization for large datasets as a boolean or an object with options like `{ estimateSize: 65, overscan: 12 }`. You can also pass other [TanStack Virtual options](https://tanstack.com/virtual/latest/docs/api/virtualizer#optional-options) to customize the virtualization behavior.

When virtualization is enabled, the divider between rows and sticky properties are not supported.

| # | Date | Status | Email | Amount |
| --- | --- | --- | --- | --- |
| #4600-0 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-1 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-2 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-3 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-4 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-5 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-6 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-7 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-8 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-9 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-10 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-11 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-12 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-13 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-14 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-15 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |
| #4600-16 | Mar 11, 15:30 | paid | james.anderson@example.com | €594.00 |

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UBadge = resolveComponent('UBadge')

type Payment = {

  id: string

  date: string

  status: 'paid' | 'failed' | 'refunded'

  email: string

  amount: number

}

const data = ref<Payment[]>(

  Array(1000)

    .fill(0)

    .map((_, i) => ({

      id: \`4600-${i}\`,

      date: '2024-03-11T15:30:00',

      status: 'paid',

      email: 'james.anderson@example.com',

      amount: 594

    }))

)

const columns: TableColumn<Payment>[] = [

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => \`#${row.getValue('id')}\`

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'status',

    header: 'Status',

    cell: ({ row }) => {

      const color = {

        paid: 'success' as const,

        failed: 'error' as const,

        refunded: 'neutral' as const

      }[row.getValue('status') as string]

      return h(UBadge, { class: 'capitalize', variant: 'subtle', color }, () =>

        row.getValue('status')

      )

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

</script>

<template>

  <UTable virtualize :data="data" :columns="columns" class="flex-1 h-80" />

</template>
```

A height constraint is required on the table for virtualization to work properly (e.g., `class="h-[400px]"`).

### With tree data

You can use the `get-sub-rows` prop to display hierarchical (tree) data in the table. For example, if your data objects have a `children` array, set `:get-sub-rows="row => row.children"` to enable expandable rows.

<table><thead><tr><th></th><th>#</th><th>Date</th><th>Email</th><th>Amount</th></tr></thead><tbody><tr><td></td><td><p>4600</p></td><td>Mar 11, 15:30</td><td>james.anderson@example.com</td><td>€594.00</td></tr><tr><td colspan="5"></td></tr><tr><td></td><td><p>4599</p></td><td>Mar 11, 10:10</td><td>mia.white@example.com</td><td>€276.00</td></tr><tr><td></td><td><p>4598</p></td><td>Mar 11, 08:50</td><td>william.brown@example.com</td><td>€315.00</td></tr><tr><td></td><td><p>4597</p></td><td>Mar 10, 19:45</td><td>emma.davis@example.com</td><td>€529.00</td></tr><tr><td></td><td><p>4589</p></td><td>Mar 9, 11:35</td><td>isabella.lee@example.com</td><td>€389.00</td></tr></tbody></table>

```
<script setup lang="ts">

import { h, resolveComponent } from 'vue'

import type { TableColumn } from '@nuxt/ui'

const UCheckbox = resolveComponent('UCheckbox')

const UButton = resolveComponent('UButton')

type Payment = {

  id: string

  date: string

  email: string

  amount: number

  children?: Payment[]

}

const data = ref<Payment[]>([

  {

    id: '4600',

    date: '2024-03-11T15:30:00',

    email: 'james.anderson@example.com',

    amount: 594,

    children: [

      {

        id: '4599',

        date: '2024-03-11T10:10:00',

        email: 'mia.white@example.com',

        amount: 276

      },

      {

        id: '4598',

        date: '2024-03-11T08:50:00',

        email: 'william.brown@example.com',

        amount: 315

      },

      {

        id: '4597',

        date: '2024-03-10T19:45:00',

        email: 'emma.davis@example.com',

        amount: 529,

        children: [

          {

            id: '4592',

            date: '2024-03-09T18:45:00',

            email: 'benjamin.jackson@example.com',

            amount: 851

          },

          {

            id: '4591',

            date: '2024-03-09T16:05:00',

            email: 'sophia.miller@example.com',

            amount: 762

          },

          {

            id: '4590',

            date: '2024-03-09T14:20:00',

            email: 'noah.clark@example.com',

            amount: 573,

            children: [

              {

                id: '4596',

                date: '2024-03-10T15:55:00',

                email: 'ethan.harris@example.com',

                amount: 639

              },

              {

                id: '4595',

                date: '2024-03-10T13:40:00',

                email: 'ava.thomas@example.com',

                amount: 428

              }

            ]

          }

        ]

      }

    ]

  },

  {

    id: '4589',

    date: '2024-03-09T11:35:00',

    email: 'isabella.lee@example.com',

    amount: 389

  }

])

const columns: TableColumn<Payment>[] = [

  {

    id: 'select',

    header: ({ table }) =>

      h(UCheckbox, {

        modelValue: table.getIsSomePageRowsSelected()

          ? 'indeterminate'

          : table.getIsAllPageRowsSelected(),

        'onUpdate:modelValue': (value: boolean | 'indeterminate') =>

          table.toggleAllPageRowsSelected(!!value),

        'aria-label': 'Select all'

      }),

    cell: ({ row }) =>

      h(UCheckbox, {

        modelValue: row.getIsSelected() ? true : row.getIsSomeSelected() ? 'indeterminate' : false,

        'onUpdate:modelValue': (value: boolean | 'indeterminate') => row.toggleSelected(!!value),

        'aria-label': 'Select row'

      })

  },

  {

    accessorKey: 'id',

    header: '#',

    cell: ({ row }) => {

      return h(

        'div',

        {

          style: {

            paddingLeft: \`${row.depth}rem\`

          },

          class: 'flex items-center gap-2'

        },

        [

          h(UButton, {

            color: 'neutral',

            variant: 'outline',

            size: 'xs',

            icon: row.getIsExpanded() ? 'i-lucide-minus' : 'i-lucide-plus',

            class: !row.getCanExpand() && 'invisible',

            ui: {

              base: 'p-0 rounded-sm',

              leadingIcon: 'size-4'

            },

            onClick: row.getToggleExpandedHandler()

          }),

          row.getValue('id') as string

        ]

      )

    }

  },

  {

    accessorKey: 'date',

    header: 'Date',

    cell: ({ row }) => {

      return new Date(row.getValue('date')).toLocaleString('en-US', {

        day: 'numeric',

        month: 'short',

        hour: '2-digit',

        minute: '2-digit',

        hour12: false

      })

    }

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'amount',

    header: 'Amount',

    meta: {

      class: {

        th: 'text-right',

        td: 'text-right font-medium'

      }

    },

    cell: ({ row }) => {

      const amount = Number.parseFloat(row.getValue('amount'))

      return new Intl.NumberFormat('en-US', {

        style: 'currency',

        currency: 'EUR'

      }).format(amount)

    }

  }

]

const expanded = ref({ 0: true })

</script>

<template>

  <UTable

    v-model:expanded="expanded"

    :data="data"

    :columns="columns"

    :get-sub-rows="(row) => row.children"

    class="flex-1"

    :ui="{

      base: 'border-separate border-spacing-0',

      tbody: '[&>tr]:last:[&>td]:border-b-0',

      tr: 'group',

      td: 'empty:p-0 group-has-[td:not(:empty)]:border-b border-default'

    }"

  />

</template>
```

### With slots

You can use slots to customize the header and data cells of the table.

Use the `#<column>-header` slot to customize the header of a column. You will have access to the `column`, `header` and `table` properties in the slot scope.

Use the `#<column>-cell` slot to customize the cell of a column. You will have access to the `cell`, `column`, `getValue`, `renderValue`, `row`, and `table` properties in the slot scope.

| ID | Name | Email | Role |  |
| --- | --- | --- | --- | --- |
| 1 | ![Lindsay Walton avatar](https://i.pravatar.cc/120?img=1)  Lindsay Walton avatar  Lindsay Walton  Front-end Developer | lindsay.walton@example.com | Member |  |
| 2 | ![Courtney Henry avatar](https://i.pravatar.cc/120?img=2)  Courtney Henry avatar  Courtney Henry  Designer | courtney.henry@example.com | Admin |  |
| 3 | ![Tom Cook avatar](https://i.pravatar.cc/120?img=3)  Tom Cook avatar  Tom Cook  Director of Product | tom.cook@example.com | Member |  |
| 4 | ![Whitney Francis avatar](https://i.pravatar.cc/120?img=4)  Whitney Francis avatar  Whitney Francis  Copywriter | whitney.francis@example.com | Admin |  |
| 5 | ![Leonard Krasner avatar](https://i.pravatar.cc/120?img=5)  Leonard Krasner avatar  Leonard Krasner  Senior Designer | leonard.krasner@example.com | Owner |  |
| 6 | ![Floyd Miles avatar](https://i.pravatar.cc/120?img=6)  Floyd Miles avatar  Floyd Miles  Principal Designer | floyd.miles@example.com | Member |  |

```
<script setup lang="ts">

import type { TableColumn, DropdownMenuItem } from '@nuxt/ui'

import { useClipboard } from '@vueuse/core'

interface User {

  id: number

  name: string

  position: string

  email: string

  role: string

}

const toast = useToast()

const { copy } = useClipboard()

const data = ref<User[]>([

  {

    id: 1,

    name: 'Lindsay Walton',

    position: 'Front-end Developer',

    email: 'lindsay.walton@example.com',

    role: 'Member'

  },

  {

    id: 2,

    name: 'Courtney Henry',

    position: 'Designer',

    email: 'courtney.henry@example.com',

    role: 'Admin'

  },

  {

    id: 3,

    name: 'Tom Cook',

    position: 'Director of Product',

    email: 'tom.cook@example.com',

    role: 'Member'

  },

  {

    id: 4,

    name: 'Whitney Francis',

    position: 'Copywriter',

    email: 'whitney.francis@example.com',

    role: 'Admin'

  },

  {

    id: 5,

    name: 'Leonard Krasner',

    position: 'Senior Designer',

    email: 'leonard.krasner@example.com',

    role: 'Owner'

  },

  {

    id: 6,

    name: 'Floyd Miles',

    position: 'Principal Designer',

    email: 'floyd.miles@example.com',

    role: 'Member'

  }

])

const columns: TableColumn<User>[] = [

  {

    accessorKey: 'id',

    header: 'ID'

  },

  {

    accessorKey: 'name',

    header: 'Name'

  },

  {

    accessorKey: 'email',

    header: 'Email'

  },

  {

    accessorKey: 'role',

    header: 'Role'

  },

  {

    id: 'action'

  }

]

function getDropdownActions(user: User): DropdownMenuItem[][] {

  return [

    [

      {

        label: 'Copy user Id',

        icon: 'i-lucide-copy',

        onSelect: () => {

          copy(user.id.toString())

          toast.add({

            title: 'User ID copied to clipboard!',

            color: 'success',

            icon: 'i-lucide-circle-check'

          })

        }

      }

    ],

    [

      {

        label: 'Edit',

        icon: 'i-lucide-edit'

      },

      {

        label: 'Delete',

        icon: 'i-lucide-trash',

        color: 'error'

      }

    ]

  ]

}

</script>

<template>

  <UTable :data="data" :columns="columns" class="flex-1">

    <template #name-cell="{ row }">

      <div class="flex items-center gap-3">

        <UAvatar

          :src="\`https://i.pravatar.cc/120?img=${row.original.id}\`"

          size="lg"

          :alt="\`${row.original.name} avatar\`"

        />

        <div>

          <p class="font-medium text-highlighted">

            {{ row.original.name }}

          </p>

          <p>

            {{ row.original.position }}

          </p>

        </div>

      </div>

    </template>

    <template #action-cell="{ row }">

      <UDropdownMenu :items="getDropdownActions(row.original)">

        <UButton

          icon="i-lucide-ellipsis-vertical"

          color="neutral"

          variant="ghost"

          aria-label="Actions"

        />

      </UDropdownMenu>

    </template>

  </UTable>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `data` |  | ` T[]` |
| `columns` |  | ` TableColumn<T, unknown>[]` |
| `caption` |  | ` string` |
| `meta` |  | ` TableMeta<T>`  You can pass any object to `options.meta` and access it anywhere the `table` is available via `table.options.meta`.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#meta) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `virtualize` | `false` | `boolean \| (Partial<Omit<VirtualizerOptions<Element, Element>, "getScrollElement" \| "count" \| "estimateSize" \| "overscan">> & { overscan?: number ; estimateSize?: number \| ((index: number) => number) \| undefined; }) \| undefined`  Enable virtualization for large datasets. Note: when enabled, the divider between rows and sticky properties are not supported.  - [https://tanstack.com/virtual/latest/docs/api/virtualizer#options](https://tanstack.com/virtual/latest/docs/api/virtualizer#options) |
| `empty` | `t('table.noData')` | ` string`  The text to display when the table is empty. |
| `sticky` | `false` | `boolean \| "header" \| "footer"`  Whether the table should have a sticky header or footer. True for both, 'header' for header only, 'footer' for footer only. Note: this prop is not supported when `virtualize` is true. |
| `loading` |  | `boolean`  Whether the table should be in loading state. |
| `loadingColor` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `loadingAnimation` | `'carousel'` | ` "carousel" \| "carousel-inverse" \| "swing" \| "elastic"` |
| `watchOptions` | `{     deep: true }` | ` WatchOptions<boolean>`  Use the `watchOptions` prop to customize reactivity (for ex: disable deep watching for changes in your data or limiting the max traversal depth). This can improve performance by reducing unnecessary re-renders, but it should be used with caution as it may lead to unexpected behavior if not managed properly.  - [API](https://vuejs.org/api/options-state.html#watch) - [Guide](https://vuejs.org/guide/essentials/watchers.html) |
| `globalFilterOptions` |  | ` Omit<GlobalFilterOptions<T>, "onGlobalFilterChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/global-filtering#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/global-filtering) |
| `columnFiltersOptions` |  | ` Omit<ColumnFiltersOptions<T>, "getFilteredRowModel" \| "onColumnFiltersChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/column-filtering#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/column-filtering) |
| `columnPinningOptions` |  | ` Omit<ColumnPinningOptions, "onColumnPinningChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/column-pinning#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/column-pinning) |
| `columnSizingOptions` |  | ` Omit<ColumnSizingOptions, "onColumnSizingChange" \| "onColumnSizingInfoChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/column-sizing#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/column-sizing) |
| `visibilityOptions` |  | ` Omit<VisibilityOptions, "onColumnVisibilityChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/column-visibility#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/column-visibility) |
| `sortingOptions` |  | ` Omit<SortingOptions<T>, "getSortedRowModel" \| "onSortingChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/sorting#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/sorting) |
| `groupingOptions` |  | ` Omit<GroupingOptions, "onGroupingChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/grouping#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/grouping) |
| `expandedOptions` |  | ` Omit<ExpandedOptions<T>, "getExpandedRowModel" \| "onExpandedChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/expanding#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/expanding) |
| `rowSelectionOptions` |  | ` Omit<RowSelectionOptions<T>, "onRowSelectionChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/row-selection#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/row-selection) |
| `rowPinningOptions` |  | ` Omit<RowPinningOptions<T>, "onRowPinningChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/row-pinning#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/row-pinning) |
| `paginationOptions` |  | ` Omit<PaginationOptions, "onPaginationChange">`  - [API](https://tanstack.com/table/v8/docs/api/features/pagination#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/pagination) |
| `facetedOptions` |  | ` FacetedOptions<T>`  - [API](https://tanstack.com/table/v8/docs/api/features/column-faceting#table-options) - [Guide](https://tanstack.com/table/v8/docs/guide/column-faceting) |
| `onSelect` |  | ` (e: Event, row: TableRow<T>): void` |
| `onHover` |  | ` (e: Event, row: TableRow<T> \| null): void` |
| `onContextmenu` |  | ` (e: Event, row: TableRow<T>): void \| ((e: Event, row: TableRow<T>) => void)[]` |
| `state` |  | ` Partial<TableState>` |
| `onStateChange` |  | ` (updater: Updater<TableState>): void` |
| `renderFallbackValue` |  | `any` |
| `_features` |  | ` TableFeature<any>[]`  An array of extra features that you can add to the table instance.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#_features) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `autoResetAll` |  | `boolean `  Set this option to override any of the `autoReset...` feature options.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#autoresetall) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `debugAll` |  | `boolean `  Set this option to `true` to output all debugging information to the console.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#debugall) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `debugCells` |  | `boolean `  Set this option to `true` to output cell debugging information to the console.  - \[API Docs\]([https://tanstack.com/table/v8/docs/api/core/table#debugcells](https://tanstack.com/table/v8/docs/api/core/table#debugcells)\] - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `debugColumns` |  | `boolean `  Set this option to `true` to output column debugging information to the console.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#debugcolumns) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `debugHeaders` |  | `boolean ` - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#debugheaders) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `debugRows` |  | `boolean `  Set this option to `true` to output row debugging information to the console.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#debugrows) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `debugTable` |  | `boolean `  Set this option to `true` to output table debugging information to the console.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#debugtable) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `defaultColumn` |  | ` Partial<ColumnDefBase<T, unknown> & StringHeaderIdentifier> \| Partial<ColumnDefBase<T, unknown> & IdIdentifier<T, unknown>> \| Partial<GroupColumnDefBase<T, unknown> & StringHeaderIdentifier> \| Partial<GroupColumnDefBase<T, unknown> & IdIdentifier<T, unknown>> \| Partial<AccessorKeyColumnDefBase<T, unknown> & Partial<StringHeaderIdentifier>> \| Partial<AccessorKeyColumnDefBase<T, unknown> & Partial<IdIdentifier<T, unknown>>> \| Partial<AccessorFnColumnDefBase<T, unknown> & StringHeaderIdentifier> \| Partial<AccessorFnColumnDefBase<T, unknown> & IdIdentifier<T, unknown>>`  Default column options to use for all column defs supplied to the table.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#defaultcolumn) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `getRowId` |  | ` (originalRow: T, index: number, parent?: Row<T> \| undefined): string`  This optional function is used to derive a unique ID for any given row. If not provided the rows index is used (nested rows join together with `.` using their grandparents' index eg. `index.index.index`). If you need to identify individual rows that are originating from any server-side operations, it's suggested you use this function to return an ID that makes sense regardless of network IO/ambiguity eg. a userId, taskId, database ID field, etc.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#getrowid) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `getSubRows` |  | ` (originalRow: T, index: number): T[]`  This optional function is used to access the sub rows for any given row. If you are using nested rows, you will need to use this function to return the sub rows object (or undefined) from the row.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#getsubrows) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `initialState` |  | ` InitialTableState`  Use this option to optionally pass initial state to the table. This state will be used when resetting various table states either automatically by the table (eg. `options.autoResetPageIndex`) or via functions like `table.resetRowSelection()`. Most reset function allow you optionally pass a flag to reset to a blank/default state instead of the initial state.  Table state will not be reset when this object changes, which also means that the initial state object does not need to be stable.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#initialstate) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `mergeOptions` |  | ` (defaultOptions: TableOptions<T>, options: Partial<TableOptions<T>>): TableOptions<T>`  This option is used to optionally implement the merging of table options.  - [API Docs](https://tanstack.com/table/v8/docs/api/core/table#mergeoptions) - [Guide](https://tanstack.com/table/v8/docs/guide/tables) |
| `cellpadding` |  | ` string \| number` |
| `cellspacing` |  | ` string \| number` |
| `summary` |  | ` string` |
| `width` |  | ` string \| number` |
| `globalFilter` |  | ` string` |
| `columnFilters` |  | ` ColumnFiltersState` |
| `columnOrder` |  | ` ColumnOrderState` |
| `columnVisibility` |  | ` VisibilityState` |
| `columnPinning` |  | ` ColumnPinningState` |
| `columnSizing` |  | ` ColumnSizingState` |
| `columnSizingInfo` |  | ` ColumnSizingInfoState` |
| `rowSelection` |  | ` RowSelectionState` |
| `rowPinning` |  | ` RowPinningState` |
| `sorting` |  | ` SortingState` |
| `grouping` |  | ` GroupingState` |
| `expanded` |  | ` true \| Record<string, boolean>` |
| `pagination` |  | ` PaginationState` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; caption?: ClassNameValue; thead?: ClassNameValue; tbody?: ClassNameValue; tfoot?: ClassNameValue; tr?: ClassNameValue; th?: ClassNameValue; td?: ClassNameValue; separator?: ClassNameValue; empty?: ClassNameValue; loading?: ClassNameValue; }` |

This component also supports all native `<table>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `expanded` | `{ row: Row<T>; }` |
| `empty` | `{} ` |
| `loading` | `{} ` |
| `caption` | `{} ` |
| `body-top` | `{} ` |
| `body-bottom` | `{} ` |

### Expose

You can access the typed component instance using [`useTemplateRef`](https://vuejs.org/api/composition-api-helpers.html#usetemplateref).

```
<script setup lang="ts">

const table = useTemplateRef('table')

</script>

<template>

  <UTable ref="table" />

</template>
```

This will give you access to the following:

| Name | Type |
| --- | --- |
| `tableRef` | `Ref<HTMLTableElement \| null>` |
| `tableApi` | [`Table`](https://tanstack.com/table/latest/docs/api/core/table#table-api) |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    table: {

      slots: {

        root: 'relative overflow-auto',

        base: 'min-w-full',

        caption: 'sr-only',

        thead: 'relative',

        tbody: 'isolate [&>tr]:data-[selectable=true]:hover:bg-elevated/50 [&>tr]:data-[selectable=true]:focus-visible:outline-primary',

        tfoot: 'relative',

        tr: 'data-[selected=true]:bg-elevated/50',

        th: 'px-4 py-3.5 text-sm text-highlighted text-left rtl:text-right font-semibold [&:has([role=checkbox])]:pe-0',

        td: 'p-4 text-sm text-muted whitespace-nowrap [&:has([role=checkbox])]:pe-0',

        separator: 'absolute z-1 left-0 w-full h-px bg-(--ui-border-accented)',

        empty: 'py-6 text-center text-sm text-muted',

        loading: 'py-6 text-center'

      },

      variants: {

        virtualize: {

          false: {

            base: 'overflow-clip',

            tbody: 'divide-y divide-default'

          }

        },

        pinned: {

          true: {

            th: 'sticky bg-default/75 z-1',

            td: 'sticky bg-default/75 z-1'

          }

        },

        sticky: {

          true: {

            thead: 'sticky top-0 inset-x-0 bg-default/75 backdrop-blur z-1',

            tfoot: 'sticky bottom-0 inset-x-0 bg-default/75 backdrop-blur z-1'

          },

          header: {

            thead: 'sticky top-0 inset-x-0 bg-default/75 backdrop-blur z-1'

          },

          footer: {

            tfoot: 'sticky bottom-0 inset-x-0 bg-default/75 backdrop-blur z-1'

          }

        },

        loading: {

          true: {

            thead: 'after:absolute after:z-1 after:h-px'

          }

        },

        loadingAnimation: {

          carousel: '',

          'carousel-inverse': '',

          swing: '',

          elastic: ''

        },

        loadingColor: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        }

      },

      compoundVariants: [

        {

          loading: true,

          loadingColor: 'primary',

          class: {

            thead: 'after:bg-primary'

          }

        },

        {

          loading: true,

          loadingColor: 'neutral',

          class: {

            thead: 'after:bg-inverted'

          }

        },

        {

          loading: true,

          loadingAnimation: 'carousel',

          class: {

            thead: 'after:animate-[carousel_2s_ease-in-out_infinite] rtl:after:animate-[carousel-rtl_2s_ease-in-out_infinite]'

          }

        },

        {

          loading: true,

          loadingAnimation: 'carousel-inverse',

          class: {

            thead: 'after:animate-[carousel-inverse_2s_ease-in-out_infinite] rtl:after:animate-[carousel-inverse-rtl_2s_ease-in-out_infinite]'

          }

        },

        {

          loading: true,

          loadingAnimation: 'swing',

          class: {

            thead: 'after:animate-[swing_2s_ease-in-out_infinite]'

          }

        },

        {

          loading: true,

          loadingAnimation: 'elastic',

          class: {

            thead: 'after:animate-[elastic_2s_ease-in-out_infinite]'

          }

        }

      ],

      defaultVariants: {

        loadingColor: 'primary',

        loadingAnimation: 'carousel'

      }

    }

  }

})
```

vite.config.ts

```ts
import { defineConfig } from 'vite'

import vue from '@vitejs/plugin-vue'

import ui from '@nuxt/ui/vite'

export default defineConfig({

  plugins: [

    vue(),

    ui({

      ui: {

        table: {

          slots: {

            root: 'relative overflow-auto',

            base: 'min-w-full',

            caption: 'sr-only',

            thead: 'relative',

            tbody: 'isolate [&>tr]:data-[selectable=true]:hover:bg-elevated/50 [&>tr]:data-[selectable=true]:focus-visible:outline-primary',

            tfoot: 'relative',

            tr: 'data-[selected=true]:bg-elevated/50',

            th: 'px-4 py-3.5 text-sm text-highlighted text-left rtl:text-right font-semibold [&:has([role=checkbox])]:pe-0',

            td: 'p-4 text-sm text-muted whitespace-nowrap [&:has([role=checkbox])]:pe-0',

            separator: 'absolute z-1 left-0 w-full h-px bg-(--ui-border-accented)',

            empty: 'py-6 text-center text-sm text-muted',

            loading: 'py-6 text-center'

          },

          variants: {

            virtualize: {

              false: {

                base: 'overflow-clip',

                tbody: 'divide-y divide-default'

              }

            },

            pinned: {

              true: {

                th: 'sticky bg-default/75 z-1',

                td: 'sticky bg-default/75 z-1'

              }

            },

            sticky: {

              true: {

                thead: 'sticky top-0 inset-x-0 bg-default/75 backdrop-blur z-1',

                tfoot: 'sticky bottom-0 inset-x-0 bg-default/75 backdrop-blur z-1'

              },

              header: {

                thead: 'sticky top-0 inset-x-0 bg-default/75 backdrop-blur z-1'

              },

              footer: {

                tfoot: 'sticky bottom-0 inset-x-0 bg-default/75 backdrop-blur z-1'

              }

            },

            loading: {

              true: {

                thead: 'after:absolute after:z-1 after:h-px'

              }

            },

            loadingAnimation: {

              carousel: '',

              'carousel-inverse': '',

              swing: '',

              elastic: ''

            },

            loadingColor: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            }

          },

          compoundVariants: [

            {

              loading: true,

              loadingColor: 'primary',

              class: {

                thead: 'after:bg-primary'

              }

            },

            {

              loading: true,

              loadingColor: 'neutral',

              class: {

                thead: 'after:bg-inverted'

              }

            },

            {

              loading: true,

              loadingAnimation: 'carousel',

              class: {

                thead: 'after:animate-[carousel_2s_ease-in-out_infinite] rtl:after:animate-[carousel-rtl_2s_ease-in-out_infinite]'

              }

            },

            {

              loading: true,

              loadingAnimation: 'carousel-inverse',

              class: {

                thead: 'after:animate-[carousel-inverse_2s_ease-in-out_infinite] rtl:after:animate-[carousel-inverse-rtl_2s_ease-in-out_infinite]'

              }

            },

            {

              loading: true,

              loadingAnimation: 'swing',

              class: {

                thead: 'after:animate-[swing_2s_ease-in-out_infinite]'

              }

            },

            {

              loading: true,

              loadingAnimation: 'elastic',

              class: {

                thead: 'after:animate-[elastic_2s_ease-in-out_infinite]'

              }

            }

          ],

          defaultVariants: {

            loadingColor: 'primary',

            loadingAnimation: 'carousel'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`2dd00`](https://github.com/nuxt/ui/commit/2dd004744e3a019df5fb014953d3d4d3d990eacb) — chore: remove `shamefully-hoist` option ([#5854](https://github.com/nuxt/ui/issues/5854))

[`effbb`](https://github.com/nuxt/ui/commit/effbb18bfef7a835fa529e864e82b01ca313ea34) — feat: new component ([#5245](https://github.com/nuxt/ui/issues/5245))

[`b0b20`](https://github.com/nuxt/ui/commit/b0b209e0becd62cb8fb0402c3af5df68f47a5610) — fix: only forward necessary props ([#5527](https://github.com/nuxt/ui/issues/5527))

[`e885b`](https://github.com/nuxt/ui/commit/e885b0ebc2adc2e6af0a181fedaa68dd76e8a18e) — fix: properly position pinned columns based on `size`

[`ebc85`](https://github.com/nuxt/ui/commit/ebc8568044248e5cf71aa2ee253e0bb3df80663c) — feat: handle virtualizer `estimateSize` as function

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`620de`](https://github.com/nuxt/ui/commit/620defa3267d6c1a2d47b93ddb67672343b262b5) — fix: apply styles to `th` based on column meta ([#5418](https://github.com/nuxt/ui/issues/5418))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`c019f`](https://github.com/nuxt/ui/commit/c019f8f7f3e16d3027df3de180312c231aeabd0c) — fix: expose `$el` instead of `rootRef`

[`9526a`](https://github.com/nuxt/ui/commit/9526a1b583d54189af80ab8d3020106f3971fc7d) — fix!: consistent args order in select event

[`c744d`](https://github.com/nuxt/ui/commit/c744d6ff82424365acc9f5489a5352e5e552b5f6) — feat: implement virtualization ([#5162](https://github.com/nuxt/ui/issues/5162))

[`44a38`](https://github.com/nuxt/ui/commit/44a38ea3340e7e21a4e290c29eb8818a7c464860) — fix: empty cell value causing hydration errors ([#5069](https://github.com/nuxt/ui/issues/5069))

[`fd6a6`](https://github.com/nuxt/ui/commit/fd6a6bb6b72c1a014531c3bea693076079b210be) — chore: use tsdoc `@see` instead of `@link`

[`bdcc8`](https://github.com/nuxt/ui/commit/bdcc8c4bf2ac339f046e6a0bbc1a719100f51566) — fix: ensure `colspan` calc for `loading` and `empty` states ([#4826](https://github.com/nuxt/ui/issues/4826))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`7ef19`](https://github.com/nuxt/ui/commit/7ef19333f03beb8e49f64b9887de446d313e8501) — feat: add support for `colspan` and `rowspan` ([#4460](https://github.com/nuxt/ui/issues/4460))

[`1db21`](https://github.com/nuxt/ui/commit/1db21d1b00964362ff5c98c45bc44568a9a61706) — feat: add `style` to table and column `meta` ([#4513](https://github.com/nuxt/ui/issues/4513))

[`f903e`](https://github.com/nuxt/ui/commit/f903ec396f8cc478507d54eac43297e7cc2ef3d8) — feat: add row `hover` event

[`4ce65`](https://github.com/nuxt/ui/commit/4ce654076c87aa86459dab9461451685420e9622) — fix: handle reactive columns ([#4412](https://github.com/nuxt/ui/issues/4412))

[`595fc`](https://github.com/nuxt/ui/commit/595fc64515613fe82c3a56fc5518f2e3fcce6e19) — feat: add `body-top` / `body-bottom` slots ([#4354](https://github.com/nuxt/ui/issues/4354))

[`edca3`](https://github.com/nuxt/ui/commit/edca3bcb743c7eb63e6abbaa801d3858342a8777) — fix: use `tr` as separator ([#4083](https://github.com/nuxt/ui/issues/4083))

[`59c26`](https://github.com/nuxt/ui/commit/59c26ec1230375a24fbaf8a630a696ae854700c7) — feat: handle `children` in items ([#4226](https://github.com/nuxt/ui/issues/4226))

[`7a2bd`](https://github.com/nuxt/ui/commit/7a2bd4e6179373902ba6f285903ea896fd1d378f) — feat: expose trigger refs

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`6e273`](https://github.com/nuxt/ui/commit/6e27304d8ca459a04667bac404084264a8cf58fd) — fix: improve `data` reactivity ([#3967](https://github.com/nuxt/ui/issues/3967))

[`80dfa`](https://github.com/nuxt/ui/commit/80dfa88ea442571ee1dc673317cc7baa8cacd8a3) — feat: conditionally apply classes to `tr` and `td` ([#3866](https://github.com/nuxt/ui/issues/3866))

[`e25aa`](https://github.com/nuxt/ui/commit/e25aa7805074c8361d5b3007c551b4e168554d16) — docs: add infinite scroll example ([#3656](https://github.com/nuxt/ui/issues/3656))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`4ebb9`](https://github.com/nuxt/ui/commit/4ebb94cd7ef909b3547bce0922f75fe3ff74de4c) — fix: wrong condition on `caption` slot

[`afff5`](https://github.com/nuxt/ui/commit/afff54fecd31497238461e0a44abd8668ed734c3) — feat: add `empty` prop

[`e80cc`](https://github.com/nuxt/ui/commit/e80cc1592fb244dd7692486a4c1ca5b1c2008112) — fix: allow links to be opened when @select is used ([#3580](https://github.com/nuxt/ui/issues/3580))[ScrollArea](https://ui.nuxt.com/docs/components/scroll-area)

[

A flexible scroll container with virtualization support.

](https://ui.nuxt.com/docs/components/scroll-area)[

Timeline

A component that displays a sequence of events with dates, titles, icons or avatars.

](https://ui.nuxt.com/docs/components/timeline)