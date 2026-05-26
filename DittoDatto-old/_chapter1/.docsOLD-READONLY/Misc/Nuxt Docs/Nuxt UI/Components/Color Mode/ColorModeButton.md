---
title: "Vue ColorModeButton Component"
source: "https://ui.nuxt.com/docs/components/color-mode-button"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A Button to switch between light and dark mode."
tags:
---
## ColorModeButton

[Button](https://ui.nuxt.com/docs/components/button) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/color-mode/ColorModeButton.vue)

A Button to switch between light and dark mode.

## Usage

The ColorModeButton component extends the [Button](https://ui.nuxt.com/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

```
<template>

  <UColorModeButton />

</template>
```

The button defaults to `color="neutral"` and `variant="ghost"`.

## Examples

### With custom icons

Use the `app.config.ts` to customize the icon with the `ui.icons` property:

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    icons: {

      light: 'i-ph-sun',

      dark: 'i-ph-moon'

    }

  }

})
```

Use the `vite.config.ts` to customize the icon with the `ui.icons` property:

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

        icons: {

          light: 'i-ph-sun',

          dark: 'i-ph-moon'

        }

      }

    })

  ]

})
```

### With fallback slot

As the button is wrapped in a [ClientOnly](https://nuxt.com/docs/api/components/client-only) component, you can pass a `fallback` slot to display a placeholder while the component is loading.

```
<template>

  <UColorModeButton>

    <template #fallback>

      <UButton loading variant="ghost" color="neutral" />

    </template>

  </UColorModeButton>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `color` | `'neutral'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'ghost'` | ` "link" \| "ghost" \| "solid" \| "outline" \| "soft" \| "subtle"` |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `name` |  | ` string` |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean` |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `label` |  | ` string` |
| `activeColor` |  | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `activeVariant` |  | ` "link" \| "ghost" \| "solid" \| "outline" \| "soft" \| "subtle"` |
| `square` |  | `boolean`  Render the button with equal padding on all sides. |
| `block` |  | `boolean`  Render the button full width. |
| `loadingAuto` |  | `boolean`  Set loading state automatically based on the `@click` promise state |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `ui` |  | ` { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`2ce9a`](https://github.com/nuxt/ui/commit/2ce9af2e138e160a6db9e74a43a92d194212548a) — fix: improve icon class merging

[`5f30c`](https://github.com/nuxt/ui/commit/5f30ccf32eea86777fc3e4d595c76f009695e6d9) — fix: missing icon import

[`1d1c6`](https://github.com/nuxt/ui/commit/1d1c6380eaaf7ae9aef058b22cdd2b539759131c) — fix: use css to display color mode icon ([#5394](https://github.com/nuxt/ui/issues/5394))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ColorModeAvatar](https://ui.nuxt.com/docs/components/color-mode-avatar)

[

An Avatar with a different source for light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-avatar)[

ColorModeImage

An image element with a different source for light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-image)