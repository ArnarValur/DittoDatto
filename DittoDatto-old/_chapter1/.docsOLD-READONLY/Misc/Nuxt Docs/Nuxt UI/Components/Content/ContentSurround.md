---
title: "Vue ContentSurround Component"
source: "https://ui.nuxt.com/docs/components/content-surround"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A pair of prev and next links to navigate between pages."
tags:
---
This component is only available when the `@nuxt/content` module is installed.

## Usage

Use the `surround` prop with the `surround` value you get when fetching a page surround.[ContentSearchButton](https://ui.nuxt.com/docs/components/content-search-button)

[

A pre-styled Button to open the ContentSearch modal.

](https://ui.nuxt.com/docs/components/content-search-button)[

ContentToc

A sticky Table of Contents with automatic active anchor link highlighting.

](https://ui.nuxt.com/docs/components/content-toc)

```
<script setup lang="ts">

const route = useRoute()

const { data: surround } = await useAsyncData(\`${route.path}-surround\`, () => {

  return queryCollectionItemSurroundings('docs', route.path, {

    fields: ['description']

  })

})

</script>

<template>

  <UContentSurround :surround="(surround as any)" />

</template>
```

Use the `prev-icon` and `next-icon` props to customize the buttons [Icon](https://ui.nuxt.com/docs/components/icon).[ContentSearchButton](https://ui.nuxt.com/components/content-search-button)

[

A pre-styled Button to open the ContentSearch modal.

](https://ui.nuxt.com/components/content-search-button)[

ContentToc

A sticky Table of Contents with customizable slots.

](https://ui.nuxt.com/components/content-toc)

```
<script setup lang="ts">

import type { ContentSurroundLink } from '@nuxt/ui'

const surround = ref<ContentSurroundLink[]>([

  {

    title: 'ContentSearchButton',

    path: '/components/content-search-button',

    stem: '3.components/content-search-button',

    description: 'A pre-styled Button to open the ContentSearch modal.'

  },

  {

    title: 'ContentToc',

    path: '/components/content-toc',

    stem: '3.components/content-toc',

    description: 'A sticky Table of Contents with customizable slots.'

  }

])

</script>

<template>

  <UContentSurround

    prev-icon="i-lucide-chevron-left"

    next-icon="i-lucide-chevron-right"

    :surround="surround"

  />

</template>
```

## Examples

### Within a page

Use the ContentSurround component in a page to display the prev and next links:

pages/\[...slug\].vue

```
<script setup lang="ts">

const route = useRoute()

const { data: page } = await useAsyncData(route.path, () => queryCollection('docs').path(route.path).first())

if (!page.value) {

  throw createError({ statusCode: 404, statusMessage: 'Page not found', fatal: true })

}

</script>

<template>

  <UPage v-if="page">

    <UPageHeader :title="page.title" />

    <UPageBody>

      <ContentRenderer v-if="page.body" :value="page" />

      <USeparator v-if="surround?.filter(Boolean).length" />

      <UContentSurround :surround="(surround as any)" />

    </UPageBody>

    <template v-if="page?.body?.toc?.links?.length" #right>

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
| `prevIcon` | `appConfig.ui.icons.arrowLeft` | `any`  The icon displayed in the prev link. |
| `nextIcon` | `appConfig.ui.icons.arrowRight` | `any`  The icon displayed in the next link. |
| `surround` |  | ` T[]` |
| `ui` |  | ` { root?: ClassNameValue; link?: ClassNameValue; linkLeading?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkTitle?: ClassNameValue; linkDescription?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `link` | `{ link: T; ui: object; }` |
| `link-leading` | `{ link: T; ui: object; }` |
| `link-title` | `{ link: T; ui: object; }` |
| `link-description` | `{ link: T; ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    contentSurround: {

      slots: {

        root: 'grid grid-cols-1 sm:grid-cols-2 gap-8',

        link: [

          'group block px-6 py-8 rounded-lg border border-default hover:bg-elevated/50 focus-visible:outline-primary',

          'transition-colors'

        ],

        linkLeading: [

          'inline-flex items-center rounded-full p-1.5 bg-elevated group-hover:bg-primary/10 ring ring-accented mb-4 group-hover:ring-primary/50',

          'transition'

        ],

        linkLeadingIcon: [

          'size-5 shrink-0 text-highlighted group-hover:text-primary',

          'transition-[color,translate]'

        ],

        linkTitle: 'font-medium text-[15px] text-highlighted mb-1 truncate',

        linkDescription: 'text-sm text-muted line-clamp-2'

      },

      variants: {

        direction: {

          left: {

            linkLeadingIcon: [

              'group-active:-translate-x-0.5'

            ]

          },

          right: {

            link: 'text-right',

            linkLeadingIcon: [

              'group-active:translate-x-0.5'

            ]

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

        contentSurround: {

          slots: {

            root: 'grid grid-cols-1 sm:grid-cols-2 gap-8',

            link: [

              'group block px-6 py-8 rounded-lg border border-default hover:bg-elevated/50 focus-visible:outline-primary',

              'transition-colors'

            ],

            linkLeading: [

              'inline-flex items-center rounded-full p-1.5 bg-elevated group-hover:bg-primary/10 ring ring-accented mb-4 group-hover:ring-primary/50',

              'transition'

            ],

            linkLeadingIcon: [

              'size-5 shrink-0 text-highlighted group-hover:text-primary',

              'transition-[color,translate]'

            ],

            linkTitle: 'font-medium text-[15px] text-highlighted mb-1 truncate',

            linkDescription: 'text-sm text-muted line-clamp-2'

          },

          variants: {

            direction: {

              left: {

                linkLeadingIcon: [

                  'group-active:-translate-x-0.5'

                ]

              },

              right: {

                link: 'text-right',

                linkLeadingIcon: [

                  'group-active:translate-x-0.5'

                ]

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

[`6dd73`](https://github.com/nuxt/ui/commit/6dd731ce2879bb0a9914b61bd6a0134a5aca69e2) — chore: update nuxt framework to ^4.3.0 (v4) ([#5923](https://github.com/nuxt/ui/issues/5923))

[`b3adc`](https://github.com/nuxt/ui/commit/b3adccc1f6fae0e1f5403a909d84d12449c075cc) — fix: align next link to right on tablet without prev ([#5833](https://github.com/nuxt/ui/issues/5833))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ContentSearchButton](https://ui.nuxt.com/docs/components/content-search-button)

[

A pre-styled Button to open the ContentSearch modal.

](https://ui.nuxt.com/docs/components/content-search-button)[

ContentToc

A sticky Table of Contents with automatic active anchor link highlighting.

](https://ui.nuxt.com/docs/components/content-toc)