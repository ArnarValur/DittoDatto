---
title: "Vue PricingTable Component"
source: "https://ui.nuxt.com/docs/components/pricing-table"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive pricing table component that displays tiered pricing plans with feature comparisons."
tags:
---
## PricingTable

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PricingTable.vue)

A responsive pricing table component that displays tiered pricing plans with feature comparisons.

## Usage

The PricingTable component provides a responsive and customizable way to display pricing plans in a table format, automatically switching between a horizontal table layout on desktop for easy comparison and a vertical card layout on mobile for better readability.

### Tiers

Use the `tiers` prop as an array of objects to define your pricing plans. Each tier object supports the following properties:

- `id: string` - Unique identifier for the tier (required)
- `title?: string` - Name of the pricing plan
- `description?: string` - Short description of the plan
- `price?: string` - The current price of the plan (e.g., "$99", "€99", "Free")
- `discount?: string` - The discounted price that will display the `price` with strikethrough (e.g., "$79", "€79")
- `billingCycle?: string` - The unit price period that appears next to the price (e.g., "/month", "/seat/month")
- `billingPeriod?: string` - Additional billing context that appears above the billing cycle (e.g., "billed monthly")
- `badge?: string | BadgeProps` - Display a badge next to the title `{ color: 'primary', variant: 'subtle' }`
- `button?: ButtonProps` - Configure the CTA button `{ size: 'lg', block: true }`
- `highlight?: boolean` - Whether to visually emphasize this tier as the recommended option

### Sections

Use the `sections` prop to organize features into logical groups. Each section represents a category of features that you want to compare across different pricing tiers.

- `title: string` - The heading for the feature section
- `features: PricingTableSectionFeature[]` - An array of features with their availability in each tier:
	- Each feature requires a `title` and a `tiers` object mapping tier IDs to values
	- Boolean values (`true` / `false`) will display as checkmarks (✓) or minus icons (-)
	- String values will be shown as text (e.g., "Unlimited", "Up to 5 users")
	- Numeric values will be displayed as is (e.g., 10, 100)

- Solo
	For indie hackers.
	$249
	/month
	Features
	Number of developers
	1
	Projects
	Security
	SSO
- Team
	For growing teams.
	$499
	/month
	Features
	Number of developers
	5
	Projects
	Security
	SSO
- Enterprise
	For large organizations.
	Custom
	Features
	Number of developers
	Unlimited
	Projects
	Security
	SSO

```
<script setup lang="ts">

import type { PricingTableTier, PricingTableSection } from '@nuxt/ui'

const tiers = ref<PricingTableTier[]>([

  {

    id: 'solo',

    title: 'Solo',

    price: '$249',

    description: 'For indie hackers.',

    billingCycle: '/month',

    button: {

      label: 'Buy now',

      variant: 'subtle'

    }

  },

  {

    id: 'team',

    title: 'Team',

    price: '$499',

    description: 'For growing teams.',

    billingCycle: '/month',

    button: {

      label: 'Buy now'

    }

  },

  {

    id: 'enterprise',

    title: 'Enterprise',

    price: 'Custom',

    description: 'For large organizations.',

    button: {

      label: 'Contact sales',

      color: 'neutral'

    }

  }

])

const sections = ref<PricingTableSection[]>([

  {

    title: 'Features',

    features: [

      {

        title: 'Number of developers',

        tiers: {

          solo: '1',

          team: '5',

          enterprise: 'Unlimited'

        }

      },

      {

        title: 'Projects',

        tiers: {

          solo: true,

          team: true,

          enterprise: true

        }

      }

    ]

  },

  {

    title: 'Security',

    features: [

      {

        title: 'SSO',

        tiers: {

          solo: false,

          team: true,

          enterprise: true

        }

      }

    ]

  }

])

</script>

<template>

  <UPricingTable :tiers="tiers" :sections="sections" />

</template>
```

## Examples

### With slots

The PricingTable component provides powerful slot customization options to tailor the display of your content. You can customize individual elements using generic slots or target specific items using their IDs.

- Solo
	For indie hackers.
	$249
	/month
	Features
	Number of developers
	1
	Projects
	Security
	SSO
- Team
	For growing teams.
	$499
	/month
	Features
	Number of developers
	5
	Projects
	Security
	SSO
- Enterprise
	For large organizations.
	Custom
	Features
	Number of developers
	Unlimited
	Projects
	Security
	SSO

