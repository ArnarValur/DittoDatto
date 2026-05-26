---
title: "callOnce · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/call-once"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## callOnce

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/once.ts)

Run a given function or block of code once during SSR or CSR.

This utility is available since [Nuxt v3.9](https://nuxt.com/blog/v3-9).

## Purpose

The `callOnce` function is designed to execute a given function or block of code only once during:

- server-side rendering but not hydration
- client-side navigation

This is useful for code that should be executed only once, such as logging an event or setting up a global state.

## Usage

The default mode of `callOnce` is to run code only once. For example, if the code runs on the server it won't run again on the client. It also won't run again if you `callOnce` more than once on the client, for example by navigating back to this page.

app/app.vue

```
<script setup lang="ts">

const websiteConfig = useState('config')

await callOnce(async () => {

  console.log('This will only be logged once')

  websiteConfig.value = await $fetch('https://my-cms.com/api/website-config')

})

</script>
```

It is also possible to run on every navigation while still avoiding the initial server/client double load. For this, it is possible to use the `navigation` mode:

app/app.vue

```
<script setup lang="ts">

const websiteConfig = useState('config')

await callOnce(async () => {

  console.log('This will only be logged once and then on every client side navigation')

  websiteConfig.value = await $fetch('https://my-cms.com/api/website-config')

}, { mode: 'navigation' })

</script>
```

`navigation` mode is available since [Nuxt v3.15](https://nuxt.com/blog/v3-15).

`callOnce` is useful in combination with the [Pinia module](https://nuxt.com/modules/pinia) to call store actions.

Read more in Docs > 4 X > Getting Started > State Management.

Note that `callOnce` doesn't return anything. You should use [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) or [`useFetch`](https://nuxt.com/docs/4.x/api/composables/use-fetch) if you want to do data fetching during SSR.

`callOnce` is a composable meant to be called directly in a setup function, plugin, or route middleware, because it needs to add data to the Nuxt payload to avoid re-calling the function on the client when the page hydrates.

## Type

Signature

```ts
export function callOnce (key?: string, fn?: (() => any | Promise<any>), options?: CallOnceOptions): Promise<void>

export function callOnce (fn?: (() => any | Promise<any>), options?: CallOnceOptions): Promise<void>

type CallOnceOptions = {

  /**

   * Execution mode for the callOnce function

   * @default 'render'

   */

  mode?: 'navigation' | 'render'

}
```

## Parameters

- `key`: A unique key ensuring that the code is run once. If you do not provide a key, then a key that is unique to the file and line number of the instance of `callOnce` will be generated for you.
- `fn`: The function to run once. It can be asynchronous.
- `options`: Setup the mode, either to re-execute on navigation (`navigation`) or just once for the lifetime of the app (`render`). Defaults to `render`.
	- `render`: Executes once during initial render (either SSR or CSR) - Default mode
	- `navigation`: Executes once during initial render and once per subsequent client-side navigation

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/call-once.md)[addRouteMiddleware](https://nuxt.com/docs/4.x/api/utils/add-route-middleware)

[

addRouteMiddleware() is a helper function to dynamically add middleware in your application.

](https://nuxt.com/docs/4.x/api/utils/add-route-middleware)[

clearError

The clearError composable clears all handled errors.

](https://nuxt.com/docs/4.x/api/utils/clear-error)