---
title: "Vue DashboardToolbar Component"
source: "https://ui.nuxt.com/docs/components/dashboard-toolbar"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A toolbar to display under the navbar in a dashboard."
tags:
---
## Usage

The DashboardToolbar component is used to display a toolbar under the [DashboardNavbar](https://ui.nuxt.com/docs/components/dashboard-navbar) component.

Use it inside the `header` slot of the [DashboardPanel](https://ui.nuxt.com/docs/components/dashboard-panel) component:

pages/index.vue

```
<script setup lang="ts">

definePageMeta({

  layout: 'dashboard'

})

</script>

<template>

  <UDashboardPanel>

    <template #header>

      <UDashboardNavbar />

      <UDashboardToolbar />

    </template>

  </UDashboardPanel>

</template>
```

Use the `left`, `default` and `right` slots to customize the toolbar.

In this example, we use the [NavigationMenu](https://ui.nuxt.com/docs/components/navigation-menu) component to render some links.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `ui` |  | ` { root?: ClassNameValue; left?: ClassNameValue; right?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |
| `left` | `{}` |
| `right` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardToolbar: {

      slots: {

        root: 'shrink-0 flex items-center justify-between border-b border-default px-4 sm:px-6 gap-1.5 overflow-x-auto min-h-[49px]',

        left: 'flex items-center gap-1.5',

        right: 'flex items-center gap-1.5'

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

        dashboardToolbar: {

          slots: {

            root: 'shrink-0 flex items-center justify-between border-b border-default px-4 sm:px-6 gap-1.5 overflow-x-auto min-h-[49px]',

            left: 'flex items-center gap-1.5',

            right: 'flex items-center gap-1.5'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components