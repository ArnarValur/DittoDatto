---
title: "<NuxtImg> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-img"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtImg>

[Source](https://github.com/nuxt/image/blob/main/src/runtime/components/NuxtImg.vue)

Nuxt provides a <NuxtImg> component to handle automatic image optimization.

`<NuxtImg>` is a drop-in replacement for the native `<img>` tag.

- Uses built-in provider to optimize local and remote images
- Converts `src` to provider-optimized URLs
- Automatically resizes images based on `width` and `height`
- Generates responsive sizes when providing `sizes` option
- Supports native lazy loading as well as other `<img>` attributes

## Setup

In order to use `<NuxtImg>` you should install and enable the Nuxt Image module:

Terminal

```bash
npx nuxt module add image
```

## Usage

`<NuxtImg>` outputs a native `img` tag directly (without any wrapper around it). Use it like you would use the `<img>` tag:

```html
<NuxtImg src="/nuxt-icon.png" />
```

Will result in:

```html
<img src="/nuxt-icon.png" />
```

Read more about the `<NuxtImg>` component.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/9.nuxt-img.md)[<NuxtIsland>](https://nuxt.com/docs/4.x/api/components/nuxt-island)

[

Nuxt provides the <NuxtIsland> component to render a non-interactive component without any client JS.

](https://nuxt.com/docs/4.x/api/components/nuxt-island)[

onPrehydrate

Use onPrehydrate to run a callback on the client immediately before Nuxt hydrates the page.

](https://nuxt.com/docs/4.x/api/composables/on-prehydrate)