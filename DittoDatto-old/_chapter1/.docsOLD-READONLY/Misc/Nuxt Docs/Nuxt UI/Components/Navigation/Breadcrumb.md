---
title: "Vue Breadcrumb Component"
source: "https://ui.nuxt.com/docs/components/breadcrumb"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A hierarchy of links to navigate through a website."
tags:
---
## Usage

Use the Breadcrumb component to show the current page's location in your site's hierarchy.

```
<script setup lang="ts">

import type { BreadcrumbItem } from '@nuxt/ui'

const items = ref<BreadcrumbItem[]>([

  {

    label: 'Docs',

    icon: 'i-lucide-book-open',

    to: '/docs'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components'

  },

  {

    label: 'Breadcrumb',

    icon: 'i-lucide-link',

    to: '/docs/components/breadcrumb'

  }

])

</script>

<template>

  <UBreadcrumb :items="items" />

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `label?: string`
- `icon?: string`
- `avatar?: AvatarProps`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `class?: any`
- `ui?: { item?: ClassNameValue, link?: ClassNameValue, linkLeadingIcon?: ClassNameValue, linkLeadingAvatar?: ClassNameValue, linkLabel?: ClassNameValue, separator?: ClassNameValue, separatorIcon?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { BreadcrumbItem } from '@nuxt/ui'

const items = ref<BreadcrumbItem[]>([

  {

    label: 'Docs',

    icon: 'i-lucide-book-open',

    to: '/docs'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components'

  },

  {

    label: 'Breadcrumb',

    icon: 'i-lucide-link',

    to: '/docs/components/breadcrumb'

  }

])

</script>

<template>

  <UBreadcrumb :items="items" />

</template>
```

A `span` is rendered instead of a link when the `to` property is not defined.

### Separator Icon

Use the `separator-icon` prop to customize the [Icon](https://ui.nuxt.com/docs/components/icon) between each item. Defaults to `i-lucide-chevron-right`.

```
<script setup lang="ts">

import type { BreadcrumbItem } from '@nuxt/ui'

const items = ref<BreadcrumbItem[]>([

  {

    label: 'Docs',

    icon: 'i-lucide-book-open',

    to: '/docs'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components'

  },

  {

    label: 'Breadcrumb',

    icon: 'i-lucide-link',

    to: '/docs/components/breadcrumb'

  }

])

</script>

<template>

  <UBreadcrumb separator-icon="i-lucide-arrow-right" :items="items" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.chevronRight` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.chevronRight` key.

## Examples

### With separator slot

Use the `#separator` slot to customize the separator between each item.

```
<script setup lang="ts">

import type { BreadcrumbItem } from '@nuxt/ui'

const items: BreadcrumbItem[] = [

  {

    label: 'Docs',

    to: '/docs'

  },

  {

    label: 'Components',

    to: '/docs/components'

  },

  {

    label: 'Breadcrumb',

    to: '/docs/components/breadcrumb'

  }

]

</script>

<template>

  <UBreadcrumb :items="items">

    <template #separator>

      <span class="mx-2 text-muted">/</span>

    </template>

  </UBreadcrumb>

</template>
```

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}`
- `#{{ item.slot }}-leading`
- `#{{ item.slot }}-label`
- `#{{ item.slot }}-trailing`

You can also use the `#item`, `#item-leading`, `#item-label` and `#item-trailing` slots to customize all items.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'nav'` | `any`  The element or component this component should render as. |
| `items` |  | ` T[]` |
| `separatorIcon` | `appConfig.ui.icons.chevronRight` | `any`  The icon to use as a separator. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `ui` |  | ` { root?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLeadingAvatar?: ClassNameValue; linkLeadingAvatarSize?: ClassNameValue; linkLabel?: ClassNameValue; separator?: ClassNameValue; separatorIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `item` | `{ item: T; index: number; active?: boolean \| undefined; ui: object; }` |
| `item-leading` | `{ item: T; index: number; active?: boolean \| undefined; ui: object; }` |
| `item-label` | `{ item: T; index: number; active?: boolean \| undefined; }` |
| `item-trailing` | `{ item: T; index: number; active?: boolean \| undefined; }` |
| `separator` | `{ ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    breadcrumb: {

      slots: {

        root: 'relative min-w-0',

        list: 'flex items-center gap-1.5',

        item: 'flex min-w-0',

        link: 'group relative flex items-center gap-1.5 text-sm min-w-0 focus-visible:outline-primary',

        linkLeadingIcon: 'shrink-0 size-5',

        linkLeadingAvatar: 'shrink-0',

        linkLeadingAvatarSize: '2xs',

        linkLabel: 'truncate',

        separator: 'flex',

        separatorIcon: 'shrink-0 size-5 text-muted'

      },

      variants: {

        active: {

          true: {

            link: 'text-primary font-semibold'

          },

          false: {

            link: 'text-muted font-medium'

          }

        },

        disabled: {

          true: {

            link: 'cursor-not-allowed opacity-75'

          }

        },

        to: {

          true: ''

        }

      },

      compoundVariants: [

        {

          disabled: false,

          active: false,

          to: true,

          class: {

            link: [

              'hover:text-default',

              'transition-colors'

            ]

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

        breadcrumb: {

          slots: {

            root: 'relative min-w-0',

            list: 'flex items-center gap-1.5',

            item: 'flex min-w-0',

            link: 'group relative flex items-center gap-1.5 text-sm min-w-0 focus-visible:outline-primary',

            linkLeadingIcon: 'shrink-0 size-5',

            linkLeadingAvatar: 'shrink-0',

            linkLeadingAvatarSize: '2xs',

            linkLabel: 'truncate',

            separator: 'flex',

            separatorIcon: 'shrink-0 size-5 text-muted'

          },

          variants: {

            active: {

              true: {

                link: 'text-primary font-semibold'

              },

              false: {

                link: 'text-muted font-medium'

              }

            },

            disabled: {

              true: {

                link: 'cursor-not-allowed opacity-75'

              }

            },

            to: {

              true: ''

            }

          },

          compoundVariants: [

            {

              disabled: false,

              active: false,

              to: true,

              class: {

                link: [

                  'hover:text-default',

                  'transition-colors'

                ]

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`cc8cb`](https://github.com/nuxt/ui/commit/cc8cbf386bd23d77f22b6413a01a1dd279852d49) — fix: handle `active` in items

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`0905b`](https://github.com/nuxt/ui/commit/0905b2b3d5e99ac78740a15d7a1afa1263ac7491) — chore: move back `item.class` on link

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight[User](https://ui.nuxt.com/docs/components/user)

[

Display user information with name, description and avatar.

](https://ui.nuxt.com/docs/components/user)[

CommandPalette

A command palette with full-text search powered by Fuse.js for efficient fuzzy matching.

](https://ui.nuxt.com/docs/components/command-palette)