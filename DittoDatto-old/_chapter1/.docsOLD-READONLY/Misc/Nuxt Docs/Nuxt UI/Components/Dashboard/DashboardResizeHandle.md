---
title: "Vue DashboardResizeHandle Component"
source: "https://ui.nuxt.com/docs/components/dashboard-resize-handle"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A handle to resize a sidebar or panel."
tags:
---
## Usage

The DashboardResizeHandle component is used by the [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) and [DashboardPanel](https://ui.nuxt.com/docs/components/dashboard-panel) components.

It is automatically displayed when the `resizable` prop is set, **you don't have to add it manually**.

## Examples

### Within resize-handle slot

Even though this component is automatically displayed when the `resizable` prop is set, you can use the `resize-handle` slot of the [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) and [DashboardPanel](https://ui.nuxt.com/docs/components/dashboard-panel) components to customize the handle.

In this example, we add an `after` pseudo-element to display a vertical line on hover.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardResizeHandle: {

      base: 'hidden lg:block touch-none select-none cursor-ew-resize relative before:absolute before:inset-y-0 before:-left-1.5 before:-right-1.5 before:z-1'

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

        dashboardResizeHandle: {

          base: 'hidden lg:block touch-none select-none cursor-ew-resize relative before:absolute before:inset-y-0 before:-left-1.5 before:-right-1.5 before:z-1'

        }

      }

    })

  ]

})
```

## Changelog

[`07147`](https://github.com/nuxt/ui/commit/07147f13ea26e593436cbbe81a3ae3d9a6a7690a) — fix: allow hover over panel with `z-index`

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[DashboardPanel](https://ui.nuxt.com/docs/components/dashboard-panel)

[

A resizable panel to display in a dashboard.

](https://ui.nuxt.com/docs/components/dashboard-panel)[

DashboardSearch

A ready to use CommandPalette to add to your dashboard.

](https://ui.nuxt.com/docs/components/dashboard-search)