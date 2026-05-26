---
title: "Vue PricingPlans Component"
source: "https://ui.nuxt.com/docs/components/pricing-plans"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Display a list of pricing plans in a responsive grid layout."
tags:
---
## PricingPlans

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PricingPlans.vue)

Display a list of pricing plans in a responsive grid layout.

## Usage

The PricingPlans component provides a flexible layout to display a list of [PricingPlan](https://ui.nuxt.com/docs/components/pricing-plan) components using either the default slot or the `plans` prop.

```
<template>

  <UPricingPlans>

    <UPricingPlan

      v-for="(plan, index) in plans"

      :key="index"

      v-bind="plan"

    />

  </UPricingPlans>

</template>
```

The grid columns will be automatically calculated based on the number of plans, this works with the `plans` prop but also with the default slot.

### Plans

Use the `plans` prop as an array of objects with the properties of the [PricingPlan](https://ui.nuxt.com/docs/components/pricing-plan#props) component.

```
<script setup lang="ts">

import type { PricingPlanProps } from '@nuxt/ui'

const plans = ref<PricingPlanProps[]>([

  {

    title: 'Solo',

    description: 'Tailored for indie hackers.',

    price: '$249',

    features: [

      'One developer',

      'Lifetime access'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Startup',

    description: 'Best suited for small teams.',

    price: '$499',

    features: [

      'Up to 5 developers',

      'Everything in Solo'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Organization',

    description: 'Ideal for larger teams and organizations.',

    price: '$999',

    features: [

      'Up to 20 developers',

      'Everything in Startup'

    ],

    button: {

      label: 'Buy now'

    }

  }

])

</script>

<template>

  <UPricingPlans :plans="plans" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the PricingPlans. Defaults to `horizontal`.

```
<script setup lang="ts">

import type { PricingPlanProps } from '@nuxt/ui'

const plans = ref<PricingPlanProps[]>([

  {

    title: 'Solo',

    description: 'Tailored for indie hackers.',

    price: '$249',

    features: [

      'One developer',

      'Lifetime access'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Startup',

    description: 'Best suited for small teams.',

    price: '$499',

    features: [

      'Up to 5 developers',

      'Everything in Solo'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Organization',

    description: 'Ideal for larger teams and organizations.',

    price: '$999',

    features: [

      'Up to 20 developers',

      'Everything in Startup'

    ],

    button: {

      label: 'Buy now'

    }

  }

])

</script>

<template>

  <UPricingPlans orientation="vertical" :plans="plans" />

</template>
```

When using the `plans` prop instead of the default slot, the `orientation` of the plans is automatically reversed, `horizontal` to `vertical` and vice versa.

### Compact

Use the `compact` prop to reduce the padding between the plans when one of the plans is scaled for a better visual balance.

```
<script setup lang="ts">

import type { PricingPlanProps } from '@nuxt/ui'

const plans = ref<PricingPlanProps[]>([

  {

    title: 'Solo',

    description: 'Tailored for indie hackers.',

    price: '$249',

    features: [

      'One developer',

      'Lifetime access'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Startup',

    description: 'Best suited for small teams.',

    price: '$499',

    scale: true,

    features: [

      'Up to 5 developers',

      'Everything in Solo'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Organization',

    description: 'Ideal for larger teams and organizations.',

    price: '$999',

    features: [

      'Up to 20 developers',

      'Everything in Startup'

    ],

    button: {

      label: 'Buy now'

    }

  }

])

</script>

<template>

  <UPricingPlans compact :plans="plans" />

</template>
```

### Scale

Use the `scale` prop to adjust the spacing between the plans when one of the plans is scaled for a better visual balance.

```
<script setup lang="ts">

import type { PricingPlanProps } from '@nuxt/ui'

const plans = ref<PricingPlanProps[]>([

  {

    title: 'Solo',

    description: 'Tailored for indie hackers.',

    price: '$249',

    features: [

      'One developer',

      'Lifetime access'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Startup',

    description: 'Best suited for small teams.',

    price: '$499',

    scale: true,

    features: [

      'Up to 5 developers',

      'Everything in Solo'

    ],

    button: {

      label: 'Buy now'

    }

  },

  {

    title: 'Organization',

    description: 'Ideal for larger teams and organizations.',

    price: '$999',

    features: [

      'Up to 20 developers',

      'Everything in Startup'

    ],

    button: {

      label: 'Buy now'

    }

  }

])

</script>

<template>

  <UPricingPlans scale :plans="plans" />

</template>
```

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a page

Use the PricingPlans component in a page to create a pricing page:

pages/pricing/index.vue

```
<script setup lang="ts">

const { data: plans } = await useAsyncData('plans', () => queryCollection('plans').all())

</script>

<template>

  <UPage>

    <UPageHero title="Pricing" />

    <UPageBody>

      <UContainer>

        <UPricingPlans :plans="plans" />

      </UContainer>

    </UPageBody>

  </UPage>

</template>
```

In this example, the `plans` are fetched using `queryCollection` from the `@nuxt/content` module.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `plans` |  | ` PricingPlanProps[]` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the pricing plans. |
| `compact` | `false` | `boolean`  When `true`, the plans will be displayed without gap. |
| `scale` | `false` | `boolean`  When `true`, the plans will be displayed with a larger gap. Useful when one plan is scaled. Doesn't work with `compact`. |

### Slots

| Slot | Type |
| --- | --- |
| `badge` | `{ ui: object; } & { plan: T; }` |
| `title` | `{ plan: T; }` |
| `description` | `{ plan: T; }` |
| `price` | `{ plan: T; }` |
| `discount` | `{ plan: T; }` |
| `billing` | `{ ui: object; } & { plan: T; }` |
| `features` | `{ plan: T; }` |
| `button` | `{ ui: object; } & { plan: T; }` |
| `header` | `{ plan: T; }` |
| `body` | `{ plan: T; }` |
| `footer` | `{ plan: T; }` |
| `tagline` | `{ plan: T; }` |
| `terms` | `{ plan: T; }` |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pricingPlans: {

      base: 'flex flex-col gap-y-8',

      variants: {

        orientation: {

          horizontal: 'lg:grid lg:grid-cols-[repeat(var(--count),minmax(0,1fr))]',

          vertical: ''

        },

        compact: {

          false: 'gap-x-8'

        },

        scale: {

          true: ''

        }

      },

      compoundVariants: [

        {

          compact: false,

          scale: true,

          class: 'lg:gap-x-13'

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

        pricingPlans: {

          base: 'flex flex-col gap-y-8',

          variants: {

            orientation: {

              horizontal: 'lg:grid lg:grid-cols-[repeat(var(--count),minmax(0,1fr))]',

              vertical: ''

            },

            compact: {

              false: 'gap-x-8'

            },

            scale: {

              true: ''

            }

          },

          compoundVariants: [

            {

              compact: false,

              scale: true,

              class: 'lg:gap-x-13'

            }

          ]

        }

      }

    })

  ]

})
```

## Changelog

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PricingPlan](https://ui.nuxt.com/docs/components/pricing-plan)

[

A customizable pricing plan to display in a pricing page.

](https://ui.nuxt.com/docs/components/pricing-plan)[

PricingTable

A responsive pricing table component that displays tiered pricing plans with feature comparisons.

](https://ui.nuxt.com/docs/components/pricing-table)