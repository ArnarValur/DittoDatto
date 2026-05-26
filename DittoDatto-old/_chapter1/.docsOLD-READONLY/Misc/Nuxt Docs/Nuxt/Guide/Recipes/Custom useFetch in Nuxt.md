---
title: "Custom useFetch in Nuxt · Recipes v4"
source: "https://nuxt.com/docs/4.x/guide/recipes/custom-usefetch"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Custom useFetch in Nuxt

How to create a custom fetcher for calling your external API in Nuxt.

When working with Nuxt, you might be making the frontend and fetching an external API, and you might want to set some default options for fetching from your API.

The [`$fetch`](https://nuxt.com/docs/4.x/api/utils/dollarfetch) utility function (used by the [`useFetch`](https://nuxt.com/docs/4.x/api/composables/use-fetch) composable) is intentionally not globally configurable. This is important so that fetching behavior throughout your application remains consistent, and other integrations (like modules) can rely on the behavior of core utilities like `$fetch`.

However, Nuxt provides a way to create a custom fetcher for your API (or multiple fetchers if you have multiple APIs to call).

## Custom $fetch

Let's create a custom `$fetch` instance with a [Nuxt plugin](https://nuxt.com/docs/4.x/directory-structure/app/plugins).

`$fetch` is a configured instance of [ofetch](https://github.com/unjs/ofetch) which supports adding the base URL of your Nuxt server as well as direct function calls during SSR (avoiding HTTP roundtrips).

Let's pretend here that:

- The main API is [https://api.nuxt.com](https://api.nuxt.com/)
- We are storing the JWT token in a session with [nuxt-auth-utils](https://github.com/atinux/nuxt-auth-utils)
- If the API responds with a `401` status code, we redirect the user to the `/login` page

app/plugins/api.ts

```ts
export default defineNuxtPlugin((nuxtApp) => {

  const { session } = useUserSession()

  const api = $fetch.create({

    baseURL: 'https://api.nuxt.com',

    onRequest ({ request, options, error }) {

      if (session.value?.token) {

        // note that this relies on ofetch >= 1.4.0 - you may need to refresh your lockfile

        options.headers.set('Authorization', \`Bearer ${session.value?.token}\`)

      }

    },

    async onResponseError ({ response }) {

      if (response.status === 401) {

        await nuxtApp.runWithContext(() => navigateTo('/login'))

      }

    },

  })

  // Expose to useNuxtApp().$api

  return {

    provide: {

      api,

    },

  }

})
```

With this Nuxt plugin, `$api` is exposed from `useNuxtApp()` to make API calls directly from the Vue components:

app/app.vue

```
<script setup>

const { $api } = useNuxtApp()

const { data: modules } = await useAsyncData('modules', () => $api('/modules'))

</script>
```

Wrapping with [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) **avoid double data fetching when doing server-side rendering** (server & client on hydration).

## Custom useFetch/useAsyncData

Now that `$api` has the logic we want, let's create a `useAPI` composable to replace the usage of `useAsyncData` + `$api`:

app/composables/useAPI.ts

```ts
import type { UseFetchOptions } from 'nuxt/app'

export function useAPI<T> (

  url: string | (() => string),

  options?: UseFetchOptions<T>,

) {

  return useFetch(url, {

    ...options,

    $fetch: useNuxtApp().$api as typeof $fetch,

  })

}
```

Let's use the new composable and have a nice and clean component:

app/app.vue

```
<script setup>

const { data: modules } = await useAPI('/modules')

</script>
```

If you want to customize the type of any error returned, you can also do so:

```ts
import type { FetchError } from 'ofetch'

import type { UseFetchOptions } from 'nuxt/app'

interface CustomError {

  message: string

  status: number

}

export function useAPI<T> (

  url: string | (() => string),

  options?: UseFetchOptions<T>,

) {

  return useFetch<T, FetchError<CustomError>>(url, {

    ...options,

    $fetch: useNuxtApp().$api,

  })

}
```

This example demonstrates how to use a custom `useFetch`, but the same structure is identical for a custom `useAsyncData`.

Read and edit a live example in [Docs > 4 X > Examples > Advanced > Use Custom Fetch Composable](https://nuxt.com/docs/4.x/examples/advanced/use-custom-fetch-composable).

We are currently discussing to find a cleaner way to let you create a custom fetcher, see [https://github.com/nuxt/nuxt/issues/14736](https://github.com/nuxt/nuxt/issues/14736).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/5.recipes/3.custom-usefetch.md)[Vite Plugins](https://nuxt.com/docs/4.x/guide/recipes/vite-plugin)

[

Learn how to integrate Vite plugins into your Nuxt project.

](https://nuxt.com/docs/4.x/guide/recipes/vite-plugin)[

Sessions and Authentication

Authentication is an extremely common requirement in web apps. This recipe will show you how to implement basic user registration and authentication in your Nuxt app.

](https://nuxt.com/docs/4.x/guide/recipes/sessions-and-authentication)