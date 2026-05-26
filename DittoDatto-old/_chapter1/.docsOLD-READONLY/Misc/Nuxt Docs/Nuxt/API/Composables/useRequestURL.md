---
title: "useRequestURL · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-request-url"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useRequestURL

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/url.ts)

Access the incoming request URL with the useRequestURL composable.

`useRequestURL` is a helper function that returns an [URL object](https://developer.mozilla.org/en-US/docs/Web/API/URL/URL) working on both server-side and client-side.

When utilizing [Hybrid Rendering](https://nuxt.com/docs/4.x/guide/concepts/rendering#hybrid-rendering) with cache strategies, all incoming request headers are dropped when handling the cached responses via the [Nitro caching layer](https://nitro.build/guide/cache) (meaning `useRequestURL` will return `localhost` for the `host`).You can define the [`cache.varies` option](https://nitro.build/guide/cache#options) to specify headers that will be considered when caching and serving the responses, such as `host` and `x-forwarded-host` for multi-tenant environments.

```
<script setup lang="ts">

const url = useRequestURL()

</script>

<template>

  <p>URL is: {{ url }}</p>

  <p>Path is: {{ url.pathname }}</p>

</template>
```

Read about the URL instance properties on the MDN documentation.