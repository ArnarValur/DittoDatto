---
title: "Vue Container Component"
source: "https://ui.nuxt.com/docs/components/container"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A container lets you center and constrain the width of your content."
tags:
---
## Container

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Container.vue)

A container lets you center and constrain the width of your content.

## Usage

Use the default slot to center and constrain the width of your content.

Its max width is controlled by the `--ui-container` CSS variable.

```
<template>

  <UContainer>

    <Placeholder class="h-32" />

  </UContainer>

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

    container: {

      base: 'w-full max-w-(--ui-container) mx-auto px-4 sm:px-6 lg:px-8'

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

        container: {

          base: 'w-full max-w-(--ui-container) mx-auto px-4 sm:px-6 lg:px-8'

        }

      }

    })

  ]

})
```

## Changelog

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`df001`](https://github.com/nuxt/ui/commit/df001495980647cab1e67fd16154f1bc778de5e2) — fix: add `w-full` class[App](https://ui.nuxt.com/docs/components/app)

[

Wraps your app to provide global configurations and more.

](https://ui.nuxt.com/docs/components/app)[

Error

A pre-built error component with NuxtError support.

](https://ui.nuxt.com/docs/components/error)