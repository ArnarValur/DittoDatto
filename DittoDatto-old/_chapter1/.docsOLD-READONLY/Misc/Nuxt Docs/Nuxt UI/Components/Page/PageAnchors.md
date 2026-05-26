---
title: "Vue PageAnchors Component"
source: "https://ui.nuxt.com/docs/components/page-anchors"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A list of anchors to be displayed in the page."
tags:
---
## PageAnchors

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageAnchors.vue)

A list of anchors to be displayed in the page.

## Usage

Use the PageAnchors component to display a list of links.

```
<script setup lang="ts">

import type { PageAnchor } from '@nuxt/ui'

const links = ref<PageAnchor[]>([

  {

    label: 'Documentation',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components'

  },

  {

    label: 'Figma Kit',

    icon: 'i-simple-icons-figma',

    to: 'https://go.nuxt.com/figma-ui',

    target: '_blank'

  },

  {

    label: 'Releases',

    icon: 'i-simple-icons-github',

    to: 'https://github.com/nuxt/ui/releases',

    target: '_blank'

  }

])

</script>

<template>

  <UPageAnchors :links="links" />

</template>
```

### Links

Use the `links` prop as an array of objects with the following properties:

- `label: string`
- `icon?: string`
- `class?: any`
- `ui?: { item?: ClassNameValue, link?: ClassNameValue, linkLabel?: ClassNameValue, linkLabelExternalIcon?: ClassNameValue, linkLeading?: ClassNameValue, linkLeadingIcon?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { PageAnchor } from '@nuxt/ui'

const links = ref<PageAnchor[]>([

  {

    label: 'Documentation',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components'

  },

  {

    label: 'Figma Kit',

    icon: 'i-simple-icons-figma',

    to: 'https://go.nuxt.com/figma-ui',

    target: '_blank'

  },

  {

    label: 'Releases',

    icon: 'i-simple-icons-github',

    to: 'https://github.com/nuxt/ui/releases',

    target: '_blank'

  }

])

</script>

<template>

  <UPageAnchors :links="links" />

</template>
```

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a layout

Use the PageAnchors component inside the [PageAside](https://ui.nuxt.com/docs/components/page-aside) component to display a list of links above the navigation.

layouts/docs.vue

```
<script setup lang="ts">

import type { PageAnchor } from '@nuxt/ui'

import type { ContentNavigationItem } from '@nuxt/content'

const navigation = inject<ContentNavigationItem[]>('navigation')

const links: PageAnchor[] = [{

  label: 'Documentation',

  icon: 'i-lucide-book-open',

  to: '/docs/getting-started'

}, {

  label: 'Components',

  icon: 'i-lucide-box',

  to: '/docs/components'

}, {

  label: 'Figma Kit',

  icon: 'i-simple-icons-figma',

  to: 'https://go.nuxt.com/figma-ui',

  target: '_blank'

}, {

  label: 'Releases',

  icon: 'i-lucide-rocket',

  to: 'https://github.com/nuxt/ui/releases',

  target: '_blank'

}]

</script>

<template>

  <UPage>

    <template #left>

      <UPageAside>

        <UPageAnchors :links="links" />

        <USeparator type="dashed" />

        <UContentNavigation :navigation="navigation" />

      </UPageAside>

    </template>

    <slot />

  </UPage>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'nav'` | `any`  The element or component this component should render as. |
| `links` |  | ` T[]` |
| `ui` |  | ` { root?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; link?: ClassNameValue; linkLeading?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLabel?: ClassNameValue; linkLabelExternalIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `link` | `{ link: T; active: boolean; ui: object; }` |
| `link-leading` | `{ link: T; active: boolean; ui: object; }` |
| `link-label` | `{ link: T; active: boolean; }` |
| `link-trailing` | `{ link: T; active: boolean; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageAnchors: {

      slots: {

        root: '',

        list: '',

        item: 'relative',

        link: 'group text-sm flex items-center gap-1.5 py-1 focus-visible:outline-primary',

        linkLeading: 'rounded-md p-1 inline-flex ring-inset ring',

        linkLeadingIcon: 'size-4 shrink-0',

        linkLabel: 'truncate',

        linkLabelExternalIcon: 'size-3 absolute top-0 text-dimmed'

      },

      variants: {

        active: {

          true: {

            link: 'text-primary font-semibold',

            linkLeading: 'bg-primary ring-primary text-inverted'

          },

          false: {

            link: [

              'text-muted hover:text-default font-medium',

              'transition-colors'

            ],

            linkLeading: [

              'bg-elevated/50 ring-accented text-dimmed group-hover:bg-primary group-hover:ring-primary group-hover:text-inverted',

              'transition'

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

        pageAnchors: {

          slots: {

            root: '',

            list: '',

            item: 'relative',

            link: 'group text-sm flex items-center gap-1.5 py-1 focus-visible:outline-primary',

            linkLeading: 'rounded-md p-1 inline-flex ring-inset ring',

            linkLeadingIcon: 'size-4 shrink-0',

            linkLabel: 'truncate',

            linkLabelExternalIcon: 'size-3 absolute top-0 text-dimmed'

          },

          variants: {

            active: {

              true: {

                link: 'text-primary font-semibold',

                linkLeading: 'bg-primary ring-primary text-inverted'

              },

              false: {

                link: [

                  'text-muted hover:text-default font-medium',

                  'transition-colors'

                ],

                linkLeading: [

                  'bg-elevated/50 ring-accented text-dimmed group-hover:bg-primary group-hover:ring-primary group-hover:text-inverted',

                  'transition'

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

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components