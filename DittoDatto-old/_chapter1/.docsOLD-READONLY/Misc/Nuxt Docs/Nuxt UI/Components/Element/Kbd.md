---
title: "Vue Kbd Component"
source: "https://ui.nuxt.com/docs/components/kbd"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A kbd element to display a keyboard key."
tags:
---
## Kbd

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Kbd.vue)

A kbd element to display a keyboard key.

## Usage

Use the default slot to set the value of the Kbd.

K

```
<template>

  <UKbd>K</UKbd>

</template>
```

### Value

Use the `value` prop to set the value of the Kbd.

K

```
<template>

  <UKbd value="K" />

</template>
```

You can pass special keys to the `value` prop that goes through the [`useKbd`](https://github.com/nuxt/ui/blob/v4/src/runtime/composables/useKbd.ts) composable. For example, the `meta` key displays as `⌘` on macOS and `Ctrl` on other platforms.

Ctrl

```
<template>

  <UKbd value="meta" />

</template>
```

### Color

Use the `color` prop to change the color of the Kbd.

K

```
<template>

  <UKbd color="neutral">K</UKbd>

</template>
```

### Variant

Use the `variant` prop to change the variant of the Kbd.

K

```
<template>

  <UKbd color="neutral" variant="solid">K</UKbd>

</template>
```

### Size

Use the `size` prop to change the size of the Kbd.

K

```
<template>

  <UKbd size="lg">K</UKbd>

</template>
```

## Examples

### class prop

Use the `class` prop to override the base styles of the Badge.

K

```
<template>

  <UKbd class="font-bold rounded-full" variant="subtle">K</UKbd>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'kbd'` | `any`  The element or component this component should render as. |
| `value` |  | ` string` |
| `color` | `'neutral'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "solid"` |
| `size` | `'md'` | ` "sm" \| "md" \| "lg"` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    kbd: {

      base: 'inline-flex items-center justify-center px-1 rounded-sm font-medium font-sans uppercase',

      variants: {

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

          sm: 'h-4 min-w-[16px] text-[10px]',

          md: 'h-5 min-w-[20px] text-[11px]',

          lg: 'h-6 min-w-[24px] text-[12px]'

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: 'solid',

          class: 'text-inverted bg-primary'

        },

        {

          color: 'primary',

          variant: 'outline',

          class: 'ring ring-inset ring-primary/50 text-primary'

        },

        {

          color: 'primary',

          variant: 'soft',

          class: 'text-primary bg-primary/10'

        },

        {

          color: 'primary',

          variant: 'subtle',

          class: 'text-primary ring ring-inset ring-primary/25 bg-primary/10'

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

        }

      ],

      defaultVariants: {

        variant: 'outline',

        color: 'neutral',

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

        kbd: {

          base: 'inline-flex items-center justify-center px-1 rounded-sm font-medium font-sans uppercase',

          variants: {

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

              sm: 'h-4 min-w-[16px] text-[10px]',

              md: 'h-5 min-w-[20px] text-[11px]',

              lg: 'h-6 min-w-[24px] text-[12px]'

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: 'solid',

              class: 'text-inverted bg-primary'

            },

            {

              color: 'primary',

              variant: 'outline',

              class: 'ring ring-inset ring-primary/50 text-primary'

            },

            {

              color: 'primary',

              variant: 'soft',

              class: 'text-primary bg-primary/10'

            },

            {

              color: 'primary',

              variant: 'subtle',

              class: 'text-primary ring ring-inset ring-primary/25 bg-primary/10'

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

            }

          ],

          defaultVariants: {

            variant: 'outline',

            color: 'neutral',

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

[`4095c`](https://github.com/nuxt/ui/commit/4095c9a55514b540c3e499d64fe8b794b26eef2b) — fix: return original value and use `uppercase` class ([#5238](https://github.com/nuxt/ui/issues/5238))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`f3366`](https://github.com/nuxt/ui/commit/f33660035f71a0e62a3446fbdb8c601efecdadfe) — feat: add `color` prop & `soft` variant ([#4549](https://github.com/nuxt/ui/issues/4549))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Icon](https://ui.nuxt.com/docs/components/icon)

[

A component to display any icon from Iconify or another component.

](https://ui.nuxt.com/docs/components/icon)[

Progress

An indicator showing the progress of a task.

](https://ui.nuxt.com/docs/components/progress)