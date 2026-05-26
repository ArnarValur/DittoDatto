---
title: "Vue PageHero Component"
source: "https://ui.nuxt.com/docs/components/page-hero"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive hero for your pages."
tags:
---
## PageHero

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageHero.vue)

A responsive hero for your pages.

## Usage

The PageHero component wraps your content in a [Container](https://ui.nuxt.com/docs/components/container) while maintaining full-width flexibility making it easy to add background colors, images or patterns. It provides a flexible way to display content with an illustration in the default slot.

Use the `title` prop to set the title of the hero.

```
<template>

  <UPageHero title="Ultimate Vue UI library" />

</template>
```

### Description

Use the `description` prop to set the description of the hero.

```
<template>

  <UPageHero

    title="Ultimate Vue UI library"

    description="A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications."

  />

</template>
```

Use the `headline` prop to set the headline of the hero.

```
<template>

  <UPageHero

    title="Ultimate Vue UI library"

    description="A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications."

    headline="New release"

  />

</template>
```

### Links

Use the `links` prop to display a list of [Button](https://ui.nuxt.com/docs/components/button) under the description.

```
<script setup lang="ts">

import type { ButtonProps } from '@nuxt/ui'

const links = ref<ButtonProps[]>([

  {

    label: 'Get started',

    to: '/docs/getting-started',

    icon: 'i-lucide-square-play'

  },

  {

    label: 'Learn more',

    to: '/docs/getting-started/theme/design-system',

    color: 'neutral',

    variant: 'subtle',

    trailingIcon: 'i-lucide-arrow-right'

  }

])

</script>

<template>

  <UPageHero

    title="Ultimate Vue UI library"

    description="A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications."

    :links="links"

  />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation with the default slot. Defaults to `vertical`.

New release

## Ultimate Vue UI library

A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications.

![App screenshot](https://ui.nuxt.com/_ipx/_/blocks/image4.png)

```
<script setup lang="ts">

import type { ButtonProps } from '@nuxt/ui'

const links = ref<ButtonProps[]>([

  {

    label: 'Get started',

    to: '/docs/getting-started',

    icon: 'i-lucide-square-play'

  },

  {

    label: 'Learn more',

    to: '/docs/getting-started/theme/design-system',

    color: 'neutral',

    variant: 'subtle',

    trailingIcon: 'i-lucide-arrow-right'

  }

])

</script>

<template>

  <UPageHero

    title="Ultimate Vue UI library"

    description="A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications."

    headline="New release"

    orientation="horizontal"

    :links="links"

  >

    <img

      src="/blocks/image4.png"

      alt="App screenshot"

      class="rounded-lg shadow-2xl ring ring-default"

    />

  </UPageHero>

</template>
```

### Reverse

Use the `reverse` prop to reverse the orientation of the default slot.

New release

## Ultimate Vue UI library

A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications.

![App screenshot](https://ui.nuxt.com/_ipx/_/blocks/image4.png)

```
<script setup lang="ts">

import type { ButtonProps } from '@nuxt/ui'

const links = ref<ButtonProps[]>([

  {

    label: 'Get started',

    to: '/docs/getting-started',

    icon: 'i-lucide-square-play'

  },

  {

    label: 'Learn more',

    to: '/docs/getting-started/theme/design-system',

    color: 'neutral',

    variant: 'subtle',

    trailingIcon: 'i-lucide-arrow-right'

  }

])

</script>

<template>

  <UPageHero

    title="Ultimate Vue UI library"

    description="A Nuxt/Vue-integrated UI library providing a rich set of fully-styled, accessible and highly customizable components for building modern web applications."

    headline="New release"

    orientation="horizontal"

    reverse

    :links="links"

  >

    <img

      src="/blocks/image4.png"

      alt="App screenshot"

      class="rounded-lg shadow-2xl ring ring-default"

    />

  </UPageHero>

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
| `links` |  | ` ButtonProps[]`  Display a list of Button under the description.`{ size: 'xl' }` |
| `orientation` | `'vertical'` | ` "horizontal" \| "vertical"`  The orientation of the page hero. |
| `reverse` | `false` | `boolean`  Reverse the order of the default slot. |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; wrapper?: ClassNameValue; header?: ClassNameValue; headline?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; links?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `top` | `{}` |
| `header` | `{}` |
| `headline` | `{}` |
| `title` | `{}` |
| `description` | `{}` |
| `body` | `{}` |
| `footer` | `{}` |
| `links` | `{}` |
| `default` | `{}` |
| `bottom` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageHero: {

      slots: {

        root: 'relative isolate',

        container: 'flex flex-col lg:grid py-24 sm:py-32 lg:py-40 gap-16 sm:gap-y-24',

        wrapper: '',

        header: '',

        headline: 'mb-4',

        title: 'text-5xl sm:text-7xl text-pretty tracking-tight font-bold text-highlighted',

        description: 'text-lg sm:text-xl/8 text-muted',

        body: 'mt-10',

        footer: 'mt-10',

        links: 'flex flex-wrap gap-x-6 gap-y-3'

      },

      variants: {

        orientation: {

          horizontal: {

            container: 'lg:grid-cols-2 lg:items-center',

            description: 'text-pretty'

          },

          vertical: {

            container: '',

            headline: 'justify-center',

            wrapper: 'text-center',

            description: 'text-balance',

            links: 'justify-center'

          }

        },

        reverse: {

          true: {

            wrapper: 'order-last'

          }

        },

        headline: {

          true: {

            headline: 'font-semibold text-primary flex items-center gap-1.5'

          }

        },

        title: {

          true: {

            description: 'mt-6'

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

        pageHero: {

          slots: {

            root: 'relative isolate',

            container: 'flex flex-col lg:grid py-24 sm:py-32 lg:py-40 gap-16 sm:gap-y-24',

            wrapper: '',

            header: '',

            headline: 'mb-4',

            title: 'text-5xl sm:text-7xl text-pretty tracking-tight font-bold text-highlighted',

            description: 'text-lg sm:text-xl/8 text-muted',

            body: 'mt-10',

            footer: 'mt-10',

            links: 'flex flex-wrap gap-x-6 gap-y-3'

          },

          variants: {

            orientation: {

              horizontal: {

                container: 'lg:grid-cols-2 lg:items-center',

                description: 'text-pretty'

              },

              vertical: {

                container: '',

                headline: 'justify-center',

                wrapper: 'text-center',

                description: 'text-balance',

                links: 'justify-center'

              }

            },

            reverse: {

              true: {

                wrapper: 'order-last'

              }

            },

            headline: {

              true: {

                headline: 'font-semibold text-primary flex items-center gap-1.5'

              }

            },

            title: {

              true: {

                description: 'mt-6'

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

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components