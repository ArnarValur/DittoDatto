---
title: "Vue Badge Component"
source: "https://ui.nuxt.com/docs/components/badge"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A short text to represent a status or a category."
tags:
---
## Badge

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Badge.vue)

A short text to represent a status or a category.

## Usage

Use the default slot to set the label of the Badge.

Badge

```
<template>

  <UBadge>Badge</UBadge>

</template>
```

### Label

Use the `label` prop to set the label of the Badge.

Badge

```
<template>

  <UBadge label="Badge" />

</template>
```

### Color

Use the `color` prop to change the color of the Badge.

Badge

```
<template>

  <UBadge color="neutral">Badge</UBadge>

</template>
```

### Variant

Use the `variant` props to change the variant of the Badge.

Badge

```
<template>

  <UBadge color="neutral" variant="outline">Badge</UBadge>

</template>
```

### Size

Use the `size` prop to change the size of the Badge.

Badge

```
<template>

  <UBadge size="xl">Badge</UBadge>

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the Badge.

Badge

```
<template>

  <UBadge icon="i-lucide-rocket" size="md" color="primary" variant="solid">Badge</UBadge>

</template>
```

Use the `leading` and `trailing` props to set the icon position or the `leading-icon` and `trailing-icon` props to set a different icon for each position.

Badge

```
<template>

  <UBadge trailing-icon="i-lucide-arrow-right" size="md">Badge</UBadge>

</template>
```

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the Badge.

Badge

```
<template>

  <UBadge

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

    size="md"

    color="neutral"

    variant="outline"

  >

    Badge

  </UBadge>

</template>
```

## Examples

### class prop

Use the `class` prop to override the base styles of the Badge.

Badge

```
<template>

  <UBadge class="font-bold rounded-full">Badge</UBadge>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'span'` | `any`  The element or component this component should render as. |
| `label` |  | ` string \| number` |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'solid'` | ` "solid" \| "outline" \| "soft" \| "subtle"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `square` |  | `boolean`  Render the badge with equal padding on all sides. |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `ui` |  | ` { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    badge: {

      slots: {

        base: 'font-medium inline-flex items-center',

        label: 'truncate',

        leadingIcon: 'shrink-0',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailingIcon: 'shrink-0'

      },

      variants: {

        fieldGroup: {

          horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

          vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

        },

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        variant: {

          solid: '',

          outline: '',

          soft: '',

          subtle: ''

        },

        size: {

          xs: {

            base: 'text-[8px]/3 px-1 py-0.5 gap-1 rounded-sm',

            leadingIcon: 'size-3',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-3'

          },

          sm: {

            base: 'text-[10px]/3 px-1.5 py-1 gap-1 rounded-sm',

            leadingIcon: 'size-3',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-3'

          },

          md: {

            base: 'text-xs px-2 py-1 gap-1 rounded-md',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          lg: {

            base: 'text-sm px-2 py-1 gap-1.5 rounded-md',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          xl: {

            base: 'text-base px-2.5 py-1 gap-1.5 rounded-md',

            leadingIcon: 'size-6',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-6'

          }

        },

        square: {

          true: ''

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: 'solid',

          class: 'bg-primary text-inverted'

        },

        {

          color: 'primary',

          variant: 'outline',

          class: 'text-primary ring ring-inset ring-primary/50'

        },

        {

          color: 'primary',

          variant: 'soft',

          class: 'bg-primary/10 text-primary'

        },

        {

          color: 'primary',

          variant: 'subtle',

          class: 'bg-primary/10 text-primary ring ring-inset ring-primary/25'

        },

        {

          color: 'neutral',

          variant: 'solid',

          class: 'text-inverted bg-inverted'

        },

        {

          color: 'neutral',

          variant: 'outline',

          class: 'ring ring-inset ring-accented text-default bg-default'

        },

        {

          color: 'neutral',

          variant: 'soft',

          class: 'text-default bg-elevated'

        },

        {

          color: 'neutral',

          variant: 'subtle',

          class: 'ring ring-inset ring-accented text-default bg-elevated'

        },

        {

          size: 'xs',

          square: true,

          class: 'p-0.5'

        },

        {

          size: 'sm',

          square: true,

          class: 'p-1'

        },

        {

          size: 'md',

          square: true,

          class: 'p-1'

        },

        {

          size: 'lg',

          square: true,

          class: 'p-1'

        },

        {

          size: 'xl',

          square: true,

          class: 'p-1'

        }

      ],

      defaultVariants: {

        color: 'primary',

        variant: 'solid',

        size: 'md'

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

        badge: {

          slots: {

            base: 'font-medium inline-flex items-center',

            label: 'truncate',

            leadingIcon: 'shrink-0',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailingIcon: 'shrink-0'

          },

          variants: {

            fieldGroup: {

              horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

              vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

            },

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            variant: {

              solid: '',

              outline: '',

              soft: '',

              subtle: ''

            },

            size: {

              xs: {

                base: 'text-[8px]/3 px-1 py-0.5 gap-1 rounded-sm',

                leadingIcon: 'size-3',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-3'

              },

              sm: {

                base: 'text-[10px]/3 px-1.5 py-1 gap-1 rounded-sm',

                leadingIcon: 'size-3',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-3'

              },

              md: {

                base: 'text-xs px-2 py-1 gap-1 rounded-md',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              lg: {

                base: 'text-sm px-2 py-1 gap-1.5 rounded-md',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              xl: {

                base: 'text-base px-2.5 py-1 gap-1.5 rounded-md',

                leadingIcon: 'size-6',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-6'

              }

            },

            square: {

              true: ''

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: 'solid',

              class: 'bg-primary text-inverted'

            },

            {

              color: 'primary',

              variant: 'outline',

              class: 'text-primary ring ring-inset ring-primary/50'

            },

            {

              color: 'primary',

              variant: 'soft',

              class: 'bg-primary/10 text-primary'

            },

            {

              color: 'primary',

              variant: 'subtle',

              class: 'bg-primary/10 text-primary ring ring-inset ring-primary/25'

            },

            {

              color: 'neutral',

              variant: 'solid',

              class: 'text-inverted bg-inverted'

            },

            {

              color: 'neutral',

              variant: 'outline',

              class: 'ring ring-inset ring-accented text-default bg-default'

            },

            {

              color: 'neutral',

              variant: 'soft',

              class: 'text-default bg-elevated'

            },

            {

              color: 'neutral',

              variant: 'subtle',

              class: 'ring ring-inset ring-accented text-default bg-elevated'

            },

            {

              size: 'xs',

              square: true,

              class: 'p-0.5'

            },

            {

              size: 'sm',

              square: true,

              class: 'p-1'

            },

            {

              size: 'md',

              square: true,

              class: 'p-1'

            },

            {

              size: 'lg',

              square: true,

              class: 'p-1'

            },

            {

              size: 'xl',

              square: true,

              class: 'p-1'

            }

          ],

          defaultVariants: {

            color: 'primary',

            variant: 'solid',

            size: 'md'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`894e8`](https://github.com/nuxt/ui/commit/894e8a61b6fea3618fc863bd77678385e9d021c2) — feat: add `square` prop ([#4008](https://github.com/nuxt/ui/issues/4008))

[`f244d`](https://github.com/nuxt/ui/commit/f244d15b96d97cd8ba34ba9c18f23965e17e3cef) — fix: handle zero value in label correctly ([#4108](https://github.com/nuxt/ui/issues/4108))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))