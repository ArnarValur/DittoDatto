---
title: "Vue ColorModeAvatar Component"
source: "https://ui.nuxt.com/docs/components/color-mode-avatar"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An Avatar with a different source for light and dark mode."
tags:
---
## ColorModeAvatar

[Avatar](https://ui.nuxt.com/docs/components/avatar) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/color-mode/ColorModeAvatar.vue)

An Avatar with a different source for light and dark mode.

## Usage

The ColorModeAvatar component extends the [Avatar](https://ui.nuxt.com/docs/components/avatar) component, so you can pass any property such as `size`, `icon`, etc.

Use the `light` and `dark` props to define the source for light and dark mode.

```
<template>

  <UColorModeAvatar light="https://github.com/vuejs.png" dark="https://github.com/nuxt.png" />

</template>
```

Switch between light and dark mode to see the different images:

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'span'` | `any`  The element or component this component should render as. |
| `light` |  | `string` |
| `dark` |  | `string` |
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
| `icon` |  | `any` |
| `text` |  | ` string` |
| `size` | `'md'` | ` "md" \| "3xs" \| "2xs" \| "xs" \| "sm" \| "lg" \| "xl" \| "2xl" \| "3xl"` |
| `chip` |  | `boolean \| ChipProps` |
| `ui` |  | ` { root?: ClassNameValue; image?: ClassNameValue; fallback?: ClassNameValue; icon?: ClassNameValue; }` |

This component also supports all native `<img>` HTML attributes.

## Changelog

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ContentToc](https://ui.nuxt.com/docs/components/content-toc)

[

A sticky Table of Contents with automatic active anchor link highlighting.

](https://ui.nuxt.com/docs/components/content-toc)[

ColorModeButton

A Button to switch between light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-button)