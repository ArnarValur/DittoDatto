---
title: "Vue PageSection Component"
source: "https://ui.nuxt.com/docs/components/page-section"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive section for your pages."
tags:
---
## PageSection

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageSection.vue)

A responsive section for your pages.

## Usage

The PageSection component wraps your content in a [Container](https://ui.nuxt.com/docs/components/container) while maintaining full-width flexibility making it easy to add background colors, images or patterns. It provides a flexible way to display content with an illustration in the default slot.

Use it after a [PageHero](https://ui.nuxt.com/docs/components/page-hero) component:

```
<template>

  <UPageHero />

  <UPageSection />

</template>
```

Use the `title` prop to set the title of the section.

```
<template>

  <UPageSection title="Beautiful Vue UI components" />

</template>
```

### Description

Use the `description` prop to set the description of the section.

```
<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

  />

</template>
```

Use the `headline` prop to set the headline of the section.

```
<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

    headline="Features"

  />

</template>
```

### Icon

Use the `icon` prop to set the icon of the section.

```
<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

    icon="i-lucide-rocket"

  />

</template>
```

### Features

Use the `features` prop to display a list of [PageFeature](https://ui.nuxt.com/docs/components/page-feature) under the description as an array of objects with the following properties:

- `title?: string`
- `description?: string`
- `icon?: string`
- `orientation?: 'horizontal' | 'vertical'`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { PageFeatureProps } from '@nuxt/ui'

const features = ref<PageFeatureProps[]>([

  {

    title: 'Icons',

    description: 'Nuxt UI integrates with Nuxt Icon to access over 200,000+ icons from Iconify.',

    icon: 'i-lucide-smile',

    to: '/docs/getting-started/integrations/icons'

  },

  {

    title: 'Fonts',

    description: 'Nuxt UI integrates with Nuxt Fonts to provide plug-and-play font optimization.',

    icon: 'i-lucide-a-large-small',

    to: '/docs/getting-started/integrations/fonts'

  },

  {

    title: 'Color Mode',

    description: 'Nuxt UI integrates with Nuxt Color Mode to switch between light and dark.',

    icon: 'i-lucide-sun-moon',

    to: '/docs/getting-started/integrations/color-mode'

  }

])

</script>

<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

    :features="features"

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

    icon: 'i-lucide-square-play',

    color: 'neutral'

  },

  {

    label: 'Explore components',

    to: '/docs/components/app',

    color: 'neutral',

    variant: 'subtle',

    trailingIcon: 'i-lucide-arrow-right'

  }

])

</script>

<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

    :links="links"

  />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation with the default slot. Defaults to `vertical`.

```
<script setup lang="ts">

import type { PageFeatureProps, ButtonProps } from '@nuxt/ui'

const features = ref<PageFeatureProps[]>([

  {

    title: 'Icons',

    description: 'Nuxt UI integrates with Nuxt Icon to access over 200,000+ icons from Iconify.',

    icon: 'i-lucide-smile',

    to: '/docs/getting-started/integrations/icons'

  },

  {

    title: 'Fonts',

    description: 'Nuxt UI integrates with Nuxt Fonts to provide plug-and-play font optimization.',

    icon: 'i-lucide-a-large-small',

    to: '/docs/getting-started/integrations/fonts'

  },

  {

    title: 'Color Mode',

    description: 'Nuxt UI integrates with Nuxt Color Mode to switch between light and dark.',

    icon: 'i-lucide-sun-moon',

    to: '/docs/getting-started/integrations/color-mode'

  }

])

const links = ref<ButtonProps[]>([

  {

    label: 'Explore components',

    to: '/docs/components/app',

    color: 'neutral',

    variant: 'subtle',

    trailingIcon: 'i-lucide-arrow-right'

  }

])

</script>

<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

    icon="i-lucide-rocket"

    orientation="horizontal"

    :features="features"

    :links="links"

  >

    <img

      src="https://picsum.photos/704/1294"

      width="352"

      height="647"

      alt="Illustration"

      class="w-full rounded-lg"

    />

  </UPageSection>

</template>
```

### Reverse

Use the `reverse` prop to reverse the orientation of the default slot.

```
<script setup lang="ts">

import type { PageFeatureProps, ButtonProps } from '@nuxt/ui'

const features = ref<PageFeatureProps[]>([

  {

    title: 'Icons',

    description: 'Nuxt UI integrates with Nuxt Icon to access over 200,000+ icons from Iconify.',

    icon: 'i-lucide-smile',

    to: '/docs/getting-started/integrations/icons'

  },

  {

    title: 'Fonts',

    description: 'Nuxt UI integrates with Nuxt Fonts to provide plug-and-play font optimization.',

    icon: 'i-lucide-a-large-small',

    to: '/docs/getting-started/integrations/fonts'

  },

  {

    title: 'Color Mode',

    description: 'Nuxt UI integrates with Nuxt Color Mode to switch between light and dark.',

    icon: 'i-lucide-sun-moon',

    to: '/docs/getting-started/integrations/color-mode'

  }

])

const links = ref<ButtonProps[]>([

  {

    label: 'Explore components',

    to: '/docs/components/app',

    color: 'neutral',

    variant: 'subtle',

    trailingIcon: 'i-lucide-arrow-right'

  }

])

</script>

<template>

  <UPageSection

    title="Beautiful Vue UI components"

    description="Nuxt UI provides a comprehensive suite of components and utilities to help you build beautiful and accessible web applications with Vue and Nuxt."

    icon="i-lucide-rocket"

    orientation="horizontal"

    reverse

    :features="features"

    :links="links"

  >

    <img

      src="https://picsum.photos/704/1294"

      width="352"

      height="647"

      alt="Illustration"

      class="w-full rounded-lg"

    />

  </UPageSection>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'section'` | `any`  The element or component this component should render as. |
