---
title: "Vue FooterColumns Component"
source: "https://ui.nuxt.com/docs/components/footer-columns"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A list of links as columns to display in your Footer."
tags:
---
## Usage

The FooterColumns component renders a list of columns to display in your Footer.

Use it in the `top` slot of the [Footer](https://ui.nuxt.com/docs/components/footer) component:

### Columns

Use the `columns` prop as an array of objects with the following properties:

- `label: string`
- `children?: FooterColumnLink[]`

Each column contains a `children` array of objects that define the links. Each link can have the following properties:

- `label?: string`
- `icon?: string`
- `class?: any`
- `ui?: { item?: ClassNameValue, link?: ClassNameValue, linkLabel?: ClassNameValue, linkLabelExternalIcon?: ClassNameValue, linkLeadingIcon?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { FooterColumn } from '@nuxt/ui'

const columns: FooterColumn[] = [

  {

    label: 'Community',

    children: [

      {

        label: 'Nuxters',

        to: 'https://nuxters.nuxt.com',

        target: '_blank'

      },

      {

        label: 'Video Courses',

        to: 'https://masteringnuxt.com/nuxt3?ref=nuxt',

        target: '_blank'

      },

      {

        label: 'Nuxt on GitHub',

        to: 'https://github.com/nuxt',

        target: '_blank'

      }

    ]

  },

  {

    label: 'Solutions',

    children: [

      {

        label: 'Nuxt Content',

        to: 'https://content.nuxt.com/',

        target: '_blank'

      },

      {

        label: 'Nuxt DevTools',

        to: 'https://devtools.nuxt.com/',

        target: '_blank'

      },

      {

        label: 'Nuxt Image',

        to: 'https://image.nuxt.com/',

        target: '_blank'

      },

      {

        label: 'Nuxt UI',

        to: 'https://ui.nuxt.com/',

        target: '_blank'

      }

    ]

  }

]

</script>

<template>

  <UFooterColumns :columns="columns">

    <template #right>

      <UFormField name="email" label="Subscribe to our newsletter" size="lg">

        <UInput type="email" class="w-full">

          <template #trailing>

            <UButton type="submit" size="xs" color="neutral" label="Subscribe" />

          </template>

        </UInput>

      </UFormField>

    </template>

  </UFooterColumns>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'nav'` | `any`  The element or component this component should render as. |
| `columns` |  | ` FooterColumn<T>[]` |
| `ui` |  | ` { root?: ClassNameValue; left?: ClassNameValue; center?: ClassNameValue; right?: ClassNameValue; label?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLabel?: ClassNameValue; linkLabelExternalIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `left` | `{}` |
| `default` | `{}` |
| `right` | `{}` |
| `column-label` | `{ column: FooterColumn<T>; }` |
| `link` | `{ link: T; active: boolean; ui: object; }` |
| `link-leading` | `{ link: T; active: boolean; ui: object; }` |
| `link-label` | `{ link: T; active: boolean; }` |
| `link-trailing` | `{ link: T; active: boolean; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    footerColumns: {

      slots: {

        root: 'xl:grid xl:grid-cols-3 xl:gap-8',

        left: 'mb-10 xl:mb-0',

        center: 'flex flex-col lg:grid grid-flow-col auto-cols-fr gap-8 xl:col-span-2',

        right: 'mt-10 xl:mt-0',

        label: 'text-sm font-semibold',

        list: 'mt-6 space-y-4',

        item: 'relative',

        link: 'group text-sm flex items-center gap-1.5 focus-visible:outline-primary',

        linkLeadingIcon: 'size-5 shrink-0',

        linkLabel: 'truncate',

        linkLabelExternalIcon: 'size-3 absolute top-0 text-dimmed inline-block'

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

        footerColumns: {

          slots: {

            root: 'xl:grid xl:grid-cols-3 xl:gap-8',

            left: 'mb-10 xl:mb-0',

            center: 'flex flex-col lg:grid grid-flow-col auto-cols-fr gap-8 xl:col-span-2',

            right: 'mt-10 xl:mt-0',

            label: 'text-sm font-semibold',

            list: 'mt-6 space-y-4',

            item: 'relative',

            link: 'group text-sm flex items-center gap-1.5 focus-visible:outline-primary',

            linkLeadingIcon: 'size-5 shrink-0',

            linkLabel: 'truncate',

            linkLabelExternalIcon: 'size-3 absolute top-0 text-dimmed inline-block'

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

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[CommandPalette](https://ui.nuxt.com/docs/components/command-palette)

[

A command palette with full-text search powered by Fuse.js for efficient fuzzy matching.

](https://ui.nuxt.com/docs/components/command-palette)[

Link

A wrapper around <NuxtLink> with extra props.

](https://ui.nuxt.com/docs/components/link)