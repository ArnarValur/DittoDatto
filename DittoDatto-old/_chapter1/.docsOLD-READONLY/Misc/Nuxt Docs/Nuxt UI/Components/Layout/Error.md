---
title: "Vue Error Component"
source: "https://ui.nuxt.com/docs/components/error"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A pre-built error component with NuxtError support."
tags:
---
## Error

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Error.vue)

A pre-built error component with NuxtError support.

## Usage

The Error component renders a `<main>` element that works together with the [Header](https://ui.nuxt.com/docs/components/header) component to create a full-height layout that extends to the viewport's available height.

The Error component uses the `--ui-header-height` CSS variable to position itself correctly below the `Header`.

### Error

Use the `error` prop to display an error message.

In most cases, you will receive the `error` prop in your `error.vue` file.

```
<template>

  <UError

    :error="{

      statusCode: 404,

      statusMessage: 'Page not found',

      message: 'The page you are looking for does not exist.'

    }"

  />

</template>
```

### Clear

Use the `clear` prop to customize or hide the clear button (with `false` value).

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

```
<template>

  <UError

    :clear="{

      color: 'neutral',

      size: 'xl',

      icon: 'i-lucide-arrow-left',

      class: 'rounded-full'

    }"

    :error="{

      statusCode: 404,

      statusMessage: 'Page not found',

      message: 'The page you are looking for does not exist.'

    }"

  />

</template>
```

### Redirect

Use the `redirect` prop to redirect the user to a different page when the clear button is clicked. Defaults to `/`.

```
<template>

  <UError

    redirect="/docs/getting-started"

    :error="{

      statusCode: 404,

      statusMessage: 'Page not found',

      message: 'The page you are looking for does not exist.'

    }"

  />

</template>
```

## Examples

Use the Error component in your `error.vue`:

error.vue

```
<script setup lang="ts">

import type { NuxtError } from '#app'

const props = defineProps<{

  error: NuxtError

}>()

</script>

<template>

  <UApp>

    <UHeader />

    <UError :error="error" />

    <UFooter />

  </UApp>

</template>
```

You might want to replicate the code of your `app.vue` inside your `error.vue` file to have the same layout and features, here is an example: [https://github.com/nuxt/ui/blob/v4/docs/app/error.vue](https://github.com/nuxt/ui/blob/v4/docs/app/error.vue)

You can read more about how to handle errors in the [Nuxt documentation](https://nuxt.com/docs/getting-started/error-handling#error-page), but when using `nuxt generate` it is recommended to add `fatal: true` inside your `createError` call to make sure the error page is displayed:

pages/\[...slug\].vue

```
<script setup lang="ts">

const route = useRoute()

const { data: page } = await useAsyncData(route.path, () => {

  return queryCollection('docs').path(route.path).first()

})

if (!page.value) {

  throw createError({ statusCode: 404, statusMessage: 'Page not found', fatal: true })

}

</script>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'main'` | `any`  The element or component this component should render as. |
| `error` |  | ` Partial<NuxtError<unknown> & { message: string; }>` |
| `redirect` | `'/'` | ` string`  The URL to redirect to when the error is cleared. |
| `clear` | `true` | `boolean \| ButtonProps`  Display a button to clear the error in the links slot.`{ size: 'lg', color: 'primary', variant: 'solid', label: 'Back to home' }` |
| `ui` |  | ` { root?: ClassNameValue; statusCode?: ClassNameValue; statusMessage?: ClassNameValue; message?: ClassNameValue; links?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |
| `statusCode` | `{}` |
| `statusMessage` | `{}` |
| `message` | `{}` |
| `links` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    error: {

      slots: {

        root: 'min-h-[calc(100vh-var(--ui-header-height))] flex flex-col items-center justify-center text-center',

        statusCode: 'text-base font-semibold text-primary',

        statusMessage: 'mt-2 text-4xl sm:text-5xl font-bold text-highlighted text-balance',

        message: 'mt-4 text-lg text-muted text-balance',

        links: 'mt-8 flex items-center justify-center gap-6'

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

        error: {

          slots: {

            root: 'min-h-[calc(100vh-var(--ui-header-height))] flex flex-col items-center justify-center text-center',

            statusCode: 'text-base font-semibold text-primary',

            statusMessage: 'mt-2 text-4xl sm:text-5xl font-bold text-highlighted text-balance',

            message: 'mt-4 text-lg text-muted text-balance',

            links: 'mt-8 flex items-center justify-center gap-6'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`6ccb1`](https://github.com/nuxt/ui/commit/6ccb1f53b9286852bce78259c3fa4eb36bb0390d) — fix: render as `main` instead of `div`

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`2a09a`](https://github.com/nuxt/ui/commit/2a09ac0c1ed5b528dc843ebeb0032395dc8a125b) — fix: render as `div` instead of `main`

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components