---
title: "Vue ColorModeImage Component"
source: "https://ui.nuxt.com/docs/components/color-mode-image"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An image element with a different source for light and dark mode."
tags:
---
## ColorModeImage

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/color-mode/ColorModeImage.vue)

An image element with a different source for light and dark mode.

## Usage

The ColorModeImage component uses the `<NuxtImg>` component when [`@nuxt/image`](https://github.com/nuxt/image) is installed, falling back to `img` otherwise.

![](https://picsum.photos/id/29/400)

```
<template>

  <UColorModeImage

    light="https://picsum.photos/id/29/400"

    dark="https://picsum.photos/id/46/400"

    :width="200"

    :height="200"

  />

</template>
```

Switch between light and dark mode to see the different images:

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `dark` |  | `string` |
| `light` |  | `string` |
| `alt` |  | ` string` |
| `crossorigin` |  | ` "" \| "anonymous" \| "use-credentials"` |
| `decoding` |  | ` "async" \| "auto" \| "sync"` |
| `height` |  | ` string \| number` |
| `loading` |  | ` "lazy" \| "eager"` |
| `referrerpolicy` |  | ` "" \| "no-referrer" \| "no-referrer-when-downgrade" \| "origin" \| "origin-when-cross-origin" \| "same-origin" \| "strict-origin" \| "strict-origin-when-cross-origin" \| "unsafe-url"` |
| `sizes` |  | ` string` |
| `srcset` |  | ` string` |
| `usemap` |  | ` string` |
| `width` |  | ` string \| number` |

This component also supports all native `<img>` HTML attributes.

## Changelog

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ColorModeButton](https://ui.nuxt.com/docs/components/color-mode-button)

[

A Button to switch between light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-button)[

ColorModeSelect

A Select to switch between system, dark & light mode.

](https://ui.nuxt.com/docs/components/color-mode-select)