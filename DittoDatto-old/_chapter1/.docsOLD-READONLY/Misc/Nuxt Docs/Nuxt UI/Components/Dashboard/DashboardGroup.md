---
title: "Vue DashboardGroup Component"
source: "https://ui.nuxt.com/docs/components/dashboard-group"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A fixed layout component that provides context for dashboard components with sidebar state management and persistence."
tags:
---
## Usage

The DashboardGroup component is the main layout that wraps the [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) and [DashboardPanel](https://ui.nuxt.com/docs/components/dashboard-panel) components to create a responsive dashboard interface.

Use it in a layout or in your `app.vue`:

layouts/dashboard.vue

```
<template>

  <UDashboardGroup>

    <UDashboardSidebar />

    <slot />

  </UDashboardGroup>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `storage` | `'cookie'` | ` "cookie" \| "local"`  The storage to use for the size. |
| `storageKey` | `'dashboard'` | ` string`  Unique id used to auto-save size. |
| `persistent` | `true` | `boolean`  Whether to persist the size in the storage. |
| `unit` | `'%'` | ` "%" \| "rem" \| "px"`  The unit to use for size values. |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardGroup: {

      base: 'fixed inset-0 flex overflow-hidden'

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

        dashboardGroup: {

          base: 'fixed inset-0 flex overflow-hidden'

        }

      }

    })

  ]

})
```

## Changelog

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components