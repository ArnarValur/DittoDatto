---
title: "Vue ColorModeSwitch Component"
source: "https://ui.nuxt.com/docs/components/color-mode-switch"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A switch to toggle between light and dark mode."
tags:
---
## ColorModeSwitch

[Switch](https://ui.nuxt.com/docs/components/switch) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/color-mode/ColorModeSwitch.vue)

A switch to toggle between light and dark mode.

## Usage

The ColorModeSwitch component extends the [Switch](https://ui.nuxt.com/docs/components/switch) component, so you can pass any property such as `color`, `size`, etc.

```
<template>

  <UColorModeSwitch />

</template>
```

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

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the switch. |
| `label` |  | ` string` |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `defaultValue` |  | `boolean`  The state of the switch when it is initially rendered. Use when you do not need to control its state. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `id` |  | ` string` |
| `value` |  | ` string`  The value given as data when submitted with a `name`. |
| `description` |  | ` string` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; container?: ClassNameValue; thumb?: ClassNameValue; icon?: ClassNameValue; wrapper?: ClassNameValue; label?: ClassNameValue; description?: ClassNameValue; }` |

## Changelog

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ColorModeSelect](https://ui.nuxt.com/docs/components/color-mode-select)

[

A Select to switch between system, dark & light mode.

](https://ui.nuxt.com/docs/components/color-mode-select)[

LocaleSelect

A Select to switch between locales.

](https://ui.nuxt.com/docs/components/locale-select)