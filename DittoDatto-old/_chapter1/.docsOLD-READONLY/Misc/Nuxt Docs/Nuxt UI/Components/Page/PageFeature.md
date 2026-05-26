---
title: "Vue PageFeature Component"
source: "https://ui.nuxt.com/docs/components/page-feature"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A component to showcase key features of your application."
tags:
---
## PageFeature

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageFeature.vue)

A component to showcase key features of your application.

## Usage

The PageFeature component is used by the [PageSection](https://ui.nuxt.com/docs/components/page-section) component to display [features](https://ui.nuxt.com/docs/components/page-section#features).

Use the `title` prop to set the title of the feature.

Theme

```
<template>

  <UPageFeature title="Theme" />

</template>
```

### Description

Use the `description` prop to set the description of the feature.

Theme

Customize Nuxt UI with your own colors, fonts, and more.

```
<template>

  <UPageFeature

    title="Theme"

    description="Customize Nuxt UI with your own colors, fonts, and more."

  />

</template>
```

### Icon

Use the `icon` prop to set the icon of the feature.

Theme

Customize Nuxt UI with your own colors, fonts, and more.

```
<template>

  <UPageFeature

    title="Theme"

    description="Customize Nuxt UI with your own colors, fonts, and more."

    icon="i-lucide-swatch-book"

  />

</template>
```

### Link

You can pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component such as `to`, `target`, `rel`, etc.

Theme

Customize Nuxt UI with your own colors, fonts, and more.

```
<template>

  <UPageFeature

    title="Theme"

    description="Customize Nuxt UI with your own colors, fonts, and more."

    icon="i-lucide-swatch-book"

    to="/docs/getting-started/theme/design-system"

    target="_blank"

  />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the feature. Defaults to `horizontal`.

```
<template>

  <UPageFeature

    orientation="vertical"

    title="Theme"

    description="Customize Nuxt UI with your own colors, fonts, and more."

    icon="i-lucide-swatch-book"

  />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `icon` |  | `any`  The icon displayed next to the title when `orientation` is `horizontal` and above the title when `orientation` is `vertical`. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the page feature. |
| `to` |  | ` string \| kt \| Tt` |
| `target` |  | ` null \| "_blank" \| "_parent" \| "_self" \| "_top" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; wrapper?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageFeature: {

      slots: {

        root: 'relative rounded-sm',

        wrapper: '',

        leading: 'inline-flex items-center justify-center',

        leadingIcon: 'size-5 shrink-0 text-primary',

        title: 'text-base text-pretty font-semibold text-highlighted',

        description: 'text-[15px] text-pretty text-muted'

      },

      variants: {

        orientation: {

          horizontal: {

            root: 'flex items-start gap-2.5',

            leading: 'p-0.5'

          },

          vertical: {

            leading: 'mb-2.5'

          }

        },

        to: {

          true: {

            root: [

              'has-focus-visible:ring-2 has-focus-visible:ring-primary',

              'transition'

            ]

          }

        },

        title: {

          true: {

            description: 'mt-1'

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

        pageFeature: {

          slots: {

            root: 'relative rounded-sm',

            wrapper: '',

            leading: 'inline-flex items-center justify-center',

            leadingIcon: 'size-5 shrink-0 text-primary',

            title: 'text-base text-pretty font-semibold text-highlighted',

            description: 'text-[15px] text-pretty text-muted'

          },

          variants: {

            orientation: {

              horizontal: {

                root: 'flex items-start gap-2.5',

                leading: 'p-0.5'

              },

              vertical: {

                leading: 'mb-2.5'

              }

            },

            to: {

              true: {

                root: [

                  'has-focus-visible:ring-2 has-focus-visible:ring-primary',

                  'transition'

                ]

              }

            },

            title: {

              true: {

                description: 'mt-1'

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

[`47d93`](https://github.com/nuxt/ui/commit/47d93d31d99e893d71cf4e2e78265d54d2e561a2) — fix: allow tab focus

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageCTA](https://ui.nuxt.com/docs/components/page-cta)

[

A call to action section to display in your pages.

](https://ui.nuxt.com/docs/components/page-cta)[

PageGrid

A responsive grid system for displaying content in a flexible layout.

](https://ui.nuxt.com/docs/components/page-grid)