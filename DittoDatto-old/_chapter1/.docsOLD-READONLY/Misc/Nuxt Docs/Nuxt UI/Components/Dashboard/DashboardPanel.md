---
title: "Vue DashboardPanel Component"
source: "https://ui.nuxt.com/docs/components/dashboard-panel"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A resizable panel to display in a dashboard."
tags:
---
## DashboardPanel

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/DashboardPanel.vue)

A resizable panel to display in a dashboard.

## Usage

The DashboardPanel component is used to display a panel. Its state (size, collapsed, etc.) will be saved based on the `storage` and `storage-key` props you provide to the [DashboardGroup](https://ui.nuxt.com/docs/components/dashboard-group#props) component.

Use it inside the default slot of the [DashboardGroup](https://ui.nuxt.com/docs/components/dashboard-group) component, you can put multiple panels next to each other:

pages/index.vue

```
<script setup lang="ts">

definePageMeta({

  layout: 'dashboard'

})

</script>

<template>

  <UDashboardPanel id="inbox-1" resizable />

  <UDashboardPanel id="inbox-2" class="hidden lg:flex" />

</template>
```

This component does not have a single root element when using the `resizable` prop, so wrap it in a container (e.g., `<div class="flex flex-1">`) if you use page transitions or require a single root for layout.

Use the `header`, `body` and `footer` slots to customize the panel or the default slot if you don't want a scrollable body with padding.

Most of the time, you will use the [`DashboardNavbar`](https://ui.nuxt.com/docs/components/dashboard-navbar) component in the `header` slot.

### Resizable

Use the `resizable` prop to make the panel resizable.

```
<template>

  <UDashboardPanel resizable>

    <template #body>

      <Placeholder class="h-96" />

    </template>

  </UDashboardPanel>

</template>
```

### Size

Use the `min-size`, `max-size` and `default-size` props to customize the size of the panel.

```
<template>

  <UDashboardPanel resizable :min-size="22" :default-size="35" :max-size="40">

    <template #body>

      <Placeholder class="h-96" />

    </template>

  </UDashboardPanel>

</template>
```

Sizes are calculated as percentages by default. You can change this using the `unit` prop on the `DashboardGroup` component.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `id` | `useId()` | ` string`  The id of the panel. |
| `minSize` | `15` | ` number`  The minimum size of the panel. |
| `maxSize` | `100` | ` number`  The maximum size of the panel. |
| `defaultSize` | `0` | ` number`  The default size of the panel. |
| `resizable` | `false` | `boolean`  Whether to allow the user to resize the panel. |
| `ui` |  | ` { root?: ClassNameValue; body?: ClassNameValue; handle?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |
| `header` | `{}` |
| `body` | `{}` |
| `footer` | `{}` |
| `resize-handle` | `{ onMouseDown: (e: MouseEvent) => void; onTouchStart: (e: TouchEvent) => void; onDoubleClick: (e: MouseEvent) => void; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardPanel: {

      slots: {

        root: 'relative flex flex-col min-w-0 min-h-svh lg:not-last:border-e lg:not-last:border-default shrink-0',

        body: 'flex flex-col gap-4 sm:gap-6 flex-1 overflow-y-auto p-4 sm:p-6',

        handle: ''

      },

      variants: {

        size: {

          true: {

            root: 'w-full lg:w-(--width)'

          },

          false: {

            root: 'flex-1'

          }

        }

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

        dashboardPanel: {

          slots: {

            root: 'relative flex flex-col min-w-0 min-h-svh lg:not-last:border-e lg:not-last:border-default shrink-0',

            body: 'flex flex-col gap-4 sm:gap-6 flex-1 overflow-y-auto p-4 sm:p-6',

            handle: ''

          },

          variants: {

            size: {

              true: {

                root: 'w-full lg:w-(--width)'

              },

              false: {

                root: 'flex-1'

              }

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fface`](https://github.com/nuxt/ui/commit/fface35e5456f084b3d97d90f5fe25f920e96bf8) — fix: handle RTL mode ([#5109](https://github.com/nuxt/ui/issues/5109))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components