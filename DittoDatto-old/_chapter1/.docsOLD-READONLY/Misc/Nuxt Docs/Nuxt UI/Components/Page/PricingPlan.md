---
title: "Vue PricingPlan Component"
source: "https://ui.nuxt.com/docs/components/pricing-plan"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A customizable pricing plan to display in a pricing page."
tags:
---
## PricingPlan

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PricingPlan.vue)

A customizable pricing plan to display in a pricing page.

## Usage

The PricingPlan component provides a flexible way to display a pricing plan with customizable content including title, description, price, features, etc.

Use the `PricingPlans` component to display multiple pricing plans in a responsive grid layout.

Use the `title` prop to set the title of the PricingPlan.

```
<template>

  <UPricingPlan title="Solo" class="w-96" />

</template>
```

### Description

Use the `description` prop to set the description of the PricingPlan.

```
<template>

  <UPricingPlan title="Solo" description="For bootstrappers and indie hackers." />

</template>
```

### Badge

Use the `badge` prop to display a [Badge](https://ui.nuxt.com/docs/components/badge) next to the title of the PricingPlan.

You can pass any property from the [Badge](https://ui.nuxt.com/docs/components/badge#props) component to customize it.

### Price

Use the `price` prop to set the price of the PricingPlan.

```
<template>

  <UPricingPlan title="Solo" description="For bootstrappers and indie hackers." price="$249" />

</template>
```

### Discount

Use the `discount` prop to set a discounted price that will be displayed alongside the original price (which will be shown with a strikethrough).

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    discount="$199"

  />

</template>
```

### Billing

Use the `billing-cycle` and/or `billing-period` props to display the billing information of the PricingPlan.

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$9"

    billing-cycle="/month"

    billing-period="billed annually"

  />

</template>
```

### Features

Use the `features` prop as an array of string to display a list of features on the PricingPlan:

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="[

      'One developer',

      'Unlimited projects',

      'Access to GitHub repository',

      'Unlimited patch & minor updates',

      'Lifetime access'

    ]"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.success` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.success` key.

You can also pass an array of objects with the following properties:

- `title: string`
- `icon?: string`

```
<script setup lang="ts">

import type { PricingPlanFeature } from '@nuxt/ui'

const features = ref<PricingPlanFeature[]>([

  {

    title: 'One developer',

    icon: 'i-lucide-user'

  },

  {

    title: 'Unlimited projects',

    icon: 'i-lucide-infinity'

  },

  {

    title: 'Access to GitHub repository',

    icon: 'i-lucide-github'

  },

  {

    title: 'Unlimited patch & minor updates',

    icon: 'i-lucide-refresh-cw'

  },

  {

    title: 'Lifetime access',

    icon: 'i-lucide-clock'

  }

])

</script>

<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="features"

  />

</template>
```

### Button

Use the `button` prop with any property from the [Button](https://ui.nuxt.com/docs/components/button) component to display a button at the bottom of the PricingPlan.

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="[

      'One developer',

      'Unlimited projects',

      'Access to GitHub repository',

      'Unlimited patch & minor updates',

      'Lifetime access'

    ]"

    :button="{

      label: 'Buy now'

    }"

  />

</template>
```

Use the `onClick` field to add a click handler to trigger the plan purchase.

### Variant

Use the `variant` prop to change the variant of the PricingPlan.

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="[

      'One developer',

      'Unlimited projects',

      'Access to GitHub repository',

      'Unlimited patch & minor updates',

      'Lifetime access'

    ]"

    :button="{

      label: 'Buy now'

    }"

    variant="subtle"

  />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the PricingPlan. Defaults to `vertical`.

Solo

For bootstrappers and indie hackers.

- One developer
- Unlimited projects
- Access to GitHub repository
- Lifetime access

$249

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="[

      'One developer',

      'Unlimited projects',

      'Access to GitHub repository',

      'Lifetime access'

    ]"

    :button="{

      label: 'Buy now'

    }"

    orientation="horizontal"

    variant="outline"

  />

</template>
```

### Tagline

Use the `tagline` prop to display a tagline text above the price.

Solo

For bootstrappers and indie hackers.

- One developer
- Unlimited projects
- Access to GitHub repository
- Lifetime access

Pay once, own it forever

$249

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="[

      'One developer',

      'Unlimited projects',

      'Access to GitHub repository',

      'Lifetime access'

    ]"

    :button="{

      label: 'Buy now'

    }"

    orientation="horizontal"

    tagline="Pay once, own it forever"

  />