```
<script setup lang="ts">

const tiers = [

  {

    id: 'solo',

    title: 'Solo',

    price: '$249',

    description: 'For indie hackers.',

    billingCycle: '/month',

    button: { label: 'Buy now', variant: 'subtle' as const }

  },

  {

    id: 'team',

    title: 'Team',

    price: '$499',

    description: 'For growing teams.',

    billingCycle: '/month',

    button: { label: 'Buy now' },

    highlight: true

  },

  {

    id: 'enterprise',

    title: 'Enterprise',

    price: 'Custom',

    description: 'For large organizations.',

    button: { label: 'Contact sales', color: 'neutral' as const }

  }

]

const sections = [

  {

    id: 'features',

    title: 'Features',

    features: [

      {

        id: 'developers',

        title: 'Number of developers',

        tiers: { solo: '1', team: '5', enterprise: 'Unlimited' }

      },

      {

        id: 'projects',

        title: 'Projects',

        tiers: { solo: true, team: true, enterprise: true }

      }

    ]

  },

  {

    id: 'security',

    title: 'Security',

    features: [

      {

        title: 'SSO',

        tiers: { solo: false, team: true, enterprise: true }

      }

    ]

  }

]

</script>

<template>

  <UPricingTable :tiers="tiers" :sections="sections">

    <!-- Customize specific tier title -->

    <template #team-title="{ tier }">

      <div class="flex items-center gap-2">

        <UIcon name="i-lucide-crown" class="size-4 text-amber-500" />

        {{ tier.title }}

      </div>

    </template>

    <!-- Customize specific section title -->

    <template #section-security-title="{ section }">

      <div class="flex items-center gap-2">

        <UIcon name="i-lucide-shield-check" class="size-4 text-green-500" />

        <span class="font-semibold text-green-700">{{ section.title }}</span>

      </div>

    </template>

    <!-- Customize specific feature value -->

    <template #feature-developers-value="{ feature, tier }">

      <template v-if="feature.tiers?.[tier.id]">

        <UBadge :label="String(feature.tiers[tier.id])" color="primary" variant="soft" />

      </template>

      <UIcon v-else name="i-lucide-x" class="size-4 text-muted" />

    </template>

  </UPricingTable>

</template>
```

The component supports various slot types for maximum customization flexibility:

| Slot Type | Pattern | Description | Example |
| --- | --- | --- | --- |
| **Tier slots** | `#{tier-id}-{element}` | Target specific tiers | `#team-title`, `#solo-price` |
| **Section slots** | `#section-{id\|formatted-title}-title` | Target specific sections | `#section-features-title` |
| **Feature slots** | `#feature-{id\|formatted-title}-{title\|value}` | Target specific features | `#feature-developers-title` |
| **Generic slots** | `#tier-title`, `#section-title`, etc. | Apply to all items | `#feature-value` |