| `headline` |  | ` string`  The headline displayed above the title. |
| `icon` |  | `any`  The icon displayed above the title. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `links` |  | ` ButtonProps[]`  Display a list of Button under the description.`{ size: 'lg' }` |
| `features` |  | ` PageFeatureProps[]`  Display a list of PageFeature under the description. |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation of the section. |
| `reverse` | `false` | `boolean`  Reverse the order of the default slot. |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; wrapper?: ClassNameValue; header?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; headline?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; body?: ClassNameValue; features?: ClassNameValue; footer?: ClassNameValue; links?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `top` | `{}` |
| `header` | `{}` |
| `leading` | `{ ui: object; }` |
| `headline` | `{}` |
| `title` | `{}` |
| `description` | `{}` |
| `body` | `{}` |
| `features` | `{}` |
| `footer` | `{}` |
| `links` | `{}` |
| `default` | `{}` |
| `bottom` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageSection: {

      slots: {

        root: 'relative isolate',

        container: 'flex flex-col lg:grid py-16 sm:py-24 lg:py-32 gap-8 sm:gap-16',

        wrapper: '',

        header: '',

        leading: 'flex items-center mb-6',

        leadingIcon: 'size-10 shrink-0 text-primary',

        headline: 'mb-3',

        title: 'text-3xl sm:text-4xl lg:text-5xl text-pretty tracking-tight font-bold text-highlighted',

        description: 'text-base sm:text-lg text-muted',

        body: 'mt-8',

        features: 'grid',

        footer: 'mt-8',

        links: 'flex flex-wrap gap-x-6 gap-y-3'

      },

      variants: {

        orientation: {

          horizontal: {

            container: 'lg:grid-cols-2 lg:items-center',

            description: 'text-pretty',

            features: 'gap-4'

          },

          vertical: {

            container: '',

            headline: 'justify-center',

            leading: 'justify-center',

            title: 'text-center',

            description: 'text-center text-balance',

            links: 'justify-center',

            features: 'sm:grid-cols-2 lg:grid-cols-3 gap-8'

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

        },

        description: {

          true: ''

        },

        body: {

          true: ''

        }

      },

      compoundVariants: [

        {

          orientation: 'vertical',

          title: true,

          class: {

            body: 'mt-16'

          }

        },

        {

          orientation: 'vertical',

          description: true,

          class: {

            body: 'mt-16'

          }

        },

        {

          orientation: 'vertical',

          body: true,

          class: {

            footer: 'mt-16'

          }

        }

      ]

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

        pageSection: {

          slots: {

            root: 'relative isolate',

            container: 'flex flex-col lg:grid py-16 sm:py-24 lg:py-32 gap-8 sm:gap-16',

            wrapper: '',

            header: '',

            leading: 'flex items-center mb-6',

            leadingIcon: 'size-10 shrink-0 text-primary',

            headline: 'mb-3',

            title: 'text-3xl sm:text-4xl lg:text-5xl text-pretty tracking-tight font-bold text-highlighted',

            description: 'text-base sm:text-lg text-muted',

            body: 'mt-8',

            features: 'grid',

            footer: 'mt-8',

            links: 'flex flex-wrap gap-x-6 gap-y-3'

          },

          variants: {

            orientation: {

              horizontal: {

                container: 'lg:grid-cols-2 lg:items-center',

                description: 'text-pretty',

                features: 'gap-4'

              },

              vertical: {

                container: '',

                headline: 'justify-center',

                leading: 'justify-center',

                title: 'text-center',

                description: 'text-center text-balance',

                links: 'justify-center',

                features: 'sm:grid-cols-2 lg:grid-cols-3 gap-8'

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

            },

            description: {

              true: ''

            },

            body: {

              true: ''

            }

          },

          compoundVariants: [

            {

              orientation: 'vertical',

              title: true,

              class: {

                body: 'mt-16'

              }

            },

            {

              orientation: 'vertical',

              description: true,

              class: {

                body: 'mt-16'

              }

            },

            {

              orientation: 'vertical',

              body: true,

              class: {

                footer: 'mt-16'

              }

            }

          ]

        }

      }

    })

  ]

})
```

## Changelog

[`60b43`](https://github.com/nuxt/ui/commit/60b430c3187f755a8ae21b64021c63bf9447420b) — fix: handle `reverse` prop under lg screens ([#5545](https://github.com/nuxt/ui/issues/5545))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageLogos](https://ui.nuxt.com/docs/components/page-logos)

[

A list of logos or images to display on your pages.

](https://ui.nuxt.com/docs/components/page-logos)[

PricingPlan

A customizable pricing plan to display in a pricing page.

](https://ui.nuxt.com/docs/components/pricing-plan)