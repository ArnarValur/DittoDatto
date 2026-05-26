---
title: "Vue PageLinks Component"
source: "https://ui.nuxt.com/docs/components/page-links"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A list of links to be displayed in the page."
tags:
---
## PageLinks

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageLinks.vue)

A list of links to be displayed in the page.

## Usage

Use the PageLinks component to display a list of links.

```
<script setup lang="ts">

import type { PageLink } from '@nuxt/ui'

const links = ref<PageLink[]>([

  {

    label: 'Edit this page',

    icon: 'i-lucide-file-pen',

    to: 'https://github.com/nuxt/ui/blob/v4/docs/content/3.components/page-links.md'

  },

  {

    label: 'Star on GitHub',

    icon: 'i-lucide-star',

    to: 'https://github.com/nuxt/ui'

  },

  {

    label: 'Releases',

    icon: 'i-lucide-rocket',

    to: 'https://github.com/nuxt/ui/releases'

  }

])

</script>

<template>

  <UPageLinks :links="links" />

</template>
```

### Links

Use the `links` prop as an array of objects with the following properties:

- `label: string`
- `icon?: string`
- `class?: any`
- `ui?: { item?: ClassNameValue, link?: ClassNameValue, linkLabel?: ClassNameValue, linkLabelExternalIcon?: ClassNameValue, linkLeadingIcon?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { PageLink } from '@nuxt/ui'

const links = ref<PageLink[]>([

  {

    label: 'Edit this page',

    icon: 'i-lucide-file-pen',

    to: 'https://github.com/nuxt/ui/blob/v4/docs/content/3.components/page-links.md'

  },

  {

    label: 'Star on GitHub',

    icon: 'i-lucide-star',

    to: 'https://github.com/nuxt/ui'

  },

  {

    label: 'Releases',

    icon: 'i-lucide-rocket',

    to: 'https://github.com/nuxt/ui/releases'

  }

])

</script>

<template>

  <UPageLinks :links="links" />

</template>
```

Use the `title` prop to display a title above the links.

```
<script setup lang="ts">

import type { PageLink } from '@nuxt/ui'

const links = ref<PageLink[]>([

  {

    label: 'Edit this page',

    icon: 'i-lucide-file-pen',

    to: 'https://github.com/nuxt/ui/blob/v4/docs/content/3.components/page-links.md'

  },

  {

    label: 'Star on GitHub',

    icon: 'i-lucide-star',

    to: 'https://github.com/nuxt/ui'

  },

  {

    label: 'Releases',

    icon: 'i-lucide-rocket',

    to: 'https://github.com/nuxt/ui/releases'

  }

])

</script>

<template>

  <UPageLinks title="Community" :links="links" />

</template>
```

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a page

Use the PageLinks component in the `bottom` slot of the ContentToc component to display a list of links below the table of contents.

pages/\[...slug\].vue

```
<script setup lang="ts">

import type { PageLink } from '@nuxt/ui'

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

const links = computed<PageLink[]>(() => [{

  icon: 'i-lucide-file-pen',

  label: 'Edit this page',

  to: \`https://github.com/nuxt/ui/edit/v4/docs/content/${page?.value?.stem}.md\`,

  target: '_blank'

}, {

  icon: 'i-lucide-star',

  label: 'Star on GitHub',

  to: 'https://github.com/nuxt/ui',

  target: '_blank'

}, {

  label: 'Releases',

  icon: 'i-lucide-rocket',

  to: 'https://github.com/nuxt/ui/releases'

}])

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

      <UContentToc :links="page.body.toc.links">

        <template #bottom>

          <USeparator type="dashed" />

          <UPageLinks title="Community" :links="links" />

        </template>

      </UContentToc>

    </template>

  </UPage>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'nav'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `links` |  | ` T[]` |
| `ui` |  | ` { root?: ClassNameValue; title?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLabel?: ClassNameValue; linkLabelExternalIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `title` | `{}` |
| `link` | `{ link: T; active: boolean; ui: object; }` |
| `link-leading` | `{ link: T; active: boolean; ui: object; }` |
| `link-label` | `{ link: T; active: boolean; }` |
| `link-trailing` | `{ link: T; active: boolean; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageLinks: {

      slots: {

        root: 'flex flex-col gap-3',

        title: 'text-sm font-semibold flex items-center gap-1.5',

        list: 'flex flex-col gap-2',

        item: 'relative',

        link: 'group text-sm flex items-center gap-1.5 focus-visible:outline-primary',

        linkLeadingIcon: 'size-5 shrink-0',

        linkLabel: 'truncate',

        linkLabelExternalIcon: 'size-3 absolute top-0 text-dimmed'

      },

      variants: {

        active: {

          true: {

            link: 'text-primary font-medium'

          },

          false: {

            link: [

              'text-muted hover:text-default',

              'transition-colors'

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

        pageLinks: {

          slots: {

            root: 'flex flex-col gap-3',

            title: 'text-sm font-semibold flex items-center gap-1.5',

            list: 'flex flex-col gap-2',

            item: 'relative',

            link: 'group text-sm flex items-center gap-1.5 focus-visible:outline-primary',

            linkLeadingIcon: 'size-5 shrink-0',

            linkLabel: 'truncate',

            linkLabelExternalIcon: 'size-3 absolute top-0 text-dimmed'

          },

          variants: {

            active: {

              true: {

                link: 'text-primary font-medium'

              },

              false: {

                link: [

                  'text-muted hover:text-default',

                  'transition-colors'

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageHero](https://ui.nuxt.com/docs/components/page-hero)

[

A responsive hero for your pages.

](https://ui.nuxt.com/docs/components/page-hero)[

PageList

A vertical list layout for displaying content in a stacked format.

](https://ui.nuxt.com/docs/components/page-list)