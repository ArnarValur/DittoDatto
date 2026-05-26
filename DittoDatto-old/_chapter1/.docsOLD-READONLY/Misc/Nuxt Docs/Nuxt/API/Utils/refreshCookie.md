---
title: "refreshCookie · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/refresh-cookie"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
This utility is available since [Nuxt v3.10](https://nuxt.com/blog/v3-10).

## Purpose

The `refreshCookie` function is designed to refresh cookie value returned by `useCookie`.

This is useful for updating the `useCookie` ref when we know the new cookie value has been set in the browser.

## Usage

app/app.vue

```
<script setup lang="ts">

const tokenCookie = useCookie('token')

const login = async (username, password) => {

  const token = await $fetch('/api/token', { /** ... */ }) // Sets \`token\` cookie on response

  refreshCookie('token')

}

const loggedIn = computed(() => !!tokenCookie.value)

</script>
```

Since , the experimental `cookieStore` option is enabled by default. It automatically refreshes the `useCookie` value when cookies change in the browser.

## Type

Signature

```ts
export function refreshCookie (name: string): void
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/refresh-cookie.md)[prerenderRoutes](https://nuxt.com/docs/4.x/api/utils/prerender-routes)

[

prerenderRoutes hints to Nitro to prerender an additional route.

](https://nuxt.com/docs/4.x/api/utils/prerender-routes)[

refreshNuxtData

Refresh all or specific asyncData instances in Nuxt

](https://nuxt.com/docs/4.x/api/utils/refresh-nuxt-data)