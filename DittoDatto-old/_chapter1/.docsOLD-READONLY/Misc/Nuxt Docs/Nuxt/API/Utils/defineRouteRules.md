---
title: "defineRouteRules · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/define-route-rules"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## defineRouteRules

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/pages/runtime/composables.ts)

Define route rules for hybrid rendering at the page level.

This feature is experimental and in order to use it you must enable the `experimental.inlineRouteRules` option in your `nuxt.config`.

## Usage

app/pages/index.vue

```
<script setup lang="ts">

defineRouteRules({

  prerender: true,

})

</script>

<template>

  <h1>Hello world!</h1>

</template>
```

Will be translated to:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  routeRules: {

    '/': { prerender: true },

  },

})
```

When running [`nuxt build`](https://nuxt.com/docs/4.x/api/commands/build), the home page will be pre-rendered in `.output/public/index.html` and statically served.

## Notes

- A rule defined in `~/pages/foo/bar.vue` will be applied to `/foo/bar` requests.
- A rule in `~/pages/foo/[id].vue` will be applied to `/foo/**` requests.

For more control, such as if you are using a custom `path` or `alias` set in the page's [`definePageMeta`](https://nuxt.com/docs/4.x/api/utils/define-page-meta), you should set `routeRules` directly within your `nuxt.config`.

Read more about the `routeRules`.