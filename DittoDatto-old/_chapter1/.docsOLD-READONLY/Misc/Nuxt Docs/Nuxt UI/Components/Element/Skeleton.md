---
title: "Vue Skeleton Component"
source: "https://ui.nuxt.com/docs/components/skeleton"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A placeholder to show while content is loading."
tags:
---
## Skeleton

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Skeleton.vue)

A placeholder to show while content is loading.

## Usage

Use the Skeleton component as-is to display a placeholder.

```
<template>

  <div class="flex items-center gap-4">

    <USkeleton class="h-12 w-12 rounded-full" />

    <div class="grid gap-2">

      <USkeleton class="h-4 w-[250px]" />

      <USkeleton class="h-4 w-[200px]" />

    </div>

  </div>

</template>
```

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

    skeleton: {

      base: 'animate-pulse rounded-md bg-elevated'

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

        skeleton: {

          base: 'animate-pulse rounded-md bg-elevated'

        }

      }

    })

  ]

})
```

## Changelog

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`fbcc3`](https://github.com/nuxt/ui/commit/fbcc3139a382b1a6bbadfa6c85c94984f876640c) — chore: remove `aria-busy:cursor-progress` class

[`34848`](https://github.com/nuxt/ui/commit/3484832822015a224ce6fbeae5132018875557e6) — fix: improve accessibility ([#3613](https://github.com/nuxt/ui/issues/3613))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Separator](https://ui.nuxt.com/docs/components/separator)

[

Separates content horizontally or vertically.

](https://ui.nuxt.com/docs/components/separator)[

Checkbox

An input element to toggle between checked and unchecked states.

](https://ui.nuxt.com/docs/components/checkbox)