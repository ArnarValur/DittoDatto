---
title: "Vue DashboardSidebar Component"
source: "https://ui.nuxt.com/docs/components/dashboard-sidebar"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A resizable and collapsible sidebar to display in a dashboard."
tags:
---
## Usage

The DashboardSidebar component is used to display a sidebar. Its state (size, collapsed, etc.) will be saved based on the `storage` and `storage-key` props you provide to the [DashboardGroup](https://ui.nuxt.com/docs/components/dashboard-group#props) component.

Use it inside the default slot of the [DashboardGroup](https://ui.nuxt.com/docs/components/dashboard-group) component:

layouts/dashboard.vue

```
<template>

  <UDashboardGroup>

    <UDashboardSidebar />

    <slot />

  </UDashboardGroup>

</template>
```

This component does not have a single root element when using the `resizable` prop, so wrap it in a container (e.g., `<div class="flex flex-1">`) if you use page transitions or require a single root for layout.

Use the `header`, `default` and `footer` slots to customize the sidebar and the `body` or `content` slots to customize the sidebar menu.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items: NavigationMenuItem[][] = [[{

  label: 'Home',

  icon: 'i-lucide-house',

  active: true

}, {

  label: 'Inbox',

  icon: 'i-lucide-inbox',

  badge: '4'

}, {

  label: 'Contacts',

  icon: 'i-lucide-users'

}, {

  label: 'Settings',

  icon: 'i-lucide-settings',

  defaultOpen: true,

  children: [{

    label: 'General'

  }, {

    label: 'Members'

  }, {

    label: 'Notifications'

  }]

}], [{

  label: 'Feedback',

  icon: 'i-lucide-message-circle',

  to: 'https://github.com/nuxt-ui-templates/dashboard',

  target: '_blank'

}, {

  label: 'Help & Support',

  icon: 'i-lucide-info',

  to: 'https://github.com/nuxt/ui',

  target: '_blank'

}]]

</script>

<template>

  <UDashboardSidebar collapsible resizable :ui="{ footer: 'border-t border-default' }">

    <template #header="{ collapsed }">

      <Logo v-if="!collapsed" class="h-5 w-auto shrink-0" />

      <UIcon v-else name="i-simple-icons-nuxtdotjs" class="size-5 text-primary mx-auto" />

    </template>

    <template #default="{ collapsed }">

      <UButton

        :label="collapsed ? undefined : 'Search...'"

        icon="i-lucide-search"

        color="neutral"

        variant="outline"

        block

        :square="collapsed"

      >

        <template v-if="!collapsed" #trailing>

          <div class="flex items-center gap-0.5 ms-auto">

            <UKbd value="meta" variant="subtle" />

            <UKbd value="K" variant="subtle" />

          </div>

        </template>

      </UButton>

      <UNavigationMenu

        :collapsed="collapsed"

        :items="items[0]"

        orientation="vertical"

      />

      <UNavigationMenu

        :collapsed="collapsed"

        :items="items[1]"

        orientation="vertical"

        class="mt-auto"

      />

    </template>

    <template #footer="{ collapsed }">

      <UButton

        :avatar="{

          src: 'https://github.com/benjamincanac.png'

        }"

        :label="collapsed ? undefined : 'Benjamin'"

        color="neutral"

        variant="ghost"

        class="w-full"

        :block="collapsed"

      />

    </template>

  </UDashboardSidebar>

</template>
```

Drag the sidebar near the left edge of the screen to collapse it.

### Resizable

Use the `resizable` prop to make the sidebar resizable.

### Collapsible

Use the `collapsible` prop to make the sidebar collapsible when dragging near the edge of the screen.

The [`DashboardSidebarCollapse`](https://ui.nuxt.com/docs/components/dashboard-sidebar-collapse) component will have no effect if the sidebar is not **collapsible**.

You can access the `collapsed` state in the slot props to customize the content of the sidebar when it is collapsed.

### Size

Use the `min-size`, `max-size`, `default-size` and `collapsed-size` props to customize the size of the sidebar.

Sizes are calculated as percentages by default. You can change this using the `unit` prop on the `DashboardGroup` component.

The `collapsed-size` prop is set to `0` by default but the sidebar has a `min-w-16` to make sure it is visible.

### Side

Use the `side` prop to change the side of the sidebar. Defaults to `left`.

### Mode

Use the `mode` prop to change the mode of the sidebar menu. Defaults to `slideover`.

Use the `body` slot to fill the menu body (under the header) or the `content` slot to fill the entire menu.

You can use the `menu` prop to customize the menu of the sidebar, it will adapt depending on the mode you choose.

These examples contain the [`DashboardGroup`](https://ui.nuxt.com/docs/components/dashboard-group), [`DashboardPanel`](https://ui.nuxt.com/docs/components/dashboard-panel) and [`DashboardNavbar`](https://ui.nuxt.com/docs/components/dashboard-navbar) components as they are required to demonstrate the sidebar on mobile.

### Toggle

Use the `toggle` prop to customize the [DashboardSidebarToggle](https://ui.nuxt.com/docs/components/dashboard-sidebar-toggle) component displayed on mobile.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

### Toggle Side

Use the `toggle-side` prop to change the side of the toggle button. Defaults to `left`.

## Examples

### Control open state

You can control the open state by using the `open` prop or the `v-model:open` directive.

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the open state of the DashboardSidebar by pressing O.

### Control collapsed state

You can control the collapsed state by using the `collapsed` prop or the `v-model:collapsed` directive.

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the collapsed state of the DashboardSidebar by pressing C.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `mode` | `'slideover'` | ` T` |
| `menu` |  | ` DashboardSidebarMenu<T>` |
| `toggle` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Customize the toggle button to open the sidebar.`{ color: 'neutral', variant: 'ghost' }` |
| `toggleSide` | `'left'` | ` "left" \| "right"`  The side to render the toggle button on. |
| `id` | `useId()` | ` string`  The id of the panel. |
| `side` | `'left'` | ` "left" \| "right"`  The side to render the panel on. |
| `minSize` | `10` | ` number`  The minimum size of the panel. |
| `maxSize` | `20` | ` number`  The maximum size of the panel. |
| `defaultSize` | `15` | ` number`  The default size of the panel. |
| `resizable` | `false` | `boolean`  Whether to allow the user to resize the panel. |
| `collapsible` | `false` | `boolean`  Whether to allow the user to collapse the panel. |
| `collapsedSize` | `0` | ` number`  The size of the panel when collapsed. |
| `open` | `false` | `boolean` |
| `collapsed` | `false` | `boolean` |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; toggle?: ClassNameValue; handle?: ClassNameValue; content?: ClassNameValue; overlay?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{ collapsed?: boolean \| undefined; collapse?: ((value: boolean) => void) \| undefined; }` |
| `default` | `{ collapsed?: boolean \| undefined; collapse?: ((value: boolean) => void) \| undefined; }` |
| `footer` | `{ collapsed?: boolean \| undefined; collapse?: ((value: boolean) => void) \| undefined; }` |
| `toggle` | `{ open: boolean; toggle: () => void; ui: object; }` |
| `content` | `{ close?: (() => void) \| undefined; }` |
| `resize-handle` | `{ onMouseDown: (e: MouseEvent) => void; onTouchStart: (e: TouchEvent) => void; onDoubleClick: (e: MouseEvent) => void; ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardSidebar: {

      slots: {

        root: 'relative hidden lg:flex flex-col min-h-svh min-w-16 w-(--width) shrink-0',

        header: 'h-(--ui-header-height) shrink-0 flex items-center gap-1.5 px-4',

        body: 'flex flex-col gap-4 flex-1 overflow-y-auto px-4 py-2',

        footer: 'shrink-0 flex items-center gap-1.5 px-4 py-2',

        toggle: '',

        handle: '',

        content: 'lg:hidden',

        overlay: 'lg:hidden'

      },

      variants: {

        menu: {

          true: {

            header: 'sm:px-6',

            body: 'sm:px-6',

            footer: 'sm:px-6'

          }

        },

        side: {

          left: {

            root: 'border-e border-default'

          },

          right: {

            root: ''

          }

        },

        toggleSide: {

          left: {

            toggle: ''

          },

          right: {

            toggle: 'ms-auto'

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

        dashboardSidebar: {

          slots: {

            root: 'relative hidden lg:flex flex-col min-h-svh min-w-16 w-(--width) shrink-0',

            header: 'h-(--ui-header-height) shrink-0 flex items-center gap-1.5 px-4',

            body: 'flex flex-col gap-4 flex-1 overflow-y-auto px-4 py-2',

            footer: 'shrink-0 flex items-center gap-1.5 px-4 py-2',

            toggle: '',

            handle: '',

            content: 'lg:hidden',

            overlay: 'lg:hidden'

          },

          variants: {

            menu: {

              true: {

                header: 'sm:px-6',

                body: 'sm:px-6',

                footer: 'sm:px-6'

              }

            },

            side: {

              left: {

                root: 'border-e border-default'

              },

              right: {

                root: ''

              }

            },

            toggleSide: {

              left: {

                toggle: ''

              },

              right: {

                toggle: 'ms-auto'

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

[`fface`](https://github.com/nuxt/ui/commit/fface35e5456f084b3d97d90f5fe25f920e96bf8) — fix: handle RTL mode ([#5109](https://github.com/nuxt/ui/issues/5109))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components