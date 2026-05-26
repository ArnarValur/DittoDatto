---
title: "Vue Pagination Component"
source: "https://ui.nuxt.com/docs/components/pagination"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A list of buttons or links to navigate through pages."
tags:
---
## Usage

Use the `default-page` prop or the `v-model:page` directive to control the current page.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" :total="100" />

</template>
```

The Pagination component uses some [`Button`](https://ui.nuxt.com/docs/components/button) to display the pages, use [`color`](https://ui.nuxt.com/docs/components/#color), [`variant`](https://ui.nuxt.com/docs/components/#variant) and [`size`](https://ui.nuxt.com/docs/components/#size) props to style them.

### Total

Use the `total` prop to set the total number of items in the list.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" :total="100" />

</template>
```

### Items Per Page

Use the `items-per-page` prop to set the number of items per page. Defaults to `10`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" :items-per-page="20" :total="100" />

</template>
```

### Sibling Count

Use the `sibling-count` prop to set the number of siblings to show. Defaults to `2`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" :sibling-count="1" :total="100" />

</template>
```

### Show Edges

Use the `show-edges` prop to always show the ellipsis, first and last pages. Defaults to `false`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" show-edges :sibling-count="1" :total="100" />

</template>
```

### Show Controls

Use the `show-controls` prop to show the first, prev, next and last buttons. Defaults to `true`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" :show-controls="false" show-edges :total="100" />

</template>
```

### Color

Use the `color` prop to set the color of the inactive controls. Defaults to `neutral`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" color="primary" :total="100" />

</template>
```

### Variant

Use the `variant` prop to set the variant of the inactive controls. Defaults to `outline`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" color="neutral" variant="subtle" :total="100" />

</template>
```

### Active Color

Use the `active-color` prop to set the color of the active control. Defaults to `primary`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" active-color="neutral" :total="100" />

</template>
```

### Active Variant

Use the `active-variant` prop to set the variant of the active control. Defaults to `solid`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" active-color="primary" active-variant="subtle" :total="100" />

</template>
```

### Size

Use the `size` prop to set the size of the controls. Defaults to `md`.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" size="xl" :total="100" />

</template>
```

### Disabled

Use the `disabled` prop to disable the pagination controls.

```
<script setup lang="ts">

const page = ref(5)

</script>

<template>

  <UPagination v-model:page="page" :total="100" disabled />

</template>
```

## Examples

### With links

Use the `to` prop to transform buttons into links. Pass a function that receives the page number and returns a route destination.

```
<script setup lang="ts">

const page = ref(5)

function to(page: number) {

  return {

    query: {

      page

    },

    hash: '#with-links'

  }

}

</script>

<template>

  <UPagination v-model:page="page" :total="100" :to="to" :sibling-count="1" show-edges />

</template>
```

In this example we're adding the `#with-links` hash to avoid going to the top of the page.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `firstIcon` | `appConfig.ui.icons.chevronDoubleLeft` | `any`  The icon to use for the first page control. |
| `prevIcon` | `appConfig.ui.icons.chevronLeft` | `any`  The icon to use for the previous page control. |
| `nextIcon` | `appConfig.ui.icons.chevronRight` | `any`  The icon to use for the next page control. |
| `lastIcon` | `appConfig.ui.icons.chevronDoubleRight` | `any`  The icon to use for the last page control. |
| `ellipsisIcon` | `appConfig.ui.icons.ellipsis` | `any`  The icon to use for the ellipsis control. |
| `color` | `'neutral'` | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"`  The color of the pagination controls. |
| `variant` | `'outline'` | ` "outline" \| "solid" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the pagination controls. |
| `activeColor` | `'primary'` | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"`  The color of the active pagination control. |
| `activeVariant` | `'solid'` | ` "outline" \| "solid" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the active pagination control. |
| `showControls` | `true` | `boolean`  Whether to show the first, previous, next, and last controls. |
| `size` |  | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `to` |  | ` (page: number): string \| RouteLocationAsRelativeGeneric \| RouteLocationAsPathGeneric`  A function to render page controls as links. |
| `defaultPage` |  | ` number`  The value of the page that should be active when initially rendered.  Use when you do not need to control the value state. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with item |
| `itemsPerPage` | `10` | ` number`  Number of items per page |
| `page` |  | ` number`  The controlled value of the current page. Can be binded as `v-model:page`. |
| `showEdges` | `false` | `boolean`  When `true`, always show first page, last page, and ellipsis |
| `siblingCount` | `2` | ` number`  Number of sibling should be shown around the current page |
| `total` | `0` | ` number`  Number of items in your list |
| `ui` |  | ` { root?: ClassNameValue; list?: ClassNameValue; ellipsis?: ClassNameValue; label?: ClassNameValue; first?: ClassNameValue; prev?: ClassNameValue; item?: ClassNameValue; next?: ClassNameValue; last?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `first` | `{}` |
| `prev` | `{}` |
| `next` | `{}` |
| `last` | `{}` |
| `ellipsis` | `{ ui: object; }` |
| `item` | `{ page: number; pageCount: number; item: { type: "ellipsis"; } \| { type: "page"; value: number; }; index: number; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:page` | `[value: number]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pagination: {

      slots: {

        root: '',

        list: 'flex items-center gap-1',

        ellipsis: 'pointer-events-none',

        label: 'min-w-5 text-center',

        first: '',

        prev: '',

        item: '',

        next: '',

        last: ''

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

        pagination: {

          slots: {

            root: '',

            list: 'flex items-center gap-1',

            ellipsis: 'pointer-events-none',

            label: 'min-w-5 text-center',

            first: '',

            prev: '',

            item: '',

            next: '',

            last: ''

          }

        }

      }

    })

  ]

})
```

## Changelog

[`38765`](https://github.com/nuxt/ui/commit/38765c367de004993290a2e9dca5f2ab1579b284) — feat: new component ([#5407](https://github.com/nuxt/ui/issues/5407))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`62f64`](https://github.com/nuxt/ui/commit/62f64cc260fbf85a2f143d53c93e0e5b665b6f71) — fix: make ellipsis non-interactive ([#5081](https://github.com/nuxt/ui/issues/5081))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`4dd56`](https://github.com/nuxt/ui/commit/4dd56c8111e5a224105b82d541b7742b46abb34a) — fix: match default button `size` ([#4350](https://github.com/nuxt/ui/issues/4350))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))