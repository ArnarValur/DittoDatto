---
title: "<NuxtPicture> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-picture"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtPicture>

[Source](https://github.com/nuxt/image/blob/main/src/runtime/components/NuxtPicture.vue)

Nuxt provides a <NuxtPicture> component to handle automatic image optimization.

`<NuxtPicture>` is a drop-in replacement for the native `<picture>` tag.

Usage of `<NuxtPicture>` is almost identical to [`<NuxtImg>`](https://nuxt.com/docs/4.x/api/components/nuxt-img) but it also allows serving modern formats like `webp` when possible.

Learn more about the [`<picture>` tag on MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/picture).

## Setup

In order to use `<NuxtPicture>` you should install and enable the Nuxt Image module:

Terminal

```bash
npx nuxt module add image
```

Read more about the `<NuxtPicture>` component.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/10.nuxt-picture.md)[<NuxtClientFallback>](https://nuxt.com/docs/4.x/api/components/nuxt-client-fallback)

[

Nuxt provides the <NuxtClientFallback> component to render its content on the client if any of its children trigger an error in SSR

](https://nuxt.com/docs/4.x/api/components/nuxt-client-fallback)[

<Teleport>

The <Teleport> component teleports a component to a different location in the DOM.

](https://nuxt.com/docs/4.x/api/components/teleports)