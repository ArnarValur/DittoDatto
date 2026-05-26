---
title: "Vue PageHeader Component"
source: "https://ui.nuxt.com/docs/components/page-header"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive header for your pages."
tags:
---
## Usage

The PageHeader component displays a header for your page.

Use it inside the default slot of the [Page](https://ui.nuxt.com/docs/components/page) component, before the [PageBody](https://ui.nuxt.com/docs/components/page-body) component:

Use the `title` prop to display a title in the header.

### Description

Use the `description` prop to display a description in the header.

Use the `headline` prop to display a headline in the header.

### Links

Use the `links` prop to display a list of [Button](https://ui.nuxt.com/docs/components/button) in the header.

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a page

Use the PageHeader component in a page to display the header of the page:

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

    <UPageHeader

      :title="page.title"

      :description="page.description"

      :headline="page.headline"

      :links="page.links"

    />

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

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `headline` |  | ` string` |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `links` |  | ` ButtonProps[]`  Display a list of Button next to the title.`{ color: 'neutral', variant: 'outline' }` |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; wrapper?: ClassNameValue; headline?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; links?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `headline` | `{}` |
| `title` | `{}` |
| `description` | `{}` |
| `links` | `{}` |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageHeader: {

      slots: {

        root: 'relative border-b border-default py-8',

        container: '',

        wrapper: 'flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4',

        headline: 'mb-2.5 text-sm font-semibold text-primary flex items-center gap-1.5',

        title: 'text-3xl sm:text-4xl text-pretty font-bold text-highlighted',

        description: 'text-lg text-pretty text-muted',

        links: 'flex flex-wrap items-center gap-1.5'

      },

      variants: {

        title: {

          true: {

            description: 'mt-4'

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

        pageHeader: {

          slots: {

            root: 'relative border-b border-default py-8',

            container: '',

            wrapper: 'flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4',

            headline: 'mb-2.5 text-sm font-semibold text-primary flex items-center gap-1.5',

            title: 'text-3xl sm:text-4xl text-pretty font-bold text-highlighted',

            description: 'text-lg text-pretty text-muted',

            links: 'flex flex-wrap items-center gap-1.5'

          },

          variants: {

            title: {

              true: {

                description: 'mt-4'

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageGrid](https://ui.nuxt.com/docs/components/page-grid)

[

A responsive grid system for displaying content in a flexible layout.

](https://ui.nuxt.com/docs/components/page-grid)[

PageHero

A responsive hero for your pages.

](https://ui.nuxt.com/docs/components/page-hero)