</template>
```

### Terms

Use the `terms` prop to display terms below the price.

### Highlight

Use the `highlight` prop to display a highlighted border around the PricingPlan.

```
<template>

  <UPricingPlan

    title="Solo"

    description="For bootstrappers and indie hackers."

    price="$249"

    :features="[

      'One developer',

      'Unlimited projects',

      'Access to GitHub repository',

      'Unlimited patch & minor updates',

      'Lifetime access'

    ]"

    :button="{

      label: 'Buy now'

    }"

    highlight

  />

</template>
```

### Scale

Use the `scale` prop to make a PricingPlan bigger than the others.

Check out the PricingPlans's `scale` example to see how it works as it's hard to demonstrate by itself.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `badge` |  | ` string \| BadgeProps`  Display a badge next to the title. Can be a string or an object.`{ color: 'primary', variant: 'subtle' }` |
| `billingCycle` |  | ` string`  The unit price period that appears next to the price. Typically used to show the recurring interval. |
| `billingPeriod` |  | ` string`  Additional billing context that appears above the billing cycle. Typically used to show the actual billing frequency. |
| `price` |  | ` string`  The current price of the plan. When used with `discount`, this becomes the original price. |
| `discount` |  | ` string`  The discounted price of the plan. When provided, the `price` prop will be displayed as strikethrough. |
| `features` |  | ` string[] \| PricingPlanFeature[]`  Display a list of features under the price. Can be an array of strings or an array of objects. |
| `button` |  | ` ButtonProps`  Display a buy button at the bottom.`{ size: 'lg', block: true }` Use the `onClick` field to add a click handler. |
| `tagline` |  | ` string`  Display a tagline highlighting the pricing value proposition. |
| `terms` |  | ` string` |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation of the pricing plan. |
| `variant` | `'outline'` | ` "soft" \| "solid" \| "outline" \| "subtle"` |
| `highlight` |  | `boolean`  Display a ring around the pricing plan to highlight it. |
| `scale` |  | `boolean`  Enlarge the plan to make it more prominent. |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; titleWrapper?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; priceWrapper?: ClassNameValue; price?: ClassNameValue; discount?: ClassNameValue; billing?: ClassNameValue; billingPeriod?: ClassNameValue; billingCycle?: ClassNameValue; features?: ClassNameValue; feature?: ClassNameValue; featureIcon?: ClassNameValue; featureTitle?: ClassNameValue; badge?: ClassNameValue; button?: ClassNameValue; tagline?: ClassNameValue; terms?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `badge` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `price` | `{}` |
| `discount` | `{}` |
| `billing` | `{ ui: object; }` |
| `features` | `{}` |
| `button` | `{ ui: object; }` |
| `header` | `{}` |
| `body` | `{}` |
| `footer` | `{}` |
| `tagline` | `{}` |
| `terms` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pricingPlan: {

      slots: {

        root: 'relative grid rounded-lg p-6 lg:p-8 xl:p-10 gap-6',

        header: '',

        body: 'flex flex-col min-w-0',

        footer: 'flex flex-col gap-6 items-center',

        titleWrapper: 'flex items-center gap-3',

        title: 'text-highlighted text-2xl sm:text-3xl text-pretty font-semibold',

        description: 'text-muted text-base text-pretty mt-2',

        priceWrapper: 'flex items-center gap-1',

        price: 'text-highlighted text-3xl sm:text-4xl font-semibold',

        discount: 'text-muted line-through text-xl sm:text-2xl',

        billing: 'flex flex-col justify-between min-w-0',

        billingPeriod: 'text-toned truncate text-xs font-medium',

        billingCycle: 'text-muted truncate text-xs font-medium',

        features: 'flex flex-col gap-3 flex-1 mt-6 grow-0',

        feature: 'flex items-center gap-2 min-w-0',

        featureIcon: 'size-5 shrink-0 text-primary',

        featureTitle: 'text-muted text-sm truncate',

        badge: '',

        button: '',

        tagline: 'text-base font-semibold text-default',

        terms: 'text-xs/5 text-muted text-center text-balance'

      },

      variants: {

        orientation: {

          horizontal: {

            root: 'grid-cols-1 lg:grid-cols-3 justify-between divide-y lg:divide-y-0 lg:divide-x divide-default',

            body: 'lg:col-span-2 pb-6 lg:pb-0 lg:pr-6 justify-center',

            footer: 'lg:justify-center lg:items-center lg:p-6 lg:max-w-xs lg:w-full lg:mx-auto',

            features: 'lg:grid lg:grid-cols-2 lg:mt-12'

          },

          vertical: {

            footer: 'justify-end',

            priceWrapper: 'mt-6'

          }

        },

        variant: {

          solid: {

            root: 'bg-inverted',

            title: 'text-inverted',

            description: 'text-dimmed',

            price: 'text-inverted',

            discount: 'text-dimmed',

            billingCycle: 'text-dimmed',

            billingPeriod: 'text-dimmed',

            featureTitle: 'text-dimmed'

          },

          outline: {

            root: 'bg-default ring ring-default'

          },

          soft: {

            root: 'bg-elevated/50'

          },

          subtle: {

            root: 'bg-elevated/50 ring ring-default'

          }

        },

        highlight: {

          true: {

            root: 'ring-2 ring-inset ring-primary'

          }

        },

        scale: {

          true: {

            root: 'lg:scale-[1.1] lg:z-[1]'

          }

        }

      },

      compoundVariants: [

        {

          orientation: 'horizontal',

          variant: 'soft',

          class: {

            root: 'divide-accented'

          }

        },

        {

          orientation: 'horizontal',

          variant: 'subtle',

          class: {

            root: 'divide-accented'

          }

        }

      ],

      defaultVariants: {

        variant: 'outline'

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

        pricingPlan: {

          slots: {

            root: 'relative grid rounded-lg p-6 lg:p-8 xl:p-10 gap-6',

            header: '',

            body: 'flex flex-col min-w-0',

            footer: 'flex flex-col gap-6 items-center',

            titleWrapper: 'flex items-center gap-3',

            title: 'text-highlighted text-2xl sm:text-3xl text-pretty font-semibold',

            description: 'text-muted text-base text-pretty mt-2',

            priceWrapper: 'flex items-center gap-1',

            price: 'text-highlighted text-3xl sm:text-4xl font-semibold',

            discount: 'text-muted line-through text-xl sm:text-2xl',

            billing: 'flex flex-col justify-between min-w-0',

            billingPeriod: 'text-toned truncate text-xs font-medium',

            billingCycle: 'text-muted truncate text-xs font-medium',

            features: 'flex flex-col gap-3 flex-1 mt-6 grow-0',

            feature: 'flex items-center gap-2 min-w-0',

            featureIcon: 'size-5 shrink-0 text-primary',

            featureTitle: 'text-muted text-sm truncate',

            badge: '',

            button: '',

            tagline: 'text-base font-semibold text-default',

            terms: 'text-xs/5 text-muted text-center text-balance'

          },

          variants: {

            orientation: {

              horizontal: {

                root: 'grid-cols-1 lg:grid-cols-3 justify-between divide-y lg:divide-y-0 lg:divide-x divide-default',

                body: 'lg:col-span-2 pb-6 lg:pb-0 lg:pr-6 justify-center',

                footer: 'lg:justify-center lg:items-center lg:p-6 lg:max-w-xs lg:w-full lg:mx-auto',

                features: 'lg:grid lg:grid-cols-2 lg:mt-12'

              },

              vertical: {

                footer: 'justify-end',

                priceWrapper: 'mt-6'

              }

            },

            variant: {

              solid: {

                root: 'bg-inverted',

                title: 'text-inverted',

                description: 'text-dimmed',

                price: 'text-inverted',

                discount: 'text-dimmed',

                billingCycle: 'text-dimmed',

                billingPeriod: 'text-dimmed',

                featureTitle: 'text-dimmed'

              },

              outline: {

                root: 'bg-default ring ring-default'

              },

              soft: {

                root: 'bg-elevated/50'

              },

              subtle: {

                root: 'bg-elevated/50 ring ring-default'

              }

            },

            highlight: {

              true: {

                root: 'ring-2 ring-inset ring-primary'

              }

            },

            scale: {

              true: {

                root: 'lg:scale-[1.1] lg:z-[1]'

              }

            }

          },

          compoundVariants: [

            {

              orientation: 'horizontal',

              variant: 'soft',

              class: {

                root: 'divide-accented'

              }

            },

            {

              orientation: 'horizontal',

              variant: 'subtle',

              class: {

                root: 'divide-accented'

              }

            }

          ],

          defaultVariants: {

            variant: 'outline'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageSection](https://ui.nuxt.com/docs/components/page-section)

[

A responsive section for your pages.

](https://ui.nuxt.com/docs/components/page-section)[

PricingPlans

Display a list of pricing plans in a responsive grid layout.

](https://ui.nuxt.com/docs/components/pricing-plans)