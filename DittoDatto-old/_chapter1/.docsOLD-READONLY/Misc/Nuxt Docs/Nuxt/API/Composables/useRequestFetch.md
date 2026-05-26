---
title: "useRequestFetch · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-request-fetch"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
You can use `useRequestFetch` to forward the request context and headers when making server-side fetch requests.

When making a client-side fetch request, the browser automatically sends the necessary headers. However, when making a request during server-side rendering, due to security considerations, we need to forward the headers manually.

Headers that are **not meant to be forwarded** will **not be included** in the request. These headers include, for example:`transfer-encoding`, `connection`, `keep-alive`, `upgrade`, `expect`, `host`, `accept`

The [`useFetch`](https://nuxt.com/docs/4.x/api/composables/use-fetch) composable uses `useRequestFetch` under the hood to automatically forward the request context and headers.

In the browser during client-side navigation, `useRequestFetch` will behave just like regular [`$fetch`](https://nuxt.com/docs/4.x/api/utils/dollarfetch).