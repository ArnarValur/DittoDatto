---
title: "Vue AvatarGroup Component"
source: "https://ui.nuxt.com/docs/components/avatar-group"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Stack multiple avatars in a group."
tags:
---
## AvatarGroup

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/AvatarGroup.vue)

Stack multiple avatars in a group.

## Usage

Wrap multiple [Avatar](https://ui.nuxt.com/docs/components/avatar) within an AvatarGroup to stack them.

```
<template>

  <UAvatarGroup>

    <UAvatar src="https://github.com/benjamincanac.png" alt="Benjamin Canac" />

    <UAvatar src="https://github.com/romhml.png" alt="Romain Hamel" />

    <UAvatar src="https://github.com/noook.png" alt="Neil Richter" />

  </UAvatarGroup>

</template>
```

### Size

Use the `size` prop to change the size of all the avatars.

```
<template>

  <UAvatarGroup size="xl">

    <UAvatar src="https://github.com/benjamincanac.png" alt="Benjamin Canac" />

    <UAvatar src="https://github.com/romhml.png" alt="Romain Hamel" />

    <UAvatar src="https://github.com/noook.png" alt="Neil Richter" />

  </UAvatarGroup>

</template>
```

### Max

Use the `max` prop to limit the number of avatars displayed. The rest is displayed as an `+X` avatar.

+1

```
<template>

  <UAvatarGroup :max="2">

    <UAvatar src="https://github.com/benjamincanac.png" alt="Benjamin Canac" />

    <UAvatar src="https://github.com/romhml.png" alt="Romain Hamel" />

    <UAvatar src="https://github.com/noook.png" alt="Neil Richter" />

  </UAvatarGroup>

</template>
```

## Examples

Wrap each avatar with a [Tooltip](https://ui.nuxt.com/docs/components/tooltip) to display a tooltip on hover.

```
<template>

  <UAvatarGroup>

    <UTooltip text="benjamincanac">

      <UAvatar

        src="https://github.com/benjamincanac.png"

        alt="Benjamin Canac"

      />

    </UTooltip>

    <UTooltip text="romhml">

      <UAvatar

        src="https://github.com/romhml.png"

        alt="Romain Hamel"

      />

    </UTooltip>

    <UTooltip text="noook">

      <UAvatar

        src="https://github.com/noook.png"

        alt="Neil Richter"

      />

    </UTooltip>

  </UAvatarGroup>

</template>
```

### With chip

Wrap each avatar with a [Chip](https://ui.nuxt.com/docs/components/chip) to display a chip around the avatar.

```
<template>

  <UAvatarGroup>

    <UAvatar

      src="https://github.com/benjamincanac.png"

      alt="Benjamin Canac"

      :chip="{ inset: true, color: 'success' }"

    />

    <UAvatar

      src="https://github.com/romhml.png"

      alt="Romain Hamel"

      :chip="{ inset: true, color: 'warning' }"

    />

    <UAvatar

      src="https://github.com/noook.png"

      alt="Neil Richter"

      :chip="{ inset: true, color: 'error' }"

    />

  </UAvatarGroup>

</template>
```

### With link

Wrap each avatar with a [Link](https://ui.nuxt.com/docs/components/link) to make them clickable.

```
<template>

  <UAvatarGroup>

    <ULink

      to="https://github.com/benjamincanac"

      target="_blank"

      class="hover:ring-primary transition"

      raw

    >

      <UAvatar

        src="https://github.com/benjamincanac.png"

        alt="Benjamin Canac"

      />

    </ULink>

    <ULink

      to="https://github.com/romhml"

      target="_blank"

      class="hover:ring-primary transition"

      raw

    >

      <UAvatar

        src="https://github.com/romhml.png"

        alt="Romain Hamel"

      />

    </ULink>

    <ULink

      to="https://github.com/noook"

      target="_blank"

      class="hover:ring-primary transition"

      raw

    >

      <UAvatar

        src="https://github.com/noook.png"

        alt="Neil Richter"

      />

    </ULink>

  </UAvatarGroup>

</template>
```

### With mask

Wrap an avatar with a CSS mask to display it with a custom shape.

```
<template>

  <UAvatarGroup :ui="{ base: 'rounded-none squircle' }">

    <UAvatar

      src="https://github.com/benjamincanac.png"

      alt="Benjamin Canac"

      class="rounded-none squircle"

    />

    <UAvatar

      src="https://github.com/romhml.png"

      alt="Romain Hamel"

      class="rounded-none squircle"

    />

    <UAvatar

      src="https://github.com/noook.png"

      alt="Neil Richter"

      class="rounded-none squircle"

    />

  </UAvatarGroup>

</template>

<style>

.squircle {

  mask-image: url("data:image/svg+xml,%3csvg width='200' height='200' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='M100 0C20 0 0 20 0 100s20 100 100 100 100-20 100-100S180 0 100 0Z'/%3e%3c/svg%3e");

  mask-size: contain;

  mask-position: center;

  mask-repeat: no-repeat;

}

</style>
```

The `chip` prop does not work correctly when using a mask. Chips may be cut depending on the mask shape.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl" \| "3xs" \| "2xs" \| "2xl" \| "3xl"` |
| `max` |  | ` string \| number`  The maximum number of avatars to display. |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    avatarGroup: {

      slots: {

        root: 'inline-flex flex-row-reverse justify-end',

        base: 'relative rounded-full ring-bg first:me-0'

      },

      variants: {

        size: {

          '3xs': {

            base: 'ring -me-0.5'

          },

          '2xs': {

            base: 'ring -me-0.5'

          },

          xs: {

            base: 'ring -me-0.5'

          },

          sm: {

            base: 'ring-2 -me-1.5'

          },

          md: {

            base: 'ring-2 -me-1.5'

          },

          lg: {

            base: 'ring-2 -me-1.5'

          },

          xl: {

            base: 'ring-3 -me-2'

          },

          '2xl': {

            base: 'ring-3 -me-2'

          },

          '3xl': {

            base: 'ring-3 -me-2'

          }

        }

      },

      defaultVariants: {

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

        avatarGroup: {

          slots: {

            root: 'inline-flex flex-row-reverse justify-end',

            base: 'relative rounded-full ring-bg first:me-0'

          },

          variants: {

            size: {

              '3xs': {

                base: 'ring -me-0.5'

              },

              '2xs': {

                base: 'ring -me-0.5'

              },

              xs: {

                base: 'ring -me-0.5'

              },

              sm: {

                base: 'ring-2 -me-1.5'

              },

              md: {

                base: 'ring-2 -me-1.5'

              },

              lg: {

                base: 'ring-2 -me-1.5'

              },

              xl: {

                base: 'ring-3 -me-2'

              },

              '2xl': {

                base: 'ring-3 -me-2'

              },

              '3xl': {

                base: 'ring-3 -me-2'

              }

            }

          },

          defaultVariants: {

            size: 'md'

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

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Avatar](https://ui.nuxt.com/docs/components/avatar)

[

An img element with fallback and Nuxt Image support.

](https://ui.nuxt.com/docs/components/avatar)[

Badge

A short text to represent a status or a category.

](https://ui.nuxt.com/docs/components/badge)