When no `id` is provided, the slot name is auto-generated from the title (e.g., "Premium Features!" becomes `#section-premium-features-title`).

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `tiers` |  | `T[]`  The pricing tiers to display in the table. Each tier represents a pricing plan with its own title, description, price, and features. |
| `sections` |  | `PricingTableSection<T>[]`  The sections of features to display in the table. Each section contains a title and a list of features with their availability in each tier. |
| `caption` |  | ` string`  The caption to display above the table. |
| `ui` |  | ` { root?: ClassNameValue; table?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; caption?: ClassNameValue; thead?: ClassNameValue; tbody?: ClassNameValue; tr?: ClassNameValue; th?: ClassNameValue; td?: ClassNameValue; tier?: ClassNameValue; tierTitleWrapper?: ClassNameValue; tierTitle?: ClassNameValue; tierDescription?: ClassNameValue; tierBadge?: ClassNameValue; tierPriceWrapper?: ClassNameValue; tierPrice?: ClassNameValue; tierDiscount?: ClassNameValue; tierBilling?: ClassNameValue; tierBillingPeriod?: ClassNameValue; tierBillingCycle?: ClassNameValue; tierButton?: ClassNameValue; tierFeatureIcon?: ClassNameValue; section?: ClassNameValue; sectionTitle?: ClassNameValue; feature?: ClassNameValue; featureTitle?: ClassNameValue; featureValue?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `caption` | `{}` |
| `tier` | `{ tier: T; }` |
| `tier-title` | `{ tier: T; }` |
| `tier-description` | `{ tier: T; }` |
| `tier-badge` | `{ tier: T; }` |
| `tier-button` | `{ tier: T; }` |
| `tier-billing` | `{ tier: T; }` |
| `tier-discount` | `{ tier: T; }` |
| `tier-price` | `{ tier: T; }` |
| `section-title` | `{ section: PricingTableSection<T>; }` |
| `feature-title` | `{ feature: PricingTableSectionFeature<T>; section: PricingTableSection<T>; }` |
| `feature-value` | `{ feature: PricingTableSectionFeature<T>; tier: T; section: PricingTableSection<T>; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pricingTable: {

      slots: {

        root: 'w-full relative',

        table: 'w-full table-fixed border-separate border-spacing-x-0 hidden md:table',

        list: 'md:hidden flex flex-col gap-6 w-full',

        item: 'p-6 flex flex-col border border-default rounded-lg',

        caption: 'sr-only',

        thead: '',

        tbody: '',

        tr: '',

        th: 'py-4 font-normal text-left border-b border-default',

        td: 'px-6 py-4 text-center border-b border-default',

        tier: 'p-6 text-left font-normal',

        tierTitleWrapper: 'flex items-center gap-3',

        tierTitle: 'text-lg font-semibold text-highlighted',

        tierDescription: 'text-sm font-normal text-muted mt-1',

        tierBadge: 'truncate',

        tierPriceWrapper: 'flex items-center gap-1 mt-4',

        tierPrice: 'text-highlighted text-3xl sm:text-4xl font-semibold',

        tierDiscount: 'text-muted line-through text-xl sm:text-2xl',

        tierBilling: 'flex flex-col justify-between min-w-0',

        tierBillingPeriod: 'text-toned truncate text-xs font-medium',

        tierBillingCycle: 'text-muted truncate text-xs font-medium',

        tierButton: 'mt-6',

        tierFeatureIcon: 'size-5 shrink-0',

        section: 'mt-6 flex flex-col gap-2',

        sectionTitle: 'font-semibold text-sm text-highlighted',

        feature: 'flex items-center justify-between gap-1',

        featureTitle: 'text-sm text-default',

        featureValue: 'text-sm text-muted flex justify-center min-w-5'

      },

      variants: {

        section: {

          true: {

            tr: '*:pt-8'

          }

        },

        active: {

          true: {

            tierFeatureIcon: 'text-primary'

          }

        },

        highlight: {

          true: {

            tier: 'bg-elevated/50 border-x border-t border-default rounded-t-lg',

            td: 'bg-elevated/50 border-x border-default',

            item: 'bg-elevated/50'

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

        pricingTable: {

          slots: {

            root: 'w-full relative',

            table: 'w-full table-fixed border-separate border-spacing-x-0 hidden md:table',

            list: 'md:hidden flex flex-col gap-6 w-full',

            item: 'p-6 flex flex-col border border-default rounded-lg',

            caption: 'sr-only',

            thead: '',

            tbody: '',

            tr: '',

            th: 'py-4 font-normal text-left border-b border-default',

            td: 'px-6 py-4 text-center border-b border-default',

            tier: 'p-6 text-left font-normal',

            tierTitleWrapper: 'flex items-center gap-3',

            tierTitle: 'text-lg font-semibold text-highlighted',

            tierDescription: 'text-sm font-normal text-muted mt-1',

            tierBadge: 'truncate',

            tierPriceWrapper: 'flex items-center gap-1 mt-4',

            tierPrice: 'text-highlighted text-3xl sm:text-4xl font-semibold',

            tierDiscount: 'text-muted line-through text-xl sm:text-2xl',

            tierBilling: 'flex flex-col justify-between min-w-0',

            tierBillingPeriod: 'text-toned truncate text-xs font-medium',

            tierBillingCycle: 'text-muted truncate text-xs font-medium',

            tierButton: 'mt-6',

            tierFeatureIcon: 'size-5 shrink-0',

            section: 'mt-6 flex flex-col gap-2',

            sectionTitle: 'font-semibold text-sm text-highlighted',

            feature: 'flex items-center justify-between gap-1',

            featureTitle: 'text-sm text-default',

            featureValue: 'text-sm text-muted flex justify-center min-w-5'

          },

          variants: {

            section: {

              true: {

                tr: '*:pt-8'

              }

            },

            active: {

              true: {

                tierFeatureIcon: 'text-primary'

              }

            },

            highlight: {

              true: {

                tier: 'bg-elevated/50 border-x border-t border-default rounded-t-lg',

                td: 'bg-elevated/50 border-x border-default',

                item: 'bg-elevated/50'

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