---
title: "Vue FieldGroup Component"
source: "https://ui.nuxt.com/docs/components/field-group"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Group multiple button-like elements together."
tags:
---
## FieldGroup

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/FieldGroup.vue)

Group multiple button-like elements together.

## Usage

Wrap multiple [Button](https://ui.nuxt.com/components/button) within a FieldGroup to group them together.

```
<template>

  <UFieldGroup>

    <UButton color="neutral" variant="subtle" label="Button" />

    <UButton color="neutral" variant="outline" icon="i-lucide-chevron-down" />

  </UFieldGroup>

</template>
```

### Size

Use the `size` prop to change the size of all the buttons.

```
<template>

  <UFieldGroup size="xl">

    <UButton color="neutral" variant="subtle" label="Button" />

    <UButton color="neutral" variant="outline" icon="i-lucide-chevron-down" />

  </UFieldGroup>

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the buttons. Defaults to `horizontal`.

```
<template>

  <UFieldGroup orientation="vertical">

    <UButton color="neutral" variant="subtle" label="Submit" />

    <UButton color="neutral" variant="outline" label="Cancel" />

  </UFieldGroup>

</template>
```

## Examples

### With input

You can use components like [Input](https://ui.nuxt.com/components/input), [InputMenu](https://ui.nuxt.com/components/input-menu), [Select](https://ui.nuxt.com/components/select) [SelectMenu](https://ui.nuxt.com/components/select-menu), etc. within a field group.

```
<template>

  <UFieldGroup>

    <UInput color="neutral" variant="outline" placeholder="Enter token" />

    <UButton color="neutral" variant="subtle" icon="i-lucide-clipboard" />

  </UFieldGroup>

</template>
```

You can use a [Tooltip](https://ui.nuxt.com/components/tooltip) within a field group.

```
<template>

  <UFieldGroup>

    <UInput color="neutral" variant="outline" placeholder="Enter token" />

    <UTooltip text="Copy to clipboard">

      <UButton

        color="neutral"

        variant="subtle"

        icon="i-lucide-clipboard"

      />

    </UTooltip>

  </UFieldGroup>

</template>
```

You can use a [DropdownMenu](https://ui.nuxt.com/components/dropdown-menu) within a field group.

### With badge

You can use a [Badge](https://ui.nuxt.com/components/badge) within a field group.

https://

```
<template>

  <UFieldGroup>

    <UBadge color="neutral" variant="outline" size="lg" label="https://" />

    <UInput color="neutral" variant="outline" placeholder="www.example.com" />

  </UFieldGroup>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation the buttons are laid out. |
| `ui` |  | ` {}` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    fieldGroup: {

      base: 'relative',

      variants: {

        size: {

          xs: '',

          sm: '',

          md: '',

          lg: '',

          xl: ''

        },

        orientation: {

          horizontal: 'inline-flex -space-x-px',

          vertical: 'flex flex-col -space-y-px'

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

        fieldGroup: {

          base: 'relative',

          variants: {

            size: {

              xs: '',

              sm: '',

              md: '',

              lg: '',

              xl: ''

            },

            orientation: {

              horizontal: 'inline-flex -space-x-px',

              vertical: 'flex flex-col -space-y-px'

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`a9fe7`](https://github.com/nuxt/ui/commit/a9fe7c61f43feb0639e8d0546496a51c993c05fe) — fix: add missing `data-orientation` for consistency

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))[Collapsible](https://ui.nuxt.com/docs/components/collapsible)

[

A collapsible element to toggle visibility of its content.

](https://ui.nuxt.com/docs/components/collapsible)[

Icon

A component to display any icon from Iconify or another component.

](https://ui.nuxt.com/docs/components/icon)