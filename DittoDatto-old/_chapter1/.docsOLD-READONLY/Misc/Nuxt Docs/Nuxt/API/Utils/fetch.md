---
title: "$fetch · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/dollarfetch"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## $fetch

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/entry.ts)

Nuxt uses ofetch to expose globally the $fetch helper for making HTTP requests.

Nuxt uses [ofetch](https://github.com/unjs/ofetch) to expose globally the `$fetch` helper for making HTTP requests within your Vue app or API routes.

During server-side rendering, calling `$fetch` to fetch your internal [API routes](https://nuxt.com/docs/4.x/directory-structure/server) will directly call the relevant function (emulating the request), **saving an additional API call**.

Using `$fetch` in components without wrapping it with [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) causes fetching the data twice: initially on the server, then again on the client-side during hydration, because `$fetch` does not transfer state from the server to the client. Thus, the fetch will be executed on both sides because the client has to get the data again.

## Usage

We recommend using [`useFetch`](https://nuxt.com/docs/4.x/api/composables/use-fetch) or [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) + `$fetch` to prevent double data fetching when fetching the component data.

app/app.vue

```
<script setup lang="ts">

// During SSR data is fetched twice, once on the server and once on the client.

const dataTwice = await $fetch('/api/item')

// During SSR data is fetched only on the server side and transferred to the client.

const { data } = await useAsyncData('item', () => $fetch('/api/item'))

// You can also useFetch as shortcut of useAsyncData + $fetch

const { data } = await useFetch('/api/item')

</script>
```

Read more in Docs > 4 X > Getting Started > Data Fetching.

You can use `$fetch` in any methods that are executed only on client-side.

app/pages/contact.vue

```
<script setup lang="ts">

async function contactForm () {

  await $fetch('/api/contact', {

    method: 'POST',

    body: { hello: 'world' },

  })

}

</script>

<template>

  <button @click="contactForm">

    Contact

  </button>

</template>
```

`$fetch` is the preferred way to make HTTP calls in Nuxt instead of [@nuxt/http](https://github.com/nuxt/http) and [@nuxtjs/axios](https://github.com/nuxt-community/axios-module) that are made for Nuxt 2.

If you use `$fetch` to call an (external) HTTPS URL with a self-signed certificate in development, you will need to set `NODE_TLS_REJECT_UNAUTHORIZED=0` in your environment.

### Passing Headers and Cookies

When we call `$fetch` in the browser, user headers like `cookie` will be directly sent to the API.

However, during Server-Side Rendering, due to security risks such as **Server-Side Request Forgery (SSRF)** or **Authentication Misuse**, the `$fetch` wouldn't include the user's browser cookies, nor pass on cookies from the fetch response.

If you need to forward headers and cookies on the server, you must manually pass them:

app/pages/index.vue

```
<script setup lang="ts">

// This will forward the user's headers and cookies to \`/api/cookies\`

const requestFetch = useRequestFetch()

const { data } = await useAsyncData(() => requestFetch('/api/cookies'))

</script>
```

However, when calling `useFetch` with a relative URL on the server, Nuxt will use [`useRequestFetch`](https://nuxt.com/docs/4.x/api/composables/use-request-fetch) to proxy headers and cookies (with the exception of headers not meant to be forwarded, like `host`).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/$fetch.md)[useState](https://nuxt.com/docs/4.x/api/composables/use-state)

[

The useState composable creates a reactive and SSR-friendly shared state.

](https://nuxt.com/docs/4.x/api/composables/use-state)[

abortNavigation

abortNavigation is a helper function that prevents navigation from taking place and throws an error if one is set as a parameter.

](https://nuxt.com/docs/4.x/api/utils/abort-navigation)