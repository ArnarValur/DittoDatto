---
title: "Vue PageBody Component"
source: "https://ui.nuxt.com/docs/components/page-body"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "The main content of your page."
tags:
---
## PageBody

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageBody.vue)

The main content of your page.

## Usage

The PageBody component wraps your main content and adds some padding for consistent spacing.

Use it inside the default slot of the [Page](https://ui.nuxt.com/docs/components/page) component, after the [PageHeader](https://ui.nuxt.com/docs/components/page-header) component:

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a page

Use the PageBody component in a page to display the content of the page:

pages/\[...slug\].vue

```
<script setup lang="ts">

const route = useRoute()

definePageMeta({

  layout: 'docs'

})

const { data: page } = await useAsyncData(route.path, () => {

  return queryCollection('docs').path(route.path).first()

})

const { data: surround } = await useAsyncData(\`${route.path}-surround\`, () => {

  return queryCollectionItemSurroundings('content', route.path)

})

</script>

<template>

  <UPage>

    <UPageHeader :title="page.title" :description="page.description" />

    <UPageBody>

      <ContentRenderer :value="page" />

      <USeparator />

      <UContentSurround :surround="surround" />

    </UPageBody>

    <template #right>

      <UContentToc :links="page.body.toc.links" />

    </template>

  </UPage>

</template>
```

In this example, we use the [`ContentRenderer`](https://content.nuxt.com/docs/components/content-renderer) component from `@nuxt/content` to render the content of the page.

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

    pageBody: {

      base: 'mt-8 pb-24 space-y-12'

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

        pageBody: {

          base: 'mt-8 pb-24 space-y-12'

        }

      }

    })

  ]

})
```

## Changelog

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components