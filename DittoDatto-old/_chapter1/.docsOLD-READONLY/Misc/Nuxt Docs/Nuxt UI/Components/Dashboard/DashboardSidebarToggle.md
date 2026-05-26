---
title: "Vue DashboardSidebarToggle Component"
source: "https://ui.nuxt.com/docs/components/dashboard-sidebar-toggle"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A Button to toggle the sidebar on mobile."
tags:
---
## Usage

The DashboardSidebarToggle component is used by the [DashboardNavbar](https://ui.nuxt.com/docs/components/dashboard-navbar) and [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) components.

It is automatically displayed on mobile to toggle the sidebar, **you don't have to add it manually**.

It extends the [Button](https://ui.nuxt.com/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

The button defaults to `color="neutral"` and `variant="ghost"`.

## Examples

### Within toggle slot

Even though this component is automatically displayed on mobile, you can use the `toggle` slot of the [DashboardNavbar](https://ui.nuxt.com/docs/components/dashboard-navbar) and [DashboardSidebar](https://ui.nuxt.com/docs/components/dashboard-sidebar) components to customize the button.

When using the `toggle-side` prop of the `DashboardSidebar` and `DashboardNavbar` components, the button will be displayed on the specified side.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `color` | `'neutral'` | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"` |
| `variant` | `'ghost'` | ` "ghost" \| "solid" \| "outline" \| "soft" \| "subtle" \| "link"` |
| `side` | `'left'` | ` "left" \| "right"` |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean` |
| `name` |  | ` string` |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `label` |  | ` string` |
| `activeColor` |  | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"` |
| `activeVariant` |  | ` "ghost" \| "solid" \| "outline" \| "soft" \| "subtle" \| "link"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `square` |  | `boolean`  Render the button with equal padding on all sides. |
| `block` |  | `boolean`  Render the button full width. |
| `loadingAuto` |  | `boolean`  Set loading state automatically based on the `@click` promise state |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `ui` |  | ` { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    dashboardSidebarToggle: {

      base: 'lg:hidden',

      variants: {

        side: {

          left: '',

          right: ''

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

        dashboardSidebarToggle: {

          base: 'lg:hidden',

          variants: {

            side: {

              left: '',

              right: ''

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

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components