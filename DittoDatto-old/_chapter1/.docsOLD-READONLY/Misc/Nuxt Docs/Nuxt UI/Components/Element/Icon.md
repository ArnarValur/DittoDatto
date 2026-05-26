---
title: "Vue Icon Component"
source: "https://ui.nuxt.com/docs/components/icon"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A component to display any icon from Iconify or another component."
tags:
---
## Icon

[Icônes](https://icones.js.org/)

A component to display any icon from Iconify or another component.

## Usage

Use the `name` prop to display an icon:

```
<template>

  <UIcon name="i-lucide-lightbulb" class="size-5" />

</template>
```

## Examples

### SVG

You can also pass a Vue component into the `name` prop:

```
<script setup lang="ts">

import { h } from 'vue'

const IconLightbulb = () => h(

  'svg',

  { xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 24 24' },

  [

    h(

      'path',

      {

        'fill': 'none',

        'stroke': 'currentColor',

        'stroke-linecap': 'round',

        'stroke-linejoin': 'round',

        'stroke-width': 2,

        'd': 'M15 14c.2-1 .7-1.7 1.5-2.5c1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5c.7.7 1.3 1.5 1.5 2.5m0 4h6m-5 4h4'

      }

    )

  ]

)

</script>

<template>

  <UIcon :name="IconLightbulb" class="size-5" />

</template>
```

You can define your icon components yourself, or use [`unplugin-icons`](https://github.com/unplugin/unplugin-icons) to import them directly from SVG files:

```
<script setup lang="ts">

import IconLightbulb from '~icons/lucide/lightbulb'

</script>

<template>

  <UIcon :name="IconLightbulb" class="size-5" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `name` |  | `any` |
| `mode` |  | ` "svg" \| "css"` |
| `size` |  | ` string \| number` |
| `customize` |  | ` (content: string, name?: string \| undefined, prefix?: string \| undefined, provider?: string \| undefined): string` |

## Changelog

[`b654a`](https://github.com/nuxt/ui/commit/b654a77243c6401fa30183f5417e4059816409cf) — fix: improve `name` type ([#5498](https://github.com/nuxt/ui/issues/5498))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))[FieldGroup](https://ui.nuxt.com/docs/components/field-group)

[

Group multiple button-like elements together.

](https://ui.nuxt.com/docs/components/field-group)[

Kbd

A kbd element to display a keyboard key.

](https://ui.nuxt.com/docs/components/kbd)