---
title: "useRequestHeader · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-request-header"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
You can use the built-in [`useRequestHeader`](https://nuxt.com/docs/4.x/api/composables/use-request-header) composable to access any incoming request header within your pages, components, and plugins.

In the browser, `useRequestHeader` will return `undefined`.

## Example

We can use `useRequestHeader` to easily figure out if a user is authorized or not.

The example below reads the `authorization` request header to find out if a person can access a restricted resource.

app/middleware/authorized-only.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  if (!useRequestHeader('authorization')) {

    return navigateTo('/not-authorized')

  }

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-request-header.md)