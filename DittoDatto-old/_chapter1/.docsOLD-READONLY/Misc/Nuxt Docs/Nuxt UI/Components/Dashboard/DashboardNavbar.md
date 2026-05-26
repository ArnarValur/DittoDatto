---
title: "Vue DashboardNavbar Component"
source: "https://ui.nuxt.com/docs/components/dashboard-navbar"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive navbar to display in a dashboard."
tags:
---
## Usage

The DashboardNavbar component is a responsive navigation bar that integrates with the [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) component. It includes a mobile toggle button to enable responsive navigation in dashboard layouts.

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

    </template>

  </UDashboardPanel>

</template>
```

Use the `left`, `default` and `right` slots to customize the navbar.

## Inbox

4

In this example, we use the [Tabs](https://ui.nuxt.com/docs/components/tabs) component in the right slot to display some tabs.

Use the `title` prop to set the title of the navbar.

### Icon

Use the `icon` prop to set the icon of the navbar.

### Toggle

Use the `toggle` prop to customize the toggle button displayed on mobile that opens the [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) component.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

### Toggle Side

Use the `toggle-side` prop to change the side of the toggle button. Defaults to `right`.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `icon` |  | `any`  The icon displayed next to the title. |
| `title` |  | ` string` |
| `toggle` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Customize the toggle button to open the sidebar.`{ color: 'neutral', variant: 'ghost' }` |
| `toggleSide` | `'left'` | ` "left" \| "right"`  The side to render the toggle button on. |
| `ui` |  | ` { root?: ClassNameValue; left?: ClassNameValue; icon?: ClassNameValue; title?: ClassNameValue; center?: ClassNameValue; right?: ClassNameValue; toggle?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `title` | `{}` |
| `leading` | `DashboardNavbarSlotsProps & { ui: object; }` |
| `trailing` | `DashboardNavbarSlotsProps & { ui: object; }` |
| `left` | `DashboardNavbarSlotsProps` |
| `default` | `DashboardNavbarSlotsProps` |
| `right` | `DashboardNavbarSlotsProps` |
| `toggle` | `DashboardNavbarSlotsProps & { ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardNavbar: {

      slots: {

        root: 'h-(--ui-header-height) shrink-0 flex items-center justify-between border-b border-default px-4 sm:px-6 gap-1.5',

        left: 'flex items-center gap-1.5 min-w-0',

        icon: 'shrink-0 size-5 self-center me-1.5',

        title: 'flex items-center gap-1.5 font-semibold text-highlighted truncate',

        center: 'hidden lg:flex',

        right: 'flex items-center shrink-0 gap-1.5',

        toggle: ''

      },

      variants: {

        toggleSide: {

          left: {

            toggle: ''

          },

          right: {

            toggle: ''

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

        dashboardNavbar: {

          slots: {

            root: 'h-(--ui-header-height) shrink-0 flex items-center justify-between border-b border-default px-4 sm:px-6 gap-1.5',

            left: 'flex items-center gap-1.5 min-w-0',

            icon: 'shrink-0 size-5 self-center me-1.5',

            title: 'flex items-center gap-1.5 font-semibold text-highlighted truncate',

            center: 'hidden lg:flex',

            right: 'flex items-center shrink-0 gap-1.5',

            toggle: ''

          },

          variants: {

            toggleSide: {

              left: {

                toggle: ''

              },

              right: {

                toggle: ''

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

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components