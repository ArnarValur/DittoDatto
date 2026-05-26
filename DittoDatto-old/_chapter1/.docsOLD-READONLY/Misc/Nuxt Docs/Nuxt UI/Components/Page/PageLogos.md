---
title: "Vue PageLogos Component"
source: "https://ui.nuxt.com/docs/components/page-logos"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A list of logos or images to display on your pages."
tags:
---
## PageLogos

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageLogos.vue)

A list of logos or images to display on your pages.

## Usage

The PageLogos component provides a flexible way to display a list of logos or images in your pages.

```
<template>

  <UPageLogos

    :items="[

      'i-simple-icons-github',

      'i-simple-icons-discord',

      'i-simple-icons-x',

      'i-simple-icons-instagram',

      'i-simple-icons-linkedin',

      'i-simple-icons-facebook'

    ]"

  />

</template>
```

Use the `title` prop to set the title above the logos.

## Trusted by the best front-end teams

```
<template>

  <UPageLogos

    title="Trusted by the best front-end teams"

    :items="[

      'i-simple-icons-github',

      'i-simple-icons-discord',

      'i-simple-icons-x',

      'i-simple-icons-instagram',

      'i-simple-icons-linkedin',

      'i-simple-icons-facebook'

    ]"

  />

</template>
```

### Items

You can display logos in two ways:

1. Using the `items` prop to provide a list of logos. Each item can be either:
- An icon name (e.g., `i-simple-icons-github`)
- An object containing `src` and `alt` properties for images, which will be utilized in a `UAvatar` component
1. Using the default slot to have complete control over the content

### Marquee

Use the `marquee` prop to enable a marquee effect for the logos.

## Trusted by the best front-end teams

```
<template>

  <UPageLogos

    title="Trusted by the best front-end teams"

    marquee

    :items="[

      'i-simple-icons-github',

      'i-simple-icons-discord',

      'i-simple-icons-x',

      'i-simple-icons-instagram',

      'i-simple-icons-linkedin',

      'i-simple-icons-facebook'

    ]"

  />

</template>
```

When you use `marquee` mode, you can customize its behavior by passing props. For more info, check out the `Marquee` component.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `items` |  | ` PageLogosItem[]` |
| `marquee` | `false` | `boolean \| MarqueeProps` |
| `ui` |  | ` { root?: ClassNameValue; title?: ClassNameValue; logos?: ClassNameValue; logo?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageLogos: {

      slots: {

        root: 'relative overflow-hidden',

        title: 'text-lg text-center font-semibold text-highlighted',

        logos: 'mt-10',

        logo: 'size-10 shrink-0'

      },

      variants: {

        marquee: {

          false: {

            logos: 'flex items-center shrink-0 justify-around gap-(--gap) [--gap:--spacing(16)]'

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

        pageLogos: {

          slots: {

            root: 'relative overflow-hidden',

            title: 'text-lg text-center font-semibold text-highlighted',

            logos: 'mt-10',

            logo: 'size-10 shrink-0'

          },

          variants: {

            marquee: {

              false: {

                logos: 'flex items-center shrink-0 justify-around gap-(--gap) [--gap:--spacing(16)]'

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

[`b6edc`](https://github.com/nuxt/ui/commit/b6edce266281ef8448588f303e4d8e28c7adf6ea) — feat!: rename from `PageMarquee` ([#4741](https://github.com/nuxt/ui/issues/4741))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageList](https://ui.nuxt.com/docs/components/page-list)

[

A vertical list layout for displaying content in a stacked format.

](https://ui.nuxt.com/docs/components/page-list)[

PageSection

A responsive section for your pages.

](https://ui.nuxt.com/docs/components/page-section)