---
title: "useResponseHeader · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-response-header"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
This composable is available in Nuxt v3.14+.

You can use the built-in [`useResponseHeader`](https://nuxt.com/docs/4.x/api/composables/use-response-header) composable to set any server response header within your pages, components, and plugins.

## Example

We can use `useResponseHeader` to easily set a response header on a per-page basis.

app/pages/test.vue

```
<script setup>

// pages/test.vue

const header = useResponseHeader('X-My-Header')

header.value = 'my-value'

</script>

<template>

  <h1>Test page with custom header</h1>

  <p>The response from the server for this "/test" page will have a custom "X-My-Header" header.</p>

</template>
```

We can use `useResponseHeader` for example in Nuxt [middleware](https://nuxt.com/docs/4.x/directory-structure/app/middleware) to set a response header for all pages.

app/middleware/my-header-middleware.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  const header = useResponseHeader('X-My-Always-Header')

  header.value = \`I'm Always here!\`

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-response-header.md)[useRequestURL](https://nuxt.com/docs/4.x/api/composables/use-request-url)

[

Access the incoming request URL with the useRequestURL composable.

](https://nuxt.com/docs/4.x/api/composables/use-request-url)[

useRoute

The useRoute composable returns the current route.

](https://nuxt.com/docs/4.x/api/composables/use-route)